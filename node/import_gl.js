'use strict'
const db = require('./db')
const utils = require('./utils');
const Excel = require('exceljs')
const XLSX = require('xlsx');
var constants = require('./constants');
var config = require('./config');
const Minizip = require('minizip-asm.js');
var fs = require("fs");
var path = require("path")

const parseOpts = {
    A2588: {shNames: function() {return [{name: 'BMD KoRe'}]}, dateFunc: getDate_A2588, parseFunc: parseRow_A2588}, //Slovenia
//    A3234: {shNames: function() {return ['TB 31.08.2018.']}, dateFunc: getDate_A3234, parseFunc: parseRow_A3234}, for trial balance
    A2572: {shNames: function() {return [{name: 'PL (without allocations) source'}, {name: 'Balance source', noDel: 1}]}, dateFunc: getDate_A2572, parseFunc: parseRow_A2572}, //Latvia
    A2736: {shNames: getSheets_A2736, dateFunc: getDate_A2736, parseFunc: parseRow_A2736}, //Bulgaria
    A3214: {shNames: function() {return [{name: 'Sheet'}]}, dateFunc: getDate_A3214, parseFunc: parseRow_A3214}, //Bosnia
    A2769: {shNames: getSheets_A2769, dateFunc: getDate_A2769, parseFunc: parseRow_A2769}, //CZ
    A3163: {shNames: getSheets_A3163, dateFunc: getDate_A3163, parseFunc: parseRow_A3163}, //SK
    A3234: {shNames: function() {return [{name: '4D Wand knjiženja'}]}, dateFunc: getDate_A3234, parseFunc: parseRow_A3234}, //HR
    HU   : {shNames: getSheets_HU,  dateFunc: getDate_HU, parseFunc: parseRow_HU, entityFunc: getEntity_HU}, //HU
    A2643: {shNames: function() {return [{name: 'Registrul jurnal'}]}, dateFunc: getDate_A2643, parseFunc: parseRow_A2643}, //RO
    RS: {shNames: function() {return [{name: 'APD'},{name: 'Uctam'}]}, dateFunc: getDate_RS, parseFunc: parseRow_RS, entityFunc: getEntity_RS}, //RS
    A2604: {shNames: function() {return [{name: 'GL'}]}, dateFunc: getDate_A2604, parseFunc: parseRow_A2604}, //RU
}
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201908\\HU\\Cost monitoring by CEE_entire general ledger _31082019.xlsx","HU",1386)
/*import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\SI\\UCTAM - Einzelnachweis KORE_07.2019.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201901-02\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 01.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201901-02\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 02.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201903\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 03.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201904\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 04.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201905\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 05.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201906\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 06.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\RS\\Uctam_KPMG_Pregled prihoda i rashoda 07.2019.xlsx","RS",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201901-02\\RO\\Registru jurnal UCTAM 01-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201901-02\\RO\\Registru jurnal UCTAM 02-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201903\\RO\\Registru jurnal UCTAM 03-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201904\\RO\\Registru jurnal UCTAM 04-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201905\\RO\\Registru jurnal UCTAM 05-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201906\\RO\\Registru jurnal UCTAM 06-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\RO\\Registru jurnal UCTAM 07-2019.xlsx","A2643",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\HU\\Cost monitoring by CEE _31072019.xlsx","HU",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\HR\\General ledger 07-2019.xlsx","A3234",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\CZ\\UCM_Deník_3172019.xls","A2769",-1)
/*import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\CZ\\UCTAMSVK_Journal_01-07_2019.xlsx","A3163",-1)
import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\BH\\Detalji knjiženja_glavna knjiga-01.01.-31.07..xlsx","A3214",-1)
*/

