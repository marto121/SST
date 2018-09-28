if(typeof require !== 'undefined') XLSX = require('xlsx');
//var wb = XLSX.readFile("C:\\Users\\Marti\\Documents\\UCTAM\\TestDatenImportRomania UPDATED 06.11.2017(1).xlsx",{cellStyles:true});
//console.log(wb.Sheets["Sales_Data_new"].A1)

//XLSX.writeFile(wb,"c:\\MyPrograms\\test.xlsx")

var templateFileName="C:\\Users\\Marti\\Documents\\UCTAM\\TestDatenImportRomania UPDATED 06.11.2017(1).xlsx"
var Excel = require('exceljs');
var db = require('./db');
db.query("select * from calendar ").then(res=>{
    console.log(res.rows[0])
    console.log(res.rows[0].rep_date==res.rows[0].rep_date)
})

/*var wb = new Excel.Workbook();
var fs = require('fs')
console.log(process.env)
if (fs.existsSync(templateFileName)) {
    wb.xlsx.readFile(templateFileName).then(res=>{
        console.log ("OK")
        sh = wb.getWorksheet("Sales_Data_new")
        console.log(sh.getCell("A1"))
    })
}
*/