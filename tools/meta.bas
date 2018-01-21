'Option Compare Database
Option Explicit
Const base_m_ID = -1

Sub printMeta()
    Dim td As TableDef
    Dim qd As QueryDef
    Dim sql As String
    Open "C:\Users\Marti\Documents\UCTAM\SST\SST.sql" For Output As #1
    For Each td In CurrentDb.TableDefs
        sql = "CREATE TABLE " & td.Name & " (" & vbNewLine
        Dim f As Field
        For Each f In td.Fields
            sql = sql & f.Name & " " & getFieldType(f.Type) & "(" & f.Size & ")," & vbNewLine
        Next f
        sql = Left(sql, Len(sql) - 3) & vbNewLine & ")"
        Debug.Print sql
        Print #1, sql
    Next td
    For Each qd In CurrentDb.QueryDefs
        sql = "CREATE VIEW " & qd.Name & " AS " & vbNewLine & qd.sql
        Debug.Print sql
        Print #1, sql
    Next qd
    Close #1
End Sub

Sub createInserts()
    Dim rs As Recordset
    Dim td As TableDef
    Dim qd As QueryDef
    Dim c As Integer
    Dim del_sql As String
    Dim upd_sql As String
    Dim ins_sql As String
    Dim on_sql As String
    Dim join_sql As String
    Dim join_count As String
    Dim sel_sql As String
    Dim db As Database
    Set db = CurrentDb
    
    Set rs = db.OpenRecordset("meta_updatable_tables")
    While Not rs.EOF
        sel_sql = "select "
    
        del_sql = "delete from " & rs!table_name & vbNewLine
        del_sql = del_sql & "where m_id=" & base_m_ID & vbNewLine
        on_sql = ""
        join_sql = "": join_count = 0
        upd_sql = "update ((" & rs!table_name & " as new_tab" & vbNewLine
        If rs!parent_table <> "" Then
            upd_sql = upd_sql & "   inner join " & rs!parent_table & " as old_parent on old_parent.id=new_tab." & rs!parent_ID & ")" & vbNewLine
            upd_sql = upd_sql & "   inner join " & rs!parent_table & " as new_parent on new_parent." & rs!parent_Code & "=old_parent." & rs!parent_Code & ")" & vbNewLine
            upd_sql = upd_sql & "   inner join " & rs!table_name & " as dw_tab &ON" & vbNewLine
        Else
            upd_sql = upd_sql & " inner join " & rs!table_name & " as dw_tab on dw_tab." & rs!Key & "=new_tab." & rs!Key & "))" & vbNewLine
        End If
        upd_sql = upd_sql & "SET "
        
        ins_sql = "insert into " & rs!table_name & vbNewLine
        ins_sql = ins_sql & "select "
        Set td = db.TableDefs(rs!table_name)
        For c = 0 To td.Fields.Count - 1
            Dim srcCol As String: Dim dstCol As String
            dstCol = td.Fields(c).Name
            If dstCol = "ID" Then
                'ins_sql = ins_sql & "0"
            ElseIf dstCol = "m_ID" Then
                ins_sql = ins_sql & base_m_ID
            ElseIf dstCol = rs!parent_ID Then
                If InStr(rs!Key, rs!parent_Code) > 0 Then
                    sel_sql = sel_sql & " parent." & rs!parent_Code & ", "
                Else
                    sel_sql = sel_sql & " max(iif(tab.m_id=" & base_m_ID & ", parent." & rs!parent_Code & ",null)) as old_" & rs!parent_Code & ", max(iif(tab.m_id<>" & base_m_ID & ", parent." & rs!parent_Code & ",null)) as new_" & rs!parent_Code & ", "
                    upd_sql = upd_sql & "dw_tab." & rs!parent_ID & "=new_tab." & rs!parent_ID & ", "
                End If
                ins_sql = ins_sql & "new_parent.ID"
            Else
                Dim prop As Property
                Set prop = Nothing
                On Error Resume Next
                Set prop = td.Fields(c).Properties("RowSource")
                On Error GoTo 0
                If Not prop Is Nothing Then
                    If Left(prop.Value, 2) = "vw" Then
                        srcCol = db.QueryDefs(prop.Value).Fields(1).Name ' Column name to be selected
                    Else
                        srcCol = db.TableDefs(prop.Value).Fields(1).Name
                    End If
                    join_sql = join_sql & " left join " & prop & " as " & prop & join_count & " on " & prop & join_count & ".id=tab." & dstCol & ")" & vbNewLine
                    srcCol = prop & join_count & "." & srcCol
                    join_count = join_count + 1
                Else
                    srcCol = "tab." & dstCol
                End If
                If InStr(rs!Key, dstCol) > 0 Then
                    If Right(srcCol, Len(dstCol)) = dstCol Then
                        sel_sql = sel_sql & srcCol & ", "
                    Else
                        sel_sql = sel_sql & "(select " & srcCol & " from " & prop & " where id=" & dstCol & ") as " & dstCol & ", "
                    End If
                Else
                    sel_sql = sel_sql & " max(iif(tab.m_id=" & base_m_ID & ", " & srcCol & ",null)) as old_" & dstCol & ", max(iif(tab.m_id<>" & base_m_ID & ", " & srcCol & ",null)) as new_" & dstCol & ", "
                    upd_sql = upd_sql & "dw_tab." & dstCol & "=iif(new_tab." & dstCol & " is null,dw_tab." & dstCol & ",new_tab." & dstCol & "), "
                End If
                ins_sql = ins_sql & "new_tab." & dstCol
            End If
            If dstCol <> "ID" Then
                ins_sql = ins_sql & " as " & dstCol
            End If
            If c < td.Fields.Count - 1 Then
                If dstCol <> "ID" Then
                    ins_sql = ins_sql & ", "
                End If
            '    upd_sql = upd_sql & ", "
            Else
                sel_sql = Left(sel_sql, Len(sel_sql) - 2) & vbNewLine
                ins_sql = ins_sql & vbNewLine
                upd_sql = Left(upd_sql, Len(upd_sql) - 2) & vbNewLine
            End If
        Next c
        sel_sql = sel_sql & "from " & String(join_count, "(") & rs!table_name & " as tab" & vbNewLine
        sel_sql = sel_sql & join_sql
        
        ins_sql = ins_sql & "from (" & rs!table_name & " as new_tab" & vbNewLine
        If rs!parent_table <> "" Then
            sel_sql = sel_sql & "   inner join " & rs!parent_table & " as parent on parent.id=tab." & rs!parent_ID & vbNewLine
            ins_sql = ins_sql & "   inner join " & rs!parent_table & " as old_parent on old_parent.id=new_tab." & rs!parent_ID & ")" & vbNewLine
            ins_sql = ins_sql & "   inner join " & rs!parent_table & " as new_parent on new_parent." & rs!parent_Code & "=old_parent." & rs!parent_Code & vbNewLine
        Else
            ins_sql = ins_sql & ")" & vbNewLine
        End If
        sel_sql = sel_sql & "where tab.m_id in ([:m_ID]," & base_m_ID & ")" & vbNewLine
        ins_sql = ins_sql & "where new_tab.m_id = [:m_ID]" & vbNewLine
        If rs!parent_table <> "" Then
            ins_sql = ins_sql & " and new_parent.m_id=" & base_m_ID & vbNewLine
        End If
        
        upd_sql = upd_sql & "where new_tab.m_id = [:m_ID] and dw_tab.m_id=" & base_m_ID & vbNewLine
        If rs!Key <> "" Then
            sel_sql = sel_sql & "group by "
            ins_sql = ins_sql & "   and not exists (select 1 from " & rs!table_name & " as dw_tab where dw_tab.m_id = " & base_m_ID & vbNewLine
            Dim keys
            keys = Split(rs!Key, ",")
            For c = 0 To UBound(keys)
                on_sql = on_sql & IIf(c = 0, "on", "and ")
                If Trim(keys(c)) = rs!parent_Code Then
                    sel_sql = sel_sql & rs!parent_Code
                    del_sql = del_sql & " and " & rs!parent_ID & " in (select old_parent.id from (" & rs!table_name & " as new_tab" & c & " inner join " & rs!parent_table & " new_parent on new_parent.id=new_tab" & c & "." & rs!parent_ID & ") inner join " & rs!parent_table & " old_parent on new_parent." & rs!parent_Code & "=old_parent." & rs!parent_Code & " where new_tab" & c & ".m_ID=[:m_ID])" & vbNewLine
                    ins_sql = ins_sql & "   and dw_tab." & rs!parent_ID & "=new_parent.id" & vbNewLine
                    on_sql = on_sql & " dw_tab." & rs!parent_ID & "=new_parent.id" & vbNewLine
                Else
                    sel_sql = sel_sql & keys(c)
                    del_sql = del_sql & " and " & keys(c) & " in (select new_tab" & c & "." & keys(c) & " from " & rs!table_name & " as new_tab" & c & " where new_tab" & c & ".m_id=[:m_ID])" & vbNewLine
                    ins_sql = ins_sql & "   and dw_tab." & Trim(keys(c)) & "=new_tab." & Trim(keys(c)) & vbNewLine
                    on_sql = on_sql & " dw_tab." & Trim(keys(c)) & "=new_tab." & Trim(keys(c)) & vbNewLine
                End If
                If c < UBound(keys) Then
                    sel_sql = sel_sql & ", "
                Else
                    sel_sql = sel_sql & vbNewLine
                End If
            Next c
            ins_sql = ins_sql & ")"
        End If
        sel_sql = sel_sql & "having max(tab.m_id)>" & base_m_ID
        upd_sql = Replace(upd_sql, "&ON", on_sql)
