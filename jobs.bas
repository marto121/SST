Option Explicit

Sub mainJob()
    Init true
    Connect
    checkMail
    processFiles
    sendReplies
'    confirmMessage 2
    Log "mainJob", "mainJob finished successfully.", tLog, -1
    DisConnect
End Sub

Sub checkMail()
    Dim objNewMailItems
    Set objNewMailItems = GetFolderPath(SST_MailBox_Path).Items
    Dim i
    For i = 1 to objNewMailItems.Count
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
    Set rsFiles = CreateObject("ADODB.Recordset")
    rsFiles.Open "select * from File_Log where fileStatus=" & statusReceived, dbConn, adOpenForwardOnly, adLockOptimistic
    While Not rsFiles.EOF
        Dim fileName
        fileName = rsFiles.Fields("fileName").Value
        WScript.Echo Now(), "Processing fileName " & fileName
        Import fileName, rsFiles.Fields("m_ID").Value
        rsFiles.Fields("fileStatus").Value = statusProcessed
        rsFiles.Update
        rsFiles.moveNext
    Wend
    rsFiles.Close
End Sub

Sub sendReplies()
    Dim rsMails
    Set rsMails = CreateObject("ADODB.Recordset")
    rsMails.Open "select ID, Sender, mailStatus from Mail_Log ml where mailStatus=" & statusReceived, dbConn, adOpenForwardOnly, adLockOptimistic
    While Not rsMails.EOF
        Dim m_ID
        m_ID = rsMails.Fields("ID").Value
        WScript.Echo Now(), "Processing Mail ID " & m_ID
        prepareAnswer m_ID, rsMails.Fields("Sender").Value
        WScript.Echo "Here the mailStatus should change..."
        rsMails.Fields("mailStatus").Value = statusProcessed
        rsMails.Update
        rsMails.moveNext
    Wend
    rsMails.Close
End Sub
