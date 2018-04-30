Option Explicit
Const outFileName = "SST.sql"
Const base_m_ID=-1

Sub printMeta()

    Dim dbe
    Set dbe = CreateObject("DAO.DBEngine.120")
    Dim wrk
    Set wrk = dbe.CreateWorkspace("sst", "Admin", "")
    Dim CurrentDb
    Set CurrentDB = wrk.OpenDatabase(SST_DB_Path)

    Dim td' As TableDef
    Dim qd' As QueryDef
    Dim sql' As String
    
    Dim outFile
    Set outFile = fso.CreateTextFile(outFileName, fsoForWriting)
    For Each td In CurrentDB.TableDefs ' Drops
      If Left(td.Name,4) <> "MSys" Then
        sql = "DROP TABLE " & td.Name & " CASCADE;" & vbNewLine
        outFile.Write sql
      End If
    Next' td
    For Each td In CurrentDB.TableDefs
      If Left(td.Name,4) <> "MSys" Then
        sql = "-- " & td.LastUpdated & vbNewLine
        sql = sql & "CREATE TABLE " & td.Name & " (" & vbNewLine
        Dim f' As Field
        For Each f In td.Fields
            sql = sql & f.Name & " " & getFieldType(f.Type) 
            If f.Type = dbText then 
                sql = sql & "(" & f.Size & ")"
            Else
            End If
            sql = sql & "," & vbNewLine
        Next' f
        sql = Left(sql, Len(sql) - 3) & vbNewLine
'        sql = Left(sql, Len(sql) - 3) & ");" & vbNewLine
        sql = sql & ");" & vbNewLine
        WScript.Echo sql
'        outFile.Write sql
      End If
    Next' td
    For Each td In CurrentDb.TableDefs
      If Left(td.Name,4) <> "MSys" Then
        sql = ""
        Dim i' As Index
        For Each i In td.Indexes
            If Not i.Primary And Not i.Foreign Then
                sql = sql & "create " 
                if i.Unique Then
                    sql = sql & "UNIQUE"
                End If 
                sql = sql & " index " & td.Name & "_" & i.Name & " on " & td.Name & "("
                    For Each f In i.Fields
                        sql = sql & f.Name & ","
                    Next' f
                sql = Left(sql, Len(sql) - 1) & ");" & vbNewLine
            End If
        Next' i
      End If
'        Debug.Print sql
        outFile.Write sql
    Next' td
    For Each td In CurrentDb.TableDefs
      If Left(td.Name,4) <> "MSys" Then
        sql = ""
        For Each i In td.Indexes
          If i.Primary Then
            sql = sql & "ALTER TABLE " & td.Name & " ADD constraint " & td.Name & "_" & i.Name
            If i.Primary Then
                sql = sql & " primary key "
            ElseIf i.Unique Then
                sql = sql & " unique "
            ElseIf i.Foreign Then
                sql = sql & " foreign key "
                Dim rel' As DAO.Relation
            Else
'                sql = sql & ";" & vbNewLine
            End If
            sql = sql & "("
'            sql = sql & "Create index " & i.Name & " on " & td.Name & "("
            For Each f In i.Fields
                sql = sql & f.Name & ","
            Next' f
            sql = Left(sql, Len(sql) - 1) & ")"
            For Each rel In CurrentDb.Relations
                If rel.Name = i.Name Then
                    sql = sql & " references " & rel.Table & "("
                    Dim rf' As Field
                    For Each rf In rel.Fields
                        sql = sql & rf.Name & ","
                    Next' rf
                    sql = Left(sql, Len(sql) - 1) & ")"
                End If
            Next' rel
            sql = sql & ";" & vbNewLine
          End If
        Next' i
'        Debug.Print sql
        outFile.Write sql
      End If
    Next' td
    For Each td In CurrentDb.TableDefs
      If Left(td.Name,4) <> "MSys" Then
        sql = ""
        For Each i In td.Indexes
          If i.Foreign Then
            sql = sql & "ALTER TABLE " & td.Name & " ADD constraint " & i.Name
            If i.Primary Then
                sql = sql & " primary key "
            ElseIf i.Unique Then
                sql = sql & " unique "
            ElseIf i.Foreign Then
                sql = sql & " foreign key "
            Else
