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
    Dim mSubject
    mSubject = oItem.Subject
    Set rs = CreateObject ("ADODB.Recordset")
    rs.Open "select * from Mail_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    rs.AddNew Array("sender", "receiver", "subject", "mailStatus", "authStatus"), Array(mSender, oItem.Recipients, mSubject, statusReceived, authFail)
    rs.Update
    m_ID = rs.fields("ID").value
    Log "processMail", "New mail received from: " & mSender & " with subject: " & mSubject & ". Starting processing.", tLog, m_ID
    rs.Close

    Dim spoof_result
    spoof_result = getMailHeader(oItem,"X-MS-Exchange-Organization-AuthAs")
    If lcase(spoof_result) <> "internal" Then
        spoof_result = getMailHeader(oItem, "X-Proofpoint-SPF-Result")
        If lcase(spoof_result) <> "pass" Then
            spoof_result = getMailHeader(oItem, "Authentication-Results")
            If InStr(spoof_result, "spf=pass") Then
            Else
                Log "processMail", "Mail spoof check failed!", tErr, m_ID
            End If
        End If
    End If

    rs.Open "vwUserCountry", dbConn, adOpenDynamic, adLockReadOnly
    rs.Find "EMail='" & mSender & "'"
    
    Do while true
    If rs.EOF Then
        Log "processMail", "E-Mail address: " & mSender & " is unknown for SST! Please contact the Administrator!", tErr, m_ID
        Exit Do
    End If

    dbConn.Execute "update mail_log set authStatus = " & authSuccess & " where id = " & m_ID
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

    ' check for m_ID in Subject
    Dim openBracket
    openBracket = InStr(mSubject, "{")
    If openBracket Then
        If InStr(openBracket, mSubject, "}") Then
            Dim old_m_ID
            old_m_ID = right(mSubject, len(mSubject)-openBracket)
            old_m_ID = left(old_m_ID, InStr(old_m_ID, "}")-1)
            Log "processMail", "Identified subject for m_ID " & old_m_ID, tLog, m_ID
            If checkRights(old_m_ID) Then
                Log "processMail", "Authorisation check successfull.", tLog, m_ID
                if LCase(left(oItem.Body,2)) = "ok" or LCase(left(oItem.Body,2)) = "ок" _
                  or LCase(left(oItem.Body,2)) = "оk" or LCase(left(oItem.Body,2)) = "oк" Then
                  confirmMessage old_m_ID, m_ID
                End If
            End If
        End If
    End If

    Exit Do
    Loop

    oItem.MarkAsTask olMarkComplete
    oItem.Save
    Dim objMailArch
    Set objMailArch = GetFolderPath(SST_MailArch_Path)
    If objMailArch is Nothing Then
        Log "processMail", "Mail Archive folder " & SST_MailArch_Path & " not found!", tErr, m_ID
    Else
        oItem.Move objMailArch
    End If

    rs.Close
    Log "processMail", "End processing mail: " & mSubject, tLog, m_ID
End Sub

Sub prepareAnswer(m_ID, mSender, mSubject)
    Dim oItem
    Set oItem = oOutlook.CreateItem(0)
    Wscript.Echo "Creating answer for message ID " & m_ID
    With oItem
        set .SendUsingAccount = oItem.Session.Accounts.Item(SST_Account_ID)
        .To = mSender
        .CC = SST_Log_Recipients
        .Subject = "{" & m_ID & "} SST Loading log"
        Wscript.Echo Now(), "Start Creating HTML Log"
        Dim attachment' As String
        Wscript.Echo Now(), "Start Creating Change Report Log"

        Dim rs
        Set rs = CreateObject("ADODB.Recordset")
        ' Check if authentication is successful
        rs.Open "select authStatus from Mail_Log where ID = " & m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
        Dim authStatus
        authStatus = rs.Fields("authStatus").Value
        rs.Close
        if authStatus = 1 then
            ' Create countries list for sender
            rs.Open "select * from vw_Mail_Countries where EMail='" & mSender & "'", dbConn, adOpenForwardOnly, adLockReadOnly
            Dim countryList
            countryList = "'NONE'"
            While Not rs.EOF
                countryList = countryList & ", '" & rs.Fields("MIS_Code").Value & "'"
                rs.MoveNext
            Wend
            rs.Close
            ' check for command in Subject
            If mSubject = "reqReport" Then
                attachment = createReport ( 1, m_ID, "where Left(NPE_Code, 2) in (" & countryList & ")" )
                If attachment <> "" Then
                    .Attachments.Add attachment
                End If
            End If

            rs.Open "select count(*) As cnt from File_Log where m_ID =" &  m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
            If rs.Fields("cnt").Value > 0 Then
                attachment = createChangeReport(m_ID)
            Else
                attachment = ""
                Log "prepareAnswer", "No Attachments found in E-mail", tLog, m_ID
            End If

            If attachment <> "" Then
                .Attachments.Add attachment
            End If
        End If
        .HTMLBody = createHTMLLog(m_ID)
        .Send '.Display 'Send  'Or use .Send
 '       .SaveAs "Drafts"
    End With
    Set oItem = Nothing
End Sub

Sub processAttachment(oAtt, mCountry, m_ID)' As Outlook.Attachment, mCountry' As String, m_ID' As Long)
    Dim fileName
    fileName = SST_Att_Path & String(5-len(m_ID),"0") & m_ID & "_" & oAtt.fileName
    oAtt.SaveAsFile fileName
    Dim rsFiles
    Set rsFiles = CreateObject("ADODB.Recordset")
    rsFiles.Open "select * from File_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    rsFiles.AddNew Array("m_ID", "fileName", "fileStatus"), Array(m_ID, fileName, statusReceived)
    rsFiles.Update
    rsFiles.Close
    'Import fileName, m_ID
End Sub
