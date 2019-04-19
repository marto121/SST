const EWS = require('node-ews');
const when = require('when');
const config = require('./config')
const cMailBox = config.mailbox
const utils = require('./utils');
const debug = require('debug')('sst_mail');
const fs = require('fs');
const db = require('./db');
const constants = require('./constants');
const striptags = require('striptags');

const ewsSoapHeader = {
    't:RequestServerVersion': {
      attributes: {
        Version: "Exchange2010"
      }
    }
  };
  
const requests = {
    getFolders: {
        ewsFunction: "FindFolder",
        ewsArgs : function (params) {
            var result = {
                "attributes" : {
                    "Traversal" : "Shallow"
                },
                "FolderShape" : {
                    "BaseShape" : "IdOnly",
                    "AdditionalProperties" : {
                        "FieldURI" : [
                            { "attributes" : { "FieldURI":"folder:ParentFolderId" } } ,
                            { "attributes" : { "FieldURI":"folder:DisplayName" } } 
                        ]
                    }
                },
            }
            if (params && params.folderName) {
                result["Restriction"] = {
                    "t:And": {
                        "t:IsEqualTo" : {
                            "t:FieldURI" : { "attributes" : {"FieldURI":"folder:DisplayName"} },
                            "t:FieldURIOrConstant" : {"t:Constant" : { "attributes" : {"Value":folderName} }  }
                        },
                    }
                }
            }
            result["ParentFolderIds"] = {
                "DistinguishedFolderId" : {
                    "Mailbox": {
                        "EmailAddress" : cMailBox
                    },
                    "attributes": {
                        "Id": "msgfolderroot"
                    }
                }
            }
            return result;
        },
        ewsResponse : "FindFolderResponseMessage",
        getResult : function (resp) {
            if (resp.RootFolder.Folders && resp.RootFolder.Folders.Folder) {
                var result = {}
                toArray(resp.RootFolder.Folders.Folder).forEach(function(el){result[el.DisplayName]=el.FolderId.attributes.Id})
                return result
            }
            else
                return null;
        },
    },
    checkMail: {
        ewsFunction: "FindItem",
        ewsArgs : function (params) {
            var result = {
                "attributes" : {
                  "Traversal" : "Shallow"
                },
                "ItemShape" : {
                    "BaseShape" : "IdOnly",
                },
            }
         
            result["Restriction"] = {
                "t:And": {
                    "t:IsEqualTo" : {
                        "t:FieldURI" : { "attributes" : {"FieldURI":"message:IsRead"} },
                        "t:FieldURIOrConstant" : {"t:Constant" : { "attributes" : {"Value":"false"} }  }
                    },
                 }
            }
             
            result["ParentFolderIds"] = {
                "FolderId": {
                    "attributes": {
                        "Id": params.folderList[config.SST_MailBox_Path.split("\\")[1]]
                    }
                }
            }
            return result;
        },
        ewsResponse : "FindItemResponseMessage",
        getResult : function (resp) {
            if (resp.RootFolder.Items && resp.RootFolder.Items.Message) {
                var result = []
                toArray(resp.RootFolder.Items.Message).forEach(function(el,index){result.push({"attributes":{"Id":el.ItemId.attributes.Id}})})
                return result
            } else
                return null;
        },
    },
    processMessages: {
        ewsFunction: "GetItem",
        ewsArgs : function (params) {
            var result = {
                "ItemShape" : {
                    "BaseShape" : "IdOnly",
         //           "IncludeMimeContent" : "true",
                    "BodyType" : "HTML",
                    "AdditionalProperties" : {
                        "FieldURI" : [
                            { "attributes" : { "FieldURI":"item:Subject" } } ,
                            { "attributes" : { "FieldURI":"message:Sender" } } ,
                            { "attributes" : { "FieldURI":"message:ToRecipients" } } ,
                            { "attributes" : { "FieldURI":"item:Attachments" } } ,
                            { "attributes" : { "FieldURI":"item:Body" } } 
                        ],
                        "IndexedFieldURI" : [
                            { "attributes" : { "FieldURI" : "item:InternetMessageHeader", "FieldIndex" : "X-MS-Exchange-Organization-AuthAs"}},
                            { "attributes" : { "FieldURI" : "item:InternetMessageHeader", "FieldIndex" : "X-Proofpoint-SPF-Result"}},
                            { "attributes" : { "FieldURI" : "item:InternetMessageHeader", "FieldIndex" : "Authentication-Results"}},
                        ]
                    }
                },
                "ItemIds" : {
                    "ItemId" : params.itemList
                }
            }
            return result;
        },
        ewsResponse : "GetItemResponseMessage",
        getResult : function (resp) {
            if (resp.Items && resp.Items.Message) {
                const msg = resp.Items.Message
                var mSender = msg.Sender.Mailbox.EmailAddress;
                var mRecipients = ""
                toArray(msg.ToRecipients.Mailbox).forEach (function(rcpt) {
                    mRecipients += rcpt.EmailAddress + ";"
                })
                var mHeaders = {}
                toArray(msg.InternetMessageHeaders.InternetMessageHeader).forEach( function (mh)  {
                    mHeaders[mh.attributes.HeaderName] = mh["$value"]
                })
                var mBody = striptags(msg.Body["$value"].trim().replace(/(\r\n|\n|\r)/gm,"")).substring(0,100)
                var mAttachments = []
                if(msg.Attachments) {
                    toArray(msg.Attachments.FileAttachment).forEach(function (att) {
                        mAttachments.push({"attributes":{"Id":att.AttachmentId.attributes.Id}})
                    })
                }
                return {Sender:mSender,Recipients:mRecipients, Subject:msg.Subject, Body:mBody, Headers:mHeaders, Attachments:mAttachments}
            } else
                return null;
        },
        returnArray : true
    },
    processAttachments: {
        // returns array of ["AttachmentName", ]
        ewsFunction: "GetAttachment",
        ewsArgs : function (params) {
            var result = {
                "AttachmentIds" : {
                    "AttachmentId" : params.itemList
                }
            }
            return result;
        },
        ewsResponse : "GetAttachmentResponseMessage",
        getResult : function (resp) {
            if (resp.Attachments && resp.Attachments.FileAttachment)
                return {fileName: resp.Attachments.FileAttachment.Name, fileContent: resp.Attachments.FileAttachment.Content}
            else
                return null;
        },
        returnArray : true
    },
    archiveMessages: {
        // returns array of ["AttachmentName", ]
        ewsFunction: "MoveItem",
        ewsArgs : function (params) {
            debug("movefolder: " + params.folderList[config.SST_MailArch_Path.split("\\")[1]])
            var result = {
                "ToFolderId" : {
                    "t:FolderId": {
                        "attributes": {
                            "Id": params.folderList[config.SST_MailArch_Path.split("\\")[1]]
                        }
                    }
                },
                "ItemIds" : {
                    "t:ItemId" : params.itemList
                }
            }
            return result;
        },
        ewsResponse : "MoveItemResponseMessage",
        getResult : function (resp) {
            if (resp.Items && resp.Items.Message)
                return resp.Items.Message.ItemId;
            else
                return null;
        },
        returnArray : true
    },
    saveMessages: {
        // returns array of ["AttachmentName", ]
        ewsFunction: "CreateItem",
        ewsArgs : function (params) {
            var items = []
            params.mails.forEach(function(msg){
                var Recipients = []
                msg.Recipients.split(";").forEach(function(to) {
                    if (to.trim().length>0)
                        Recipients.push({EmailAddress:to.trim()})
                })
                var CC = []
                if (msg.CC) {
                    msg.CC.split(";").forEach(function(cc) {
                        if (cc.trim().length>0)
                        CC.push({EmailAddress:cc.trim()})
                    })
                }
                var Message = {
//                    "ItemClass": "IPM.Note",
                    "Subject" : msg.Subject,
                    "Body" : {
                        "attributes": {"BodyType" : "HTML"},
                        "$value": msg.Body
                    }
                }
                Message.ToRecipients = {Mailbox: Recipients}
                if (CC.length>0) Message.CcRecipients = {Mailbox: CC}
                Message.From = {
                    "Mailbox": {
                        "EmailAddress" : cMailBox
                    }
                }
                Message.IsRead = false
                Message.ReplyTo = {
                    "Mailbox": {
                        "EmailAddress" : cMailBox
                    }
                }
                
                items.push(Message)
            })
            var result = {
                "attributes" : {
                  "MessageDisposition" : "SaveOnly"
                },
                "SavedItemFolderId": {
/*                    "FolderId" : {
                        attributes : {
                            Id: params.folderList["Sent Items"]
                        }
                    }*/
                  "DistinguishedFolderId": {
                    "Mailbox": {
                        "EmailAddress" : cMailBox
                    },
                    "attributes": {
                      "Id": "drafts"
                    }
                  }
                },
                "Items" : {Message:items}
            }
            return result;
        },
        ewsResponse : "CreateItemResponseMessage",
        getResult : function (resp) {
            if (resp.Items && resp.Items.Message) {
                return resp.Items.Message.ItemId
            } else {
                return null
            }
        },
        returnArray : true
    },
    createAttachments: {
        // returns array of ["AttachmentName", ]
        ewsFunction: "CreateAttachment",
        ewsArgs : function (params) {
            if (params.attList) {
                Attachments = []
                params.attList.forEach(function(att) {
                    if (att.trim()!="") {
                        var fileName = att.split("\\")
                        fileName = fileName[fileName.length-1]
                        var buf = fs.readFileSync(att)
                        Attachments.push({Name:fileName, Content: buf.toString("base64")})
                        //Attachments.push({Name:"FileAttachment.txt", IsInline: "false", IsContactPhoto: "false", Content: "VGhpcyBpcyBhIGZpbGUgYXR0YWNobWVudC4="})
                    }
                })
            }
            var result = {
                ParentItemId: params.parentItemId,
                "Attachments" : {FileAttachment: Attachments}
            }
//            debug("r"+JSON.stringify(result))
            return result;
        },
        ewsResponse : "CreateAttachmentResponseMessage",
        getResult : function (resp) {
            if (resp.Attachments && resp.Attachments.FileAttachment)
                return resp.Attachments.FileAttachment.AttachmentId;
            else
                return null;
        },
        returnArray : true
    },
    sendMessages: {
        // returns array of ["AttachmentName", ]
        ewsFunction: "SendItem",
        ewsArgs : function (params) {
            var result = {
                attributes: {SaveItemToFolder: true},
                "ItemIds" : {
                    "ItemId" : params.itemList
                }
            }
            return result;
        },
        ewsResponse : "SendItemResponseMessage",
        getResult : function (resp) {
            if (resp.Attachments && resp.Attachments.FileAttachment)
                return resp.Attachments.FileAttachment.AttachmentId;
            else
                return null;
        },
        returnArray : true
    },
}
 

