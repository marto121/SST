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
    confirmMessage = ""
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
        If LCase(rsMsg.Fields("Sender").Value) = mSender and LCase(rsMsg.Fields("Sender").Value)<>"mkrastev.external@unicredit.eu" Then
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

        performUpdates confirm_m_ID, log_m_ID

        rsMsg.Fields("mailStatus").Value = statusConfirmed
        rsMsg.Update

        msg = "Message " & confirm_m_ID & " from " & rsMsg.Fields("Sender").Value & " confirmed successfully!"
        confirmMessage = "Update Mail_Log Set answerText = '" & msg & "', answerRecipients='" & rsMsg.Fields("Sender").Value & "' where ID = " & log_m_ID
        Exit Do
    Loop
    dbConn.CommitTrans
    On Error resume Next
    rsMsg.Close
    set rsMsg = Nothing
    rst.Close
    set rst = Nothing
    On Error goto 0
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
    set rs = Nothing
    checkRights = hasRights
End Function

Sub createReminders(m_ID)
    Dim Rep_Date
    Dim Send_Date
    Dim Confirm_Date

    With dbConn.Execute("select Rep_Date, Send_Date, Confirm_Date from calendar inner join lastdate on lastdate.currmonth=calendar.Rep_Date")
        Rep_Date = .Fields("Rep_Date").Value
        Send_Date = .Fields("Send_Date").Value
        Confirm_Date = .Fields("Confirm_Date").Value
        .Close
    End With
    Dim rsLE
    Set rsLE = CreateObject("ADODB.RecordSet")
    rsLE.Open "select Legal_Entities.ID, Tagetik_Code, LE_Name, MIS_Code from Legal_Entities inner join nom_countries on nom_countries.id = legal_Entities.LE_Country_ID where Active = 1", dbConn, adOpenForwardOnly, adLockReadOnly
    While Not rsLE.EOF
        Dim mqRecipients: mqRecipients = ""
        Dim mqCC: mqCC = ""
        Dim mqSubject: mqSubject = ""
        Dim mqBody: mqBody = ""
        Dim mqAttachments: mqAttachments = ""
        
        mqSubject = "SST Due Dates for UCTAM " & rsLE.Fields("MIS_Code") & " for " & (Year(Rep_Date)*100 + Month(Rep_Date))
        Dim rsUsers
        Set rsUsers = CreateObject("ADODB.RecordSet")
        rsUsers.Open "select Role, FirstName, EMail from Users where LE_ID=" & rsLE.Fields("ID").Value, dbConn, adOpenForwardOnly, adLockReadOnly
        While not rsUsers.EOF
            If (rsUsers.Fields("Role").Value And roleConfirm) = 2 Then
                If InStr(LCase(SST_Log_Recipients),LCase(rsUsers.Fields("EMail").Value))=0 Then
                    mqCC = mqCC & rsUsers.Fields("EMail").Value & ";"
                End If
            Else
                mqBody = mqBody & "<p>Dear " & rsUsers.Fields("FirstName").Value & ","
                mqRecipients = mqRecipients &  rsUsers.Fields("EMail").Value & ";"
            End If
            rsUsers.MoveNext
        Wend
        rsUsers.Close
        If mqRecipients = "" Then 
            Log "createReminders", "No recipients found for LE " & rsLE.Fields("Tagetik_Code").Value & ":(" & rsLe.Fields("MIS_Code").Value & ") "& rsLE.Fields("LE_Name").Value, tErr, m_ID
        Else
            mqBody = mqBody & "<p>In the attached file you may find the monthly SST Template for " _
                & rsLE.Fields("Tagetik_Code").Value & ":(" & rsLe.Fields("MIS_Code").Value & ") "& rsLE.Fields("LE_Name").Value _
                & " as of " & (Year(Rep_Date)*100 + Month(Rep_Date)) & "."
            mqBody = mqBody & "<p>Please make sure that the template is prepared and sent back to the SST not later than <b>" & Send_Date & "</b>."
            mqBody = mqBody & "<p>Deadline for final confirmation by the CM is <b>" & Confirm_Date & "</b>."
            mqBody = mqBody & "<p>Regards, SST"
            mqAttachments = createReport ( 1, m_ID, "where Left(NPE_Code, 2) = '" & rsLE.Fields("MIS_Code").Value & "'", rsLE.Fields("Tagetik_Code").Value)
            queueMail mqRecipients, mqCC, mqSubject, mqBody, mqAttachments
        End If
        rsLE.MoveNext
    Wend
    rsLE.Close
    set rsLE = Nothing
    set rsUsers = Nothing
