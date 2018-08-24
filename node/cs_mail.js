eval((new ActiveXObject('Scripting.FileSystemObject')).OpenTextFile('json2/json2.js', 1).ReadAll());

// Constants
var olNoFlag = 0
var olMarkComplete = 5
var olMail = 43
var olExchangeUserAddressEntry = 0
var PR_TRANSPORT_MESSAGE_HEADERS = 'http://schemas.microsoft.com/mapi/proptag/0x007D001E'

var SST_Account_UserName = 'UCTAM_SST';
var SST_MailArch_Path = 'UCTAM_SST@unicredit.eu\\Processed'
var SST_regBase ='';
var SST_Account_UserName_Reg = ''
var SST_MailBox_Path = 'UCTAM_SST@unicredit.eu\\Inbox'
var objOutlook = new ActiveXObject("Outlook.Application");

if (getAccountID())
    chekcMail();

function getAccountID(){
    for (var SST_Account_ID=1; SST_Account_ID<=objOutlook.Session.Accounts.Count; SST_Account_ID++) {
        if (objOutlook.Session.Accounts.Item(SST_Account_ID).UserName==SST_Account_UserName)
            return true;
    }
    log ('ERROR: Account with name "' + SST_Account_UserName + '" not found! Default account will be used. Please check setting ' + SST_regBase + SST_Account_UserName_Reg)
    return false;
}

function chekcMail(){
    var objNewMailItems = getFolderPath(SST_MailBox_Path).Items

    if (!objNewMailItems) return 0;
    for (var i = objNewMailItems.Count; i>0 ; i--) {
        var oItem = objNewMailItems.Item(i)
        if (oItem.Class == olMail) {
            log ('Processing ' + oItem.Subject)
            if (oItem.FlagStatus != olNoFlag) {
                var m=processMail (oItem)
                log(JSON.stringify(m))
            } else {
                log('E-mail ' + oItem.Subject + ' already Flagged as Complete. Skipping...')
            }
        }
    }
}

function getFolderPath(folderPath) {
    if (folderPath.substring(0,2)=='\\\\') {
        folderPath=folderPath.substring(2)
    }
    aFolders = folderPath.split('\\')
    try {
        var oFolder = objOutlook.Session.Folders.Item(aFolders[0]);
    } catch (e) {
        log ('Error obtaining Outlook session / Folder ' + aFolders[0])
        return null;
    }
    if (oFolder) {
        for (var f = 1; f<aFolders.length; f++) {
            var subFolders = oFolder.Folders;
            try {
                oFolder = subFolders.Item(aFolders[f]);
            } catch (e) {
                log ('Error obtaining Outlook session / Folder ' + aFolders[f])
                return null;
            }
        }
    }
    return oFolder
}

function log() {
    var d = new Date();
    var msg = ''
    for (i = 0; i < arguments.length; i++) msg+=' '+arguments[i]
    WScript.Echo( msg)
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
        log ('Saving attachment: '+ fileName)
        mAttachments.push(fileName)
    }

    //oItem.MarkAsTask(olMarkComplete) CHANGE
    oItem.Save()
    var objMailArch = getFolderPath(SST_MailArch_Path)
    if(!objMailArch) {
        log ('processMail', 'Mail Archive folder ' + SST_MailArch_Path + ' not found!')
    } else
      //  oItem.Move (objMailArch); CHANGE
      ;
    return {Sender:mSender,Recipients:mRecipients, Subject:mSubject, Body:mBody, SpoofResult:mSpoofResult, Attachments:mAttachments}
}

function getMailAddress(oAddress) {
    var mAddress
    if (oAddress) {
        if (oAddress.AddressEntryUserType == olExchangeUserAddressEntry) {
            mAddress = oAddress.GetExchangeUser.PrimarySmtpAddress.toLowerCase()
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