function ewsCall(func, param) {
    request = requests[func]
    if (!request) throw "Function " + func + " not Supported!"
    const ewsFunction = request.ewsFunction
    const ewsArgs = request.ewsArgs(param)
//    debug("ewsFunc" + JSON.stringify(ewsFunction))
//    debug("ewsArgs" + JSON.stringify(ewsArgs))
    return ews.run(ewsFunction, ewsArgs, ewsSoapHeader)
    .then(ewsResult => {
        return when.promise((resolve, reject) => {
            var response = ewsResult.ResponseMessages[request.ewsResponse];
//            debug ("ewsResult:" + JSON.stringify(ewsResult))
            if (request.returnArray) {
                var result = []
                var errors = []
//                debug("resp"+JSON.stringify(response))
                toArray(response).forEach(function(el,index) {
                    if (el.attributes.ResponseClass == "Success")
                        result.push({Id:param.itemList[index].attributes.Id, Result: request.getResult(el)})
                    else
                        errors.push({Id:param.itemList[index].attributes.Id, Result: el.MessageText})
                })
                resolve({result:result,errors:errors})
            } else {
                if (response.attributes.ResponseClass=="Success") {
                    resolve(request.getResult(response))
                } else {
                    reject("Error Running " + ewsFunction + " with parameter " + param + ": " + response.MessageText);
                }
            }
        })
    })
 }