'        sel_sql = Replace(sel_sql, "&ON", on_sql)
'        Debug.Print sel_sql
'        Debug.Print del_sql
'        Debug.Print upd_sql
        Debug.Print ins_sql
        On Error Resume Next
        db.QueryDefs.Delete "sel_" & rs!table_name
        db.QueryDefs.Delete "del_" & rs!table_name
        db.QueryDefs.Delete "upd_" & rs!table_name
        db.QueryDefs.Delete "ins_" & rs!table_name
        On Error GoTo 0
        Set qd = db.CreateQueryDef("sel_" & rs!table_name, sel_sql)
        If rs!Del_Key = "yes" Then
            Set qd = db.CreateQueryDef("del_" & rs!table_name, del_sql)
        Else
            Set qd = db.CreateQueryDef("upd_" & rs!table_name, upd_sql)
        End If
        Set qd = db.CreateQueryDef("ins_" & rs!table_name, ins_sql)
        rs.MoveNext
    Wend
    rs.Close
End Sub

Function getFieldType(ft) As String
    Select Case ft
        Case dbBigInt: getFieldType = "Big Integer"
        Case dbBinary: getFieldType = "Binary"
        Case dbBoolean: getFieldType = "Boolean"
        Case dbByte: getFieldType = "Byte"
        Case dbChar: getFieldType = "Char"
        Case dbCurrency: getFieldType = "Currency"
        Case dbDate: getFieldType = "Date/Time"
        Case dbDecimal: getFieldType = "Decimal"
        Case dbDouble: getFieldType = "Double"
        Case dbFloat: getFieldType = "Float"
        Case dbGUID: getFieldType = "GUID"
        Case dbInteger: getFieldType = "Integer"
        Case dbLong: getFieldType = "Long"
        Case dbLongBinary: getFieldType = "Long Binary (OLE Object)"
        Case dbMemo: getFieldType = "Memo"
        Case dbNumeric: getFieldType = "Numeric"
        Case dbSingle: getFieldType = "Single"
        Case dbText: getFieldType = "Text"
        Case dbTime: getFieldType = "Time"
        Case dbTimeStamp: getFieldType = "Time Stamp"
        Case dbVarBinary: getFieldType = "VarBinary"
        Case Else: getFieldType = "Unknown"
    End Select
End Function
