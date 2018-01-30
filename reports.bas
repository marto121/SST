'Attribute VB_Name = "reports"
Option Explicit

Sub test_report()
    Init false
    createChangeReport 5
'    createReport 1, -1
End Sub

Function createChangeReport(m_ID)' As Long)' As String

    Dim cmdData' As ADODB.Command
    Dim rsData' As ADODB.Recordset
    Dim rst' As ADODB.Recordset
    Dim ex' As Excel.Application
    Dim wb' As Excel.Workbook
    Dim sh' As Excel.Worksheet
    Dim report_filename' As String
    
    Set rst = CreateObject ("ADODB.Recordset")
'    rst.Open "select * from Meta_Updatable_Tables where table_name='NPE_List'", dbConn, adOpenForwardOnly, adLockReadOnly
    rst.Open "select * from Meta_Updatable_Tables", dbConn, adOpenForwardOnly, adLockReadOnly
        
    Set ex = CreateObject ("Excel.Application")
    ex.Visible = true
'    ex.ScreenUpdating = false
    ex.DisplayAlerts = false
    Wscript.Echo Now(), "Create Workbook"
    Set wb = ex.Workbooks.Add
    
    Set cmdData = CreateObject ("ADODB.Command")
'    cmdData.CreateParameter ":m_ID", adBigInt, adParamInput, , m_ID
    cmdData.ActiveConnection = dbConn
    
    While Not rst.EOF
        Wscript.Echo Now(), "Create Worksheet"
        Set sh = wb.Sheets.Add
        sh.Name = rst.fields("table_name").value
        
        cmdData.CommandText = "select * from sel_" & rst.fields("table_name").Value
        Set rsData = CreateObject ("ADODB.Recordset")
        
        Wscript.Echo Now(), "Execute Query " & rst.fields("table_name").Value
        Set rsData = cmdData.Execute(, m_ID)
        
        printCells rsData, sh
        rst.MoveNext
        rsData.Close
        Set rsData = Nothing
    Wend
    report_filename = SST_Att_Path_Out & "ChangeReport_" & m_ID & ".xlsx"
    Wscript.Echo Now(), "Save file"
    wb.SaveAs report_filename
    wb.Close
    ex.Quit
    Set ex = Nothing
    createChangeReport = report_filename
End Function

Function printCells(rsData, sh)
        Dim f' As Integer
        Dim fc' As Integer
        fc = 1
        Dim fieldCount
        fieldCount = rsData.fields.Count

        Dim cells()
        ReDim preserve cells(fieldCount-1, 0) ' Rows/Columns switched

        Wscript.Echo Now(), "Print fields"
        For f = 1 To fieldCount
            If LCase(Left(rsData.fields(f - 1).Name, 4)) = "old_" Then
            Else
                cells(fc-1,0) = rsData.fields(f-1).Name
                With sh.Cells(1, fc)
'                    .value = rsData.fields(f - 1).Name
                    .Font.Bold = True
                End With
                fc = fc + 1
            End If
        Next' f
        Dim r' As Integer
        r = 2
        Wscript.Echo Now(), "Print data"
        While Not rsData.EOF
            Dim changed' As Boolean
            changed = False
            fc = 1
            For f = 1 To fieldCount
                If LCase(Left(rsData.fields(f - 1).Name, 4)) = "old_" Then
                Else
                    Dim newValue, oldValue
                    newValue = rsData.fields(f - 1).value
                    
                    If LCase(Left(rsData.fields(f - 1).Name, 4)) = "new_" Then
                        oldValue = rsData.fields(Replace(rsData.fields(f - 1).Name, "new_", "old_")).value
                        If IsNull(newValue) Then
                            newValue = oldValue ' If no new value is sent then take the old value
                        End If
                        
                        If (IsNull(oldValue) And Not IsNull(newValue)) Or oldValue <> newValue Then
                            changed = True
                            sh.Cells(r, fc).Interior.Color = RGB(255, 204, 102)
                            If Not IsNull(oldValue) Then
                                sh.Cells(r, fc).AddComment "Old value: " & CStr(oldValue)
                            End If
                        End If
                        
                    End If
                    Redim preserve cells(fieldCount-1, r-1)
                    cells(fc-1, r-1) = newValue