//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201904\\BG\\MIS 2019_UCTAM_BG.xlsx","A2736",-1)
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201905\\BG\\MIS 2019_UCTAM_BG.xlsx","A2736",-1)
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201906\\BG\\MIS 2019_UCTAM_BG.xlsx","A2736",-1)
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\BG\\Mis 07.2019_sent.xlsx","A2736",-1)
/*import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\LV\\07 UCTAM report Jul 2019 (management).xlsx","A2572",-1)

/*
import_gl("J:\\UCTAMCEE\\CFO\\0002 Controlling\\Data received\\2018\\201808\\HR\\Trial balance on 31.08.2018..xlsx","A3234",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_06.2018.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_05.2018.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_04.2018.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_03.2018 V4.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_02.2018 V4.xlsb","A2588",-1)
import_gl("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_01.2018 V4.xlsb","A2588",-1)
*/
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201907\\RU\\Expenses 01012019-31072019.xls","A2604")
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201908\\RU\\Expenses 01012019-31082019.xls","A2604",1401)
//import_gl("I:\\UCTAM_CFO\\CONTROLLING\\Cost Controlling\\2019\\201908\\LV\\08 UCTAM report Aug 2019 (management).xlsx","A2572",1403)
//.then(res=>{console.log(res)})
async function import_gl(fName, LE, m_ID) {
    //{toStatus, Rep_LE, Rep_Date}
    var LE_Rights = LE
    if(parseOpts[LE]&&parseOpts[LE].entityFunc) LE_Rights = parseOpts[LE].entityFunc()
    const chkRights = await db.query("select * from vw_LE_Sender where Tagetik_Code=$1 and id=$2",[LE_Rights, m_ID])
    if (chkRights.rows==0) {
        db.log ("import_gl", "You are not allowed to work with Legal Entity " + LE_Rights + ". Processing stopped.", constants.tErr, m_ID)
        return {toStatus: constants.statusRejected, Rep_LE: LE, Rep_Date: null}
    }
if (!parseOpts[LE]) {
        db.log ("import_gl", "No definition found for reading GL of LE " + LE,  constants.tErr, m_ID)
        return {toStatus: constants.statusRejected, Rep_LE: LE, Rep_Date: null}
    }
    if (path.extname(fName).toLowerCase()==".zip") {
        db.log ("import_gl", "Zip file detected [" + fName + "]. Try to unzip.",  constants.tLog, m_ID)
        try {
            const zipped = fs.readFileSync(fName)
            const mz = new Minizip(zipped)
            const zipFiles = mz.list()
            var options = {}
            if (path.basename(fName).includes("KORE")) {
                if(zipFiles[0].filepath.split("/").pop().substring(0,27)!="UCTAM - Einzelnachweis KORE") {
                    throw ("\"file [UCTAM - Einzelnachweis KORE] not found in ZIP!\"")
                }
                options.password = config.KORE_pass
            }
            const unzipped = mz.extract(zipFiles[0].filepath,options)
            fName = path.join(path.dirname(fName),utils.pad(m_ID, 4) + "_" + zipFiles[0].filepath.split("/").pop())
            fs.writeFileSync(fName, unzipped)
        } catch (e) {
            db.log ("import_gl", "Error unzipping file: [" + fName + "]. The error is " + e.toString(),  constants.tSys, m_ID)
            return {toStatus: constants.statusRejected, Rep_LE: LE, Rep_Date: null};
        }
    }
    if(path.extname(fName).toLowerCase()=='.xlsb' || path.extname(fName).toLowerCase()=='.xls') {
        try {
            var workbook = await XLSX.readFile(fName,{cellDates:true, cellStyles:true, cellNF:true});
            if (!workbook) throw new Error("Unable to read workbook")
            fName = fName + '.xlsx'
            await XLSX.writeFile(workbook, fName);
        } catch (e) {
            //console.log(e)
            db.log ("import_gl", "Error parsing excel file: \"" + fName + "\". The error is " + e.toString(),  constants.tSys, m_ID)
            return {toStatus: constants.statusRejected, Rep_LE: LE, Rep_Date: null};
        }
    }

    var wb = new Excel.Workbook();
//    var wbOut = new Excel.Workbook();
//    var shOut = wbOut.addWorksheet("Data")
/*    shOut.columns = [
        { header:'subAsset', key:'subAsset' },
        { header:'docDate', key:'docDate' },
        { header:'bookDate', key:'bookDate' },
        { header:'docNom', key:'docNom' },
        { header:'countName', key:'countName' },
        { header:'countID', key:'countID' },
        { header:'accNo', key:'accNo' },
        { header:'opType', key: 'opType'},
//        { header:'accNoCT', key:'accNoCT' },
//        { header:'accNoDT', key:'accNoDT' },
        { header:'accName', key:'accName' },
        { header:'docRef', key:'docRef' },
        { header:'CCY', key:'CCY' },
        { header:'amtCCY', key:'amtCCY' },
        { header:'FX', key:'FX' },
        { header:'amtFX', key:'amtFX' },
        { header:'docText', key:'docText' },
        { header:'LE_Code', key:'LE_Code' },
        { header:'debug', key:'debug'}
    ]*/
    var insert_sql = "INSERT INTO public.gl_data(/*id,*/ subasset, docdate, bookdate, docnom, countname, countid, accno, opType, /*accnoct, accnodt, */accname, docref, ccy, amtccy, fx, amtfx, doctext, le_code, debug, m_id) values "
    //insert_sql+="VALUES (/*?,*/ $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);"
    try {
        await wb.xlsx.readFile(fName)

        wb.name = fName;
    
        var shNames = parseOpts[LE].shNames(wb)
        var sh=wb.getWorksheet(shNames[0].name);

        if (!sh) throw new Error("Sheet with name " + shNames[0].name + " not found.")
    
        var Rep_Date = parseOpts[LE].dateFunc(sh)
        if (isNaN(Rep_Date.startDate)) Rep_Date.startDate = null;
        //console.log(LE + ": " + JSON.stringify(Rep_Date))
        
        var LE_Code = LE
        //await db.query("delete from trial_balance where rep_date=$1 and LE_ID = (select id from legal_entities where tagetik_code=$2)",[Rep_Date, LE])
        for (var shNo = 0; shNo<shNames.length; shNo++) {
            sh=wb.getWorksheet(shNames[shNo].name)
            if (parseOpts[LE].entityFunc) {
                LE_Code = parseOpts[LE].entityFunc(sh)

            }
            console.log("Entity: " + LE_Code + ", Rows: " + sh.rowCount, db.dbDate(Rep_Date.startDate), db.dbDate(Rep_Date.endDate))
            if (!shNames[shNo].noDel) {
                await db.query("delete from gl_data where bookDate between $1 and $2 and LE_Code = $3", [db.dbDate(Rep_Date.startDate), db.dbDate(Rep_Date.endDate), LE_Code])
            }
            var rows = [{subAsset: null, docDate: null, bookDate: null, docNom: null, countName: null, countID: null, accNo: null, opType: null,/* accNoCT: null, accNoDT:null,*/
                accName: null, docRef: null, CCY: null, amtCCY: null, FX: null, amtFX: null, docText: null, LE_Code: null, debug: null}]
            var values = ""
            var valuesCount = 0
            try {
                for (var rowNum=1; rowNum<=sh.rowCount; rowNum++) {
                var rowValues = []
        /*        for (var colNum = 0; colNum<range.e.c; colNum++) {
                    const cellAddress = XLSX.utils.encode_cell({c:colNum, r:rowNum});
                    if (sh.hasOwnProperty(cellAddress)) {
                        rowValues.push(sh[XLSX.utils.encode_cell({c:colNum, r:rowNum})])
                    } else {
                        rowValues.push(null)
                    }
                }*/
                    rows = parseOpts[LE].parseFunc(sh.getRow(rowNum), (rows.length)?rows[0]:[], Rep_Date);
                    for (const row of rows) {
                        if (row&&row.amtCCY) {
                            row.LE_Code = LE_Code
                            //shOut.addRow(row)
                            values += "("
                            values += ((row.subAsset) ? "'"+row.subAsset+"'": "null")+","
                            values += ((row.docDate) ? "'"+db.dbDate(row.docDate)/*.split("T")[0]*/+"'": "null")+","
                            values += ((row.bookDate) ? "'"+db.dbDate(row.bookDate)/*.split("T")[0]*/+"'": "null")+","
                            values += ((row.docNom) ? "'"+row.docNom+"'": "null")+","
                            values += ((row.countName) ? "'"+row.countName.replace("'","''")+"'": "null")+","
                            values += ((row.countID) ? "'"+row.countID+"'": "null")+","
                            values += ((row.accNo) ? "'"+row.accNo+"'": "null")+","
                            values += ((row.opType) ? "'"+row.opType+"'": "null")+","
    //                        values += ((row.accNoCT) ? "'"+row.accNoCT+"'": "null")+","
    //                        values += ((row.accNoDT) ? "'"+row.accNoDT+"'": "null")+","
                            values += ((row.accName) ? "'"+row.accName+"'": "null")+","
                            values += ((row.docRef) ? "'"+row.docRef+"'": "null")+","
                            values += ((row.CCY) ? "'"+row.CCY+"'": "null")+","
                            values += ((row.amtCCY) ? "'"+row.amtCCY+"'": "null")+","
                            values += ((row.FX) ? "'"+row.FX+"'": "null")+","
                            values += ((row.amtFX) ? "'"+row.amtFX+"'": "null")+","
                            values += ((row.docText) ? "'"+row.docText.replace("'","''")+"'": "null")+","
                            values += ((row.LE_Code) ? "'"+row.LE_Code+"'": "null")+","
                            values += "null,"
                            values += m_ID + ")"
                            valuesCount ++
                            if ((valuesCount%100)==0) {
                                //console.log(insert_sql+values)
                                await db.query(insert_sql+values)
                                values = ""
                            } else {
                                values+=","
                            }
    //                        await db.query(insert_sql, [row.subAsset, row.docDate, row.bookDate, row.docNom, row.countName, row.countID, row.accNo, row.accNoCT, row.accNoDT,
    //                           row.accName, row.docRef, row.CCY, row.amtCCY, row.FX, row.amtFX, row.docText, row.LE_Code, null])
                        //console.log(row)
                        /*await db.query(
                            "insert into trial_balance as tb (le_id, rep_date, accNo, amt, m_ID) select id, $2, $3, $4 as amt, $5 from legal_entities where tagetik_code=$1"
                            +" on conflict (le_id, rep_date, accNo, m_ID) do update set amt = coalesce(tb.amt,0) + coalesce(excluded.amt,0)"
                            , [LE, Rep_Date, row.accNo, row.amt, m_ID]
                        )*/
                        }
                    }
                }
                if (values!="") {
                    await db.query(insert_sql + values.substring(0,values.length-1))
                }
            } catch (e) {
//                console.log(fName, rowNum, LE, Rep_Date, rows, e.toString())
                db.log ("import_gl", "Error parsing excel file: \"" + fName + "\" at row " +rowNum + ". The error is " + e.toString(),  constants.tErr, m_ID)
                break
            }
        }
        console.log("Loaded "+fName + " for LE " + LE + " for date " + Rep_Date.endDate)
        db.log ("import_gl", "Successfully imported GL file: \"" + fName + "\".",  constants.tLog, m_ID)
        return {toStatus: constants.statusProcessed, Rep_LE: LE, Rep_Date: Rep_Date.endDate}
        wbOut.xlsx.writeFile("C:\\Temp\\" + LE + ".xlsx")
    } catch(e) {
        db.log ("import_gl", "Error parsing excel file: \"" + fName + "\". The error is " + e.toString(),  constants.tSys, m_ID)
        return {toStatus: constants.statusRejected, Rep_LE: LE, Rep_Date: null};
    }
}

