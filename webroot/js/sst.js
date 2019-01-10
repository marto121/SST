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

function init () {
    $.each(listNames, function (index, obj) {
        fillList(obj);
    })
}
function fillList(list_name){
    lists[list_name]=[];
    $.ajax({
        type: "GET",
        url: "reportsJSON/"+list_name,
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (lst) {
            $.each(lst.rows, function (index, obj) {
                lists[list_name].push(obj[0]);
            })
        },
        error: function (request, status, error) {
            $("#tbReports").append("<tr><td class=\"error\"><b>An error occured:</b><br>"+request.responseText+"</td></tr>");
        }
    });
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
//                    row += '<button onclick=\"javascript:showReportDT(\''+obj.repLink+'\')\">' + obj.repName + '</button></br>'
                    row += '<button onclick=\"javascript:generateForm(\''+encodeURIComponent(JSON.stringify(obj))+'\')\">' + obj.repName + '</button></br>'
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

function generateForm(objText) {
    var objRep = JSON.parse(decodeURIComponent(objText));
    if (objRep.repFilters) {
        var html = "<tr><td><div class=\"filters\" id=\"filters\"><b>The following parameters are available:</b><br>"
        $.each(objRep.repFilters, function (index, obj) {
            switch (obj.filter_type) {
                case "npes":
                    html += "<div class=\"filter_element\">"+obj.filter_text+"<div class=\"autocomplete\"> <input id=\"" + obj.filter_type + "\" type=\"text\" name=\"" + encodeURIComponent(obj.filter_column) + "\" placeholder=\"" + obj.filter_column + "\"></input></div></div>"
                    break;
                case "periods":
                    html += "<div class =\"filter_element\">"+obj.filter_text+"<select name=\"" + encodeURIComponent(obj.filter_column) + "\">"
                    $.each(lists["periods"], function(index, obj) {
                        html+= "<option value=\"" + obj + "\">" + obj + "</option>"
                    });
                    html += "<option value=\"\">All</option></select></div>"
                    break;
                default:
                    html += "<div class=\"filter_"+obj.filter_type+"\"></div>"
            }
        })
        html += "<p><button onclick=\"javascript:showReportDT(\'" + objRep.repLink + "\')\">Run</button>"
        html += "</div></td></tr>"
        if ( $.fn.dataTable.isDataTable( '#tbResult' ) ) {
            $('#tbResult').DataTable().destroy();
        }
        $("#tbResult").empty()
        $("#tbResult").append(html)
        $.each(listNames, function (index, obj) {
            if (document.getElementById(obj)) {
                autocomplete(document.getElementById(obj),lists[obj]);
            }
        });
    } else {
        showReportDT(objRep.repLink);
    }
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
    var query=""
    var inputs = $("#filters :input")
    $.each(inputs,function(idex, obj) {
        if(obj.type!='submit'&&obj.value!="") {
            query += ((query=="")?"":"&") + obj.name + "=" + encodeURIComponent(obj.value.split(" - ")[0]);
        }
    })
    if ( $.fn.dataTable.isDataTable( '#tbResult' ) ) {
        $('#tbResult').DataTable().destroy();
    }
    $("#tbResult").empty()
    $("#tbResult").append("<tr><td>Working...</td><tr>")
    $.ajax({
        type: "GET",
        url: url,
        data: query,
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


function autocomplete(inp, arr) {
    /*the autocomplete function takes two arguments,
    the text field element and an array of possible autocompleted values:*/
    var currentFocus;
    /*execute a function when someone writes in the text field:*/
    inp.addEventListener("input", function(e) {
        var a, b, i, val = this.value;
        /*close any already open lists of autocompleted values*/
        closeAllLists();
        if (!val) { return false;}
        currentFocus = -1;
        /*create a DIV element that will contain the items (values):*/
        a = document.createElement("DIV");
        a.setAttribute("id", this.id + "autocomplete-list");
        a.setAttribute("class", "autocomplete-items");
        /*append the DIV element as a child of the autocomplete container:*/
        this.parentNode.appendChild(a);
        /*for each item in the array...*/
        for (i = 0; i < arr.length; i++) {
          /*check if the item starts with the same letters as the text field value:*/
          if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
            /*create a DIV element for each matching element:*/
            b = document.createElement("DIV");
            /*make the matching letters bold:*/
            b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
            b.innerHTML += arr[i].substr(val.length);
            /*insert a input field that will hold the current array item's value:*/
            b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
            /*execute a function when someone clicks on the item value (DIV element):*/
                b.addEventListener("click", function(e) {
                /*insert the value for the autocomplete text field:*/
                inp.value = this.getElementsByTagName("input")[0].value;
                /*close the list of autocompleted values,
                (or any other open lists of autocompleted values:*/
                closeAllLists();
            });
            a.appendChild(b);
          }
        }
    });
    /*execute a function presses a key on the keyboard:*/
    inp.addEventListener("keydown", function(e) {
        var x = document.getElementById(this.id + "autocomplete-list");
        if (x) x = x.getElementsByTagName("div");
        if (e.keyCode == 40) {
          /*If the arrow DOWN key is pressed,
          increase the currentFocus variable:*/
          currentFocus++;
          /*and and make the current item more visible:*/
          addActive(x);
        } else if (e.keyCode == 38) { //up
          /*If the arrow UP key is pressed,
          decrease the currentFocus variable:*/
          currentFocus--;
          /*and and make the current item more visible:*/
          addActive(x);
        } else if (e.keyCode == 13) {
          /*If the ENTER key is pressed, prevent the form from being submitted,*/
          e.preventDefault();
          if (currentFocus > -1) {
            /*and simulate a click on the "active" item:*/
            if (x) x[currentFocus].click();
          }
        }
    });
    function addActive(x) {
      /*a function to classify an item as "active":*/
      if (!x) return false;
      /*start by removing the "active" class on all items:*/
      removeActive(x);
      if (currentFocus >= x.length) currentFocus = 0;
      if (currentFocus < 0) currentFocus = (x.length - 1);
      /*add class "autocomplete-active":*/
      x[currentFocus].classList.add("autocomplete-active");
    }
    function removeActive(x) {
      /*a function to remove the "active" class from all autocomplete items:*/
      for (var i = 0; i < x.length; i++) {
        x[i].classList.remove("autocomplete-active");
      }
    }
    function closeAllLists(elmnt) {
      /*close all autocomplete lists in the document,
      except the one passed as an argument:*/
      var x = document.getElementsByClassName("autocomplete-items");
      for (var i = 0; i < x.length; i++) {
        if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
   document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
  }

var listNames = ["npes","periods"]
var lists = {}
window.onload = init