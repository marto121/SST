var sstApp = function() {
    var ep=require('./excelParser')
    var mail = require('./mail')
    var config = require('./config');
    var constants = require('./constants');
    var dbClient = null;
    var db = require('./db');

    function dbConnect(connectionString) {
        const { Client } = require('pg')
        dbClient = new Client({
            connectionString: connectionString
        })
        dbClient.connect()
    }

    function dbDisconnect() {
        if(dbClient)dbClient.end();
    }

    function checkMail() {

    }

    async function processFiles() {
        const res = await db.query('select * from File_Log where fileStatus=$1', [constants.statusReceived])
        for (var row of res.rows) {
            var fileName = row.filename;
            db.log("processFiles", "Start processing fileName " + fileName, constants.tLog, row.m_id)
            const parseResult = await ep.parseExcel(fileName, row.m_id)
            db.log("processFiles", "End processing fileName " + fileName, constants.tLog, row.m_id)
            try {
                await db.query("update file_log set fileStatus=$1, repLE=$2, repDate=$3 where id = $4", [constants.statusReceived, parseResult.Rep_LE, parseResult.Rep_Date, row.id])
            } catch (e) {
                    db.log("processFiles", "Error updating file_log!"+err.toString(), constants.tSys, row.m_id);
            }
//@TODO                fxConvert(rows.m_id);
        }
    }

    function createReplies() {
        db.query('select ID, Sender, Subject, mailStatus from Mail_Log ml where mailStatus=$1', [constants.statusReceived], (err, res) => {
            res.rows.forEach(function(row){
                var fileName = row.filename;
                mail.prepareAnswer(row.id, row.sender, row.subject).then(res=>{
                    db.query("update mail_log set mailStatus=$1 where id = $2", [constants.statusReceived, row.id], (err, res) => {
                        if(err)db.log("creatReplies", "Error updating mail_log!"+err.toString(), constants.tSys, row.m_id);
                    })
                }).catch(e=>{
                    console.log(e)
                    db.log("createReplies","Error preparing mail answer: "+e.toString(),constants.tSys, row.m_id)
                })
            })
        })
    }

    function sendMails() {

    }
    function run() {
        db.log("run", "SST App Starting...", constants.tLog, -1)
        var d = new Date()
        processFiles().then(res=>{
            createReplies()
        })
        db.log("run", "SST App Ending...", constants.tLog, -1)
    }
    
    return {run:run}
}

sstApp().run()