/* Baltics */
function getDate_A2572(sh) {
    var month = path.basename(sh.workbook.name).split("_").pop().substring(0,2);
    var year = path.basename(sh.workbook.name).split("_").pop().substring(20,24);
    var dt = new Date(parseInt(year),parseInt(month),0);
    return {startDate:new Date(2010,0,1), endDate: dt};
}

function parseRow_A2572(row) {
    if(row.number>1&&row.getCell(2).value!=null) {
/*        var begYear = new Date(rep_date.getTime())
        begYear.setMonth(0);
        begYear.setDate(0)*/
        const offset = (row.worksheet.name.substring(0,2)=="PL")?1:0;
        if (true /*||row.getCell(4+offset).value.getTime() > begYear.getTime()*/) {
            var res = {}
            var amt = getAmt(row.getCell(13+offset).value)
            res.subAsset = row.getCell(9+offset).value;
            //res.docDate = row.getCell(4+offset).value;
            res.bookDate = row.getCell(4+offset).value;
            res.docNom = row.getCell(3+offset).value
            //res.countName = row.getCell(12).value
            //res.countID = row.getCell(10).value
            res.accNo = row.getCell(2).value
            if (isString(res.accNo)) res.accNo = res.accNo.split("/")[0].trim()
            if (offset) res.accNo += "." + getAmt(row.getCell(3).value).substring(0,1)
            if (amt>0) {
                res.opType = "DT"
            } else {
                res.opType = "CT"
            }
            res.accName = row.getCell(2).value
            if (isString(res.accName)) res.accName = res.accName.split("/").pop().trim()
            res.docRef = row.getCell(7+offset).value
            res.CCY = 'EUR'
            res.amtCCY = amt
            res.FX = res.CCY
            res.amtFX = res.amtCCY
            res.docText = row.getCell(8+offset).value
            //res.debug = row.getCell(13+offset)
            return [res]
        } else {
            return null;
        }
    } else {
        return []
    }
}

