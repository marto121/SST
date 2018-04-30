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
        cmdData.CommandText = "select * from sel_" & rst.fields("table_name").Value
        Set rsData = CreateObject ("ADODB.Recordset")
        
        Wscript.Echo Now(), "Execute Query " & rst.fields("table_name").Value
        Set rsData = cmdData.Execute(, m_ID)
        
        if rsData.EOF Then
            Log "createChangeReport", "No new data for " & rst.fields("table_name").Value, tInfo, m_ID
        else
            Wscript.Echo Now(), "Create Worksheet"
            Set sh = wb.Sheets.Add
            sh.Name = rst.fields("table_name").value
            
            printCells rsData, sh, m_ID
        End If
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

Function printCells(rsData, sh, m_ID)
        Dim f' As Integer
        Dim fc' As Integer
        Dim records_new
        Dim records_changed
        records_new = 0
        records_changed = 0
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
            Dim changedRow' As Boolean
            Dim changedField
            changedRow = False
            fc = 1
            For f = 1 To fieldCount
                changedField = False
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
                            changedField = True
                        End If
                        If IsNumeric(oldValue) and IsNumeric(newValue) Then
                            If Round(oldValue,2)=Round(newValue,2) Then
                                changedField = false
                            End If
                        End If
                        If IsNumeric(newValue) Then
                            If IsNull(oldValue) and newValue=0 Then
                                changedField = false
                            End If
                        End If
                        If changedField Then
                            changedRow = True
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
                            records_new = records_new + 1
                        ElseIf changedRow Then
                            records_changed = records_changed + 1
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
        If records_new+records_changed>0 Then
            Log "printCells", records_new & " new record(s) and " & records_changed & " changed record(s) in sheet " & sh.Name, tInfo, m_ID
        Else
            Log "printCells", "No New/changed records in sheet " & sh.Name, tInfo, m_ID
        End If
End Function

