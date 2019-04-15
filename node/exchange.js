const EWS = require('node-ews');
const when = require('when');
const config = require('./config')
const cMailBox = config.mailbox
const debug = require('debug')('sst_mail');
const fs = require('fs');
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
                        "Id": params.folderList["Inbox"]
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
                var mBody = msg.Body["$value"].trim().substring(0,100)
                var mAttachments = []
                toArray(msg.Attachments.FileAttachment).forEach(function (att) {
                    mAttachments.push({"attributes":{"Id":att.AttachmentId.attributes.Id}})
                })
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
            var result = {
                "ToFolderId" : {
                    "t:FolderId": {
                        "attributes": {
                            "Id": params.folderList["Processed"]
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

async function checkMail() {
    var folderList = await ewsCall("getFolders")
    var msgList = await ewsCall("checkMail", {folderList: folderList})
    if (msgList) {
        debug(msgList.length + " unread message(s) found")
        var msgData = await ewsCall("processMessages", {itemList: msgList})
        debug("msgData: " + JSON.stringify(msgData))
        var pAtt = []
        var processedMsgs = []
        msgData.result.forEach(function(msg) {
            debug("processing message " + JSON.stringify(msg))
            processedMsgs.push ({attributes: {Id: msg.Id}})
            pAtt.push(ewsCall("processAttachments", {itemList: msg.Result.Attachments}))
        })
        msgData.errors.forEach(function(err) {
            debug("error processing message " + err.Id + ": " + err.Result)
        })
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
    }

}

async function sendMails(mails) {
    if (mails.length<=0)
        return
//    var folderList = await ewsCall("getFolders")
    var itemList = []
    mails.forEach(function(m) {
        if (!m.ID)
            throw "Missing ID parameter from mail data"
        itemList.push({attributes:{Id:m.ID}})
    })
    var draftMails = await ewsCall("saveMessages",{itemList: itemList, mails:mails})
    var pAtt = []
    draftMails.result.forEach(function(draft,index) {
        if (mails[index].Attachments && mails[index].Attachments.length>0) {
            var attIdList = []
            mails[index].Attachments.forEach(function(att){
                attIdList.push({attributes:{Id:att}})
            })
            pAtt.push( ewsCall("createAttachments", {parentItemId: draft.Result, itemList: attIdList, attList: mails[index].Attachments}) )
        }
    })
    var pAttResult = await Promise.all(pAtt)
    var drafts = []
    pAttResult.forEach(function(attResult) {
        if (attResult.result.length>0) {
            drafts.push({attributes:{Id:attResult.result[0].Result.attributes.RootItemId,ChangeKey:attResult.result[0].Result.attributes.RootItemChangeKey}})
        }
    })
    if (drafts.length>0) {
        var sendResult = await ewsCall("sendMessages", {itemList: drafts})
        debug (JSON.stringify(sendResult))
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
  
sendMails(
    [
        {ID:1,Recipients:"MKrastev.external@unicredit.eu;marto12@gmail.com",Subject:"Test Subject1",Body:"body",Attachments:["C:\\Users\\Marti\\Documents\\Programming\\SST\\src\\node\\mails.txt"]},
        {ID:2,Recipients:"MKrastev.external@unicredit.eu;marto12@gmail.com",Subject:"Test Subject2",Body:"body",
        Attachments:["C:\\Users\\Marti\\Documents\\Programming\\SST\\src\\node\\mails.txt","C:\\Users\\Marti\\Documents\\Programming\\SST\\src\\node\\package.json"]},
    ]
);

//checkMail()

/*
findFolder - findds IDs of all folders
checkMail - finds all new mails in inbox
processMessage - processes all found mail ids
processAttachments - processes all found attachment Ids
archiveMessage
*/