/* UCTAM Bulgaria */
function getSheets_A2736(wb) {
    var result = "Sheet starting with \"MIS\""
    wb.eachSheet(function(worksheet, sheetId) {
        if (worksheet.name.toLowerCase().substring(0,3)=="mis") {
            result = worksheet.name;
        }
    });
    return [{name: result}]
}

function getDate_A2736(sh) {
    var year = sh.getCell("P2");
    var month = sh.getCell("Q2")
    var dt = new Date(parseInt(year),parseInt(month),0);
    return {startDate:new Date(dt.getFullYear(),dt.getMonth(),1), endDate: dt};
}

function parseRow_A2736(row) {
    if(row.number>1&&row.getCell(1).value) {
        var res = {}
        var amt = getAmt(row.getCell(13).value)
        res.subAsset = row.getCell(3).value;
        res.docDate = row.getCell(4).value;
        res.bookDate = row.getCell(5).value;
        res.docNom = row.getCell(6).value
        res.countName = row.getCell(7).value
        res.countID = row.getCell(8).value
        res.accNo = row.getCell(9).value
        if (amt>0) {
            res.opType = "CT"
        } else {
            res.opType = "DT"
        }
        res.accName = row.getCell(11).value
        res.docRef = row.getCell(12).value
        res.CCY= row.getCell(14).value
        res.amtCCY = amt
        res.FX = 'EUR'
        res.amtFX = res.amtCCY/1.95583
        return [res]
    } else {
        return []
    }
}

/* UCTAM Bosnia */
function getDate_A3214(sh) {
//Detalji knjiženja_glavna knjiga-01.01.-31.07..xlsx
    var day = sh.workbook.name.substring(sh.workbook.name.length-11).substring(0,2);
    var month = sh.workbook.name.substring(sh.workbook.name.length-8).substring(0,2);
    var dt = new Date();
    var dateOffset = (24*60*60*1000) * 30
    dt.setTime(dt.getTime() - dateOffset);
    dt = new Date(dt.getFullYear(),parseInt(month)-1,parseInt(day));
    return {startDate:new Date(dt.getFullYear(),0,1), endDate: dt};
}

function parseRow_A3214(row) {
    if(row.number>3&&row.getCell(1).value) {
        var res = {}
        var amt = getAmt(row.getCell(11).value)
        //res.subAsset = row.getCell(3).value;
        res.docDate = row.getCell(8).value;
        //res.bookDate = row.getCell(17).value; // Booking date
        res.bookDate = row.getCell(5).value; // Value date
        res.docNom = row.getCell(2).value
        res.countName = row.getCell(24).value
        res.countID = row.getCell(21).value
        res.accNo = row.getCell(20).value
        if (amt>0) {
            res.opType="DT"
        } else {
            res.opType="CT"
        }
        res.accName = row.getCell(1).value
        res.docRef = row.getCell(6).value
        res.CCY = 'BAM'
        res.amtCCY = -amt
        res.FX = 'EUR'
        res.amtFX = res.amtCCY/1.95583
        res.docText = row.getCell(14).value
        return [res]
    } else {
        return []
    }
}

