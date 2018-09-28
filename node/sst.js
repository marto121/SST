'use strict'

var sstApp = function() {
    const ep=require('./excelParser')
    const mail = require('./mail')
    const config = require('./config');
    const utils = require('./utils');
    const proxy = require('./proxy')
    const constants = require('./constants');
    const db = require('./db');
    const fs = require('fs');

    async function checkMail() {
        var mails = proxy.execSync('cs_mail.js','checkMail')
        if (mails.hasOwnProperty("Error")) {
            await db.log("checkMail", "Error checking mail: " + JSON.stringify(mails.Error), constants.tSys, -1)
        } else {
            for (const mail of mails) {
                //mail: Sender, Recipients, Subject, Body, SpoofResult (0 = Pass), Attachments
                var res = await db.query("select 1 from vwUserCountry where lower(email) = $1", [mail.Sender.toLowerCase()])
                var authStatus = 0
                if (res.rowCount)
                    authStatus = 1
                await db.query("BEGIN")
                try {
                    res = await db.query("insert into mail_log (sender, receiver, subject, body, mailstatus, authStatus) values ($1, $2, $3, $4, $5, $6) returning id", [mail.Sender, mail.Recipients, mail.Subject, mail.Body, constants.statusReceived, authStatus])
                    var m_ID = -1
                    if (res.rowCount)
                        m_ID = res.rows[0].id
                    await db.log("checkMail", "New mail received from: " + mail.Sender + " with subject: " + mail.Subject + ". Starting processing.", constants.tLog, m_ID)
                    for (const att of mail.Attachments) {
                        var fStatus = constants.statusReceived
                        const targetFileName =  utils.pad(m_ID, 4) + "_" + att.fileName;
                        if (att.fileName.substring(0,3).toLowerCase()=="bc_"||att.fileName.substring(0,3).toLowerCase()=="ec_") {
                            var fileType = att.fileName.substring(0,3).toUpperCase()
                            var NPE_Code = att.fileName.substring(3,11)
                            const rsNPE = await db.query("select ID from NPE_List where m_ID=-1 and NPE_Code=$1",[NPE_Code])
                            if (rsNPE.rowCount==0) {
                                db.log("processMail", "Attachment " + att.fileName + " looks like a " + fileType.substring(0,2) + ", but the NPE_Code is not recognized. Please name the file \'" + fileType + "_[NPE_Code]\'.", constants.tWar, m_ID)
                                NPE_Code = ""
                            } else {
                                db.log("processMail", "Attachment: " + att.fileName + " recognized as " + fileType.substring(0,2) + " for NPE_Code " + NPE_Code + " and stored.", constants.tWar, m_ID)
                            }
                            fStatus = constants.statusProcessed
                        } else if (att.fileName.split('.').pop().toLowerCase().substring(0,2) == "xl"){
                            fileType = "SST"
                            NPE_Code = ""
                        } else {
                            db.log("processMail", "Attachment: " + att.fileName + " is not an Excel file (*.xl*), Business case (BC_*) or Exit Calculation (EC_*). Skipping ...", constants.tWar, m_ID)
                            fStatus = constants.statusProcessed
                        }
                        try {
                            fs.copyFileSync(att.tempFile, config.SST_Att_Path + "\\" + targetFileName)
                            fs.unlinkSync(att.tempFile);
                            res = await db.query("insert into file_log (m_ID, fileName, filestatus, fileType, NPE_ID) values ($1, $2, $3, $4, $5)", [m_ID, config.SST_Att_Path + "\\" + targetFileName, fStatus, fileType, NPE_Code])
                        } catch (e) {
                            db.log("checkMail", "Error saving file " + config.SST_Att_Path + "\\" + targetFileName + ": " + e.message, constants.tWar, m_ID)
                        }
                    }
                    await db.query("COMMIT")
                } catch (e) {
                    db.log("checkMail", "Error inserting new mails: "+e.toString(), constants.tSys, -1);
                }
            }
        }
    }

    async function processMails() {
        const res = await db.query('select * from Mail_Log where mailStatus = $1', [constants.statusReceived])
        for (const row of res.rows) {
            await processMail(row.id)
        }
    }

    async function processMail(m_ID) {
        const reject = async function(msg) {
            db.log("processMail",msg, constants.tSys, m_ID)
            await db.changeMailStatus(m_ID, constants.statusError)
        }
        try {
            const ml = await db.query("select authStatus, sender, subject, body from mail_log where id = $1", [m_ID])
            if (ml.rows[0].authstatus) {
                if (ml.rows[0].subject.toLowerCase()=="ok") {
                    var matches = mystring.match(/\{(.*?)\}/);
                    var confirm_m_ID;
                    if (matches&&(confirm_m_ID=parseInt(matches[0]))&&!isNaN(confirm_m_ID)) {
                        db.log("processMail", "Identified 'OK' command in message. Confirming data in Message ID " + confirm_m_ID, constants.tLog, m_ID)
                        try {
                            await db.confirmMessage(confirm_m_ID, m_ID)
                        } catch (e) {
                            reject("Error confirming message " + confirm_m_ID + ": " + e.toString())
                        }
                    } else {
                        db.log("processMail", "Identified 'OK' command in message, but no message ID identified in Subject!", constants.tErr, m_ID)
                    }
                }
                try {
                    const nFiles = await processFiles(m_ID)
                    if (nFiles) {
                        try {
                            const updRes = await db.performUpdates(m_ID)
                            try {
                                const FXRes = await db.performFX(m_ID)
                                try {
                                    await db.performChecks(m_ID)
                                } catch (e) {
                                    reject("Error performing checks: " + e.toString())
                                }
                            } catch(e) {
                                reject("Error performing FX Updates: " + e.toString())
                            }
                        } catch (e) {
                            reject("Error performing Updates: " + e.toString())
                        }
                    } else {
                    }
                } catch (e) {
                    reject("Error processing files: " + e.stack)
                }
            } else {
                db.log("processMails", "Sender " + ml.rows[0].sender + " of message '" + ml.rows[0].subject + "' is unknown to SST!", constants.tErr, m_ID)
            }
            try {
                const ansRes = await mail.prepareAnswer(m_ID)
                await db.changeMailStatus(m_ID, constants.statusProcessed)
            } catch(e) {
                reject("Error preparing Answer: " + e.stack)
            }
        } catch(e) {
            reject("Error fetching mail ID " + m_ID + " details: " + e.toString())
        }
    }

    async function processFiles(m_ID) {
        var result = 0;
        const res = await db.query('select * from File_Log where m_ID = $1 and fileStatus = $2', [m_ID, constants.statusReceived])
        for (const row of res.rows) {
            var fileName = row.filename;
            db.log("processFiles", "Start processing fileName " + fileName, constants.tLog, row.m_id)
            const parseResult = await ep.parseExcel(fileName, row.m_id)
            db.log("processFiles", "End processing fileName " + fileName, constants.tLog, row.m_id)
            try {
                await db.query("update file_log set fileStatus=$1, repLE=$2, repDate=$3 where id = $4", [parseResult.toStatus, parseResult.Rep_LE, parseResult.Rep_Date, row.id])
                result ++;
            } catch (e) {
                db.log("processFiles", "Error updating file_log!"+e.toString(), constants.tSys, row.m_id);
            }
        }
        return result;
    }

    async function sendMails() {
        const mq = await db.query('select id, mRecipients, mCC, mSubject, mBody, mAttachments from Mail_Queue mq where mStatus=$1', [constants.statusReceived])
        var messages=[]
        for (const mqItem of mq.rows) {
            messages.push({ID: mqItem.id, Recipients: mqItem.mrecipients, CC: mqItem.mcc, Subject: mqItem.msubject, Body: mqItem.mbody, Attachments: mqItem.mattachments.split(";")})
        }
        var result = await proxy.exec('cs_mail.js','sendMail', messages)

        if (result.Error) {
            await db.log("sendMails", "Error sending mail: " + result.Error, constants.tSys, -1)
        } else {
            for (const res of result) {
                if(res.Status=="OK") {
                    await db.query("update mail_queue set mStatus=$1 where id=$2",[constants.statusProcessed, res.ID])
                } else {
                    await db.log("sendMails", "Error updating sendMail status: " + res.Status, constants.tSys, res.ID)
                }
            }
        }
    }

    async function run() {
        db.log("run", "SST App Starting...", constants.tLog, -1)
        var d = new Date()
        checkMail().then(chkRes=>{
            console.log("mail checked")
            processMails().then(procRes=>{
                sendMails().then(sendRes=>{
                    db.log("run", "SST App Ending...", constants.tLog, -1)
                })
            })
        })
    }
    
    return {run:run}
}

sstApp().run()