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
            If InStr(spoof_result, "spf=pass") or InStr(spoof_result, "spf=neutral") Then
            Else
                Log "processMail", "Mail spoof check failed!", tLog, m_ID
            End If
        End If
    End If

    rs.Open "select * from vwUserCountry where LCase(EMail)='" & mSender & "'", dbConn, adOpenDynamic, adLockReadOnly
    
    Do while true
    If rs.EOF Then
        Log "processMail", "E-Mail address: " & mSender & " is unknown for SST! Please contact the Administrator!", tErr, m_ID
        Exit Do
    End If

    dbConn.Execute "update mail_log set authStatus = " & authSuccess & " where id = " & m_ID
    mCountry = rs.fields("Country_Code").value
    
    Dim oAtt' As Outlook.Attachment
    For Each oAtt In oItem.Attachments
        If LCase(Left(getFileExt(oAtt.fileName), 2)) <> "xl" Then
            Log "processMail", "Attachment: " & oAtt.fileName & " is not an Excel file. Skipping ...", tWar, m_ID
        Else
            Log "processMail", "Saving attachment: " & oAtt.fileName, tLog, m_ID
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
                  Log "processMail", "Identified 'OK' command in message. Confirming data in Message ID " & old_m_ID, tLog, m_ID
                  dim mSQL 
                  mSQL = confirmMessage (old_m_ID, m_ID, mSender)
                  if mSQL<>"" Then
                    dbConn.Execute mSQL
                  End If
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
    set rs = Nothing
    Log "processMail", "End processing mail: " & mSubject, tLog, m_ID
End Sub