/* UCTAM CZ */
function getSheets_A2769(wb) {
    var wbName = path.basename(wb.name).split(".")[0]
    if (wbName.substring(0,3)!="UCM")
        wbName = "UCM" + wbName.split("UCM")[1];
    return [{name: wbName}]
}
function getDate_A2769(sh) {
//UCM_Deník_3172019.xls
    var dText = path.basename(sh.workbook.name).split("_").pop().split(".")[0]
    var day = dText.substring(0,2)
    var month = dText.substring(2, 2 + dText.length-6)
    var year = dText.substring(dText.length-4)
    var dt = new Date(parseInt(year), parseInt(month)-1, parseInt(day));
    return {startDate:new Date(dt.getFullYear(),0,1), endDate: dt};
    return dt;
}

function parseRow_A2769(row) {
    if(row.number>1&&row.getCell(1).value) {
        var res = {}
        res.subAsset = row.getCell(17).value;
        res.docDate = row.getCell(22).value;
        res.bookDate = row.getCell(4).value;
        res.docNom = row.getCell(2).value
        res.countName = row.getCell(19).value
        res.countID = row.getCell(18).value
        res.accNo = row.getCell(6).value
        if (row.getCell(11).value) {
            res.opType="DT"
        } else {
            res.opType="CT"
        }
        res.accName = row.getCell(7).value
        res.docRef = row.getCell(16).value
        res.CCY = 'CZK'
        res.amtCCY = -getAmt(row.getCell(10).value)
        res.FX = row.getCell(13).value
        res.amtFX = -getAmt(row.getCell(14).value)
        res.docText = row.getCell(15).value
        return [res]
    } else {
        return []
    }
}

/* UCTAM SVK */
function getSheets_A3163(wb) {
    return [{name: wb.getWorksheet(1).name}]
}

function getDate_A3163(sh) {
//UCTAMSVK_Journal_01-07_2019.xlsx
    var fName=path.basename(sh.workbook.name).split(".")[0]
    console.log(fName)
    var month = fName.substring(fName.length-7).substring(0,2);
    var year = fName.substring(fName.length-4).substring(0,4);
    var dt = new Date(parseInt(year),parseInt(month),0);
    return {startDate:new Date(dt.getFullYear(),0,1), endDate: dt};
    return dt;
}

function parseRow_A3163(row) {
    if(row.number>1&&row.getCell(1).value) {
        var res = {}
        var amt = getAmt(row.getCell(6).value)
        res.subAsset = 'CZ_00022_001';
        res.docDate = row.getCell(8).value;
        res.bookDate = row.getCell(4).value;
        res.docNom = row.getCell(1).value
        res.countName = row.getCell(13).value
        res.countID = row.getCell(12).value
        res.accNo = row.getCell(5).value
        res.accName = row.getCell(5).value
        if(amt>0) {
            res.opType = "DT"
        } else {
            res.opType = "CT"
        }
        res.docRef = row.getCell(11).value
        res.CCY = 'EUR'
        res.amtCCY = -getAmt(row.getCell(6).value)
        res.FX = res.CCY
        res.amtFX = res.amtCCY
        res.docText = row.getCell(10).value
        return [res]
    } else {
        return []
    }
}

/* UCTAM Zagreb */
function getDate_A3234(sh) {
//General ledger 07-2019.xlsx
    var month = sh.workbook.name.substring(sh.workbook.name.length-12).substring(0,2);
    var year = sh.workbook.name.substring(sh.workbook.name.length-9).substring(0,4);
    var dt = new Date(parseInt(year),parseInt(month),0);
    return {startDate:new Date(dt.getFullYear(),0,1), endDate: dt};
    return dt;
}

function parseRow_A3234(row) {
    if(row.number>1&&row.getCell(1).value) {
        var res = {}
        var amt = getAmt(row.getCell(13).value)
        res.subAsset = row.getCell(17).value;
        res.docDate = row.getCell(10).value;
        //res.bookDate = row.getCell(3).value; booking date
        res.bookDate = row.getCell(4).value; // value date
        res.docNom = row.getCell(7).value
        res.countName = row.getCell(12).value
        res.countID = row.getCell(11).value
        if(amt>0) {
            res.opType = "DT"
        } else {
            res.opType = "CT"
        }
        res.accNo = row.getCell(5).value
        res.accName = row.getCell(6).value
        res.docRef = row.getCell(9).value
        res.CCY = 'HRK'
        res.amtCCY = - amt
        res.FX = getCCY(row.getCell(25).value)
        res.amtFX = -getAmt(row.getCell(29).value)
        res.docText = row.getCell(16).value
        return [res]
    } else {
        return []
    }
}

