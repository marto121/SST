var config = require('./config')
const ADODB = require('node-adodb');
const connection = ADODB.open('Provider=Microsoft.ACE.OLEDB.12.0;Data source=' + config.SST_DB_Path + ';');

const express = require('express')
const app = express()
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
    res.send(out)
  })
  
app.get('/', (req, res) => {
    connection.query("select * from nom_currencies").then(
        rs=>{
                var out = "<p>Welcome " + req.connection.user
                out+="<p><table><tr>"
                Object.keys(rs[0]).forEach(function(t){out+="<th>"+t+"</th>"})
                out+="</tr>"
                rs.forEach(function(r){
                    out+="<tr>"
                    Object.values(r).forEach(function(v){out+="<td>"+v+"</td>"})
                    out+="</tr>"
                })
                out+="</table>"
            res.send(out)
        }
    )
})

app.listen(3000, () => console.log('Example app listening on port 3000!'))