Sub prepareAnswer(m_ID, mSender, mSubject)
    
    Dim mqRecipients: mqRecipients = ""
    Dim mqSubject: mqSubject = ""
    Dim mqBody: mqBody = ""
    Dim mqAttachments: mqAttachments = ""

    Dim addRecipients
    addRecipients = ""
    Dim mailText
    mailText = ""
    Wscript.Echo "Creating answer for message ID " & m_ID

        mqRecipients = mSender
        mqSubject = "{" & m_ID & "} SST Loading log"
        Wscript.Echo Now(), "Start Creating HTML Log"
        Dim attachment' As String
        Wscript.Echo Now(), "Start Creating Change Report Log"

        Dim rs
        Set rs = CreateObject("ADODB.Recordset")
        ' Check if authentication is successful
        rs.Open "select authStatus, answerText, answerRecipients from Mail_Log where ID = " & m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
        Dim authStatus
        authStatus = rs.Fields("authStatus").Value
        addRecipients = rs.Fields("answerRecipients").Value
        mailText = rs.Fields("answerText").Value
        rs.Close
        if authStatus = 1 then
            ' Create countries list for sender
            rs.Open "select * from vw_Mail_Countries where LCase(EMail)='" & mSender & "'", dbConn, adOpenForwardOnly, adLockReadOnly
            Dim countryList
            Dim Rep_Country
            Rep_Country = "-"
            countryList = "'NONE'"
            While Not rs.EOF
                If Rep_Country = "-" Then
                    Rep_Country = rs.Fields("MIS_Code").Value
                Else
                    Rep_Country = ""
                End If
                countryList = countryList & ", '" & rs.Fields("MIS_Code").Value & "'"
                rs.MoveNext
            Wend
            rs.Close
            ' check for command in Subject
            If Left(Trim(mSubject),9) = "reqReport" Then
                Dim rName
                Dim rID
                If Left(Trim(mSubject),13) = "reqReportFull" then
                    rName = "reqReportFull"
                    rID=2 ' Full report
                Else
                    rName = "reqReport"
                    rID=1 ' Report with only final Rentals/Appraisals/Insurances
                End If
                Log "prepareAnswer", "Detected """ & rName & """ command. A template will be generated.", tLog, m_ID
                Dim sel
                sel = ""
                If InStr(mSubject, ":") > 0 Then
                    sel = Trim(Split(mSubject, ":")(1))
                End If
                If sel <> "" then
                    Rep_Country = sel
                    Log "prepareAnswer", "Detected country selection. Only Objects of " & Rep_Country & " will be selected.", tLog, m_ID
                    sel = " and Left(NPE_Code, 2) = '" & Rep_Country & "'"
                End If
                Dim Rep_LE
                Rep_LE = ""
                If Rep_Country <> "" Then
                    On Error Resume Next
                    Rep_Le = dbConn.Execute("select Rep_LE from vw_CountryLE where MIS_Code = '" + Rep_Country + "'").Fields("Rep_LE").Value
                    If Err.Number > 0 Then
                        Log "prepareAnswer", "Error getting default Legal Entity for " & Rep_Country & ". The error is: " & Err.Description, tErr, m_ID
                    End If
                    On Error GoTo 0
                End If
                attachment = createReport ( rID, m_ID, "where Left(NPE_Code, 2) in (" & countryList & ")" & sel, Rep_LE)
                If attachment <> "" Then
                    mqAttachments = attachment
                End If
            ElseIf Left(Trim(mSubject),12) = "reqReminders" and InStr(LCase(SST_Log_Recipients), LCase(mSender))>0 Then
                createReminders m_ID
            Else
                Log "prepareAnswer", "No command found in E-mail subject", tLog, m_ID
            End If

            rs.Open "select max(repLE) as repLE_, max(repDate) as repDate, max(Confirm_Date) as Confirm_Date, count(*) As cnt from File_Log left join calendar on file_log.repDate = calendar.rep_date where m_ID =" &  m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
            If rs.Fields("cnt").Value > 0 Then
                attachment = createChangeReport_Template(m_ID)
                Dim rsRoles
                Set rsRoles = CreateObject("ADODB.Recordset")
                rsRoles.Open "select * from vw_Mail_Roles where m_ID = " & m_ID, dbConn, adOpenDynamic, adLockReadOnly
                While Not rsRoles.EOF
                    If (rsRoles.Fields("Role").Value And roleConfirm) = 2 Then
                        If InStr(LCase(SST_Log_Recipients),LCase(rsRoles.Fields("EMail").Value)) = 0 Then
                            addRecipients = addRecipients & ";" & rsRoles.Fields("EMail").Value
                            mailText = mailText & "Dear " & dbConn.Execute("select FirstName from Users where EMail = '" & rsRoles.Fields("EMail").Value & "'").Fields("FirstName").Value & ",<BR>" 
                        End If
                    End If
                    rsRoles.MoveNext
                Wend
                mailText = mailText & "<p>" & dbConn.Execute("select FullName from Users where email='" & mSender & "'").Fields("FullName").Value & " has sent data to the SST for " & rs.Fields("repLE_").Value & " as of " & rs.Fields("repDate").Value & ". "
                mailText = mailText & "In the attachment you may find the submitted report, highlighting the changes made. "
                mailText = mailText & "In the log below you may see all the messages generated during processing the file. "
                mailText = mailText & "Please have a look and if you find the data satisfactory, answer to this E-Mail with OK in the message body."
                mailText = mailText & "If you have any concerns for the quality of delivered data, please contact the sender and request corerctions. "
                mailText = mailText & "<p>The deadline for confirming the data for " & rs.Fields("repDate").Value & " is <u>" & rs.Fields("Confirm_Date").Value & "</u>."
                mailText = mailText & "<p>Regards, SST"
                mqRecipients = mqRecipients & addRecipients
                rsRoles.Close
            Else
                attachment = ""
                Log "prepareAnswer", "No Attachments found in E-mail", tLog, m_ID
            End If

            If attachment <> "" Then
                mqAttachments = mqAttachments & attachment & ";"
            End If
        End If
        Dim htmlLog
        htmlLog = createHTMLLog(m_ID)
        mqBody = "<p>" & mailText & "<p>" & htmlLog

    queueMail mqRecipients, "", mqSubject, mqBody, mqAttachments
End Sub

Sub queueMail(mqRecipients, mqCC, mqSubject, mqBody, mqAttachments)
    Dim rsMails
    set rsMails = CreateObject("ADODB.Recordset")
    rsMails.Open "select * from mail_queue where 1=0", dbConn, adOpenForwardOnly, adLockOptimistic
    rsMails.AddNew Array("mRecipients", "mCC","mSubject","mBody","mAttachments","mStatus","mDate"), Array(mqRecipients, mqCC, mqSubject, mqBody, mqAttachments, 0, Now())
    rsMails.Update
    rsMails.Close
    set rsMails = Nothing
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
    set rsFiles = Nothing
    'Import fileName, m_ID
End Sub

Sub sendMails()
    Dim rsMails
    set rsMails = CreateObject("ADODB.Recordset")
    rsMails.Open "select * from mail_queue where mStatus = 0", dbConn, adOpenForwardOnly, adLockOptimistic
    While not rsMails.EOF
        Dim oItem
        Set oItem = oOutlook.CreateItem(0)
        With oItem
            set .SendUsingAccount = oItem.Session.Accounts.Item(SST_Account_ID)
            .To = rsMails.Fields("mRecipients").Value
            .CC = rsMails.Fields("mCC").Value & SST_Log_Recipients 
            .Subject = rsMails.Fields("mSubject").Value
            .HTMLBody = rsMails.Fields("mBody").Value
            Dim vAttachments
            
            If not IsNull(rsMails.Fields("mAttachments").Value) Then
                vAttachments = Split(rsMails.Fields("mAttachments").Value,";")
                Dim v
                For v = 0 to UBound(vAttachments)
                    If vAttachments(v)<>"" Then
                        On Error Resume Next
                        .Attachments.Add vAttachments(v)
                        If Err.Number>0 Then
                            Wscript.Echo "Attachment not found for queued message id " & rsMails.Fields("ID").Value
                        End If
                        On Error Goto 0
                    End If
                Next
            End If
            .Display
            rsMails.Fields("mStatus").Value = 1
            rsMails.Update
'            .Send
        End With
        rsMails.MoveNext
    Wend
    rsMails.Close
    set rsMails = Nothing
End Sub
