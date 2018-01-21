Option Explicit

Public SST_DB_Path' As String
Public SST_Att_Path' As String
Public SST_Att_Path_Out' As String
Public SST_MailBox_Path' As String
Public SST_Account_UserName' As String
Public SST_Log_Recipients
Public SST_Account_ID' As Long
Public oOutlook

Sub Init(withOutlook)

On Error Resume Next
	SST_DB_Path = wshShell.RegRead ( SST_regBase & SST_DB_Path_Reg )
    Wscript.Echo "Settings:"
    Wscript.Echo "SST_DB_Path=" & SST_DB_Path
	SST_Att_Path = wshShell.RegRead ( SST_regBase & SST_Att_Path_Reg )
    Wscript.Echo "SST_Att_Path=" & SST_Att_Path
	SST_Att_Path_Out = wshShell.RegRead ( SST_regBase & SST_Att_Path_Out_Reg )
    Wscript.Echo "SST_Att_Path_Out=" & SST_Att_Path_Out
	SST_MailBox_Path = wshShell.RegRead ( SST_regBase & SST_MailBox_Path_Reg )
    Wscript.Echo "SST_MailBox_Path=" & SST_MailBox_Path
	SST_Account_UserName = wshShell.RegRead ( SST_regBase & SST_Account_UserName_Reg )
    Wscript.Echo "SST_Account_UserName=" & SST_Account_UserName
	SST_Log_Recipients = wshShell.RegRead ( SST_regBase & SST_Log_Recipients_Reg )
    Wscript.Echo "SST_Log_Recipients=" & SST_Log_Recipients
On Error Goto 0

    If withOutlook Then
        Set oOutlook = CreateObject ("Outlook.Application")
        Do
            For SST_Account_ID = 1 To oOutlook.Session.Accounts.Count
                If oOutlook.Session.Accounts.Item(SST_Account_ID).UserName = SST_Account_UserName Then Exit Do
            Next' SST_Account_ID
            WScript.Echo Now(), "ERROR: Account with name '" & SST_Account_UserName & "' not found! Default account will be used. Please check setting " & SST_regBase & SST_Account_UserName_Reg
            SST_Account_ID = 1
            Exit Do
        Loop While True
    End If
End Sub
