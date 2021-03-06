eval((new ActiveXObject('Scripting.FileSystemObject')).OpenTextFile('json2/json2.js', 1).ReadAll());
eval((new ActiveXObject('Scripting.FileSystemObject')).OpenTextFile('config.js', 1).ReadAll());

// Constants
var olNoFlag = 0
var olMarkComplete = 5
var olMail = 43
var olExchangeUserAddressEntry = 0
var olExchangeRemoteUserAddressEntry = 5
var PR_TRANSPORT_MESSAGE_HEADERS = 'http://schemas.microsoft.com/mapi/proptag/0x007D001E'

/*
var SST_Account_UserName = 'UCTAM_SST';
var SST_Account_UserName = 'outlook_085E258A99872FC4@outlook.com';
var SST_MailArch_Path = 'UCTAM_SST@unicredit.eu\\Processed'
var SST_MailArch_Path = 'personal\\Test\\processed'
var SST_regBase ='';
var SST_Account_UserName_Reg = ''
var SST_MailBox_Path = 'UCTAM_SST@unicredit.eu\\Inbox'
var SST_MailBox_Path = 'personal\\Test'
*/
var objOutlook = new ActiveXObject("Outlook.Application");
var fso = new ActiveXObject("Scripting.FileSystemObject")
var shell = new ActiveXObject("WScript.Shell")
var SST_Account_ID=1

if (WScript.Arguments.Count()) {
    try {
        getAccountID()
        var command = WScript.Arguments(0)
        switch (command) {
            case "checkMail":
                var output=checkMail();
                WScript.StdOut.Write(JSON.stringify(output))
                break
            case "sendMail":
                var input = JSON.parse(WScript.StdIn.ReadAll())
                var result=sendMails(input)
//                var input = JSON.parse("{\"aas\":\"bbb\"}")
                var output = result
                WScript.StdOut.Write(JSON.stringify(output))
                break
            default:
                break
        }
        WScript.Quit(0)
    } catch (e) {
        WScript.StdErr.Write(JSON.stringify({Error:e}))
        WScript.Quit(99)
    }
} else {
    WScript.StdErr.Write(JSON.stringify({Error:"Please specify command argument!"}))
}

function sendMails(mails) {
    var sentMails = []
    for (m=0;m<mails.length;m++) {
        try {
            var oItem = objOutlook.CreateItem(0)
            oItem.SendUsingAccount = oItem.Session.Accounts.Item(SST_Account_ID)
            oItem.To = mails[m].Recipients
            if (mails[m].CC)
            oItem.CC = mails[m].CC
            oItem.Subject = mails[m].Subject
            oItem.HTMLBody = mails[m].Body
            var atts = mails[m].Attachments
            for (a=0;a<atts.length;a++) {
                if(atts[a]!="")
                oItem.Attachments.Add (atts[a])
            }
//            oItem.Display()
            oItem.Send()
            sentMails.push({ID:mails[m].ID,Status:"OK"})
        } catch (e) {
            sentMails.push({ID:mails[m].ID,Status:e.message})
        }
    }
    return sentMails
}
function getAccountID(){
    for (SST_Account_ID=1; SST_Account_ID<=objOutlook.Session.Accounts.Count; SST_Account_ID++) {
        if (objOutlook.Session.Accounts.Item(SST_Account_ID).SmtpAddress==config.SST_Account_UserName)
            return true;
    }
    throw ('ERROR: Account with name \"' + config.SST_Account_UserName + '\" not found! Default account will be used. Please check setting \"SST_Account_UserName\".')
}

function checkMail(){
    var objNewMailItems = getFolderPath(config.SST_MailBox_Path).Items
    log (objNewMailItems.Count)
    if (!objNewMailItems) 
        throw "Mail folder path " + config.SST_MailBox_Path + " not found!";
    var result = []
    for (var i = objNewMailItems.Count; i>0 ; i--) {
        var oItem = objNewMailItems.Item(i)
        if (oItem.Class == olMail) {
            log ('Processing ' + oItem.Subject)
            if (1|(oItem.FlagStatus == olNoFlag)) {
                var m=processMail (oItem)
                if (m) result.push(m);
            } else {
                log('E-mail ' + oItem.Subject + ' already Flagged as Complete. Skipping...')
            }
        }
    }
    return result;
}

