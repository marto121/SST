'use strict'

var config = require('./config')
const db = require('./db')
const utils = require('./utils');

const fs = require('fs');
const constants = require('./constants');

const express = require('express')
const fileUpload = require('express-fileupload');
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
app.use(fileUpload());

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
  var filter = ""
  Object.keys(req.query).forEach(function(key,index) {
    filter += " and cast(\"" + key + "\" as varchar) like '" + req.query[key] + "'"
  })
  console.log(filter)
  db.query("select * from rep_" + req.params.queryName + " where (le_id=-1 or le_id in (select le_id from users where username=\'"+ req.connection.user  +"\'))" + filter).then(rs=> {
//  db.query("select * from rep_" + req.params.queryName + " where le_id in (select le_id from users where username=\'"+ req.connection.user  +"\')").then(rs=> {
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
  if(!obj_ID.q_ID) obj_ID.q_ID=null
  return db.query("select u_web.role from mail_log ml join users u_send on lower(u_send.email)=lower(sender) join users u_web on u_web.le_id=u_send.le_id left join file_log fl on fl.m_id=ml.id left join mail_queue mq on mq.m_id=ml.id where ml.id=coalesce($1, ml.id) and coalesce(fl.id,-1)=coalesce($2, coalesce(fl.id,-1)) and coalesce(mq.id,-1)=coalesce($3, coalesce(mq.id,-1)) and u_web.username=$4",[obj_ID.m_ID, obj_ID.f_ID, obj_ID.q_ID, userName])
  .then(qry=>{
    if (qry.rows.length>0){
//      console.log(qry.rows)
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
//    console.log(role)
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

app.get('/downloadOut/:file_id', (req,res) => {
  var userName = req.connection.user;
  var q_ID = req.params.file_id.split("_")[0];
  var f_No = req.params.file_id.split("_")[1];
  getRole({q_ID: q_ID}, userName)
  .then(role=>{
    if((!role) | (role==-1)) {
      throw new HTTPError(401, "You are not authorized to download files from queue with id {" + q_ID + "}!")
    }
  })
  .then(()=>{
    return db.query("select mattachments from mail_queue where id=$1",[q_ID])
    .then(qry=>{
      if (qry.rows.length>0) {
        const file = qry.rows[0].mattachments.split(";")[f_No];
        res.download(file); // Set disposition and send it.
      } else {
        throw new HTTPError(400, "Queue with id {" + q_ID + "} not found!")
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
        sHTML += "<tr><th>Answer</th><td colspan='4'><a href=\"javascript:showAnswer(" + m_ID + ");\">View answer</a></td></tr>"
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

app.get('/answer/:m_id', (req,res) => {
  var userName = req.connection.user;
  var m_ID = req.params.m_id;
  getRole({m_ID: m_ID}, userName)
  .then(role=>{
    if((!role) | (role==-1)) {
      throw new HTTPError(401, "You are not authorized to view answer for message with id {" + m_ID + "}!")
    }
  })
  .then(()=>{
    return db.query("select id, mrecipients, mcc, msubject, mbody, mattachments, mstatus, mdate, m_id from mail_queue where m_id=$1",[m_ID])
    .then(qry=>{
      if(qry.rows.length>0){
        var sHTML = "<div id=\"accordion\">"
        var r=0;
        qry.rows.forEach(mail_data=>{
          r++
          sHTML += "<h3>" + ((qry.rows.length>1) ? " (" + r + " of " + qry.rows.length + ") ":"") + mail_data.msubject + "</h3>"
          sHTML += "<div><table cellspacing='0' cellpadding='1' border='1'>"
          sHTML += "<tr><th>Original mail</th><td colspan='4'><a href=\"javascript:showMail(" + m_ID + ");\">View original mail</a></td></tr>"
          if (mail_data.mrecipients) {
            sHTML += "<tr><th>Recipients</th><td colspan='4'>"+mail_data.mrecipients+"</td></tr>"
          }
          if (mail_data.mcc) {
            sHTML += "<tr><th>CC</th><td colspan='4'>"+mail_data.mcc+"</td></tr>"
          }
          if (mail_data.msubject) {
            sHTML += "<tr><th>Subject</th><td colspan='4'>"+mail_data.msubject+"</td></tr>"
          }
          if (mail_data.mbody) {
            sHTML += "<tr><th>Body</th><td colspan='4'>"+mail_data.mbody+"</td></tr>"
          }
          if (mail_data.mattachments) {
            sHTML += "<tr><th>Attachments</th><td colspan='4'>"
            mail_data.mattachments.split(";").forEach(att=>{
              var a=0
              if (att.trim()!="") {
                sHTML+= "<a href=\"/downloadOut/"+mail_data.id+"_"+a+"\">" + att.split(/[\\]+/).pop() + "</a>"
                a++
              }
            })
            sHTML += "</td></tr>"
          }
          sHTML += "</table></div>"
        })
        sHTML += "</div>"
        res.status(200).send(sHTML)
      } else {
        throw new HTTPError(400, "No answer found for mail with id {" + m_ID + "}!")
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

app.post('/fileUpload', (req, res) => {
  var userName = req.connection.user
  if (Object.keys(req.files).length == 0) {
    return res.status(400).send('No files were uploaded.');
  }
  //console.log(JSON.stringify(req))
//  console.log(req.body);
//  console.log(req.files);

  var uploadedFile = req.files.uploadingFile;
  
  db.query("insert into mail_log (sender, receiver, subject, body, mailstatus, authStatus) select max(email), $2, $3, $4, $5, $6 from users where username = $1 returning id", [userName, "uctam_sst@unicredit.eu", "Web file upload " + uploadedFile.name, "Web file upload " + uploadedFile.name, constants.statusReceived, /*authStatus*/ 1])
  .then(res => {
    var m_ID = -1
    if (res.rowCount)
        m_ID = res.rows[0].id
    else {
      db.log("fileUpload", "New file uploaded by " + userName + ": " + uploadedFile.name + ". Starting processing.", constants.tLog, m_ID)
      throw new Error("User " + userName + " not registered in SST!")
    }
    db.log("fileUpload", "New file uploaded by " + userName + ": " + uploadedFile.name + ". Starting processing.", constants.tLog, m_ID)
    return m_ID
  })
  .then(m_ID => {
    return new Promise((resolve,reject) => { 
      var ret = {
        m_ID: m_ID,
        fileType: uploadedFile.name.substring(0,3).toUpperCase(),
        NPE_Code: uploadedFile.name.substring(3,11),
        fStatus: constants.statusReceived
      }
      if (uploadedFile.name.substring(0,3).toLowerCase()=="bc_"||uploadedFile.name.substring(0,3).toLowerCase()=="ec_") {
          return db.query("select ID from NPE_List where m_ID=-1 and NPE_Code=$1",[NPE_Code])
          .then(rsNPE=>{
            if (rsNPE.rowCount==0) {
                db.log("fileUpload", "Uploaded file " + uploadedFile.name + " looks like a " + ret.fileType.substring(0,2) + ", but the NPE_Code is not recognized. Please name the file \'" + ret.fileType + "_[NPE_Code]\'.", constants.tWar, m_ID)
                ret.NPE_Code = ""
            } else {
                db.log("fileUpload", "Uploaded file " + uploadedFile.name + " recognized as " + ret.fileType.substring(0,2) + " for NPE_Code " + ret.NPE_Code + " and stored.", constants.tWar, m_ID)
            }
            ret.fStatus = constants.statusProcessed
            resolve(ret)
          })
      } else if (uploadedFile.name.split('.').pop().toLowerCase().substring(0,2) == "xl"){
          ret.fileType = "SST"
          ret.NPE_Code = ""
      } else {
          const fileExt = uploadedFile.name.split('.').pop().toLowerCase();
          // Disregard pics
          if (fileExt != 'png' && fileExt != 'gif' && fileExt != 'jpg') 
              db.log("fileUpload", "Uploaded file " + uploadedFile.name + " is not an Excel file (*.xl*), Business case (BC_*) or Exit Calculation (EC_*). Skipping ...", constants.tWar, m_ID)
          ret.fStatus = constants.statusProcessed
      }
      resolve(ret)
    })
  })
  .then(ret=>{
    ret.targetFileName =  utils.pad(ret.m_ID, 4) + "_" + uploadedFile.name;
    return uploadedFile.mv(config.SST_Att_Path + "\\" + ret.targetFileName)
    .then(()=>{return ret})
    .catch(e=>{
      db.log("fileUpload", "Error saving file " + config.SST_Att_Path + "\\" + ret.targetFileName + ": " + e.message, constants.tWar, ret.m_ID)
      res.status(500).send(("Error saving file " + config.SST_Att_Path + "\\" + ret.targetFileName + ": " + e.message).padEnd(513," "))
    })
  })
  .then(ret=>{
      return db.query("insert into file_log (m_ID, fileName, filestatus, fileType, NPE_ID) values ($1, $2, $3, $4, $5)", [ret.m_ID, config.SST_Att_Path + "\\" + ret.targetFileName, ret.fStatus, ret.fileType, ret.NPE_Code])
      .then(()=>{return ret})
  })
  .then(ret=>{
    res.status(200).send("<span>File upload successful!</span> <a href=\"javascript:showLog("+ret.m_ID+")\">(view log)</a>")
  })
  .catch (err=>{
    db.log("fileUpload", "Error uploading file: "+err.toString(), constants.tSys, -1);
    res.status(500).send(("Error uploading file: "+err.toString()).padEnd(513," "))
  })

  
/*  
  var targetPath = './uploads/' + uploadedFile.name;




  fs.rename(tmpPath, targetPath, function(err) {
  if (err) throw err;
  fs.unlink(tmpPath, function() {
      if (err) throw err;
          res.send('File Uploaded to ' + targetPath + ' - ' + uploadedFile.size + ' bytes');
      });
  });
*/

});

function toHTML(innerHTML) {
  var out = "<!DOCTYPE html><html lang=\"en\"><head><title>UCTAM SST</title><META http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><link rel=\"stylesheet\" href=\"/css/sst.css\"></head><body>"
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