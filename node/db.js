var config = require('./config')
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
    connection.query("select * from rep_" + req.params.queryName).then(rs=> {
        var t = "<table><tr>"
        Object.keys(rs[0]).forEach(function(key,value) {t+= "<th>"+key+"</th>"})
        t += '</tr>'
        rs.forEach(function(r) {t += '<tr>';Object.values(r).forEach(function(key, value){t += "<td class=\"" + typeof(key) + "\">"+ ((typeof(key)=='number')?String(key).replace(".",","):key)+"</td>"}); t += '</tr>'})
        t += '</table>'
        res.status(200).send(toHTML(t))
    })
    .catch(err=>{
        console.log(err)
        res.status(400).send(toHTML(err.toString()))
    })
});

app.get('/', (req, res) => {
    var userName = req.connection.user
    connection.query("select * from Users where UserName = '" + userName + "'").then(
        rs=>{
            var out =""
            if (rs.length>0) {
              var fullname = rs[0].FullName
              out += "<p>Welcome " + fullname + "!"
              out += "<p>The following reports are available for you in the SST:"
              connection.query("select * from Reports").then(
                reps=> {
                  out += "<ul>"
                  reps.forEach(function(rep){out += "<li><a href='/reports/" + rep.Report_Query.replace("rep_","") + "'>" + rep.Report_Name + "</a>"})
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

function toHTML(innerHTML) {
  out = "<html><head><title>UCTAM SST</title><link rel=\"stylesheet\" href=\"/css/sst.css\"></head><body>"
  out += innerHTML
  out += "</body></html>"
  return out
}
app.listen(3000, () => console.log('Example app listening on port 3000!'))