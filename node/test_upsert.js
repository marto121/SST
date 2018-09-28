const db = require('./db')

db.query("insert into lst_sheets (id, report_id) values(28,2) on conflict(id) do update set report_id=2 returning excluded.id",null
,(err,res)=>{console.log(err, res)})