/* UCTAM Russia */
function getDate_A2604(sh) {
    //Expenses 01012019-31072019.xlsx
    var pStart=sh.workbook.name.indexOf(".xls")
    var sDay = sh.workbook.name.substring(pStart-17).substring(0,2)
    var sMonth = sh.workbook.name.substring(pStart-15).substring(0,2);
    var sYear = sh.workbook.name.substring(pStart-13).substring(0,4);
    var eDay = sh.workbook.name.substring(pStart-8).substring(0,2)
    var eMonth = sh.workbook.name.substring(pStart-6).substring(0,2);
    var eYear = sh.workbook.name.substring(pStart-4).substring(0,4);
    var sdt = new Date(parseInt(sYear),parseInt(sMonth)-1,parseInt(sDay));
    var edt = new Date(parseInt(eYear),parseInt(eMonth)-1,parseInt(eDay));
    return {startDate: sdt, endDate: edt};
    return dt;
}

function parseRow_A2604(row) {
    if(row.number>1&&row.getCell(1).value) {
        var res = {}
        var amt = getAmt(row.getCell(12).value)
        //res.subAsset = row.getCell(17).value;
        //res.docDate = row.getCell(10).value;
        //res.bookDate = row.getCell(3).value; booking date
        var dateText = ""
        var dt = row.getCell(2).value
        if (isString(dt)) {
            dateText = row.getCell(2).value
            dt = dt.split("."); // value date
            res.bookDate = new Date(parseInt(dt[2].substring(0,4)),parseInt(dt[1])-1, parseInt(dt[0]));
        } else if (dt instanceof Date && !isNaN(dt)) {
            dateText = dt.toISOString()
            res.bookDate = dt
            //console.log(dt)
        }
        var doc = row.getCell(3).value
        var docStart = doc.indexOf(" 0U")+1
        if(docStart > 0) {
            res.docNom = dateText + ":" + doc.substring(docStart, docStart+11) + ":" + row.getCell(1).value
        } else {
            res.docNom = dateText + ":" + row.number + ":" + row.getCell(1).value
        }
        if (res.docNom.length>50) console.log(res.docNom)
        //res.docNom = row.getCell(7).value
        //res.countName = row.getCell(12).value
        //res.countID = row.getCell(11).value
        res.opType = "DT"
        res.accNo = row.getCell(4).value
        res.accName = row.getCell(5).value + "~" + row.getCell(6).value + "~" + row.getCell(7).value
        res.docRef = row.getCell(3).value
        res.CCY = 'RUB'
        res.amtCCY = - amt
//        res.FX = getCCY(row.getCell(25).value)
//        res.amtFX = -getAmt(row.getCell(29).value)
        res.docText = row.getCell(13).value
        var res2 = Object.assign({}, res)
        res2.accNo = row.getCell(8).value
        res2.opType = "CT"
        res2.accName = row.getCell(9).value + "~" + row.getCell(10).value + "~" + row.getCell(11).value
        res2.amtCCY = -res.amtCCY
    return [res, res2]
    } else {
        return []
    }
}
    
function getCCY(num) {
    if (num=='001')
        return 'HRK'
    else if (num=='978')
        return 'EUR'
    else
        return "UNK"
}


/* Hungary */
function getSheets_HU(wb) {
    return [
        {name: "EIFM01-" + wb.name.substring(wb.name.length-11).substring(0,2)},
        {name: "UCT HUN01-" + wb.name.substring(wb.name.length-11).substring(0,2)},
        {name: "UCT RET01-" + wb.name.substring(wb.name.length-11).substring(0,2)}
    ]
}

function getEntity_HU(sh) {
    if (!sh||sh.name.substring(0,7)=="UCT HUN") {
        return "A2917"
    } else if (sh.name.substring(0,4)=="EIFM") {
        return "A765"
    } else if (sh.name.substring(0,7)=="UCT RET") {
        return "A3176"
    } else {
        return "UNKNOWN"
    }
}
function getDate_HU(sh) {
//Cost monitoring by CEE _31072019.xlsx
    var periodText = sh.getCell("C4").text
    var startDate = new Date(parseInt(periodText.substring(0,4)), parseInt(periodText.substring(5,7))-1, parseInt(periodText.substring(8,10)))
    var endDate = new Date(parseInt(periodText.substring(16,20)), parseInt(periodText.substring(21,23))-1, parseInt(periodText.substring(24,26)))
    return {startDate: startDate, endDate: endDate};
}

function parseRow_HU(row, init) {
    if(row.number>6&&row.getCell(1).value) {
        var res = (init)?init:{}
        var res2 = {}
        if(row.getCell(1).value!="" && row.getCell(10).value==null) {
            res.accNo = getAmt(row.getCell(2).value)
            if(isString(res.accNo)) res.accNo = res.accNo.split(",")[0].trim()
            //console.log(res.accNo)
            res.accName = getAmt(row.getCell(2).value)
            if(isString(res.accName)) {
                if(isString(res.accName.split(",")[1]))res.accName = res.accName.split(",")[1].trim()
            }
            res.amtCCY = null
        } else if (row.getCell(7).value) {
            //res.subAsset = row.getCell(17).value;
            //res.docDate = row.getCell(22).value;
            res.bookDate = row.getCell(6).value;
            res.docNom = row.getCell(1).value
            res.countName = row.getCell(3).value
            //res.countID = row.getCell(18).value
            if (row.getCell(10).value!=0) {
                res.opType = "DT"
            } else {
                res.opType = "CT"
            }
            res.docRef = row.getCell(5).text
            res.CCY = 'HUF'
            res.amtCCY = getAmt(row.getCell(11).value)-getAmt(row.getCell(10).value)

    //        res.FX = row.getCell(13).value
    //        res.amtFX = row.getCell(14).value
            res.docText = row.getCell(4).text
            res2 = Object.assign({}, res)
            res2.accNo = row.getCell(7).value
            res2.accName = ""
            if (res.opType=="CT") {
                res2.opType = "DT"
            } else {
                res2.opType = "CT"
            }
            res2.amtCCY = -res2.amtCCY
        } else {
            res.amtCCY = null
        }
        return [res/*, res2*/]
    } else {
        init.amtCCY = null
        return [init]
    }
}

