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
                var oldGroup = '';
                var row = '<tr><td>';
                $.each(lstReports, function (index, obj) { 
                    if(obj.repGroup!=oldGroup) {
                        if (oldGroup!='') row += '</div></div>';
                        row += '<div class=\"repWrapper\"><h3>'+obj.repGroup+'</h2><div>';
                        oldGroup=obj.repGroup;
                    }
                    row += '<button onclick=\"javascript:showReportDT(\''+obj.repLink+'\')\">' + obj.repName + '</button></br>'
                });
                row += '</div></div></td></tr>'
                $("#tbReports").append(row);
                $('.repWrapper h3').click(function() { $(this).next().toggle();});
                //$("#tbReports").append("<tr><td><button onclick=\"javascript:myFunc()\">runScript</button></td></tr>");
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

function showReportDT(url) {
    if ( $.fn.dataTable.isDataTable( '#tbResult' ) ) {
        $('#tbResult').DataTable().destroy();
    }
    $("#tbResult").empty()
    $("#tbResult").append("<tr><td>Working...</td><tr>")

    $.ajax({
        type: "GET",
        url: url,
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            $("#tbResult").empty()
            var fields = result.fields;
            var columns = [];
            for (f in fields) {
                columns.push({title: fields[f].fieldName});
                switch(fields[f].dataTypeID) {
                    case 1082:
                    //columnDefs.push({targets: f, visible: false, render:function(data){return "aa";}});
                        columns[f].render = function(data){return formatValue(1082, data);};
                        break;
                    case 701:
                        columns[f].render = function(data){return formatValue(701, data);};
                        break;
                }
            }
            var rows = result.rows;

            $('#tbResult').DataTable({
                destroy: true,
                "dom": 'B<"top"iflp<"clear">>rt<"bottom"iflp<"clear">>',
                "fixedHeader": "true",
                "buttons": [{ extend:'copy', attr: { id: 'allan' } }, 'csv', 'excel', 'pdf'],
                data: rows,
                columns: columns,
                language: {decimal:"."}
            })
        },
        error: function (request, status, error) {
            $("#tbResult").empty()
            $("#tbResult").append("<tr><td class=\"error\"><b>An error occured:</b><br>"+request.responseText+"</td></tr>");
        }
    });
}
