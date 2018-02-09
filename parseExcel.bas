'Attribute VB_Name = "parseExcel"
Option Explicit
Dim sheetTables' As Dictionary
Dim codeLists' As Dictionary

Function Import(fileName, m_ID)' As String, m_ID' As Long)
    'An Open connection and Log are assumed
    Dim rsCols' As ADODB.Recordset
    Dim rsTarget' As ADODB.Recordset
    Dim rsTemp' As ADODB.Recordset
    
    Dim oExcel' As New Excel.Application
    Do while true
    On Error Resume Next
    Set oExcel = CreateObject("Excel.Application")
    On Error Goto 0
    If oExcel is Nothing Then
        Log "Import", "Error starting Excel! Please contact Administrator", tErr, m_ID
        Exit Do
    End If
    oExcel.DisplayAlerts = False
    Dim wb' As Workbook
    Dim sh' As Worksheet
    On Error Resume Next
    Set wb = oExcel.Workbooks.Open(fileName, False)
    On Error Goto 0
    If wb is Nothing Then
        Log "Import", "File " & fileName & " not found! Please contact Administrator", tErr, m_ID
        Exit Do
    End If
    Dim r' As Long
    Dim recs' As Long
    Dim rowFound' As Boolean
    Dim Rep_LE' As String
    Dim Rep_Date' As Long
    
