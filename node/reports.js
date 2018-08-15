module.exports = {
    createReport: createReport,
    createChangeReport_Template:createChangeReport_Template,
    createHTMLLog: createHTMLLog
}

var config = require('./config')
var constants = require('./constants')
var fs = require('fs')
var db = require('./db')

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
    const res = await db.query("select * from lst_reports where id=" + report_id)

    if (res.rows.length==0){
        db.log("createReport", "Report with id: " + report_id + " does not exist!", constants.tSys, m_ID)
    } else {
        var report_code = res.rows[0].report_code
        var templateFileName = res.rows[0].template_filename

        const sheets = await db.query("select * from lst_sheets where report_id=" + report_id)

        if (sheets.rows.length==0) {
            db.log("createReport", "Report with id: " + report_id + " has no defined sheets!", constants.tSys, m_ID)
        } else {
            db.log("createReport", "Creating report \"" + report_code + "\"", constants.tLog, m_ID)
            var wb = new Excel.Workbook();
            if (templateFileName != "") {
                templateFileName = config.SST_Templates_Path + "\\" + templateFileName
                if (fs.existsSync(templateFileName)) {
                    await wb.xlsx.readFile(templateFileName)
                    setNameValue(wb, "Rep_LE", Rep_LE)
                    setNameValue(wb, "Rep_Date", getLastMonth() )
                } else {
                    templateFileName = ""
                    db.log("createReport", "Template file name " + templateFileName + " not found! Creating empty file.", constants.tWar, m_ID)
                }
            }
            for (var r in sheets.rows) {
                shRow = sheets.rows[r]
                var sh = wb.getWorksheet(shRow.sheet_name)
                if (!sh) {
                    sh = wb.addWorksheet(shRow.sheet_name);
                }
                if (shRow.sheet_query!=null) {
                    var sql = "select " + shRow.sheet_columns + " from " + shRow.sheet_query + " " + condition
                    try {
                        const data = await db.query(sql)
                        if (templateFileName == "") {
                            sh.addRow(Object.keys(data.rows[0]))
                        }
                        for (var rr in data.rows) {
                            sh.addRow(Object.values(data.rows[rr]))
                        }
                    } catch(error) {
                        db.log("createReport", "Error running SQL: " + sql + ". Error: " + error.toString(), constants.tSys, m_ID)
                    } finally {
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
            return fileName
        }
    }
}

async function createHTMLLog(m_ID) {
    var tBody
    const res = await db.query("select log_date,log_text,nom_log_types.color from SST_Log inner join nom_log_types on nom_log_types.id=sst_log.log_type where Mail_ID=$1 order by sst_log.id",[m_ID]);
    for (const row of res.rows ) {
        tBody += "<tr bgcolor='" + row.color + "'><td>" + row.log_date + "</td><td>" + row.log_text + "</td></tr>"
    }
    var sHTML = "<table cellspacing='0' cellpadding='1' border='1'>"
        +"<thead><th>Date</th><th>Message</th></thead>"
        + tBody + "</table>"
    return sHTML
}

async function createChangeReport_Template(m_ID) {
    const res = await db.query("select * from meta_updatable_tables")
    var templateFileName = "SST_Template.xlsx"
    templateFileName = config.SST_Templates_Path + "\\" + templateFileName
    var wb = new Excel.Workbook();
    if (fs.existsSync(templateFileName)) {
        await wb.xlsx.readFile(templateFileName)

        const rsF = await db.query("select repLE, repDate from file_log where m_id=$1",[m_ID])
        if (rsF.rows.length>0) {
            setNameValue(wb, "Rep_LE", rsF.rows[0].reple)
            setNameValue(wb, "Rep_Date", rsF.rows[0].repdate.getFullYear()*100+rsF.rows[0].repdate.getMonth()+1 )
        }
        setNameValue(wb, "preparedBy",  "SST Change report for message " + m_ID)
        setNameValue(wb, "preparedOn", new Date())
    } else {
        templateFileName = ""
        db.log("createReport", "Template file name " + templateFileName + " not found! Creating empty file.", constants.tWar, m_ID)
    }
    for (const shRow of res.rows) {
        var sql = "select * from sel_" + shRow.table_name + "($1)"
        const rsData = await db.query(sql,[m_ID])
        if (rsData.rows.length==0) {
            db.log ("createChangeReport", "No new data for " + shRow.table_name, constants.tInfo, m_ID)
        } else if (shRow.sheet_name){
            var sh = wb.getWorksheet(shRow.sheet_name)
            if (!sh) {
                sh = wb.addWorksheet(shRow.sheet_name);
            }
            printCells_Template(rsData, sh, m_ID, shRow.fields_list)
        }
    }
    var fileName = config.SST_Att_Path_Out + "ChangeReport_" + m_ID + ".xlsx"
    await wb.xlsx.writeFile(fileName)
    return fileName
}

function printCells_Template(rsData, sh, m_ID, fields_list) {
    var outRow = []
    var emptySheet = true
    if (sh.getCell("A1").text) {
        emptySheet = false
    }
    if (emptySheet) {
        rsData.fields.forEach ( function (field) {
            if (field.name.substring(0,4).toLowerCase()!='old_') {
                outRow.push(field.name)
            }
        })
        sh.getRow(1).values = outRow
        sh.getRow(1).font={bold:true}
    }
    var records_new=0
    var records_changed=0
    var currRow = 1
    for (const row of rsData.rows) {
        var changedRow = false
        var col = 0
        currRow ++
        var shRow = sh.getRow(currRow)
        //console.log(shRow)
        rsData.fields.forEach(function (field) {
            var changedField = false
            if (field.name.substring(0,4).toLowerCase()!='old_') {
                col ++
                var oldValue = null
                var newValue = row[field.name]
                if (field.name.toLowerCase().indexOf("_new")!=-1) {
                    oldValue = row[field.name.replace("_new","_old")]
                }
                if (newValue==null) newValue = oldValue;
                if ((oldValue==null&&newValue!=null)|oldValue!=newValue){
                    changedField = true
                }
                if(oldValue&&oldValue.parseFloat()!=NaN&&newValue&&newValue.parseFloat()!=NaN) {
                    if (round(oldValue.parseFloat())==round(newValue.parseFloat()))changedField = false
                }
                if((oldValue==null)&&newValue&&newValue.parseFloat&&newValue.parseFloat()==0)changedField=false
                if (changedField) {
                    changedRow = true
                }
                with (shRow.getCell(col)) {
                    value = newValue;
                    if (changedField) {
                        fill = {type:"pattern", pattern:"solid", fgColor:{argb:"00FFCC66"}}
                    }
                    if (oldValue!=null) {
                        //add comment to cell
                    }
                }
                if (field.name.toLowerCase()=='record_status') {
                    if (row[field.name]=="New") {
                        shRow.fill = {type:"pattern", pattern:"solid", fgColor:{argb:"00C1F5FF"}}
                        records_new++;
                    } else if (changedRow) {
                        records_changed++;
                    } else {}

                }
            }
        })
    }
    if (records_new+records_changed>0){
        db.log("printCells", records_new + " new record(s) and " + records_changed + " changed record(s) in sheet " + sh.name, constants.tInfo, m_ID)
    } else {
        db.log("printCells", "No New/Changed record(s) in sheet " + sh.name, constants.tInfo, m_ID)
    }
}