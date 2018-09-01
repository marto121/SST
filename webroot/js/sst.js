function myFunc() {
    var i = 1001.1
    alert (i.toLocaleString())
    var d = new Date()
    alert (d.toLocaleDateString())
}

function formatValue(dataTypeID, value) {
    switch(dataTypeID) {
      case 1082: // Date
        var d = new Date(Date.parse(value))
        return d.toLocaleDateString()
        break;
      case 701, 701: // Float
        var f = parseFloat(value)
        return isNaN(f)?"":Math.round(f).toLocaleString()
        break;
      default:
        return value;
    }
  }

function refreshReports()
{
    $.ajax({
        type: "GET",
        url: "menu/lstReports",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (lstReports) {
            $("#tbReports").empty()
            setTimeout(function(){
                $.each(lstReports, function (index, obj) { 
                    var row = '<tr><td class=\"report\"><button onclick=\"javascript:showReport(\''+obj.repLink+'\')\">' + obj.repName + '</button></td></tr>'
                    $("#tbReports").append(row);
                });
                $("#tbReports").append("<tr><td><button onclick=\"javascript:myFunc()\">runScript</button></td></tr>");
            }, 500)
        },
        error: function (request, status, error) {
            $("#tbReports").append("<tr><td class=\"error\"><b>An error occured:</b><br>"+request.responseText+"</td></tr>");
        }
    });
}

function showReport(url) {
    $("#tbResult").empty()
    $("#tbResult").append("<tr><td>Working...</td><tr>")
    $.ajax({
        type: "GET",
        url: url,
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (report) {
            $("#tbResult").empty()
            var tHead = "<tr>"
            $.each(report.fields, function(index, field){
                tHead += "<th>" + field.fieldName + "</th>"
            })
            tHead += "</tr>"
            $("#tbResult").append(tHead)
            $.each(report.rows, function (index, row) { 
                var tRow = "<tr>"
                $.each(row, function (index, value) {
                    tRow += "<td class=\""+typeof(value)+"\">" + formatValue(report.fields[index].dataTypeID, value) + "</td>"
                })
                tRow += "</tr>"
                $("#tbResult").append(tRow);
            }); 
        },
        error: function (request, status, error) {
            $("#tbResult").empty()
            $("#tbResult").append("<tr><td class=\"error\"><b>An error occured:</b><br>"+request.responseText+"</td></tr>");
        }
    });
}