function toArray(el) {
    if (Array.isArray(el))
        return el
    else
        return [el]
}

async function checkMail_old() {
    var folderList = await ewsCall("getFolders")
    var msgList = await ewsCall("checkMail", {folderList: folderList})
    if (msgList) {
        await db.log("checkMail", msgList.length + " unread message(s) found", constants.tLog, -1)
//        debug(msgList.length + " unread message(s) found")
        var msgData = await ewsCall("processMessages", {itemList: msgList})
//        debug("msgData: " + JSON.stringify(msgData))
        var processedMsgs = []
        var mails = []
        for (msg of msgData.result) {
            var mAttachments = []
            debug("processing message " + JSON.stringify(msg))
            processedMsgs.push ({attributes: {Id: msg.Id}})
            if(msg.Result.Attachments.length>0) {
                pAttResult = await ewsCall("processAttachments", {itemList: msg.Result.Attachments})
            }
            for (att of pAttResult.result) {
                var fileName = Result.fileName;
                var tempFileName = os.tmpDir() + "\\" + fso.GetTempName()
                await db.log("checkMail", 'Saving attachment: '+ fileName, constants.tLog, -1)
                oItem.Attachments.Item(a).SaveAsFile(tempFileName)
                mAttachments.push({fileName:fileName,tempFile:tempFileName})
            }
            debug(pAttResult.result[0].Result)


            mails.push({Sender:msg.Result.Sender,Recipients:msg.Result.Recipients, Subject:msg.Result.Subject, Body:msg.Result.Body, SpoofResult: getSpoofResult(msg.Result.Headers), Attachments:mAttachments})
        }
        for (const err of msgData.errors) {
            await db.log("checkMail", "Error processing message " + err.Id + ": " + err.Result, constants.tSys, -1)
            debug("error processing message " + err.Id + ": " + err.Result)
        }
        if (processedMsgs.length>0) {
            var pAttResult = await Promise.all(pAtt)
            pAttResult.forEach(function(att) {
                debug (att.result.length + " attachment(s) returned")
            })
            debug(JSON.stringify(processedMsgs))
            var archived = await ewsCall("archiveMessages", {folderList: folderList, itemList: processedMsgs})
            debug ("archived: " + JSON.stringify(archived))
        }
    } else {
        debug("No unread messages found")
        await db.log("checkMail", "No unread messages found", constants.tLog, -1)
    }

}

