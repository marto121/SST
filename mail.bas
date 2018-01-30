'Attribute VB_Name = "mail"
Option Explicit

Sub processMail(oItem)' As MailItem)
    Dim mCountry' As String
    Dim m_ID' As Long
    Dim mSender' As String
    mSender = LCase(oItem.SenderEmailAddress)
    Dim s
    Set s = oItem.Sender
    If Not s Is Nothing Then
    Set s = oItem.sender
    If Not s Is Nothing Then
        If s.AddressEntryUserType = olExchangeUserAddressEntry Then
            mSender = LCase(s.GetExchangeUser.PrimarySmtpAddress)
        Else
            mSender = LCase(s.Address)
        End If
    End If
    End If
    
    
    Dim rs' As Recordset
    
    Dim fields' As Variant
    'fields(0) = "sender"
    'fields(1) = "receiver"
    'fields(2) = "subject"
    Dim fieldvalues' As Variant
    Set rs = CreateObject ("ADODB.Recordset")
    rs.Open "select * from Mail_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    rs.AddNew Array("sender", "receiver", "subject", "mailStatus"), Array(mSender, oItem.Recipients, oItem.Subject, statusReceived)
    rs.Update
    m_ID = rs.fields("ID").value
    Log "processMail", "New mail received from: " & mSender & " with subject: " & oItem.Subject & ". Starting processing.", tLog, m_ID
    rs.Close

    Dim spoof_result
    spoof_result = getMailHeader(oItem,"X-MS-Exchange-Organization-AuthAs")
    If lcase(spoof_result) <> "internal" Then
        spool_result = getMailHeader(oItem, "X-Proofpoint-SPF-Result")
        If lcase(spoof_result) <> "pass" Then
            Log "processMail", "Mail spoof check failed!", tErr, m_ID
        End If
    End If

    rs.Open "vwUserCountry", dbConn, adOpenDynamic, adLockReadOnly
    rs.Find "EMail='" & mSender & "'"
    
    Do while true
    If rs.EOF Then
        Log "processMail", "E-Mail address: " & mSender & " is unknown for SST! Please contact the Administrator!", tErr, m_ID
        Exit Do
    End If
    mCountry = rs.fields("Country_Code").value
    
    Dim oAtt' As Outlook.Attachment
    For Each oAtt In oItem.Attachments
        If Left(getFileExt(oAtt.fileName), 2) <> "xl" Then
            Log "processMail", "Attachment: " & oAtt.fileName & " is not an Excel file. Skipping ...", tWar, m_ID
        Else
            Log "processMail", "Processing attachment: " & oAtt.fileName, tLog, m_ID
            processAttachment oAtt, mCountry, m_ID
        End If
    Next' oAtt
    oItem.MarkAsTask olMarkComplete
    oItem.Save
    Exit Do
    Loop

    rs.Close
    Log "processMail", "End processing mail: " & oItem.Subject, tLog, m_ID
End Sub

Sub prepareAnswer(m_ID, mSender)
    Dim oItem
    Set oItem = oOutlook.CreateItem(0)
    Wscript.Echo "Creating answer for message ID " & m_ID
    With oItem
        .SendUsingAccount = oItem.Session.Accounts.Item(SST_Account_ID)
        .To = mSender
        .CC = SST_Log_Recipients
        .Subject = "{" & m_ID & "} SST Loading log"
        Wscript.Echo Now(), "Start Creating HTML Log"
        Dim changeReport' As String
        Wscript.Echo Now(), "Start Creating Change Report Log"
        Dim rs
        Set rs = CreateObject("ADODB.Recordset")
        rs.Open "select count(*) As cnt from File_Log where m_ID =" &  m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
        If rs.Fields("cnt").Value > 0 Then
            changeReport = createChangeReport(m_ID)
        Else
            changeReport = ""
            Log "prepareAnswer", "No Attachments found in E-mail", tLog, m_ID
        End If

        If changeReport <> "" Then
            .Attachments.Add changeReport
        End If
        .HTMLBody = createHTMLLog(m_ID)
        .Display  'Or use .Send
 '       .SaveAs "Drafts"
    End With
    Set oItem = Nothing
End Sub

Sub processAttachment(oAtt, mCountry, m_ID)' As Outlook.Attachment, mCountry' As String, m_ID' As Long)
    Dim fileName
    fileName = SST_Att_Path & String(5-len(m_ID),"0") & "_" & oAtt.fileName
    oAtt.SaveAsFile fileName
    Dim rsFiles
    Set rsFiles = CreateObject("ADODB.Recordset")
    rsFiles.Open "select * from File_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    rsFiles.AddNew Array("m_ID", "fileName", "fileStatus"), Array(m_ID, fileName, statusReceived)
    rsFiles.Update
    rsFiles.Close
    'Import fileName, m_ID
End Sub
