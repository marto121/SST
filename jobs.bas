Option Explicit

Sub mainJob()
    Init true
    Connect
    checkMail
    processFiles
    createReplies
    sendMails
'    confirmMessage 2
    Log "mainJob", "mainJob finished successfully.", tLog, -1
    DisConnect
End Sub

Sub checkMail()
    Dim objNewMailItems
    Set objNewMailItems = GetFolderPath(SST_MailBox_Path).Items
    Dim i
    For i = objNewMailItems.Count to 1 Step -1 
        Dim oItem
        Set oItem = objNewMailItems.Item(i)
        If oItem.Class = olMail Then
            WScript.Echo Now(), "Processing " & objNewMailItems.Item(i).Subject
            If oItem.FlagStatus = olNoFlag Then
                processMail oItem
            Else
                WScript.Echo Now(), "E-mail " & objNewMailItems.Item(i).Subject & " already Flagged as Complete. Skipping..."
            End If
        End If
    Next
End Sub

Sub processFiles()
    Dim rsFiles
    Dim Rep_LE
    Dim Rep_Date
    Set rsFiles = CreateObject("ADODB.Recordset")
    rsFiles.Open "select * from File_Log where fileStatus=" & statusReceived, dbConn, adOpenForwardOnly, adLockOptimistic
    While Not rsFiles.EOF
        Dim fileName
        fileName = rsFiles.Fields("fileName").Value
        Log "processFiles", "Start processing fileName " & fileName, tLog, rsFiles.Fields("m_ID").Value
        Import fileName, rsFiles.Fields("m_ID").Value, Rep_LE, Rep_Date
        rsFiles.Fields("fileStatus").Value = statusProcessed
        rsFiles.Fields("repLE").Value = Rep_LE
        If Rep_Date <> "" Then
            rsFiles.Fields("repDate").Value = DateSerial(left(Rep_Date,4), right(rep_date,2)+1, 0)
        End If
        rsFiles.Update
        rsFiles.moveNext
    Wend
    rsFiles.Close
    set rsFiles = Nothing
End Sub

Sub createReplies()
    Dim rsMails
    Set rsMails = CreateObject("ADODB.Recordset")
    rsMails.Open "select ID, Sender, Subject, mailStatus from Mail_Log ml where mailStatus=" & statusReceived, dbConn, adOpenForwardOnly, adLockOptimistic
    While Not rsMails.EOF
        Dim m_ID
        m_ID = rsMails.Fields("ID").Value
        WScript.Echo Now(), "Processing Mail ID " & m_ID
        prepareAnswer m_ID, rsMails.Fields("Sender").Value, rsMails.Fields("Subject").Value
        WScript.Echo "Here the mailStatus should change..."
        rsMails.Fields("mailStatus").Value = statusProcessed
        rsMails.Update
        rsMails.moveNext
    Wend
    rsMails.Close
    set rsMails = Nothing
End Sub
