'use strict'

var config = require('./config')
const db = require('./db')
const fs = require('fs');

const express = require('express')
const https = require('https')
const app = express()

const STATUS_CODES = require('http').STATUS_CODES;


class HTTPError extends Error {
  constructor(code, message, extras) {
    super(message || STATUS_CODES[code]);
    if (arguments.length >= 3 && extras) {
      Object.assign(this, extras);
    }
    this.name = toName(code);
    this.statusCode = code;
  }
}
function toName (code) {
  const suffix = (code / 100 | 0) === 4 || (code / 100 | 0) === 5 ? 'error' : '';
  return (String(STATUS_CODES[code]).replace(/error$/i, ''), suffix);
}

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
  console.log(req.query)
  console.log(req.headers["accept-language"] )
  var lang = req.headers["accept-language"]
  var filter = ""
  Object.keys(req.query).forEach(function(key,index) {
    filter += " and cast(\"" + key + "\" as varchar) like '" + req.query[key] + "'"
  })
  console.log(filter)
  db.query("select * from rep_" + req.params.queryName + " where (le_id=-1 or le_id in (select le_id from users where username=\'"+ req.connection.user  +"\'))" + filter).then(rs=> {
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

app.get('/--no-way--', (req, res) => {
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

async function getRole(obj_ID, userName) {
  if(!obj_ID.m_ID) obj_ID.m_ID=null
  if(!obj_ID.f_ID) obj_ID.f_ID=null
  return db.query("select u_web.role from mail_log ml join users u_send on lower(u_send.email)=lower(sender) join users u_web on u_web.le_id=u_send.le_id left join file_log fl on fl.m_id=ml.id where ml.id=coalesce($1, ml.id) and coalesce(fl.id,-1)=coalesce($2, coalesce(fl.id,-1)) and u_web.username=$3",[obj_ID.m_ID, obj_ID.f_ID, userName])
  .then(qry=>{
    if (qry.rows.length>0){
      console.log(qry.rows)
      return qry.rows[0].role;
    } else {
      return -1;
    }
  })
}

app.get('/log/:m_id', (req,res) => {
  var userName = req.connection.user;
  var m_ID = req.params.m_id;
  getRole({m_ID: m_ID}, userName)
  .then(role=>{
    console.log(role)
    if((!role) | (role==-1)) {
      res.status(401).send("You are not authorized to view this log!")
    } else {
      var tBody = ""
      db.query("select to_char(log_date,'DD.MM.YYYY HH24:MI:SS') as log_date,log_text,nom_log_types.color from SST_Log inner join nom_log_types on nom_log_types.id=sst_log.log_type where Mail_ID=$1 order by sst_log.id",[m_ID])
      .then(qry=>{
        for (const row of qry.rows ) {
          tBody += "<tr bgcolor='" + row.color + "'><td>" + row.log_date + "</td><td>" + row.log_text + "</td></tr>"
        }
        var sHTML = "<table cellspacing='0' cellpadding='1' border='1'>"
        +"<thead><th>Date</th><th>Message</th></thead>"
        + tBody + "</table>"
        res.status(200).send(sHTML)
      })
      .catch(err=>{
        console.log(err)
        res.status(400).send(err.toString())
      })
    }
  })
})

app.get('/download/:file_id', (req,res) => {
  var userName = req.connection.user;
  var f_ID = req.params.file_id;
  getRole({f_ID: f_ID}, userName)
  .then(role=>{
    if((!role) | (role==-1)) {
      throw new HTTPError(401, "You are not authorized to download file with id {" + f_ID + "}!")
    }
  })
  .then(()=>{
    return db.query("select filename from file_log where id=$1",[f_ID])
    .then(qry=>{
      if (qry.rows.length>0) {
        const file = qry.rows[0].filename;
        res.download(file); // Set disposition and send it.
      } else {
        throw new HTTPError(400, "File with id {" + f_ID + "} not found!")
      }
    })
  })
  .catch(err=>{
    console.log(err)
    if (err instanceof HTTPError)
      res.status(err.statusCode).send(err.message.padEnd(513," "))
    else
      res.status(500).send(err.toString().padEnd(513," "))
  })
})

app.get('/mail/:m_id', (req,res) => {
  var userName = req.connection.user;
  var m_ID = req.params.m_id;
  getRole({m_ID: m_ID}, userName)
  .then(role=>{
    if((!role) | (role==-1)) {
      throw new HTTPError(401, "You are not authorized to view message with id {" + m_ID + "}!")
    }
  })
  .then(()=>{
    return db.query("select sender, receiver, subject, mailstatus, authstatus, answertext, answerrecipients, body from mail_log where id=$1",[m_ID])
    .then(qry=>{
      if(qry.rows.length>0){
        var sHTML = "<table cellspacing='0' cellpadding='1' border='1'>"
        var mail_data = qry.rows[0];
        sHTML += "<tr><th>Log</th><td colspan='4'><a href=\"javascript:showLog(" + m_ID + ");\">View log</a></td></tr>"
        if (mail_data.sender) {
          sHTML += "<tr><th>Sender</th><td colspan='4'>"+mail_data.sender+"</td></tr>"
        }
        if (mail_data.receiver) {
          sHTML += "<tr><th>Recipients</th><td colspan='4'>"+mail_data.receiver+"</td></tr>"
        }
        if (mail_data.subject) {
          sHTML += "<tr><th>Subject</th><td colspan='4'>"+mail_data.subject+"</td></tr>"
        }
        if (mail_data.body) {
          sHTML += "<tr><th>Body</th><td colspan='4'>"+mail_data.body+"...</td></tr>"
        }
        return sHTML
      } else {
        throw new HTTPError(400, "Mail with id {" + m_ID + "} not found!")
      }
    })
  })
  .then(sHTML=>{
    return db.query("select id, filename, reple, to_char(repdate,'DD.MM.YYYY') repdate, filetype from file_log where m_id=$1 order by id",[m_ID])
    .then(qry=>{
      var attNo = 0;
      if (qry.rows.length>0) {
        sHTML += "<tr><th>Attachments</th><th>File</th><th>LE</th><th>Rep Date</th><th>File Type</th></tr>"
      }
      for (const row of qry.rows ) {
        attNo++;
        sHTML += "<tr><td>Attachment " + attNo + "</td><td><a href=\"/download/"+row.id+"\">" + row.filename.split(/[\\]+/).pop() + "</a></td><td>" + row.reple + "</td><td>" + row.repdate + "</td><td>" + row.filetype + "</td></tr>"
      }
      sHTML += "</table>"
      res.status(200).send(sHTML)
    })
  })
  .catch(err=>{
    console.log(err)
    if (err instanceof HTTPError)
      res.status(err.statusCode).send(err.message.padEnd(513," "))
    else
      res.status(500).send(err.toString().padEnd(513," "))
  })
})

app.get('/menu/lstReports', (req, res) => {
  var userName = req.connection.user
  var lstReports=[]
  db.query("select report_name, report_query, report_group, report_order, report_filters from get_user_reports(\'" + userName + "\') order by report_group, report_order").then(
    reps=> {
      reps.rows.forEach(function (rep) {
        lstReports.push({repLink:"/reportsJSON/" + rep.report_query.replace("rep_",""),repName:rep.report_name,repGroup:rep.report_group,repOrder:rep.report_order,repFilters:JSON.parse(rep.report_filters)})
      })
      res.status(200).send(JSON.stringify(lstReports))
    }
  ).catch(err=>{
    console.log(err)
    res.status(400).send(err.toString())
})

})

function toHTML(innerHTML) {
  var out = "<html><head><title>UCTAM SST</title><link rel=\"stylesheet\" href=\"/css/sst.css\"></head><body>"
  out += innerHTML
  out += "</body></html>"
  return out
}

if (config.web_privatekey) {
var privateKey = fs.readFileSync( config.web_privatekey );
var certificate = fs.readFileSync( config.web_cert );

https.createServer({
    key: privateKey,
    cert: certificate,
    passphrase: config.web_privatepass
}, app).listen(config.web_port, () => console.log('SST Web app listening on port '+config.web_port+'!'));
} else {
  app.listen(3000, () => console.log('Example app listening on port 3000!'))
}

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