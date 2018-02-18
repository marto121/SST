Const tLog = 0
Const tWar = 1
Const tErr = 2
Const tInfo = 3

Const statusReceived = 0
Const statusProcessed = 1
Const statusConfirmed = 2
Const statusRejected = 3

Const roleSend = 1
Const roleConfirm = 2

Const fsoForReading = 1
Const fsoForWriting = 2

Function getStatusName(inStatus)
    If inStatus = statusReceived Then
        getStatusName = "[received]"
    ElseIf inStatus = statusProcessed Then
        getStatusName = "[processed]"
    ElseIf inStatus = statusConfirmed Then
        getStatusName = "[confirmed]"
    ElseIf inStatus = statusRejected Then
        getStatusName = "[rejected]"
    Else
        getStatusName = "[unknown]"
    End If
End Function


Const authFail = 0
Const authSuccess = 1

Const ADODB_Provider = "Microsoft.ACE.OLEDB.12.0"
Const SST_regBase = "HKCU\Software\VB and VBA Program Settings\UCTAM_SST\Constants\"

Const SST_DB_Path_Reg = "SST_DB_Path"
Const SST_Att_Path_Reg = "SST_Att_Path"
Const SST_Att_Path_Out_Reg = "SST_Att_Path_Out"
Const SST_Templates_Path_Reg = "SST_Templates_Path"
Const SST_MailBox_Path_Reg = "SST_MailBox_Path"
Const SST_MailArch_Path_Reg = "SST_MailArch_Path"
Const SST_Account_UserName_Reg = "SST_Account_UserName"
Const SST_Log_Recipients_Reg = "SST_Log_Recipients"
Const SST_Account_Name_Reg = "SST_Account_Name"

Const PR_TRANSPORT_MESSAGE_HEADERS = "http://schemas.microsoft.com/mapi/proptag/0x007D001E"

Const olExchangeUserAddressEntry = 0
Const olMarkComplete = 5
Const olNoFlag = 0
Const olFlagComplete = 1
Const olMail = 43
