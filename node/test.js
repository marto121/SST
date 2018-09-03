if(typeof require !== 'undefined') XLSX = require('xlsx');
//var wb = XLSX.readFile("C:\\Users\\Marti\\Documents\\UCTAM\\TestDatenImportRomania UPDATED 06.11.2017(1).xlsx",{cellStyles:true});
//console.log(wb.Sheets["Sales_Data_new"].A1)

//XLSX.writeFile(wb,"c:\\MyPrograms\\test.xlsx")

var templateFileName="C:\\Users\\Marti\\Documents\\UCTAM\\SST\\xlTest\\comment_in.xlsx"
var Excel = require('exceljs');
var wb = new Excel.Workbook();
var fs = require('fs')
if (fs.existsSync(templateFileName)) {
    wb.xlsx.readFile(templateFileName).then(res=>{

        res.worksheets
        res.worksheets.forEach(function(ws){
//            console.log(ws.getCell("A1"))
            if (ws.id == 1) {
                ws.getCell("B1").comment="My comment"
                //ws.getCell("B8").value="b"
                console.log(ws.getCell("B1").comment)
                console.log(ws.getCell("B8").comment)
                console.log(ws.getCell("A1").comment)
            //   console.log(ws.name)
                }
        })
        wb.xlsx.writeFile("C:\\Users\\Marti\\Documents\\UCTAM\\SST\\xlTest\\comment_out.xlsx")
            .then("aaaa")
            .catch(e=>{console.log(e.stack)})
    }).catch(err=>{console.log(err.stack)})
}