function getFolderPath(folderPath) {
    if (folderPath.substring(0,2)=='\\\\') {
        folderPath=folderPath.substring(2)
    }
    aFolders = folderPath.split('\\')
    try {
        var oFolder = objOutlook.Session.Folders.Item(aFolders[0]);
        log(oFolder)
    } catch (e) {
        log ('Error obtaining Outlook session / Folder ' + aFolders[0])
        return null;
    }
    if (oFolder) {
        for (var f = 1; f<aFolders.length; f++) {
            var subFolders = oFolder.Folders;
            try {
                oFolder = subFolders.Item(aFolders[f]);
                log(oFolder)
            } catch (e) {
                log ('Error obtaining Outlook session / Folder ' + aFolders[f])
                return null;
            }
        }
    }

    log(oFolder.Items.Count)
    return oFolder
}

function log() {
    var d = new Date();
    var msg = ''
    for (i = 0; i < arguments.length; i++) msg+=' '+arguments[i]
//    WScript.Echo( msg)
}

function processMail(oItem) {
    var mSender = oItem.SenderEmailAddress.toLowerCase();
    var s = oItem.Sender
    if (s) s = oItem.sender
    if (s) {
        if (s.AddressEntryUserType == olExchangeUserAddressEntry) {
            mSender = s.GetExchangeUser.PrimarySmtpAddress.toLowerCase()
        } else {
            mSender = s.Address.toLowerCase()
        }
    }
    var mSubject = oItem.Subject
    var mRecipients = ''
    for (r=1;r<=oItem.Recipients.Count;r++)
        mRecipients += getMailAddress(oItem.Recipients.Item(r))+';'

    var mBody = oItem.Body.substring(0,100);
    var mSpoofResult = 1
    var spoofResult = getMailHeader(oItem,'X-MS-Exchange-Organization-AuthAs')

    if(!spoofResult||spoofResult.substring(spoofResult.length-8)!='internal') {
        spoofResult = getMailHeader(oItem, 'X-Proofpoint-SPF-Result');
        if(!spoofResult||spoofResult.substring(spoofResult.length-4) != 'pass') {
            spoofResult = getMailHeader(oItem, 'Authentication-Results');
            if (!spoofResult||spoofResult.indexOf('spf=pass')==-1 && spoofResult.indexOf('spf=neutral')==-1) {
                mSpoofResult = 0
            }
        }
    }

    var mAttachments=[]
    for (var a=1; a<=oItem.Attachments.Count; a++) {
        var fileName = oItem.Attachments.Item(a).fileName;
        var tempFileName = shell.ExpandEnvironmentStrings("%TEMP%") + "\\" + fso.GetTempName()
        log ('Saving attachment: '+ fileName)
        oItem.Attachments.Item(a).SaveAsFile(tempFileName)
        mAttachments.push({fileName:fileName,tempFile:tempFileName})
    }

    //oItem.MarkAsTask(olMarkComplete) CHANGE
    oItem.Save()
    var objMailArch = getFolderPath(config.SST_MailArch_Path)
    if(!objMailArch) {
        throw ('Mail Archive folder ' + config.SST_MailArch_Path + ' not found!')
    } else
        oItem.Move (objMailArch); //CHANGE
      ;
    if (
        (oItem.Subject.toLowerCase().indexOf("out of office reply")>-1)||
        (oItem.Subject.toLowerCase().indexOf("automatic reply")>-1)
    ) return null;
    return {Sender:mSender,Recipients:mRecipients, Subject:mSubject, Body:mBody, SpoofResult:mSpoofResult, Attachments:mAttachments}
}

function getMailAddress(oAddress) {
    var mAddress
    if (oAddress) {
        log(oAddress.AddressEntry)
        if (oAddress.AddressEntry.AddressEntryUserType == olExchangeUserAddressEntry ||
            oAddress.AddressEntry.AddressEntryUserType == olExchangeRemoteUserAddressEntry) {
            mAddress = oAddress.AddressEntry.GetExchangeUser.PrimarySmtpAddress.toLowerCase()
        } else {
            mAddress = oAddress.Address.toLowerCase()
        }
    }
    return mAddress
}

function getMailHeader(oItem, header) {
    var headers = oItem.propertyAccessor.GetProperty(PR_TRANSPORT_MESSAGE_HEADERS)
    if (header == '') {
        return header
    } else {
        var lines = headers.split(/\r\n|\r|\n/g)
        for (l=0;l<lines.length;l++) {
            if (lines[l].substring(0,header.length).toLowerCase() == header.toLowerCase()) {
                return lines[l].substring(lines[l].indexOf(':')+2)
            }
        } 
    }
}
