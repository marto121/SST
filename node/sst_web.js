'use strict'

var config = require('./config')
const db = require('./db')
const ADODB = require('node-adodb');
const connection = ADODB.open('Provider=Microsoft.ACE.OLEDB.12.0;Data source=' + config.SST_DB_Path + ';');

const express = require('express')
const app = express()

app.use(express.static(config.SST_Root_Path))

app.use(function (req, res, next) {
    var nodeSSPI = require('node-sspi')
    var nodeSSPIObj = new nodeSSPI({
      retrieveGroups: true
    })
    nodeSSPIObj.authenticate(req, res, function(err){
      res.finished || next()
    })
  })
  app.use("/A", function(req, res, next) {
    var out =
      'Hello ' +
      req.connection.user +
      '! Your sid is ' +
      req.connection.userSid +
      ' and you belong to following groups:<br/><ul>'
    if (req.connection.userGroups) {
      for (var i in req.connection.userGroups) {
        out += '<li>' + req.connection.userGroups[i] + '</li><br/>\n'
      }
    }
    out += '</ul>'
    res.send((toHTML(out)))
  })

  app.get('/reports/:queryName', function (req, res, next) {
    console.log(req.params)
    console.log(req.headers["accept-language"] )
    var lang = req.headers["accept-language"]
    db.query("select * from rep_" + req.params.queryName + " where le_id in (select le_id from users where username=\'"+ req.connection.user  +"\')").then(rs=> {
        var t = "<table><tr>"
        rs.fields.forEach(function(Field) {if(Field.name!="le_id")t+= "<th>"+Field.name+"</th>"})
        t += '</tr>'
        rs.rows.forEach(function(row) {
          t += '<tr>';
          Object.keys(row).forEach(function(key,index){
              if(rs.fields[index].name!="le_id") t += "<td class=\"" + typeof(row[key]) + "\">"+ formatValue(rs.fields[index].dataTypeID, row[key]) + "</td>"
          })
          t += '</tr>'
        })
        t += '</table>'
        res.status(200).send(toHTML(t))
    })
    .catch(err=>{
        console.log(err)
        res.status(400).send(toHTML(err.toString()))
    })
});
app.get('/reportsJSON/:queryName', function (req, res, next) {
  console.log(req.params)
  console.log(req.headers["accept-language"] )
  var lang = req.headers["accept-language"]
  db.query("select * from rep_" + req.params.queryName + " where le_id in (select le_id from users where username=\'"+ req.connection.user  +"\')").then(rs=> {
    var aFields = []
      var aRows = []
      rs.fields.forEach(function(Field) {if(Field.name!="le_id")aFields.push({fieldName:Field.name, dataTypeID:Field.dataTypeID})})
      rs.rows.forEach(function(row) {
        var aRow = []
        Object.keys(row).forEach(function(key,index){
            if(rs.fields[index].name!="le_id")aRow.push(row[key])
        })
        aRows.push(aRow)
      })
      res.status(200).send(JSON.stringify({fields:aFields,rows:aRows}))
  })
  .catch(err=>{
      console.log(err)
      res.status(400).send(err.toString())
  })
});

app.get('/', (req, res) => {
    var userName = req.connection.user
    db.query("select * from Users where UserName = '" + userName + "'").then(
        rs=>{
            var out =""
            if (rs.rowCount>0) {
              var fullname = rs.rows[0].fullname
              out += "<p>Welcome " + fullname + "!"
              out += "<p>The following reports are available for you in the SST:"
              db.query("select * from Reports").then(
                reps=> {
                  out += "<ul>"
                  reps.rows.forEach(function(rep){out += "<li><a href='/reports/" + rep.report_query.replace("rep_","") + "'>" + rep.report_name + "</a>"})
                  out += "</ul>"
                  res.status(200).send(toHTML(out))
                }
              )
            } else {
              out += "Sorry " + userName + ", you are not registered in SST Reporting environment"
              res.status(200).send(toHTML(out))
            }
/*          var out = "<p>Welcome " + req.connection.user
                out+="<p><table><tr>"
                Object.keys(rs[0]).forEach(function(t){out+="<th>"+t+"</th>"})
                out+="</tr>"
                rs.forEach(function(r){
                    out+="<tr>"
                    Object.values(r).forEach(function(v){out+="<td>"+v+"</td>"})
                    out+="</tr>"
                })
                out+="</table>"
            res.send(out)*/
        }
    )
})


app.get('/menu/lstReports', (req, res) => {
  var userName = req.connection.user
  var lstReports=[]
  db.query("select * from Reports").then(
    reps=> {
      reps.rows.forEach(function (rep) {
        lstReports.push({repLink:"/reportsJSON/" + rep.report_query.replace("rep_",""),repName:rep.report_name})
      })
      res.status(200).send(JSON.stringify(lstReports))
    }
  )
})

function toHTML(innerHTML) {
  var out = "<html><head><title>UCTAM SST</title><link rel=\"stylesheet\" href=\"/css/sst.css\"></head><body>"
  out += innerHTML
  out += "</body></html>"
  return out
}
app.listen(3000, () => console.log('Example app listening on port 3000!'))

function formatValue(dataTypeID, value) {
  switch(dataTypeID) {
    case 1082: // Date
      var d = new Date(Date.parse(value))
      return '' + d.getDate() + '.' + (d.getMonth()+1) + '.' + d.getFullYear()
      break;
    case 701, 701: // Float
      var f = parseFloat(value)
      return isNaN(f)?"":Math.round(f)
      break;
    default:
      return value;
  }
}