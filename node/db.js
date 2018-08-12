const { Pool } = require('pg')
var config = require('./config');

const pool = new Pool({connectionString:config.SST_pg_conn})

function query(text, params, callback) {
    return pool.query(text, params, callback);
}

function log(src, Msg, log_type, m_ID) {
    query("insert into sst_log (log_date, log_source, log_text, log_type, mail_id) values (now(), $1, $2, $3, $4)",[src, Msg.substring(0,254), log_type, m_ID])
    var d = new Date();
    var datestring = d.getFullYear()  + "-" + (d.getMonth()+1) + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
    
    console.log ( datestring, src, Msg )
}

module.exports = {
  query: query,
  log: log
}