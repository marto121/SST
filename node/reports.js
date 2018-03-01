var config = require('./config')
var fs = require('fs')

const { Pool } = require('pg')
const pool = new Pool({
    connectionString: config.SST_pg_conn
})

var Excel = require('exceljs');

function getLastMonth() {
    var today = new Date()
    var lm = new Date(today.getFullYear(), today.getMonth(), 0)
    return lm.getFullYear()*100+lm.getMonth()+1
}
function setNameValue(wb, name, value) {
    rng = wb.definedNames.getRanges(name)
    if (rng.ranges[0]) {
        var a = rng.ranges[0].split("!")
        var c = wb.getWorksheet(a[0]).getCell(a[1])
        c.value = value
    }
}
async function createReport(report_id, m_ID, condition, Rep_LE) {
    var client = await pool.connect()
    var reports = await client.query("select * from lst_reports where id=" + report_id)
    client.release()
    if (reports.rows.length==0){
//      Log "createReport", "Report with id: " & report_id & " does not exist", tErr, m_ID
    } else {
        var report_code = reports.rows[0].report_code
        var templateFileName = reports.rows[0].template_filename
        client = await pool.connect()
        
        var sheets = await client.query("select * from lst_sheets where report_id=" + report_id)
        client.release()
        if (sheets.rows.length==0) {
//          Log "createReport", "Report with id: " & report_id & " has no defined sheets", tErr, m_ID
        } else {
//          Log "createReport", "Creating report """ & report_code & """", tLog, m_ID
            console.log(templateFileName)
            var wb = new Excel.Workbook();
            if (templateFileName != "") {
                templateFileName = config.SST_Templates_Path + "\\" + templateFileName
                if (fs.existsSync(templateFileName)) {
                    await wb.xlsx.readFile(templateFileName)
                    setNameValue(wb, "Rep_LE", Rep_LE)
                    setNameValue(wb, "Rep_Date", getLastMonth() )
                } else {
                    templateFileName = ""
    //              Log "createReport", "Template file name " & templateFileName & " not found! Creating empty file.", tWar, m_ID
                }
            }

            for (var r in sheets.rows) {
                shRow = sheets.rows[r]
                var sh = wb.getWorksheet(shRow.sheet_name)
                if (!sh) {
                    sh = wb.addWorksheet(shRow.sheet_name);
                }
                if (shRow.sheet_query!="") {
                    client = await pool.connect()
                    var sql = "select " + shRow.sheet_columns + " from " + shRow.sheet_query + " " + condition
                    try {
                        var data = await client.query(sql)
                        if (templateFileName == "") {
                            sh.addRow(Object.keys(data.rows[0]))
                        }
                        for (var rr in data.rows) {
                            sh.addRow(Object.values(data.rows[rr]))
                        }
                    } catch(error) {
//                        Log "createReport", "Error running SQL: " & sql, tErr, m_ID
                    } finally {
                        client.release()
                    }
                }
            }

            var fileName = ""
            for (f = 0; f<9999; f++) {
                fileName = config.SST_Att_Path_Out + "\\" + report_code + '_' + ("00000" + m_ID).slice(-6) + '_' + ('000' + f).slice(-4) + '.xlsx'
                if (!fs.existsSync(fileName)) {
                    break;
                }
            }
            await wb.xlsx.writeFile(fileName)
            console.log("ended")
        }
    }
    process.exit()
}
createReport(1, -1, '', 'Report')
/*
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
    rs.Open "select * from lst_reports.rows where id=" & report_id, dbConn, adOpenForwardOnly, adLockReadOnly
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
        Log "createReport", "Creating report """ & report_code & """", tLog, m_ID
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
*/