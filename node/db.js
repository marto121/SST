'use strict'
const pg = require('pg')
/*
pg.types.setTypeParser( 1082, 'text', function( val ) {
    return new Date( val + ' 00:00:00Z')
})
*/
var config = require('./config');

var pool;
try {
    pool = new pg.Pool({connectionString:config.SST_pg_conn})
} catch (e) {
    console.log("ERROR: Connection failed: " + e.description)
}

function query(text, params, callback) {
    if (typeof pool != "undefined" && pool)
        return pool.query(text, params, callback);
    else
        console.log("ERROR: DB not initialized!")
        return new Promise((resolve, reject)=>{resolve({rowCount:0, rows:[]})});
}

function log(src, Msg, log_type, m_ID) {
    var d = new Date();
    var datestring = d.getFullYear()  + "-" + (d.getMonth()+1) + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
    console.log ( datestring, src, Msg )
    query("insert into sst_log (log_date, log_source, log_text, log_type, mail_id) values (now(), $1, $2, $3, $4)",[src, Msg.substring(0,254), log_type, m_ID])
}

async function confirmMessage(confirm_m_ID, log_m_ID) {
    await query("SELECT * FROM fn_confirmmessage($1, $2)", [confirm_m_ID, log_m_ID])
}

async function performChecks(m_ID) {
//    return //@TODO FIX
    await query("SELECT * FROM fn_performchecks($1)", [m_ID])
}

async function performFX(m_ID) {
    await query("SELECT * FROM fn_performfx($1)", [m_ID])
}

async function performUpdates(m_ID) {
//    return //@TODO FIX
    await query("SELECT * FROM fn_performupdates($1,$2)", [m_ID,m_ID]) //check for confir_message_id
}

async function changeMailStatus(m_ID, newStatus) {
    await query("update mail_log set mailStatus=$1 where id = $2", [newStatus, m_ID], (err, res) => {
        if(err)db.log("changeMailStatus", "Error updating mail_log! " + err.toString(), constants.tSys, m_ID);
    })
}

module.exports = {
  query: query,
  log: log,
  performChecks: performChecks,
  performUpdates: performUpdates,
  confirmMessage: confirmMessage,
  performFX, performFX,
  changeMailStatus: changeMailStatus
}