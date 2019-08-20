const EWS = require('node-ews');
const config = require('./config')
const when = require('when');
const ewsSoapHeader = {
    't:RequestServerVersion': {
      attributes: {
        Version: "Exchange2010"
      }
    }
  };
  
const ewsConfig = {
    username: config.mail_username,
    password: config.mail_password,
    host: config.mail_host
  };
   
  // initialize node-ews
const ews = new EWS(ewsConfig);
const cMailBox = config.mailbox
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
    .catch(function(err){
        console.log("ERR:"+JSON.stringify(err)+"=")
        throw err;
    })
 }
function toArray(el) {
    if (Array.isArray(el))
        return el
    else
        return [el]
}

ewsCall("getFolders")
    .then(folderList=>{
        console.log("ERR3:")
        ewsCall("checkMail", {folderList: folderList})
        .then((msgList,errors)=>{
            console.log(JSON.stringify(msgList))
            console.log(JSON.stringify(errors))
        })
    })
    .catch(function(err){
        console.log("ERR2:"+err)
    })