'                sql = sql & ";" & vbNewLine
            End If
            sql = sql & "("
'            sql = sql & "Create index " & i.Name & " on " & td.Name & "("
            For Each f In i.Fields
                sql = sql & f.Name & ","
            Next' f
            sql = Left(sql, Len(sql) - 1) & ")"
            For Each rel In CurrentDb.Relations
                If rel.Name = i.Name Then
                    sql = sql & " references " & rel.Table & "("
                    For Each rf In rel.Fields
                        sql = sql & rf.Name & ","
                    Next' rf
                    sql = Left(sql, Len(sql) - 1) & ")"
                End If
            Next' rel
            sql = sql & ";" & vbNewLine
          End If
        Next' i
'        Debug.Print sql
        outFile.Write sql
      End If
    Next' td
    For Each qd In CurrentDb.QueryDefs
        dim drop
        drop = "-- " & qd.LastUpdated & vbNewLine
        drop = drop & "DROP"
        sql = ""
        sql = sql & "CREATE"
        If LCase(Left(qd.sql, 3)) = "del" Or LCase(Left(qd.sql, 3)) = "ins" Or LCase(Left(qd.sql, 3)) = "upd" _
            or qd.Parameters.Count>0 Then
            drop = drop & " function if exists " & qd.Name & ";" & vbNewLine
            sql = sql & " function " & qd.Name & "( "
            Dim p' As Parameter
            For Each p In qd.Parameters
                sql = sql & Replace(Replace(p.Name, "[:", "p_"), "]", "") & " " & getFieldType(p.Type) & ","
            Next' p
            sql = Left(sql, Len(sql) - 1) & ") RETURNS "
            if LCase(Left(qd.sql,3)) = "sel" Then
                sql = sql & "table ("
                for each f in qd.Fields
                    sql = sql & f.Name & " " & getFieldType(f.Type) 
                    If f.Type = dbText then 
                        'sql = sql & "(" & f.Size & ")"
                    Else
                    End If
                    sql = sql & ","
                next
                sql = left(sql, len(sql)-1) & ")"
            Else
                sql = sql & " void "
            End If
            sql = sql & " LANGUAGE 'sql' AS $$" & vbNewLine
        Else
            sql = sql & " VIEW " & qd.Name & " AS" & vbNewLine
            drop = drop & " view if exists " & qd.Name & ";" & vbNewLine
        End If
        sql = sql & Replace(Replace(Replace(qd.sql, ":", "p_"), "]", ""), "[", "") & vbNewLine
        if LCase(Left(qd.sql, 3)) = "ins" then
            dim fr, as_
            as_=0
            fr = instr(lcase(qd.sql),"from")
            as_ = instr(lcase(qd.sql),")")
            if as_=0 or as_>fr then
                as_ = instr(lcase(qd.sql), " as ")
                dim fn
                fn = ""
                while as_>0 and as_<fr
                    dim cm
                    cm = instr(as_, qd.sql, ",")
                    if cm=0 then cm = fr-2
                    fn = fn & mid(qd.sql, as_+3, cm-as_-2)
                    as_ = instr(as_+1, lcase(qd.sql), " as ")
                wend
                sql = replace(sql, "SELECT" , "(" & fn & ") " & "SELECT")
            end if
        end if
        If LCase(Left(qd.sql, 3)) = "del" Or LCase(Left(qd.sql, 3)) = "ins" Or LCase(Left(qd.sql, 3)) = "upd" _
            or qd.Parameters.Count>0 Then
            sql = sql & "$$;" & vbNewLine
        End If
        dim de
        de = instr(LCase(sql),"delete")
        if de>0 then
            'dim fr
            fr = instr(de, lcase(sql), "from")
            sql = left(sql, de+6) & right(sql, len(sql)-fr+1)
        end if
        sql = Replace(sql, "DELETE *", "DELETE")
        'sql = replaceIIF(sql)
        sql = replaceIsNull(sql)
        sql = Replace(sql, "year(", "extract(year from ")
        sql = Replace(sql, "#1/1/2000#", "'2000-1-1'")
        sql = Replace(sql, "p_m_ID varchar", "p_m_ID integer")
        sql = Replace(sql, "&", "||")
        sql = Replace(sql, """", "'")
        sql = Replace(sql, "iif(tab.m_id=-1,", "case when tab.m_id=-1 then")
        sql = Replace(sql, "iif(tab.m_id<>-1,", "case when tab.m_id<>-1 then")
        sql = Replace(sql, ",null)", " else null end")
        sql = Replace(sql, ":", "p_")
        on error Resume Next
        if LCase(Left(qd.sql, 3)) <> "tra" then
            outFile.Write drop
            outFile.Write sql
            If Err.Number>0 Then
                WScript.Echo sql
            End If
        end if
        on error GoTo 0
    Next' qd
    outFile.Close
End Sub

Sub createInserts()

    Dim dbe
    Set dbe = CreateObject("DAO.DBEngine.120")
    Dim wrk
    Set wrk = dbe.CreateWorkspace("sst", "Admin", "")
    Dim CurrentDb
    Set CurrentDB = wrk.OpenDatabase(SST_DB_Path)

    Dim rs' As Recordset
    Dim td' As TableDef
    Dim qd' As QueryDef
    Dim c' As Integer
    Dim del_sql' As String
    Dim upd_sql' As String
    Dim ins_sql' As String
    Dim on_sql' As String
    Dim join_sql' As String
    Dim join_count' As String
    Dim sel_sql' As String
    Dim grp_sql' As String
    Dim db' As Database
    Dim keys
    Set db = CurrentDb
    
    Set rs = db.OpenRecordset("meta_updatable_tables")
    While Not rs.EOF
        sel_sql = "select "
        grp_sql = "group by "
    
        del_sql = "delete from " & rs.Fields("table_name") & vbNewLine
        del_sql = del_sql & "where m_id=" & base_m_ID & vbNewLine
        on_sql = ""
        join_sql = "": join_count = 0
        upd_sql = "update ((" & rs.Fields("table_name") & " as new_tab" & vbNewLine
        If rs.Fields("parent_table") <> "" Then
            upd_sql = upd_sql & "   inner join " & rs.Fields("parent_table") & " as old_parent on old_parent.id=new_tab." & rs.Fields("parent_ID") & ")" & vbNewLine
            upd_sql = upd_sql & "   inner join " & rs.Fields("parent_table") & " as new_parent on new_parent." & rs.Fields("parent_Code") & "=old_parent." & rs.Fields("parent_Code") & ")" & vbNewLine
            upd_sql = upd_sql & "   inner join " & rs.Fields("table_name") & " as dw_tab &ON" & vbNewLine
        Else
            upd_sql = upd_sql & " inner join " & rs.Fields("table_name") & " as dw_tab"
            keys = Split(rs.Fields("Key"), ",")
            For c = 0 To UBound(keys)
                If c = 0 Then
                    upd_sql = upd_sql & " on "
                Else
                    upd_sql = upd_sql & " and "
                End IF
                upd_sql = upd_sql & "dw_tab." & keys(c) & "=new_tab." & keys(c)
            Next
            upd_sql = upd_sql & "))" & vbNewLine
        End If
        upd_sql = upd_sql & "SET "
        
        ins_sql = "insert into " & rs.Fields("table_name") & vbNewLine
        ins_sql = ins_sql & "select "
        Set td = db.TableDefs(rs.Fields("table_name"))
        For c = 0 To td.Fields.Count - 1
            Dim srcCol' As String
            Dim dstCol' As String
            dstCol = td.Fields(c).Name
            If dstCol = "ID" Then
                'ins_sql = ins_sql & "0"
            ElseIf dstCol = "m_ID" Then
                ins_sql = ins_sql & base_m_ID
            ElseIf dstCol = rs.Fields("parent_ID") Then
                If InStr(rs.Fields("Key"), rs.Fields("parent_Code")) > 0 Then
                    sel_sql = sel_sql & " parent." & rs.Fields("parent_Code") & ", "
                    grp_sql = grp_sql & " parent." & rs.Fields("parent_Code") & ", "
                Else
                    sel_sql = sel_sql & " max(iif(tab.m_id=" & base_m_ID & ", parent." & rs.Fields("parent_Code") & ",null)) as old_" & rs.Fields("parent_Code") & ", max(iif(tab.m_id<>" & base_m_ID & ", parent." & rs.Fields("parent_Code") & ",null)) as new_" & rs.Fields("parent_Code") & ", "
                    upd_sql = upd_sql & "dw_tab." & rs.Fields("parent_ID") & "=new_parent.id, "
                End If
                If rs.Fields("Add_Fields") <> "" Then
                    'sel_sql = sel_sql & " parent." & rs.Fields("Add_Fields") & ", "
                    'grp_sql = grp_sql & " parent." & rs.Fields("Add_Fields") & ", "
                    sel_sql = sel_sql & " IIf(Max(IIf([tab].[m_id]<>-1,[parent].[" & rs.Fields("Add_Fields") & "],Null)) Is Null,Max([parent].[" & rs.Fields("Add_Fields") & "]),Max(IIf([tab].[m_id]<>-1,[parent].[" & rs.Fields("Add_Fields") & "],Null))) as " & rs.Fields("Add_Fields") & ", "
                    'grp_sql = grp_sql & " Nz(Max(IIf([tab].[m_id]=-1,[parent].[" & rs.Fields("Add_Fields") & "],Null)),Max([parent].[" & rs.Fields("Add_Fields") & "])), "
                End If
                ins_sql = ins_sql & "new_parent.ID"
            Else
                Dim prop' As Property
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
                If InStr(rs.Fields("Key"), dstCol) > 0 Then
                    grp_sql = grp_sql & srcCol & ", "
                    If Right(srcCol, Len(dstCol)) = dstCol Then
                        sel_sql = sel_sql & srcCol & ", "
                    Else
                        sel_sql = sel_sql & srcCol & " as " & dstCol & ", "
                        'sel_sql = sel_sql & "(select " & srcCol & " from " & prop & " where id=" & dstCol & ") as " & dstCol & ", "
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
                'sel_sql = Left(sel_sql, Len(sel_sql) - 2) & vbNewLine
                sel_sql = sel_sql & " iif(min(tab.m_ID)>-1,""New"","""") as Record_Status" & vbNewLine
                ins_sql = ins_sql & vbNewLine
                upd_sql = Left(upd_sql, Len(upd_sql) - 2) & vbNewLine
            End If
        Next' c
        sel_sql = sel_sql & "from " & String(join_count, "(") & rs.Fields("table_name") & " as tab" & vbNewLine
        sel_sql = sel_sql & join_sql
        
        ins_sql = ins_sql & "from (" & rs.Fields("table_name") & " as new_tab" & vbNewLine
        If rs.Fields("parent_table") <> "" Then
            sel_sql = sel_sql & "   inner join " & rs.Fields("parent_table") & " as parent on parent.id=tab." & rs.Fields("parent_ID") & vbNewLine
            ins_sql = ins_sql & "   inner join " & rs.Fields("parent_table") & " as old_parent on old_parent.id=new_tab." & rs.Fields("parent_ID") & ")" & vbNewLine
            ins_sql = ins_sql & "   inner join " & rs.Fields("parent_table") & " as new_parent on new_parent." & rs.Fields("parent_Code") & "=old_parent." & rs.Fields("parent_Code") & vbNewLine
        Else
            ins_sql = ins_sql & ")" & vbNewLine
        End If
        sel_sql = sel_sql & "where tab.m_id in ([:m_ID]," & base_m_ID & ")" & vbNewLine
        ins_sql = ins_sql & "where new_tab.m_id = [:m_ID]" & vbNewLine
        upd_sql = upd_sql & "where new_tab.m_id = [:m_ID] and dw_tab.m_id=" & base_m_ID & vbNewLine
        If rs.Fields("parent_table") <> "" Then
            ins_sql = ins_sql & " and new_parent.m_id=" & base_m_ID & vbNewLine
            upd_sql = upd_sql & " and new_parent.m_id=" & base_m_ID & vbNewLine
        End If
        
        If rs.Fields("Key") <> "" Then
 '           sel_sql = sel_sql & "group by "
            ins_sql = ins_sql & "   and not exists (select 1 from " & rs.Fields("table_name") & " as dw_tab where dw_tab.m_id = " & base_m_ID & vbNewLine
            keys = Split(rs.Fields("Key"), ",")
            For c = 0 To UBound(keys)
                If c = 0 Then
                    on_sql = on_sql & "on"
                Else
                    on_sql = on_sql & "and "
                End IF
                If Trim(keys(c)) = rs.Fields("parent_Code") Then
  '                  sel_sql = sel_sql & rs.Fields("parent_Code
                    del_sql = del_sql & " and " & rs.Fields("parent_ID") & " in (select old_parent.id from (" & rs.Fields("table_name") & " as new_tab" & c & " inner join " & rs.Fields("parent_table") & " new_parent on new_parent.id=new_tab" & c & "." & rs.Fields("parent_ID") & ") inner join " & rs.Fields("parent_table") & " old_parent on new_parent." & rs.Fields("parent_Code") & "=old_parent." & rs.Fields("parent_Code") & " where new_tab" & c & ".m_ID=[:m_ID])" & vbNewLine
                    ins_sql = ins_sql & "   and dw_tab." & rs.Fields("parent_ID") & "=new_parent.id" & vbNewLine
                    on_sql = on_sql & " dw_tab." & rs.Fields("parent_ID") & "=new_parent.id" & vbNewLine
                Else
  '                  sel_sql = sel_sql & keys(c)
                    del_sql = del_sql & " and " & keys(c) & " in (select new_tab" & c & "." & keys(c) & " from " & rs.Fields("table_name") & " as new_tab" & c & " where new_tab" & c & ".m_id=[:m_ID])" & vbNewLine
                    ins_sql = ins_sql & "   and dw_tab." & Trim(keys(c)) & "=new_tab." & Trim(keys(c)) & vbNewLine
                    on_sql = on_sql & " dw_tab." & Trim(keys(c)) & "=new_tab." & Trim(keys(c)) & vbNewLine
                End If
                If c < UBound(keys) Then
'                    sel_sql = sel_sql & ", "
                Else
                    sel_sql = sel_sql & vbNewLine
                End If
            Next' c
            ins_sql = ins_sql & ")"
        End If
        If grp_sql <> "group by " Then
            sel_sql = sel_sql & Left(grp_sql, Len(grp_sql) - 2) & vbNewLine
        Else
            sel_sql = sel_sql & vbNewLine
        End If
        sel_sql = sel_sql & "having max(tab.m_id)>" & base_m_ID
        upd_sql = Replace(upd_sql, "&ON", on_sql)
'        sel_sql = Replace(sel_sql, "&ON", on_sql)
'        Debug.Print sel_sql
'        Debug.Print del_sql
'        Debug.Print upd_sql
'        Debug.Print ins_sql
        On Error Resume Next
        db.QueryDefs.Delete "sel_" & rs.Fields("table_name")
        db.QueryDefs.Delete "del_" & rs.Fields("table_name")
        db.QueryDefs.Delete "upd_" & rs.Fields("table_name")
        db.QueryDefs.Delete "ins_" & rs.Fields("table_name")
        On Error GoTo 0
        wscript.echo sel_sql
        Set qd = db.CreateQueryDef("sel_" & rs.Fields("table_name"), sel_sql)
        If rs.Fields("Del_Key") = "yes" Then
            Set qd = db.CreateQueryDef("del_" & rs.Fields("table_name"), del_sql)
        Else
            wscript.echo upd_sql
            Set qd = db.CreateQueryDef("upd_" & rs.Fields("table_name"), upd_sql)
        End If
        Set qd = db.CreateQueryDef("ins_" & rs.Fields("table_name"), ins_sql)
        rs.MoveNext
    Wend
    rs.Close
End Sub


Function getFieldType(ft)' As String
    Select Case ft
        Case dbBigInt: getFieldType = "bigint"
        Case dbBinary: getFieldType = "bytea"
        Case dbBoolean: getFieldType = "boolean"
        Case dbByte: getFieldType = "smallint"
        Case dbChar: getFieldType = "varchar"
        Case dbCurrency: getFieldType = "money"
        Case dbDate: getFieldType = "date"
        Case dbDecimal: getFieldType = "decimal"
        Case dbDouble: getFieldType = "double precision"
        Case dbFloat: getFieldType = "double precision"
        Case dbGUID: getFieldType = "GUID"
        Case dbInteger: getFieldType = "smallint"
        Case dbLong: getFieldType = "integer"
        Case dbLongBinary: getFieldType = "Long Binary (OLE Object)"
        Case dbMemo: getFieldType = "varchar(2000)"
        Case dbNumeric: getFieldType = "numeric"
        Case dbSingle: getFieldType = "real"
        Case dbText: getFieldType = "varchar"
        Case dbTime: getFieldType = "time"
        Case dbTimeStamp: getFieldType = "timestamp"
        Case dbVarBinary: getFieldType = "VarBinary"
        Case Else: getFieldType = "Unknown"
    End Select
End Function

Function replaceIsNull(str)
    Dim res, i, b1, b2, arg
    res = str 
    While InStr(LCase(res), "isnull")
        i = InStr(LCase(res), "isnull")
        b1 = findNext(i+1, res, "(")
        b2 = findNext(b1+1, res, ")")
        arg = Mid(res, b1 + 1, b2 - b1 - 1)
        res = Left(res, i - 1) & " " & arg & " is null " & Right(res, Len(res) - b2)
    Wend
    replaceIsNull = res
End Function

Function replaceIIF(str)
    Dim res, i, b1, c1, c2, b2, ob, r
    res = str
    r=0
    While InStr(LCase(res), "iif")
        i = InStr(LCase(res), "iif")
        b1 = findNext(i + 1, res, "(")
        b2 = findNext(b1 + 1, res, ")")
        c1 = findNext(b1 + 1, res, ",")
        c2 = findNext(c1 + 1, res, ",")
        If c2 > b2 Then c2 = b2
        Dim condition, truepart, falsepart
        condition = Mid(res, b1 + 1, c1 - b1 - 1)
        truepart = Mid(res, c1 + 1, c2 - c1 - 1)
        If c2 = b2 Then
            falsepart = " null "
        Else
            falsepart = Mid(res, c2 + 1, b2 - c2 - 1)
        End If
        res = Left(res, i - 1) & " case when " & condition & " then " & truepart & " else " & falsepart & " end " & Right(res, Len(res) - b2)
    Wend
'    WScript.echo(r & " replacements")
    replaceIIF = res
End Function

Function findNext(start, str, find)
    Dim ob,cb,dd, opens
    findNext = InStr(start, str, find)
    If find = "(" Then Exit Function
    
    ob = start
    cb = start
    
    Do While InStr(ob + 1, str, "(") <> 0 And InStr(ob + 1, str, "(") < findNext
        While InStr(ob + 1, str, "(") <> 0 And InStr(ob + 1, str, "(") < findNext
            opens = opens + 1
            ob = InStr(ob + 1, str, "(")
        Wend
        While opens > 0
            opens = opens - 1
            cb = InStr(cb + 1, str, ")")
        Wend
        findNext = InStr(cb + 1, str, find)
    Loop
End Function