async function checkMail() {
    var folderList = await ewsCall("getFolders")
    var msgList = await ewsCall("checkMail", {folderList: folderList})
    if (msgList) {
        await db.log("checkMail", msgList.length + " unread message(s) found", constants.tLog, -1)
        var msgData = await ewsCall("processMessages", {itemList: msgList})
        var processedMsgs = []
        var receivedMails=0;
        var errMails=0;
        for (msg of msgData.result) {
            processedMsgs.push ({attributes: {Id: msg.Id}})
            //mail: Sender, Recipients, Subject, Body, SpoofResult (0 = Pass), Attachments
            var res = await db.query("select 1 from vwUserCountry where lower(email) = $1", [msg.Result.Sender.toLowerCase()])
            var authStatus = 0
            if (res.rowCount)
                authStatus = 1
//                await db.query("BEGIN")
            try {
                res = await db.query("insert into mail_log (sender, receiver, subject, body, mailstatus, authStatus) values ($1, $2, $3, $4, $5, $6) returning id", [msg.Result.Sender.toLowerCase(), msg.Result.Recipients.toLowerCase(), msg.Result.Subject, msg.Result.Body, constants.statusReceived, authStatus])
                var m_ID = -1
                if (res.rowCount)
                    m_ID = res.rows[0].id
                await db.log("checkMail", "New mail received from: " + msg.Result.Sender + " with subject: " + msg.Result.Subject + ". Starting processing.", constants.tLog, m_ID)
                
                if(msg.Result.Attachments.length>0) {
                    pAttResult = await ewsCall("processAttachments", {itemList: msg.Result.Attachments})
                    for (att of pAttResult.result) {
                        var fStatus = constants.statusReceived
                        const targetFileName =  utils.pad(m_ID, 4) + "_" + att.Result.fileName;
                        if (att.Result.fileName.substring(0,3).toLowerCase()=="bc_"||att.Result.fileName.substring(0,3).toLowerCase()=="ec_") {
                            var fileType = att.Result.fileName.substring(0,3).toUpperCase()
                            var NPE_Code = att.Result.fileName.substring(3,11)
                            const rsNPE = await db.query("select ID from NPE_List where m_ID=-1 and NPE_Code=$1",[NPE_Code])
                            if (rsNPE.rowCount==0) {
                                db.log("processMail", "Attachment " + att.Result.fileName + " looks like a " + fileType.substring(0,2) + ", but the NPE_Code is not recognized. Please name the file \'" + fileType + "_[NPE_Code]\'.", constants.tWar, m_ID)
                                NPE_Code = ""
                            } else {
                                db.log("processMail", "Attachment: " + att.Result.fileName + " recognized as " + fileType.substring(0,2) + " for NPE_Code " + NPE_Code + " and stored.", constants.tWar, m_ID)
                            }
                            fStatus = constants.statusProcessed
                        } else if (att.Result.fileName.split('.').pop().toLowerCase().substring(0,2) == "xl"){
                            fileType = "SST"
                            NPE_Code = ""
                        } else {
                            const fileExt = att.Result.fileName.split('.').pop().toLowerCase();
                            // Disregard pics
                            if (fileExt != 'png' && fileExt != 'gif' && fileExt != 'jpg') 
                                db.log("processMail", "Attachment: " + att.Result.fileName + " is not an Excel file (*.xl*), Business case (BC_*) or Exit Calculation (EC_*). Skipping ...", constants.tWar, m_ID)
                            fStatus = constants.statusProcessed
                        }
                        try {
                            fs.writeFileSync(config.SST_Att_Path + "\\" + targetFileName, att.Result.fileContent,'base64');
                            res = await db.query("insert into file_log (m_ID, fileName, filestatus, fileType, NPE_ID) values ($1, $2, $3, $4, $5)", [m_ID, config.SST_Att_Path + "\\" + targetFileName, fStatus, fileType, NPE_Code])
                        } catch (e) {
                            db.log("checkMail", "Error saving file " + config.SST_Att_Path + "\\" + targetFileName + ": " + e.message, constants.tWar, m_ID)
                        }
                    }
                }
                receivedMails++;
            } catch (e) {
                db.log("checkMail", "Error inserting new mails: "+e.toString(), constants.tSys, -1);
                errMails++;
            } finally {
//                    await db.query("COMMIT")
            }
        }
        for (const err of msgData.errors) {
            await db.log("checkMail", "Error processing message " + err.Id + ": " + err.Result, constants.tSys, -1)
//            debug("error processing message " + err.Id + ": " + err.Result)
        }
        if (processedMsgs.length>0) {
            var archived = await ewsCall("archiveMessages", {folderList: folderList, itemList: processedMsgs})
            //debug ("archived: " + JSON.stringify(archived))
        }
        return receivedMails + " mail(s) received. " + ((errMails)? "Error inserting " + errMails + " mail(s)." : "" )
    } else {
//        debug("No unread messages found")
        await db.log("checkMail", "No unread messages found", constants.tLog, -1)
        return "No unread messages found"
    }
}