'                    sh.Cells(r, fc).value = newValue
                    If rsData.fields(f - 1).Name = "Record_Status" Then
                        If rsData.fields(f - 1).value = "New" Then
                            sh.Rows(r).Interior.Color = RGB(193, 245, 255) 'blue
                        ElseIf changed Then
                            'sh.Rows(r).Interior.Color = RGB(255, 204, 102)
                        Else
                            'sh.Cells(r, fc).value = "Confirmed"
                            'sh.Rows(r).Interior.Color = RGB(204, 255, 204)
                        End If
                    End If
                    fc = fc + 1
                End If
            Next' f
            r = r + 1
            rsData.MoveNext
        Wend
        sh.Range("A1").Resize(r-1,fc).value=transpose(cells)
End Function

Function createReport(report_id, m_ID)' As Long, m_ID' As Long)' As String
    Connect
    Dim rs' As ADODB.Recordset
    Dim rsData' As New ADODB.Recordset
    Dim ex' As Excel.Application
    Dim wb' As Excel.Workbook
    Dim sh' As Excel.Worksheet
    Dim report_code' As String
    Set rs = CreateObject ("ADODB.Recordset")
    rs.Open "select * from lst_reports where id=" & report_id, dbConn, adOpenForwardOnly, adLockReadOnly
    Do While True
        If rs.EOF Then
            Log "createReport", "Report with id: " & report_id & " does not exist", tErr, m_ID
            Exit Do
        End If
        report_code = rs.fields("Report_Code").value
        rs.Close
        rs.Open "select * from lst_sheets where report_id=" & report_id, dbConn, adOpenForwardOnly, adLockReadOnly
        If rs.EOF Then
            Log "createReport", "Report with id: " & report_id & " has no defined sheets", tErr, m_ID
            Exit Do
        End If
        Log "createReport", "Creating report """ & report_code & """", tLog, m_ID
        Set ex = CreateObject ( "Excel.Application" )
        Set wb = ex.Workbooks.Add
        While Not rs.EOF
            
            Set sh = wb.Sheets.Add
            sh.Name = rs.fields("Sheet_Name").value
            If rs.fields("Sheet_Query").value <> "" Then
                rsData.Open "select * from " & rs.fields("Sheet_Query").value, dbConn
                Dim f' As Integer
                For f = 1 To rsData.fields.Count
                    With sh.Cells(1, f)
                        .value = rsData.fields(f - 1).Name
                        .Font.Bold = True
                    End With
                Next' f
                sh.Cells(2, 1).CopyFromRecordset rsData
                rsData.Close
            End If
            
            rs.MoveNext
        Wend
        Dim fileName' As String
        For f = 0 To 9999
            fileName = wshShell.ExpandEnvironmentStrings("%TEMP%") & "\" & report_code & "_" & string(6-len(m_ID),"0") & "_" & string(6-len(f),"0") & ".xlsx"
            If fso.FileExists(fileName) = "" Then Exit For
        Next' f
        wb.SaveAs fileName
        
        wb.Close
        ex.Quit
        Set ex = Nothing
        Exit Do
    Loop
    
    rs.Close
    Set rs = Nothing
    Set rsData = Nothing
    disConnect
End Function

Function createHTMLLog(m_ID)
    Dim rs
    Dim sHTML
    Dim tBody' As String
    Set rs = CreateObject("ADODB.Recordset")
    rs.Open "select log_date,log_text,nom_log_types.color from SST_Log inner join nom_log_types on nom_log_types.id=sst_log.log_type where Mail_ID=" & m_ID & " order by sst_log.id", dbConn, adOpenForwardOnly, adLockReadOnly
    While Not rs.EOF
        tBody = tBody & "<tr bgcolor='" & rs.fields("color").value & "'><td>" & rs.fields("log_date").value & "</td><td>" & rs.fields("log_text").value & "</td></tr>" & vbNewLine
        rs.MoveNext
    Wend
    rs.Close
    sHTML = "<table cellspacing=""0"" cellpadding=""1"" border=""1"">" & vbNewLine & _
        "<thead><th>Date</th><th>Message</th></thead>" & vbNewLine & _
        tBody & vbNewLine & "</table>"
    createHTMLLog = sHTML
End Function