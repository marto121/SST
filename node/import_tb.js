'use strict'
const db = require('./db')
const Excel = require('exceljs')
const XLSX = require('xlsx');

const parseOpts = {
    A2588: {shNames: ['Trial Balance'], dateFunc: getDate_A2588, parseFunc: parseRow_A2588},
    A3234: {shNames: ['TB 31.08.2018.'], dateFunc: getDate_A3234, parseFunc: parseRow_A3234},
    A2572: {shNames: ['PL - Details','Balance - details'], dateFunc: getDate_A2572, parseFunc: parseRow_A2572}

}
import_tb("J:\\UCTAMCEE\\CFO\\0002 Controlling\\Data received\\2018\\201808\\LV\\08_UCTAM report_31.08.2018.xlsx","A2572",-1)

/*
import_tb("J:\\UCTAMCEE\\CFO\\0002 Controlling\\Data received\\2018\\201808\\HR\\Trial balance on 31.08.2018..xlsx","A3234",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_06.2018.xlsb","A2588",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_05.2018.xlsb","A2588",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_04.2018.xlsb","A2588",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_03.2018 V4.xlsb","A2588",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_02.2018 V4.xlsb","A2588",-1)
import_tb("I:\\UCTAM_CFO\\COUNTRIES\\SI\\UCTAM - Einzelnachweis KORE_01.2018 V4.xlsb","A2588",-1)
*/
async function import_tb(fName, LE, m_ID) {
    if(fName.substring(fName.length-4).toLowerCase()=='.xlsb') {
        try {
            var workbook = XLSX.readFile(fName,{cellDates:true, cellStyles:true, cellNF:true});
            XLSX.writeFile(workbook, fName.substring(fName.length-4) + '.xlsx');
        } catch (e) {
            db.log ("Import", "Error parsing excel file \":" + fName + "\". The error is " + e.toString(),  constants.tSys, m_ID)
            return result;
        }
    }
    var wb = new Excel.Workbook();
    await wb.xlsx.readFile(fName)

    wb.name = fName;

    var sh=wb.getWorksheet(parseOpts[LE].shNames[0]);

    const Rep_Date = parseOpts[LE].dateFunc(sh)
    console.log(Rep_Date)

    await db.query("delete from trial_balance where rep_date=$1 and LE_ID = (select id from legal_entities where tagetik_code=$2)",[Rep_Date, LE])
    for (var shNo = 0; shNo<parseOpts[LE].shNames.length; shNo++) {
        sh=wb.getWorksheet(parseOpts[LE].shNames[shNo])
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
            var row = parseOpts[LE].parseFunc(sh.getRow(rowNum), Rep_Date);
            if (row)
            try {
                await db.query(
                    "insert into trial_balance as tb (le_id, rep_date, accNo, amt, m_ID) select id, $2, $3, $4 as amt, $5 from legal_entities where tagetik_code=$1"
                    +" on conflict (le_id, rep_date, accNo, m_ID) do update set amt = coalesce(tb.amt,0) + coalesce(excluded.amt,0)"
                    , [LE, Rep_Date, row.accNo, row.amt, m_ID]
                )
            } catch (e) {
                console.log(fName, rowNum, LE, Rep_Date, row, e.toString())
            }
        }
    }
    console.log("Loaded "+fName)
}

function parseRow_A2588(row) {
    if (/^\d+$/.test(row.values[1])) {
        return {accNo: row.values[1], amt: -parseFloat(row.values[4])}
    } else {
        return null;
    }
}

function parseRow_A3234(row) {
    if(row.number>1&&row.getCell(1).value&&!row.getCell(1).font.bold) {
        const dt = row.getCell(9).value?parseFloat(row.getCell(9).value):0;
        const ct = row.getCell(10).value?parseFloat(row.getCell(10).value):0;
        return {accNo: row.getCell(1).value, amt: ct-dt}
    }
}

function parseRow_A2572(row, rep_date) {
    if(row.number>1&&row.getCell(2).value!=null) {
        var begYear = new Date(rep_date.getTime())
        begYear.setMonth(0);
        begYear.setDate(0)
        const offset = (row.worksheet.name.substring(0,2)=="PL")?1:0;
        if (row.getCell(4+offset).value.getTime() > begYear.getTime()) {
            var amt = row.getCell(13+offset).value;
            if (amt) {
                if (amt.sharedFormula||amt.formula) {amt = amt.result};
            } else {amt=0}
            if(row.getCell(2).value.substring(0,4)=='6010')console.log(row.number,amt)
            return {accNo: row.getCell(2).value.substring(0,4) + '.' + row.getCell(3).value.substring(0,1), amt: amt}
        }
        else
            return null;
    }
}

function getDate_A2588(sh) {
    var cellValue = sh.getCell("B6");
    cellValue = cellValue.substring(cellValue.length-10)
    var pattern = /(\d{2})\.(\d{2})\.(\d{4})/;
    var dt = new Date(cellValue.replace(pattern,'$3-$2-$1'));
    return dt;
}
function getDate_A3234(sh) {
    var v = sh.name;
    v = v.substring(3,13)
    var pattern = /(\d{2})\.(\d{2})\.(\d{4})/;
    var dt = new Date(v.replace(pattern,'$3-$2-$1'));
    return dt;
}

function getDate_A2572(sh) {
    const thisDate = sh.workbook.name.substring(sh.workbook.name.length-15).substring(0,10)
    var pattern = /(\d{2})\.(\d{2})\.(\d{4})/;
    var dt = new Date(thisDate.replace(pattern,'$3-$2-$1'));
    return dt
}