async function sendMails(mails) {
    if (mails.length<=0)
        return []
//    var folderList = await ewsCall("getFolders")
    var itemList = []
    var sentMails = []
    mails.forEach(function(m) {
        if (!m.ID)
            throw "Missing ID parameter from mail data"
        itemList.push({attributes:{Id:m.ID}})
    })
    var draftMails = await ewsCall("saveMessages",{itemList: itemList, mails:mails})
    var drafts = []
    var index=0;
    for (draft of draftMails.result) {
        debug("Att: " + JSON.stringify(mails[index].Attachments))
        if (mails[index].Attachments && mails[index].Attachments.length>0) {
            var attIdList = []
            mails[index].Attachments.forEach(function(att){
                attIdList.push({attributes:{Id:att}})
            })
            var attResult = await ewsCall("createAttachments", {parentItemId: draft.Result, itemList: attIdList, attList: mails[index].Attachments})
            if (attResult.result.length>0) {
                drafts.push({attributes:{Id:attResult.result[0].Result.attributes.RootItemId,ChangeKey:attResult.result[0].Result.attributes.RootItemChangeKey}})
            }
        } else {
            drafts.push({attributes:{Id: draft.Result.attributes.Id, ChangeKey: draft.Result.attributes.ChangeKey}})
        }
        sentMails.push({ID:mails[index].ID,Status:"OK"})
        index++
    }
    if (drafts.length>0) {
        try {
            var sendResult = await ewsCall("sendMessages", {itemList: drafts})
            debug (JSON.stringify(sendResult))
        } catch(e) {
            debug ("error sending messages: " + e)
            return {Error:e}
        }
    }
    return sentMails;
}

