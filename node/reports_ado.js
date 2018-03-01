'use strict';

var constants = require('./constants')
var fs = require('fs')
var config = require('./config')

const ADODB = require('node-adodb');
const connection = ADODB.open('Provider=Microsoft.ACE.OLEDB.12.0;Data source='+config.SST_DB_Path+';');

connection.schema(4,Array(null, null, "USers")).then(res=>console.log(res))

async function report(report_id) {

}

async function gen_report(report_id, m_ID) {
    const reports = await connection.query ('select * from lst_reports where id='+report_id)
    if (reports.length==0) {
        console.log('createReport', 'Report with id: ' + report_id + ' does not exist', constants.tErr, m_ID)
        return
    }
    const report_code = reports[0].Report_Code

    const report_sheets = await connection.query ('select * from lst_sheets where report_id='+reports[0].ID)
    if (report_sheets==0) {
        console.log('createReport', 'Report with id: ' + report_id + ' has no defined sheets', constants.tErr, m_ID)
        return
    }
    
    var excel = require('excel4node');
    var wb = new excel.Workbook();

    var styleTitle = wb.createStyle({
        font: {
          bold: true
        }
      });
      var styleNumber = wb.createStyle({
        numberFormat: '#,##0;[Red]#,##0); -'
      });
      var styleDate = wb.createStyle({
        numberFormat: 'dd.mm.yyyy'
      });
      
    console.log ('createReport', 'Creating report "' + report_code + '"', constants.tLog, m_ID)
    for (var s in report_sheets) {
        console.log ('createReport', 'Processing sheet "' + report_sheets[s]['Sheet_Name'] + '"', constants.tLog, m_ID)
        var sh = wb.addWorksheet(report_sheets[s]['Sheet_Name'])
        var sq = report_sheets[s]['Sheet_Query']
        if (sq) {
            const report_data = await connection.query ('select * from ' + sq)
            //console.log(report_data)
            var row=1;
            var fields = report_data[0];
            for (var r in report_data) {
                row++;
                var col = 1
                for (var key in report_data[r]) {
                    if (row==2) {
                        sh.cell(1,col).string(key).style(styleTitle);
                    }
                    var v = report_data[r][key]
                    //console.log(v, typeof(v))
                    if(v){
                        if(fields[key]=='Number') {
                            sh.cell(row,col).number(v).style(styleNumber);
                        } else if(fields[key]=='Date') {
                            sh.cell(row,col).date(v).style(styleDate);
                        } else if(fields[key]=='Text') {
                            sh.cell(row,col).string(v);
                        }
                    }
                    col++;
                }
            }
        }
    }
    var fileName = config.SST_Att_Path_Out + '' + report_code + '_' + ("00000" + m_ID).slice(-6) + '_0000' + '.xlsx';
    for (var f=0; f<=9999; f++) {
        fileName = config.SST_Att_Path_Out + '' + report_code + '_' + ("00000" + m_ID).slice(-6) + '_' + ('000' + f).slice(-4) + '.xlsx';
        if (!fs.existsSync(fileName)) {
            break;
        }
    }
    console.log("Saving " + fileName)
    wb.write(fileName);
    console.log(new Date());
}
async function query() {
 try {
   const users = await connection.query('SELECT * FROM Users');

   console.log(users);
 } catch (error) {
   console.error(error);
 }
}

console.log(new Date())
gen_report('1',-1);
