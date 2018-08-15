var Excel = require('exceljs');
var workbook = new Excel.Workbook();

workbook.xlsx.readFile('C:\\Users\\Marti\\Documents\\UCTAM\\TestDatenImportRomania UPDATED 06.11.2017(1).xlsx')
    .then(function() {
        var worksheet = workbook.getWorksheet('Sales_Data_new');
        console.log(worksheet)
        var row = worksheet.getRow(5);
        row.getCell(1).value = 5; // A5's value set to 5
        row.commit();
        return workbook.xlsx.writeFile('new.xlsx');
    })