function getSpoofResult(headers) {
    var mSpoofResult = 1
    var spoofResult = headers['X-MS-Exchange-Organization-AuthAs']
    
    if(!spoofResult||spoofResult.substring(spoofResult.length-8)!='internal') {
        spoofResult = headers['X-Proofpoint-SPF-Result'];
        if(!spoofResult||spoofResult.substring(spoofResult.length-4) != 'pass') {
            spoofResult = headers['Authentication-Results'];
            if (!spoofResult||spoofResult.indexOf('spf=pass')==-1 && spoofResult.indexOf('spf=neutral')==-1) {
                mSpoofResult = 0
            }
        }
    }
}

// exchange server connection info
const ewsConfig = {
    username: config.mail_username,
    password: config.mail_password,
    host: config.mail_host
  };
   
  // initialize node-ews
  const ews = new EWS(ewsConfig);
  
/*sendMails(
    [
        {ID:1,Recipients:"MKrastev.external@unicredit.eu;marto12@gmail.com",Subject:"Test Subject1",Body:"body",Attachments:["C:\\MyPrograms\\SST\\node\\mails.txt"]},
        {ID:2,Recipients:"MKrastev.external@unicredit.eu;marto12@gmail.com",Subject:"Test Subject2",Body:"body",
        Attachments:["C:\\MyPrograms\\SST\\node\\mails.txt","C:\\MyPrograms\\SST\\node\\package.json"]},
    ]
);
*/
//checkMail()

module.exports = {
    checkMail: checkMail,
    sendMails: sendMails
}
/*
findFolder - findds IDs of all folders
checkMail - finds all new mails in inbox
processMessage - processes all found mail ids
processAttachments - processes all found attachment Ids
archiveMessage
*/