/* UCTAM Romania */
function getDate_A2643(sh) {
    //Registru jurnal UCTAM 07-2019.xlsx
    var periodText = sh.getCell("A5").text
    var startDate = new Date(parseInt(periodText.substring(16,20)), parseInt(periodText.substring(13,15))-1, parseInt(periodText.substring(10,12)))
    var endDate = new Date(parseInt(periodText.substring(29,33)), parseInt(periodText.substring(26,28))-1, parseInt(periodText.substring(23,25)))
    return {startDate: startDate, endDate: endDate};
}
    
function parseRow_A2643(row) {
    if(row.number>9&&row.getCell(7).value&&!isNaN(row.getCell(1).value)) {
        var res = {}
        //res.subAsset = row.getCell(17).value;
        //res.docDate = row.getCell(4).value;
        res.bookDate = row.getCell(5).value;
        res.docNom = row.getCell(2).value
        res.countName = row.getCell(10).value
        //res.countID = row.getCell(10).value
        res.accNo = row.getCell(7).value.replace(/\s+/g,"")
        res.opType = "DT"
        //res.accName = row.getCell(6).value
        res.docRef = row.getCell(4).value
        res.CCY = 'RON'
        res.amtCCY = -getAmt(row.getCell(9).value)
        //res.FX = row.getCell(3).value
        //res.amtFX = row.getCell(29).value
        res.docText = row.getCell(6).value
        var res2 = Object.assign({}, res)
        res2.accNo = row.getCell(8).value.replace(/\s+/g,"")
        res2.opType = "CT"
        res2.amtCCY = -res.amtCCY
        return [res, res2]
    } else {
        return []
    }
}

/* UCTAM Serbia */
function getDate_RS(sh) {
//Uctam_KPMG_Pregled prihoda i rashoda 07.2019.xlsx
    var periodText = sh.getCell("A3").text
    var startDate = new Date(parseInt(periodText.substring(13,17)), parseInt(periodText.substring(10,12))-1, parseInt(periodText.substring(7,9)))
    var endDate = new Date(parseInt(periodText.substring(24,28)), parseInt(periodText.substring(21,23))-1, parseInt(periodText.substring(18,20)))
    return {startDate: startDate, endDate: endDate};
}
    
function parseRow_RS(row) {
    if(row.number>4&&row.getCell(1).value) {
        var res = {}
        if (row.worksheet.name=="APD") {
            res.subAsset = ""
        } else {
            res.subAsset = row.getCell(9).value;
        }
        //res.docDate = row.getCell(4).value;
        res.bookDate = row.getCell(2).value;
        res.docNom = row.getCell(1).value
        res.countName = row.getCell(3).value
        //res.countID = row.getCell(10).value
        if (row.getCell(6).value!="") {
            res.opType = "DT"
        } else {
            res.opType = "CT"
        }
        res.accNo = row.getCell(8).value.replace(/\s+/g,"")
        if (row.worksheet.name=="APD") {
            res.accName = row.getCell(9).value;
        } else {
            res.accName = row.getCell(10).value;
        }
        res.docRef = row.getCell(5).value
        res.CCY = 'RSD'
        res.amtCCY = getAmt(row.getCell(7).value)-getAmt(row.getCell(6).value)
        //res.FX = row.getCell(3).value
        //res.amtFX = row.getCell(29).value
        res.docText = row.getCell(4).value
        return [res]
    } else {
        return []
    }
}

function getEntity_RS(sh) {
    if (!sh||sh.name=="Uctam") {
        return "A2716"
    } if (sh.name=="APD") {
        return "A2842"
    } else {
        return "UNKNOWN"
    }
}

/* UCTAM doo Slovenia*/
function getDate_A2588(sh) {
    // UCTAM - Einzelnachweis KORE_07.2019
    var startText = sh.getCell("F3").text
    var startDate = new Date(parseInt(startText.substring(0,4)), parseInt(startText.substring(4,6))-1, 1)
    var endText = sh.getCell("H3").text
    var endDate = new Date(parseInt(endText.substring(0,4)), parseInt(endText.substring(4,6)), 0)
    return {startDate: startDate, endDate: endDate};
}

