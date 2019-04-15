'use strict'
var constants = require('./constants');
var config = require('./config');
var reports = require('./reports');
var db = require('./db');
var fs = require('fs')

module.exports = {
    prepareAnswer: prepareAnswer
}

async function prepareAnswer(m_ID) {
    var mqRecipients = ""
    var mqSubject = ""
    var mqBody = ""
    var mqAttachments = ""
    var attachment = ""
    var Rep_LE =""

    mqSubject = "{" + m_ID + "} SST Loading log"

    var addRecipients = ""
    var mailText = ""

    var res = await db.query("select Sender, Subject, authStatus, answerText, answerRecipients from Mail_Log where ID = $1", [m_ID])
    if (res.rows.length>0) {
      const mSender=res.rows[0].sender
      mqRecipients = mSender
      const mSubject=res.rows[0].subject
      if(res.rows[0].authstatus==1) {
        if (res.rows[0].answerrecipients)
            addRecipients = res.rows[0].answerrecipients;
        if (res.rows[0].answertext)
            mailText = res.rows[0].answertext;

        var countryList="'NONE'"
        var Rep_Country = "-"
        const res2 = await db.query("select * from vw_Mail_Countries where lower(EMail)=$1",[mSender])
        for (const row of res2.rows) {
            if (Rep_Country == "-") {
                Rep_Country = row.mis_code
            } else {
                Rep_Country =""
            }
            countryList += ", '" + row.mis_code + "'"
        }
        //check for command in Subject
        if (mSubject.trim().substring(0,9)=="reqReport") {
            var rName
            var rID
            if (mSubject.trim().substring(0,13)=="reqReportFull") {
                rName = "reqReportFull"
                rID=2 // Full report
            } else {
                rName = "reqReport"
                rID=1 //' Report with only final Rentals/Appraisals/Insurances
            }
            db.log ("prepareAnswer", "Detected \"" + rName + "\" command. A template will be generated.", constants.tLog, m_ID)
            var sel=""
            if(mSubject.indexOf(":")!=-1) {
                sel = mSubject.split(":")[1].trim()
            }
            if (sel!="") {
                Rep_Country = sel
                db.log ("prepareAnswer", "Detected country selection. Only Objects of " + Rep_Country + " will be selected.", constants.tLog, m_ID)
                sel = " and Left(NPE_Code, 2) = '" + Rep_Country + "'"
            }
            if (Rep_Country!="") {
                const res3 = await db.query("select Rep_LE from vw_CountryLE where MIS_Code = $1",[Rep_Country])
                if (res3.rowCount>0) {
                    Rep_LE = res3.rows[0].rep_le
                } else {
                    db.log ("prepareAnswer", "Error getting default Legal Entity for " + Rep_Country + ".", constants.tErr, m_ID)
                }
            }
            attachment = await reports.createReport ( rID, m_ID, "where Left(NPE_Code, 2) in (" + countryList + ")" + sel, Rep_LE)
            if (attachment!="") mqAttachments = attachment + ";";
        } else if (mSubject.trim().substring(0,12)=="reqReminders"&&config.SST_Log_Recipients.toLowerCase().indexOf(mSender.toLowerCase())!=-1) {
            db.log ("prepareAnswer", "Detected \"reqReminders\" command. A reminder mail with attached template will be generated for each Legal Entity.", constants.tLog, m_ID)
            await createReminders(m_ID)
        } else {
            db.log ("prepareAnswer", "No command found in E-mail subject", constants.tLog, m_ID)
        }
        res = await db.query("select max(repLE) as repLE, to_char(max(repDate),'DD.MM.YYYY') as repDate, to_char(max(send_date),'DD.MM.YYYY') as send_date, to_char(max(Confirm_Date),'DD.MM.YYYY') as Confirm_Date, count(*) As cnt from File_Log left join calendar on file_log.repDate = calendar.rep_date where m_ID = $1 and fileStatus = $2 and fileType=\'SST\'",[m_ID, constants.statusProcessed])
        if (res.rowCount>0&&res.rows[0].cnt>0) {
            attachment = await reports.createChangeReport_Template(m_ID)
            
            var errorsText = ""
            var hasErrors = 0
            const logSummary = await db.query("select Log_Type, Descr, Color, Count(*) as Cnt FROM Nom_Log_Types INNER JOIN sst_log ON Nom_Log_Types.ID = sst_log.Log_Type where mail_id=$1 and log_type in (1,2) group by log_type, Descr, Color",[m_ID])
            if (logSummary.rowCount>0) {
                errorsText += "<p>Please consider the Summary of Errors below:<br><table cellspacing='0' cellpadding='1' border='1'><tr><th>Message Type</th><th>Nr Messages</th></tr>"
                logSummary.rows.forEach(function (r) {
                    errorsText += "<tr bgcolor='" + r.color + "'><td>" + r.descr + "</td><td align='right'>" + r.cnt + "</td></tr>"
                    if (r.log_type==constants.tErr)
                        hasErrors = r.cnt
                })
                errorsText += "</table>"
            }
            var senderName = mSender
            const rsSenderName = await db.query("select FullName from users where lower(email)=$1", [mSender.toLowerCase()])
            if (rsSenderName.rowCount>0)
                senderName = rsSenderName.rows[0].fullname

            if (hasErrors) {
                mailText += "Dear " + senderName + ",<BR>"
                mailText += "<p>You have sent data to the SST for " + res.rows[0].reple + " as of " + res.rows[0].repdate + ". "
            } else {
                const resRoles = await db.query("select * from vw_Mail_Roles where m_ID = $1", [m_ID])
                resRoles.rows.forEach(function(role) {
                    if ((role.role & constants.roleConfirm) == 2) {
                        if (config.SST_Log_Recipients.toLowerCase().indexOf(role.email.toLowerCase())==-1) {
                            addRecipients += ";" + role.email
                            mailText += "Dear " + role.firstname + ", <BR>"
                        }
                    }
                })
                mailText += "<p>" + senderName + " has sent data to the SST for " + res.rows[0].reple + " as of " + res.rows[0].repdate+ ". "
            }
            mailText += "In the attachment you may find the submitted report, highlighting the changes made. "
            mailText += "In the log below you may see all the messages generated during processing of the file. "

            if (hasErrors) {
                mailText += "<p><b>As there were " + hasErrors + " errors identified in the file, please correct them and re-submit the file. "
                mailText += "Submissions with errors cannot be accepted!</b>"
                mailText += errorsText
                if (res.rows[0].confirm_date)
                    mailText += "<p>The deadline for sending the data for " + res.rows[0].repdate + " is <u>" + res.rows[0].send_date + "</u>."
            } else {
                mailText += "Please have a look and if you find the data satisfactory, answer to this E-Mail with OK in the message body."
                mailText += "If you have any concerns for the quality of delivered data, please contact the sender and request corerctions. "
            }
            mailText += "<p>The deadline for confirming the data for " + res.rows[0].repdate + " is <u>" + res.rows[0].confirm_date + "</u>."

            mailText += "<p>Regards, SST"
            mqRecipients += ";" + addRecipients
        } else {
            attachment = ""
            db.log ("prepareAnswer", "No valid attachments found in E-mail", constants.tLog, m_ID)
        }
        if (attachment!="") {
            mqAttachments += attachment + ";"
        }
      } else {
        //@TODO what happens if not authenticated?
      }
    } else {
        //@TODO what happens if mail is not found
    }
    var htmlLog = await reports.createHTMLLog(m_ID)
    mqBody += "<p>" + mailText + "<p>" + htmlLog
    await queueMail (mqRecipients, config.SST_Log_Recipients, mqSubject, mqBody, mqAttachments)
}