End Sub

Function Nz(value, valueIfNull)
    If IsNull(value) Then
        Nz = valueIfNull
    Else
        Nz = value
    End If
End Function

Sub fxConvert(m_ID)
    Dim rsMeta' As New ADODB.Recordset
    Set rsMeta = CreateObject("ADODB.Recordset")
    Dim rsACCY' As New ADODB.Recordset
    Set rsACCY = CreateObject("ADODB.Recordset")
    Dim rsNCCY' As New ADODB.Recordset
    Set rsNCCY = CreateObject("ADODB.Recordset")
    Dim rsUpd' As New ADODB.Recordset
    Set rsUpd = CreateObject("ADODB.Recordset")
    Dim tbl' As New ADODB.Recordset
    Set tbl = CreateObject("ADODB.Recordset")

    Dim vEUR_id' As Integer
    Dim updCCY_id' As Long
    Dim updCCY_col' As Long
    Dim updEUR_col' As Long
    Dim noDate' As Long

    rsMeta.Open "Meta_CCY_Conversion", dbConn, adOpenForwardOnly, adLockReadOnly
    
    rsACCY.Open "vw_asset_ccy_id", dbConn, adOpenDynamic, adLockReadOnly
    rsNCCY.Open "vw_npe_ccy_id", dbConn, adOpenDynamic, adLockReadOnly
    rsUpd.Open "Update_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    vEUR_id = dbConn.Execute("select id from nom_currencies where currency_code='EUR'").Fields("ID").value
    
    Dim aFixedRates()
    With dbConn.Execute("nom_currencies")
        While Not .EOF
            If Not IsNull(.Fields("Fixed_Rate").value) Then
                ReDim Preserve aFixedRates(.Fields("ID").value)
                aFixedRates(.Fields("ID")) = .Fields("Fixed_Rate").value
            End If
            .MoveNext
        Wend
        .Close
    End With
    
    
    rsMeta.MoveFirst
    While Not rsMeta.EOF
        Dim Ref_Date_Col: Ref_Date_Col = rsMeta.Fields("Ref_Date_Col").value
        Dim Ref_Date_Add_Col: Ref_Date_Add_Col = rsMeta.Fields("Ref_Date_Add_Col").value
        Dim CCY_ID_Col: CCY_ID_Col = rsMeta.Fields("CCY_ID_Col").value
        Dim CCY_Amount_Col: CCY_Amount_Col = rsMeta.Fields("CCY_Amount_Col").value
        Dim EUR_Amount_Col: EUR_Amount_Col = rsMeta.Fields("EUR_Amount_Col").value
        Dim Table_Name: Table_Name = rsMeta.Fields("Table_Name").value
        Dim Asset_ID_Col: Asset_ID_Col = rsMeta.Fields("Asset_ID_Col").value
        
        ' Reset counters
        updCCY_id = 0
        updCCY_col = 0
        updEUR_col = 0
        noDate = 0
        
        ' 1 Missing CCY_Code
        tbl.Open "select * from " & Table_Name & " where " & CCY_ID_Col & " is null and m_ID=" & m_ID, dbConn, adOpenForwardOnly, adLockOptimistic
        While Not tbl.EOF
            If False And (Nz(tbl.Fields(EUR_Amount_Col).value, 0) <> 0 And Nz(tbl.Fields(CCY_Amount_Col).value, 0) = 0) Then
                tbl.Fields(CCY_ID_Col).value = vEUR_id
                rsUpd.AddNew Array("Table_Name", "R_ID", "Column_Name", "Old_Value", "New_Value", "Upd_Time"), Array(Table_Name, tbl.Fields("ID").value, CCY_ID_Col, Null, vEUR_id, Now())
                updCCY_id = updCCY_id + 1
            Else
                Dim rsOCCY' As ADODB.Recordset
                If Left(LCase(Table_Name), 3) = "npe" Then
                    Set rsOCCY = rsNCCY
                Else
                    Set rsOCCY = rsACCY
                End If
                rsOCCY.MoveFirst
                rsOCCY.Find ("ID=" & tbl.Fields(Asset_ID_Col).value & "")
                If rsACCY.EOF Then
                    Debug.Print "Asset ID " & tbl.Fields(Asset_ID_Col).value & " not found"
                Else
                    tbl.Fields(CCY_ID_Col).value = rsOCCY.Fields("Currency_ID").value
                    rsUpd.AddNew Array("Table_Name", "R_ID", "Column_Name", "Old_Value", "New_Value", "Upd_Time"), Array(Table_Name, tbl.Fields("ID").value, CCY_ID_Col, Null, rsOCCY.Fields("Currency_ID").value, Now())
                    updCCY_id = updCCY_id + 1
                End If
            End If
            tbl.MoveNext
        Wend
        tbl.Close
        ' only one column filled_in
        Dim sql' As String
        sql = "select " & Table_Name & ".ID, curr.id as curr_id," & Ref_Date_Col & "," & Nz(Ref_Date_Add_Col, " null  as empty") & "," & CCY_Amount_Col & "," & EUR_Amount_Col & ", currency_code from " & Table_Name & " inner join nom_currencies as curr on curr." 
        If CCY_ID_Col <> "NPE_Currency" Then
            sql = sql & "ID"
        Else
            sql = sql & "Currency_Code"
        End If
        sql = sql &  " = " & Table_Name & "." & CCY_ID_Col & " where ((" & CCY_Amount_Col & "<>0 and iif(isnull(" & EUR_Amount_Col & "),0," & EUR_Amount_Col & ")=0) or (" & EUR_Amount_Col & "<>0 and iif(isnull(" & CCY_Amount_Col & "),0," & CCY_Amount_Col & ")=0)) and m_ID=" & m_ID
        tbl.Open sql, dbConn, adOpenForwardOnly, adLockOptimistic
        While Not tbl.EOF
            
            Dim fx' As Double
            fx = 0
            If Not IsEmpty(aFixedRates(tbl.Fields("curr_id").value)) Then
                fx = aFixedRates(tbl.Fields("curr_id").value)
            Else
                Dim Ref_Date
                
                Ref_Date = Nz(tbl.Fields(Ref_Date_Col).value, DateSerial(2000, 1, 1))
                If Ref_Date = DateSerial(2000, 1, 1) Then
                    If Not IsNull(Ref_Date_Add_Col) Then
                        Ref_Date = tbl.Fields(Ref_Date_Add_Col).value
                    End If
                End If
                
                If Ref_Date <> DateSerial(2000, 1, 1) Then
                    If Ref_Date > DateSerial(Year(Now), Month(Now), 0) Then
                        Ref_Date = DateSerial(Year(Now), Month(Now), 0)
                    End If
                    Ref_Date = DateSerial(Year(Ref_Date), Month(Ref_Date) + 1, 0)
                    sql = "select fx_rate_eop from fx_rates where ccy_code='" & tbl.Fields("currency_code").value & "' and scenario='Act' and repdate=#" & Month(Ref_Date) & "/" & Day(Ref_Date) & "/" & Year(Ref_Date) & "#"
                    fx = dbConn.Execute(sql).Fields("fx_rate_eop").value
                Else
                '    Debug.Print "No Suitable date found at " & Table_Name & ", " & tbl!id
                    noDate = noDate + 1
                End If
            End If
            If fx > 0 Then
                If Nz(tbl.Fields(CCY_Amount_Col).value, 0) <> 0 Then
                    updEUR_col = updEUR_col + 1
                    tbl.Fields(EUR_Amount_Col).value = tbl.Fields(CCY_Amount_Col).value / fx
                    rsUpd.AddNew Array("Table_Name", "R_ID", "Column_Name", "Old_Value", "New_Value", "Upd_Time"), Array(Table_Name, tbl.Fields("ID").value, EUR_Amount_Col, 0, tbl.Fields(CCY_Amount_Col).value / fx, Now())
                Else
                    updCCY_col = updCCY_col + 1
                    tbl.Fields(CCY_Amount_Col).value = tbl.Fields(EUR_Amount_Col).value * fx
                    rsUpd.AddNew Array("Table_Name", "R_ID", "Column_Name", "Old_Value", "New_Value", "Upd_Time"), Array(Table_Name, tbl.Fields("ID").value, CCY_Amount_Col, 0, tbl.Fields(EUR_Amount_Col).value / fx, Now())
                End If
            End If
            tbl.MoveNext
        Wend
        tbl.Close
        rsMeta.MoveNext
        If updCCY_id>0 or noDate>0 or updCCY_col>0 or updEUR_col>0 Then
            dim msg
            msg = "FX updates results for table " & Table_Name & ":"
            If updCCY_id>0 Then
                msg = msg & " column " & CCY_ID_Col & " updated " & updCCY_id & " times;"
            End If
            If noDate>0 Then
                msg = msg & " conversion impossible for " & noDate & "row(s) due to missing " & Ref_Date_Col & ";"
            End If
            If updCCY_col>0 Then
                msg = msg & " " & CCY_Amount_Col & " updated " & updCCY_col & " times;"
            End If 
            If updEUR_col>0 Then
                msg = msg & " " & EUR_Amount_Col & " updated " & updEUR_col & " times;"
            End If 
            Log "convertFX", msg, tLog, m_ID
        End If