Function createReport(report_id, m_ID, condition, Rep_LE)' As Long, m_ID' As Long)' As String
'    Connect
    Dim rs' As ADODB.Recordset
    Dim rsData' As New ADODB.Recordset
    Dim ex' As Excel.Application
    Dim wb' As Excel.Workbook
    Dim sh' As Excel.Worksheet
    Dim report_code' As String
    Set rs = CreateObject ("ADODB.Recordset")
    Set rsData = CreateObject ("ADODB.Recordset")
    rs.Open "select * from lst_reports where id=" & report_id, dbConn, adOpenForwardOnly, adLockReadOnly
    Do While True
        If rs.EOF Then
            Log "createReport", "Report with id: " & report_id & " does not exist", tErr, m_ID
            Exit Do
        End If
        report_code = rs.fields("Report_Code").value
        Dim templateFileName
        templateFileName = rs.Fields("Template_FileName").Value
        rs.Close
        rs.Open "select * from lst_sheets where report_id=" & report_id, dbConn, adOpenForwardOnly, adLockReadOnly
        If rs.EOF Then
            Log "createReport", "Report with id: " & report_id & " has no defined sheets", tErr, m_ID
            Exit Do
        End If
        Log "createReport", "Creating report """ & report_code & """ for " & Rep_LE, tLog, m_ID
        Set ex = CreateObject ( "Excel.Application" )

        If templateFileName <> "" Then
            templateFileName = SST_Templates_Path & "\" & templateFileName
            If fso.FileExists (templateFileName) Then
                Set wb = ex.Workbooks.Open (templateFileName, False)
                On Error Resume Next
                wb.Names("Rep_LE").RefersToRange.Value = Rep_LE
                wb.Names("Rep_Date").RefersToRange.Value = Year(DateSerial(Year(Now),Month(Now),0))*100 + Month(DateSerial(Year(Now),Month(Now),0))
                On Error Goto 0
            Else
                Log "createReport", "Template file name " & templateFileName & " not found! Creating empty file.", tWar, m_ID
                templateFileName = ""
            End If
        End If

        If templateFileName = "" then Set wb = ex.Workbooks.Add
 
        Do While Not rs.EOF
            Set sh = Nothing    
            On Error Resume Next 'Try if sheet exists
            Set sh = wb.Sheets(rs.fields("Sheet_Name").Value)
            On Error GoTo 0
            If sh is Nothing Then
                Set sh = wb.Sheets.Add
                sh.Name = rs.fields("Sheet_Name").value
            End If
            If rs.fields("Sheet_Query").value <> "" Then
                Dim sql
                sql = "select " & rs.Fields("Sheet_Columns") & " from " & rs.fields("Sheet_Query").Value & " " & condition
                on Error Resume Next
                rsData.Open sql, dbConn
                If Err.Number <> 0 Then
                    Log "createReport", "Error running SQL: " & sql, tErr, m_ID
                    On Error GoTo 0
                    Exit Do
                End If
                On Error Goto 0
                Dim f' As Integer
                If templateFileName = "" Then ' Do not change field names if no template
                    For f = 1 To rsData.fields.Count
                        With sh.Cells(1, f)
                            .value = rsData.fields(f - 1).Name
                            .Font.Bold = True
                        End With
                    Next' f
                End If
                sh.Activate ' Necessary in order to avoid bug with format change to date in other sheets
                sh.Cells(2, 1).CopyFromRecordset rsData
                rsData.Close
            End If
            
            rs.MoveNext
        Loop
        Dim fileName' As String
        For f = 0 To 9999
            fileName = SST_Att_Path_Out & "\" & report_code & "_" & string(4-len(f),"0") & f & ".xlsx"
            If Not fso.FileExists(fileName) Then Exit For
        Next' f
        wb.SaveAs fileName', 50 'xlExcel12
        createReport = fileName
        wb.Close
        ex.Quit
        Set ex = Nothing
        Exit Do
    Loop
    
    rs.Close
    Set rs = Nothing
    Set rsData = Nothing
'    disConnect
End Function

Function createHTMLLog(m_ID)
    Dim rs
    Dim sHTML
    Dim tBody' As String
    Set rs = CreateObject("ADODB.Recordset")
    rs.Open "select log_date,log_text,nom_log_types.color from SST_Log inner join nom_log_types on nom_log_types.id=sst_log.log_type where Mail_ID=" & m_ID & " order by sst_log.id", logConn, adOpenForwardOnly, adLockReadOnly
    While Not rs.EOF
        tBody = tBody & "<tr bgcolor='" & rs.fields("color").value & "'><td>" & rs.fields("log_date").value & "</td><td>" & rs.fields("log_text").value & "</td></tr>" & vbNewLine
        rs.MoveNext
    Wend
    rs.Close
    sHTML = "<table cellspacing=""0"" cellpadding=""1"" border=""1"">" & vbNewLine & _
        "<thead><th>Date</th><th>Message</th></thead>" & vbNewLine & _
        tBody & vbNewLine & "</table>"
    createHTMLLog = sHTML
    set rs = Nothing
End Function


Function createChangeReport_Template(m_ID)' As Long)' As String

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
    Dim templateFileName
    templateFileName = "SST_Template.xlsx"
    templateFileName = SST_Templates_Path & "\" & templateFileName
    If fso.FileExists (templateFileName) Then
        Set wb = ex.Workbooks.Open (templateFileName, False)
        On Error Resume Next
        Dim rsF
        set rsF = dbConn.Execute("select repLE, repDate from File_Log where m_ID=" & m_ID)
        wb.Names("Rep_LE").RefersToRange.Value = rsF.Fields("repLE").Value
        wb.Names("Rep_Date").RefersToRange.Value = year(rsF.Fields("repDate").Value)*100+month(rsF.Fields("repDate").Value)
        wb.Names("preparedBy").RefersToRange.Value = "SST Change report for message " & m_ID
        wb.Names("preparedOn").RefersToRange.Value = Now()
        On Error Goto 0
    Else
        Log "createReport", "Template file name " & templateFileName & " not found! Creating empty file.", tWar, m_ID
        templateFileName = ""
        Set wb = ex.Workbooks.Add
    End If
    
    Set cmdData = CreateObject ("ADODB.Command")
'    cmdData.CreateParameter ":m_ID", adBigInt, adParamInput, , m_ID
    cmdData.ActiveConnection = dbConn
    
    While Not rst.EOF
        cmdData.CommandText = "select * from sel_" & rst.fields("table_name").Value
        Set rsData = CreateObject ("ADODB.Recordset")
        
        Wscript.Echo Now(), "Execute Query " & rst.fields("table_name").Value
        Set rsData = cmdData.Execute(, m_ID)
        
        if rsData.EOF Then
            Log "createChangeReport", "No new data for " & rst.fields("table_name").Value, tInfo, m_ID
        else
            Wscript.Echo Now(), "Create Worksheet"
            Set sh = Nothing    
            On Error Resume Next 'Try if sheet exists
            Set sh = wb.Sheets(rst.fields("Sheet_Name").Value)
            On Error GoTo 0
            If sh is Nothing Then
                Set sh = wb.Sheets.Add
                sh.Name = rst.fields("Sheet_Name").value
            End If
            
            printCells_Template rsData, sh, m_ID, rst.fields("Fields_List").Value
        End If
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
    createChangeReport_Template = report_filename
End Function

Function printCells_Template(rsData, sh, m_ID, fieldList)
        Dim f' As Integer
        Dim fc' As Integer
        Dim records_new
        Dim records_changed
        records_new = 0
        records_changed = 0
        fc = 1
        Dim isEmptySheet
        Dim fieldCount
        fieldCount = rsData.fields.Count

        Dim destCols
        Set destCols = CreateObject ( "Scripting.Dictionary" )
        Dim destFieldArray
        destFieldArray = Split(fieldList,",")
        Wscript.Echo "FieldList: " + fieldList
        Dim df

        Dim cells()
        ReDim preserve cells(50 + fieldCount-1, 0) ' Rows/Columns switched

        Wscript.Echo Now(), "Print fields"
        Dim r' As Integer
        r = 2
        isEmptySheet = False
        If sh.Cells(1,1).Value = "" Then ' only if sheet is new
            isEmptySheet = True
        End If
        For f = 1 To fieldCount
            Dim fn ' Field name
            fn = rsData.fields(f - 1).Name
            destCols.Add f, 50 + f
            For df = 0 to UBound(destFieldArray)
                If Trim(LCase(destFieldArray(df))) = LCase(replace(fn,"new_","")) Then
                    destCols(f) = df + 1
'                    Wscript.Echo "Field " & fn & " goes to column " & df + 1
                End If
            Next
            If LCase(Left(fn, 4)) = "old_" or (not isEmptySheet) Then ' The second check is for existence of template
            Else
'                cells(fc-1,0) = fn
                With sh.Cells(1, fc)
                    .Value = rsData.fields(f - 1).Name
                    .Font.Bold = True
                End With
                fc = fc + 1
            End If
        Next' f

        Wscript.Echo Now(), "Print data"
        While Not rsData.EOF
            Dim changedRow' As Boolean
            Dim changedField
            changedRow = False
            fc = 1
            For f = 1 To fieldCount
                changedField = False
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
                            changedField = True
                        End If
                        If IsNumeric(oldValue) and IsNumeric(newValue) Then
                            If Round(oldValue,2)=Round(newValue,2) Then
                                changedField = false
                            End If
                        End If
                        If IsNumeric(newValue) Then
                            If IsNull(oldValue) and newValue=0 Then
                                changedField = false
                            End If
                        End If
                        If changedField Then
                            changedRow = True
                            sh.Cells(r, destCols(f)).Interior.Color = RGB(255, 204, 102)
                            If Not IsNull(oldValue) Then
                                sh.Cells(r, destCols(f)).AddComment "Old value: " & CStr(oldValue)
                            End If
                        End If
                        
                    End If
                    Redim preserve cells(50 + fieldCount-1, r-2) '@TODO change 50
                    cells(destCols(f)-1, r-2) = newValue
'                    sh.Cells(r, fc).value = newValue
                    If rsData.fields(f - 1).Name = "Record_Status" Then
                        If rsData.fields(f - 1).value = "New" Then
                            sh.Rows(r).Interior.Color = RGB(193, 245, 255) 'blue
                            records_new = records_new + 1
                        ElseIf changedRow Then
                            records_changed = records_changed + 1
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
        sh.Range("A2").Resize(r-2,UBound(destFieldArray)+1).value=transpose(cells)
        If records_new+records_changed>0 Then
            Log "printCells", records_new & " new record(s) and " & records_changed & " changed record(s) in sheet " & sh.Name, tInfo, m_ID
        Else
            Log "printCells", "No New/changed records in sheet " & sh.Name, tInfo, m_ID
        End If
End Function
