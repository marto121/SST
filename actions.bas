'Attribute VB_Name = "actions"
Option Explicit
Const base_m_ID = -1

Sub confirmMessage_old(m_ID)' As Integer)
    Connect
    Dim rs' As ADODB.Recordset
    Dim rs_old' As ADODB.Recordset
    Dim f' As Integer
    Dim old_ID' As Long 'Change NPE ID in assets list to the one wit
    Set rs = CreateObject("ADODB.Recordset")
    Set rs_old = CreateObject("ADODB.Recordset")
    
    
    ' NPE updates
    rs.Open "select * from npe_list where m_id=" & m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
    While Not rs.EOF
        ' check if npe with the same code exists
        rs_old.Open "select * from npe_list where npe_code=""" & rs.fields("NPE_Code").value & """ and m_ID=" & base_m_ID, dbConn, adOpenForwardOnly, adLockOptimistic
        If rs_old.EOF Then
            ' such NPE_Code did not exist so just insert a new row
            rs_old.AddNew
        Else ' otherwise update dependant tables npe_id
            old_ID = rs.fields("ID").value
            dbConn.Execute "update assets_list set asset_npe_id=" & rs.fields("ID").value & " where asset_npe_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update npe_history set npe_id=" & rs.fields("ID").value & " where npe_id=" & old_ID & " and m_ID=" & m_ID
        End If
        For f = 0 To rs.fields.Count - 1 ' align fields values to new NPE Record
            If rs_old.fields(f).Name = "ID" Then
            ElseIf rs.fields(f).Name = "m_ID" Then
                rs_old.fields(f).value = base_m_ID
            Else
                rs_old.fields(f).value = rs.fields(f).value
            End If
        Next' f
        rs_old.Update
        rs_old.Close
        rs.MoveNext
    Wend
    rs.Close
    
    ' Asset updates
    rs.Open "select * from assets_list where m_id=" & m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
    While Not rs.EOF
        ' check if npe with the same code exists
        rs_old.Open "select * from assets_list where asset_code=""" & rs.fields("Asset_Code").value & """ and m_ID=" & base_m_ID, dbConn, adOpenForwardOnly, adLockOptimistic
        If rs_old.EOF Then
            ' such NPE_Code did not exist so just insert a new row
            rs_old.AddNew
        Else ' otherwise update dependant tables npe_id
            old_ID = rs.fields("ID").value
            
            dbConn.Execute "update asset_financing set financing_asset_id=" & rs.fields("ID").value & " where financing_asset_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update asset_insurances set insurance_asset_id=" & rs.fields("ID").value & " where insurance_asset_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update asset_appraisals set appraisal_asset_id=" & rs.fields("ID").value & " where appraisal_asset_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update asset_rentals set rental_asset_id=" & rs.fields("ID").value & " where rental_asset_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update asset_sales set sale_asset_id=" & rs.fields("ID").value & " where sale_asset_id=" & old_ID & " and m_ID=" & m_ID
            dbConn.Execute "update asset_history set asset_id=" & rs.fields("ID").value & " where asset_id=" & old_ID & " and m_ID=" & m_ID
        End If
        For f = 0 To rs.fields.Count - 1 ' align fields values to new NPE Record
            If rs_old.fields(f).Name = "ID" Then
            ElseIf rs.fields(f).Name = "m_ID" Then
                rs_old.fields(f).value = base_m_ID
            Else
                rs_old.fields(f).value = rs.fields(f).value
            End If
        Next' f
        rs_old.Update
        rs_old.Close
        rs.MoveNext
    Wend
    rs.Close
    
    Set rs_old = Nothing
    Set rs = Nothing
    disConnect
    
End Sub

Function confirmMessage(confirm_m_ID, log_m_ID, mSender)' As Long)' As String

    Dim cmdData' As ADODB.Command
    Dim rsMsg
    Dim rst' As ADODB.Recordset
    Dim report_filename' As String
    Dim mailStatus
    Dim rows
    Dim msg
    
    dbConn.BeginTrans
    Do while true
        Set rsMsg = CreateObject("ADODB.Recordset")
        rsMsg.Open "select mailStatus, Sender, ID from Mail_Log where ID = " & confirm_m_ID, dbConn, adOpenForwardOnly, adLockOptimistic
        If rsMsg.EOF Then
            Log "confirmMessage", "Message with ID " & confirm_m_ID & " does not exist!", tErr, log_m_ID
            Exit Do
        End If
        mailStatus = rsMsg.Fields("mailStatus").Value
        If mailStatus <> statusProcessed Then
            Log "confirmMessage", "Message with ID " & confirm_m_ID & " has status " & getStatusName(mailStatus) & " and cannot be confirmed anymore.", tErr, log_m_ID
            Exit Do
        End If
        If LCase(rsMsg.Fields("Sender").Value) = mSender Then
            Log "confirmMessage", mSender & " cannot confirm messsage with ID " & confirm_m_ID & " because it was received from the same address.", tErr, log_m_ID
            Exit Do
        End If

        Set cmdData = CreateObject ("ADODB.Command")
        cmdData.ActiveConnection = dbConn
        cmdData.CommandType = adCmdStoredProc
        cmdData.CommandText = "vw_Mail_auth_sender"
        cmdData.Parameters.Refresh
        
        Set rst = CreateObject ("ADODB.Recordset")
        Set rst = cmdData.Execute(rows, Array(mSender, confirm_m_ID))
        If not rst.EOF Then
            msg = "Message confirmation failed. You are not allowed to confirm the data for the following Objects: "
            While not rst.EOF
                msg = msg & rst.Fields("Object_Code").Value & ", "
                rst.MoveNext
            Wend
            msg = left(msg, len(msg)-2) & "."
            Log "confirmMessage", msg, tErr, log_m_ID
            Exit Do
        End If
        rst.Close
        rst.Open "select * from Meta_Updatable_Tables order by ID", dbConn, adOpenForwardOnly, adLockReadOnly
            
        While Not rst.EOF
            Dim tableName 
            tableName = rst.fields("table_name").Value
            Log "confirmMessage", "Executing confirm action for " & tableName, tLog, log_m_ID
            If rst.Fields("Del_Key")="yes" Then
                cmdData.CommandText = "del_" & tableName
                cmdData.Parameters.Refresh
                cmdData.Execute rows, confirm_m_ID
                Log "confirmMessage", tableName & ": " & rows & " row(s) deleted.", tLog, log_m_ID
            Else
                cmdData.CommandText = "upd_" & tableName
                cmdData.Parameters.Refresh
                cmdData.Execute rows, confirm_m_ID
                Log "confirmMessage", tableName & ": " & rows & " row(s) updated.", tLog, log_m_ID
            End If
            cmdData.CommandText = "ins_" & tableName
            cmdData.Parameters.Refresh
            cmdData.Execute rows, confirm_m_ID
            Log "confirmMessage", tableName & ": " & rows & " row(s) inserted.", tLog, log_m_ID

            rst.MoveNext
        Wend
        cmdData.CommandText = "upd_old_Linked_Mails_Reject"
        cmdData.Parameters.Refresh
        cmdData.Execute rows, confirm_m_ID
        If rows>0 Then
            Log "confirmMessage", rows & " previous data mails rejected due to related data in currently confirmed message.", tLog, log_m_ID
        End If

        rsMsg.Fields("mailStatus").Value = statusConfirmed
        rsMsg.Update
        Exit Do
    Loop
    dbConn.CommitTrans
    On Error resume Next
    rsMsg.Close
    rst.Close
    On Error goto 0
    confirmMessage = true
End Function

Function checkRights(m_ID)
    if not isNumeric(m_ID) Then
        checkRights = false
        Exit Function
    End if
    Dim rs
    set rs = CreateObject("ADODB.Recordset")
    rs.Open "select * from vwFileRights where m_ID=" & m_ID, dbConn, adOpenForwardOnly, adLockReadOnly
    Dim hasRights
    hasRights = true
    While not rs.EOF
        If IsNull(rs.Fields("repLE").Value) Then
            hasRights = false
            Dim msg
            msg = "Sender " & rs.Fields("Sender").Value & " has no permissions to work with Legal Entity " & rs.Fields("Tagetik_Code").Value
            msg = msg & " " & rs.Fields("LE_Name").Value & " as specified in File " & rs.Fields("fileName").Value
            Log "checkRights", msg, tErr, m_ID
        End If
        rs.MoveNext
    Wend
    rs.Close
    checkRights = hasRights
End Function