'TODO Check the country
    Rep_LE = "All"
    On Error Resume Next
    Rep_LE = wb.Names("Rep_LE").RefersToRange.value
    On Error GoTo 0
    If Rep_LE = "All" Then
        Set rsTemp = dbConn.Execute("select Tagetik_Code from vw_LE_Sender where id=" & m_ID)
        If not rsTemp.EOF Then
            Rep_LE = rsTemp.Fields("Tagetik_Code").Value
            Log "Import", "No Legal Entity specified in the file (Name=Rep_LE). Assuming data is for default LE: " & Rep_LE, tLog, m_ID
        Else
            Log "Import", "No Legal Entity specified in the file (Name=Rep_LE). Assuming access to all Legal entities.", tWar, m_ID
        End If
    Else
        Log "Import", "Importing data for legal entity " & Rep_LE, tLog, m_ID
    End If
    Import = Rep_LE
    Set rsTemp = dbConn.Execute("select * from vw_LE_Sender where Tagetik_Code=""" & Rep_LE & """ and id=" & m_ID)
    If rsTemp.EOF Then
        Log "Import", "You are not allowed to work with Legal Entity " & Rep_LE & ". Processing stopped", tErr, m_ID
        Exit Do
    End If
    
    'check for valid reporting period
    Rep_Date = 0
    On Error Resume Next
    Rep_Date = CLng(wb.Names("Rep_Date").RefersToRange.value)
    On Error GoTo 0
    Dim priorMonthEnd
    priorMonthEnd = Year(DateSerial(Year(Now),Month(Now),0))*100 + Month(DateSerial(Year(Now),Month(Now),0))
    If Rep_Date = 0 Then
        Log "Import", "No or invalid reporting date specified in the file (Name=Rep_Date). Assuming end of previous month.", tWar, m_ID
        Rep_Date = priorMonthEnd
    End If
    'check reporting date in the future
    If Rep_Date > priorMonthEnd Then
        Log "Import", "Reporting date specified in the file (Name=Rep_Date) is in the future. Assuming end of previous month.", tWar, m_ID
        Rep_Date = priorMonthEnd
    End If
    If Rep_Date < 201712 Then
        Log "Import", "Reporting date specified in the file (Name=Rep_Date) is before 201712. Loading aborted.", tErr, m_ID
        Exit Do
    End If
    
    
    For Each sh In wb.Sheets
        Log "Import", "Start loading sheet: " & sh.Name, tLog, m_ID
        If getSheetDef(sh.Name, m_ID) Then
            r = 2
            While sh.Cells(r, 1).value <> ""
                Dim tbl
                Dim key' As Variant
                Dim dstTable' As cDstTable
                Dim col
                Dim lookup' As String
                Do while true
                For Each tbl In sheetTables
                    Dim value
                    Dim keyItems' As Dictionary
                    Set keyItems = CreateObject ( "Scripting.Dictionary" )
                    keyItems.RemoveAll
                    Set dstTable = sheetTables(tbl)
                    Dim debug
                    debug = ""
                    For Each key In dstTable.key
                        Dim kk
                        for each kk in dstTable.codeLists
                            debug = debug & " cl:" & kk &","
                        Next
                        If key = "m_ID" Then ' Special case for message_ID, which is always part of the key
                            value = m_ID
                        ElseIf dstTable.codeLists.Exists(key & "&") Then
                            lookup = Trim(LCase(sh.Cells(r, dstTable.key(key)).value))
'                            If Left(dstTable.codeLists(key & "&"), 8) = "NPE_List" Or Left(dstTable.codeLists(key & "&"), 11) = "Assets_List" Then
'                                lookup = m_ID & ":" & lookup
'                            End If
                            value = codeLists(dstTable.codeLists(key & "&"))(lookup)
                            debug = debug & "key: " & key & ",lkp:" & lookup & ", value: " & value &";"
                        ElseIf dstTable.key(key) = 99 Then ' Special case for Rep_Date
                            value = DateSerial(Left(Rep_Date, 4), Right(Rep_Date, 2) + 1, 0)
                        Else
                            value = Trim(sh.Cells(r, dstTable.key(key)).value)
                        End If
                        
                        If value = "" Then
                            If InStr(key, "Date") > 0 Then
                                value = CDate("1.1.2000")
                            Else
                                Log "ImportFile", "Invalid value: " & sh.Cells(r, dstTable.key(key)).value & " in row: " & r & ", key column: " & key & ". Row not imported!", tErr, m_ID
                                Exit Do
                            End If
                        End If
                        On Error Resume Next
                        dstTable.cmd.Parameters("@" & key).value = value
                        If Err.Number > 0 Then
                            Log "Import", "Error in Sheet: " & sh.Name & ", row: " & r & ", column: " & key & ". Value is: " & value & ". The error is: " & Err.Description, tErr, m_ID
                            Exit Do
                        End If
                        On Error GoTo 0
                        keyItems.Add key, value
                    Next' key
                    
                    Dim rs' As New ADODB.Recordset
                    Set rs = CreateObject("ADODB.Recordset")
                    On Error Resume Next
                    rs.Open dstTable.cmd, , adOpenForwardOnly, adLockOptimistic
                    If Err.Number<>0 Then
                        Log "Import", "Error executing " & dstTable.cmd.CommandText, tErr, m_ID
                        dim tmpPar
                        dim msg
                        msg = ""
                        for Each tmpPar in dstTable.cmd.Parameters
                            msg = msg & "Parameter " & tmpPar.Name & " has value " & tmpPar.Value & ", "
                        Next 
                        Log "Import", msg & debug, tErr, m_ID
                        Exit Do
                    End If
                    On Error GoTo 0
                    
                    If rs.EOF Then
                        rs.AddNew
                        For Each key In keyItems
                            On Error resume next
                            rs.fields(key).value = keyItems(key)
                            If Err.Number>0 Then
                                Log "Import", Err.Text & ": key=" & key, tErr, message_ID
                            End If
                            On Error GoTo 0
                        Next' key
                    End If
                    For Each col In dstTable.cols
                        Dim column_name' As String
                        column_name = Split(col, "&")(0)
                        If dstTable.codeLists.Exists(col) Then
                            Dim spl
                            spl = Split(dstTable.cols(col), ":")
                            Dim s' As Integer
                            lookup = "-"
                            For s = 0 To UBound(spl)
                                If lookup = "-" Then
                                    lookup = ""
                                Else
                                    lookup = lookup & ":"
                                End IF
                                lookup = lookup & Trim(sh.Cells(r, spl(s) * 1).value)
                            Next' s
'                            If spl(0) = "NPE_List" Or spl(0) = "Assets_List" Then
'                                lookup = m_ID & ":" & lookup
'                            End If
                            If lookup <> "" Then
                                value = codeLists(dstTable.codeLists(col))(LCase(lookup))
                                If IsEmpty(value) And lookup <> "" Then
                                    value = addCode(dstTable.codeLists(col), lookup, m_ID)
                                End If
                            Else
                                value = ""
                            End If
                        ElseIf dstTable.cols(col) = 99 Then ' Special case for Rep_Date
                            value = DateSerial(Left(Rep_Date, 4), Right(Rep_Date, 2) + 1, 0)
                        Else
                            On Error Resume Next
                            value = "Error"
                            value = Trim(sh.Cells(r, dstTable.cols(col)).value)
                            On Error GoTo 0
                        End If
                        
                        Dim condition' As String
                        condition = Split(col, "&")(1)
                        If condition <> "" Then
                            If rs.fields(Split(condition, "=")(0)).value <> "" Then
                                rs.Find condition, , , adBookmarkFirst
                                If rs.EOF Then
                                    rs.AddNew
                                    For Each key In keyItems
                                        rs.fields(key).value = keyItems(key)
                                    Next' key
                                End If
                            End If
                            rs.fields(Split(condition, "=")(0)).value = Split(condition, "=")(1)
                            rs.Update
                        End If
                        
                        If value = "n/a" Then value = Null
                        If value <> "" Then ' check if value exists
                            If Not (rs.EditMode <> adEditAdd And dstTable.newOnlyCols.Exists(col)) Then 'check if the field has to be updated
                                On Error Resume Next
                                rs.fields(column_name).value = value
                                If Err.Number <> 0 Then
                                    Log "Import", "Error importing value: " & value & ". Sheet: " & sh.Name & ", Row: " & r & ", Column: " & column_name & ". Error text: " & Err.Description, tWar, m_ID
                                End If
                                On Error GoTo 0
                            End If
                        End If
                        
                        If rs.EditMode = adEditAdd And ( _
                            (tbl = "Assets_List" And column_name = "Asset_Code" And codeLists.Exists(tbl & ":" & column_name)) _
                            Or (tbl = "NPE_List" And column_name = "NPE_Code" And codeLists.Exists(tbl & ":" & column_name)) _
                            ) Then ' add manually the subasset if not existing
                                If codeLists(tbl & ":" & column_name).Exists(LCase(value)) Then
                                    codeLists(tbl & ":" & column_name)(LCase(value)) = rs.fields("ID").value
                                Else
                                    codeLists(tbl & ":" & column_name).Add LCase(value), rs.fields("ID").value
                                End If
                        End If
                    Next' col
'                    If tbl = "NPE_History" Or tbl = "Asset_History" Then
'                        rs.fields("Rep_Date") = DateSerial(Left(Rep_Date, 4), Right(Rep_Date, 2)+1, 0)
'                    End If
                    If rs.EditMode = adEditAdd or rs.EditMode = adEditInProgress Then
                        rs.Update
                    End If
                    rs.Close
                Next' tbl
                Exit Do
                Loop
'nextRow:
                r = r + 1
            Wend
            Log "Import", "Sheet: " & sh.Name & " loaded. " & r & " row(s) processed", tLog, m_ID
        Else
'            Log "Import", "No definition found for sheet: " & sh.Name, tWar, m_ID
        End If
    Next' sh
    Exit Do
    Loop
'fin:
    If Not oExcel is Nothing Then
        If Not wb is Nothing Then
            wb.Close False
        End If
        oExcel.Quit
    End If
End Function

Function getSheetDef(sheetName, m_ID)' As String, m_ID' As Long)' As Boolean
    Dim rsCols' As ADODB.Recordset
    Dim rs' As ADODB.Recordset
    Set sheetTables = CreateObject ( "Scripting.Dictionary" )
    Set codeLists = CreateObject ( "Scripting.Dictionary" )
    
    Set rsCols = dbConn.Execute("select * from Import_Mapping where Target_Table is not null and Sheet_Name='" & sheetName & "'")
    If rsCols.EOF Then
        Log "Import", "No definition found for sheet: " & sheetName, tWar, m_ID
        getSheetDef = False
    Else
        While Not rsCols.EOF
            Dim tableName' As String
            tableName = rsCols.fields("Target_Table").value
            If Not sheetTables.Exists(tableName) Then
                Dim dstTable' As cDstTable
                Dim cmd' As ADODB.Command
                Set cmd = CreateObject ( "ADODB.Command" )
                
                cmd.CommandText = "select * from " & tableName
                cmd.ActiveConnection = dbConn
                
                Set dstTable = New cDstTable
                Set dstTable.cmd = cmd
                Set dstTable.key = CreateObject ( "Scripting.Dictionary" )
                Set dstTable.cols = CreateObject ( "Scripting.Dictionary" )
                Set dstTable.codeLists = CreateObject ( "Scripting.Dictionary" )
                Set dstTable.newOnlyCols = CreateObject ( "Scripting.Dictionary" )
                sheetTables.Add tableName, dstTable
            End If
            If rsCols.fields("Key").value <> "" Then
                sheetTables(tableName).key.Add rsCols.fields("Target_Field").value, rsCols.fields("Column_No").value
            End If
            
            Dim columnID' As String
            columnID = rsCols.fields("Target_Field").value & "&" & rsCols.fields("Condition").value
            
            If sheetTables(tableName).cols.Exists(columnID) Then
                If Right(sheetTables(tableName).codeLists(columnID), Len(rsCols.fields("Lookup_Field").value)) = rsCols.fields("Lookup_Field").value Then
                'check if this column is already set with codelist
                Else
                    sheetTables(tableName).cols(columnID) = sheetTables(tableName).cols(columnID) & ":" & rsCols.fields("Column_No").value
                    If rsCols.fields("Lookup_Table").value <> "" Then
                        sheetTables(tableName).codeLists(columnID) = sheetTables(tableName).codeLists(columnID) & ":" & rsCols.fields("Lookup_Field").value
                    End If
                End If
            Else
                sheetTables(tableName).cols.Add columnID, rsCols.fields("Column_No").value
                If rsCols.fields("Lookup_Table").value <> "" Then
                    sheetTables(tableName).codeLists.Add columnID, rsCols.fields("Lookup_Table").value & ":" & rsCols.fields("Lookup_Field").value
                End If
            End If
            If rsCols.fields("UpdateMode").value = "KeepOld" Then
                sheetTables(tableName).newOnlyCols.Add columnID, rsCols.fields("UpdateMode").value
            End If
            rsCols.MoveNext
        Wend
        
        Dim tbl, key, where
        For Each tbl In sheetTables
            sheetTables(tbl).key.Add "m_ID", -1
            where = ""
            For Each key In sheetTables(tbl).key
                Set dstTable = sheetTables(tbl)
                If where = "" Then
                    where = where & " where " & "iif(" & key & " is null,"
                Else
                    where = where & " and " & "iif(" & key & " is null,"
                End if
                Dim par
                If InStr(key, "Date") > 0 Then
                    where = where & "'" & CDate("1.1.2000") & "'"
                    Set par = dstTable.cmd.CreateParameter("@" & key, adDate, adParamInput, 100, Null)
                Else
                    where = where & "'-'"
                    Set par = dstTable.cmd.CreateParameter("@" & key, adVarChar, adParamInput, 100, Null)
                End if
                where = where & "," & key & ")=@" & key
                'where = where & IIf(where = "", " where ", " and ") & "iif(" & key & " is null," & IIf(InStr(key, "Date") > 0, "'" & CDate("1.1.2000") & "'", "'-'") & "," & key & ")=@" & key
                
                dstTable.cmd.Parameters.Append par
            Next' key
            For Each key In sheetTables(tbl).codeLists
                Dim codeList' As Dictionary
                Set codeList = CreateObject ( "Scripting.Dictionary" )
                Dim spl, kk, s' As Integer
                spl = Split(sheetTables(tbl).codeLists(key), ":")
                Set rs = dbConn.Execute(spl(0))
                While Not rs.EOF
                    kk = "-"
                    For s = 1 To UBound(spl)
                        if kk = "-" Then
                            kk = ""
                        Else
                            kk = kk & ":"
                        End If
                        kk = kk & LCase(rs.fields(spl(s)).value)
                    Next' s
'                    If spl(0) = "NPE_List" Or spl(0) = "Assets_List" Then ' add m_ID key for NPEs and Assets
'                        kk = rs.fields("m_ID").value & ":" & kk
'                    End If
                    If Not codeList.Exists(kk) Then codeList.Add kk, rs.fields("ID").value
                    rs.MoveNext
                Wend
                If Not codeLists.Exists(sheetTables(tbl).codeLists(key)) Then
                    codeLists.Add sheetTables(tbl).codeLists(key), codeList
                End If
            Next' key
            dstTable.cmd.CommandText = dstTable.cmd.CommandText & where
            dstTable.cmd.Prepared = True
            Set sheetTables(tbl) = dstTable
        Next' tbl
        getSheetDef = True
    End If
End Function

Function addCode(columns, lookup, m_ID)' As String, lookup' As String)' As Long
    Dim rs' As Recordset
    Dim cols, s
    cols = Split(columns, ":")
    Set rs = CreateObject("ADODB.Recordset")
    rs.Open cols(0), dbConn, adOpenDynamic, adLockOptimistic
    rs.AddNew
    For s = 1 To UBound(cols)
        rs.fields(cols(s)).value = Left(Split(lookup, ":")(s - 1), rs.fields(cols(s)).DefinedSize)
    Next' s
    On Error Resume Next
    rs.Update
    On Error GoTo 0
    If Err.Number<>0 Then
        Log "addCode", "Error adding code for columns: " & columns & " with lookup " & lookup, tErr, m_ID
        rs.Cancel
    Else
        addCode = rs.fields("ID").value
        codeLists(columns)(LCase(lookup)) = addCode
    End If
'    rs.Close
End Function