function parseRow_A2588(row, init, repDate) {
    if(row.number>3&&row.getCell(3).value) {
        var res = (init)?init:{}
        var res2 = {}
        res.amtCCY = null
        if (row.getCell(1).value&&isNaN(row.getCell(1).value)&&(row.getCell(1).value.includes("Stroš. mesto:")||row.getCell(1).value.includes("Cost centre.:"))) {
            res.subAsset = row.getCell(2).value;
        } else {
            if((row.getCell(1).value) && !isNaN(row.getCell(1).value)) {
                res.accNo = row.getCell(1).value
                res.opType = "DT"
                res.accName = row.getCell(2).value
            } 
            if (!isNaN(row.getCell(8).value)&&!isNaN(row.getCell(14).value)) {
                //res.docDate = row.getCell(22).value;
                var dt = row.getCell(7).value
                if(isString(dt)) dt = dt.split("/")
                res.bookDate = new Date(parseInt(dt[0]),parseInt(dt[1])-1, parseInt(dt[2]));
                if (res.bookDate>repDate.endDate) res.bookDate=repDate.endDate
                res.docNom = row.getCell(5).value
                //res.accNoCT = row.getCell(8).value
                //res.countName = row.getCell(2).value
                //res.countID = row.getCell(18).value
                res.docRef = row.getCell(6).value
                res.CCY = 'EUR'
                res.amtCCY = -getAmt(row.getCell(14).value)
                res.FX = res.CCY
                res.amtFX = res.amtCCY
                res.docText = row.getCell(9).value
                res2 = Object.assign({}, res)
                res2.accNo = row.getCell(8).value
                res2.opType = "CT"
            }
        }
        return [res, res2]
    } else {
        init.amtCCY = null
        return [init]
    }
}

function getAmt(amt) {
    if (amt) {
        if (amt.sharedFormula||amt.formula) {amt = amt.result};
    } else {
        //amt=0
    }
    return amt
}

function fName_recognize(fName) {
    fName=fName.toLowerCase()
    console.log(fName)
    if (fName.substring(0,8)=="registru") {
        return {LE_Code: "A2643", fileType: "GL"}
    } else if ((fName.substring(0,27)=="uctam - einzelnachweis kore")||(fName.substring(0,4)=="kore")) {
        return {LE_Code: "A2588", fileType: "GL"}
    } else if (fName.substring(0,18)=="uctam_kpmg_pregled") {
        return {LE_Code: "RS", fileType: "GL"}
    } else if (fName.substring(0,15)=="uctam_kpmg_book") {
        return {LE_Code: "RS", fileType: "BV"}
    } else if (fName.substring(0,20)=="ambassador_kpmg_book") {
        return {LE_Code: "RS", fileType: "BV"}
    } else if (fName.substring(0,22)=="cost monitoring by cee") {
        return {LE_Code: "HU", fileType: "GL"}
    } else if ((fName.substring(0,14)=="general ledger")||(fName.substring(0,18)=="sst_general ledger")) {
        return {LE_Code: "A3234", fileType: "GL"}
    } else if ((fName.substring(0,13)=="trial balance")||(fName.substring(0,17)=="sst_trial balance")) {
        return {LE_Code: "A3234", fileType: "TB"}
    } else if ((fName.substring(0,9)=="ucm_deník")||(fName.substring(0,18)=="ucm_general_ledger")) {
        return {LE_Code: "A2769", fileType: "GL"}
    } else if (fName.substring(0,16)=="uctamsvk_journal") {
        return {LE_Code: "A3163", fileType: "GL"}
    } else if (fName.substring(0,17)=="detalji knjiženja") {
        return {LE_Code: "A3214", fileType: "GL"}
    } else if (fName.substring(0,13)=="kartice konta") {
        return {LE_Code: "A3214", fileType: "TB"}
    } else if (fName.substring(0,4)=="mis ") {
        return {LE_Code: "A2736", fileType: "GL"}
    } else if (fName.includes("uctam report")) {
        return {LE_Code: "A2572", fileType: "GL"}
    } else if (fName.substring(0,9)=="expenses ") {
        return {LE_Code: "A2604", fileType: "GL"}
    } else {
        return {LE_Code: null, fileType: "SST"}
    }
}

module.exports = {
    import_gl: import_gl,
    fName_recognize: fName_recognize
}
/*
console.log(fName_recognize("Mis 07.2019_sent.xlsx"))
console.log(fName_recognize("Detalji knjiženja_glavna knjiga-01.01.-31.07."))
console.log(fName_recognize("UCM_Deník_3172019"))
console.log(fName_recognize("UCTAMSVK_Journal_01-07_2019"))
console.log(fName_recognize("General ledger 07-2019"))
console.log(fName_recognize("Cost monitoring by CEE _31072019"))
console.log(fName_recognize("Registru jurnal UCTAM 07-2019"))
console.log(fName_recognize("07 UCTAM report Jul 2019 (management)"))
console.log(fName_recognize("Uctam_KPMG_Pregled prihoda i rashoda 07.2019"))
console.log(fName_recognize("UCTAM - Einzelnachweis KORE_07.2019"))
console.log(fName_recognize("Expenses 01012019-31072019"))
*/
function isString(v) {
    if(((typeof v) == "string") || (v instanceof String)) {
        return true
    } else {
        return false
    }
}