async function createReminders(m_ID) {
    try {
        // Reporting dates
        const rsDates = await db.query("select to_char(Rep_Date,'DD.MM.YYYY') rep_date, to_char(Send_Date,'DD.MM.YYYY') send_date, to_char(Confirm_Date,'DD.MM.YYYY') confirm_date from calendar inner join lastdate on lastdate.currmonth=calendar.Rep_Date")
        if(rsDates.rowCount>0) {
            try {
                // List of Legal entities
                const rsLEs = await db.query("select Legal_Entities.ID, Tagetik_Code, LE_Name, MIS_Code from Legal_Entities inner join nom_countries on nom_countries.id = legal_Entities.LE_Country_ID where Active = 1")
                for (const rLE of rsLEs.rows) {
                    try {
                        db.log("creatReminders","Creating reminder mail for " + rLE.tagetik_code + " " + rLE.le_name + ", Reporting Date " + rsDates.rows[0].rep_date + ".", constants.tLog, m_ID)
                        // List of recipients
                        const rsUsers = await db.query("select role, FirstName, EMail from Users where LE_ID=$1",[rLE.id])
                        var mqRecipients = ""
                        var mqCC = config.SST_Log_Recipients
                        var mqBody = ""
                        for (const rUser of rsUsers.rows) {
                            if(rUser.role&constants.roleConfirm) {
                                if(config.SST_Log_Recipients.toLowerCase().indexOf(rUser.email.toLowerCase())==-1) {
                                    mqCC += ";" + rUser.email
                                }
                            } else if (rUser.role&constants.roleSend) {
                                mqBody += "<p>Dear " + rUser.firstname + ","
                                mqRecipients += rUser.email + ";"
                            }
                        }
                        if (mqRecipients=="") {
                            db.log("createReminders", "No recipients found for LE " + rLE.tagetik_code + ":(" + rLE.mis_code + ") " + rLE.le_name, constants.tErr, m_ID)
                        } else {
                            mqBody += "<p>In the attached file you may find the monthly SST Template for "
                            mqBody += rLE.tagetik_code + ":(" + rLE.mis_code + ") " + rLE.le_name 
                            mqBody += " as of " + rsDates.rows[0].rep_date + "."
                            mqBody += "<p>Please make sure that the template is prepared and sent back to the SST not later than <b>" + rsDates.rows[0].send_date + "</b>."
                            mqBody += "<p>Deadline for final confirmation by the CM is <b>" + rsDates.rows[0].confirm_date + "</b>."
                            mqBody += "<p>Regards, SST"
                            var mqSubject = "SST Due Dates for UCTAM " + rLE.mis_code + " for " + rsDates.rows[0].rep_date
                            try {
                                const mqAttachments = await reports.createReport ( 1, m_ID, "where Left(NPE_Code, 2) = '" + rLE.mis_code + "'", rLE.tagetik_code)
                                try {
                                    await queueMail (mqRecipients, mqCC, mqSubject, mqBody, mqAttachments)
                                } catch (err) {
                                    db.log("createReminders", "Error queueing mail " + mqSubject + ": " + err.toString(), constants.tSys, m_ID)    
                                }
                            } catch(err) {
                                db.log("createReminders", "Error creating report for " + rLE.mis_code + ": " + err.toString(), constants.tSys, m_ID)
                            }
                        }
                    } catch (err) {
                        db.log("createReminders", "Error fetching users: " + err.toString(), constants.tSys, m_ID)
                    }
                }
            } catch (err) {
                db.log("createReminders", "Error fetching list of LEs: " + err.toString(), constants.tSys, m_ID)
            }
        }
    } catch(err){
        db.log("createReminders", "Error fetching calendar deadlines: " + err.toString(), constants.tSys, m_ID)
    }
}

async function queueMail(mqRecipients, mqCC, mqSubject, mqBody, mqAttachments) {
//    console.log (mqRecipients, mqCC, mqSubject, mqAttachments)
//    fs.writeFileSync("c:\\Users\\Marti\\Desktop\\sst_out.html", mqBody)
    const res = await db.query(
        "insert into mail_queue (mrecipients, mcc, msubject, mbody, mattachments, mstatus, mdate) values ($1, $2, $3, $4, $5, $6, $7)"
        , [mqRecipients, (mqRecipients.toLowerCase().indexOf("mkrastev.external@unicredit.eu")!=-1)?"":mqCC, mqSubject, mqBody, mqAttachments, 0, new Date()]
    )
}