'        Debug.Print Table_Name & " CCY col upd: " & updCCY_id; ", Missing date: " & noDate & ", CCY upd: " & updCCY_col & ", EUR upd: " & updEUR_col
'        DoEvents
    Wend
    rsUpd.Close
    rsMeta.Close

End Sub

Sub performUpdates(confirm_m_ID, log_m_ID)
    Dim rsUpdates
    Dim cmdUpdate
    Dim rows

    Set cmdUpdate = CreateObject ("ADODB.Command")
    cmdUpdate.ActiveConnection = dbConn
    cmdUpdate.CommandType = adCmdStoredProc

    Set rsUpdates = CreateObject("ADODB.Recordset")
    rsUpdates.Open "select Update_Name, Update_Query from lst_Updates where is_Active = 1" , dbConn, adOpenForwardOnly, adLockReadOnly
    While not rsUpdates.EOF
        cmdUpdate.CommandText = rsUpdates.Fields("Update_Query")
        cmdUpdate.Parameters.Refresh
        cmdUpdate.Execute rows, confirm_m_ID
        If rows>0 Then
            Log "performUpdates", rsUpdates.Fields("Update_Name").Value & rows & " row(s) affected.", tLog, log_m_ID
        End If
        rsUpdates.moveNext
    Wend

End Sub

Sub performChecks(m_ID)
    Dim rsChecks
    Dim cmdCheck
    Dim rows

    Set cmdCheck = CreateObject ("ADODB.Command")
    cmdCheck.ActiveConnection = dbConn
    cmdCheck.CommandType = adCmdStoredProc

    Set rsChecks = CreateObject("ADODB.Recordset")
    rsChecks.Open "select Check_Name, Check_Query from lst_Checks where is_Active = 1" , dbConn, adOpenForwardOnly, adLockReadOnly
    While not rsChecks.EOF
        Log "performChecks", "Performing " & rsChecks.Fields("Check_Name").Value, tLog, m_ID
        cmdCheck.CommandText = rsChecks.Fields("Check_Query")
        cmdCheck.Parameters.Refresh
        cmdCheck.Execute rows, m_ID
        rsChecks.moveNext
    Wend
End Sub

