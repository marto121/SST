'use strict';


 
var constants = require('./constants')
var config = require('./config')
var fs = require('fs')


function ADOConn(connStr) {
    const ADODB = require('node-adodb');
    const connection = ADODB.open('Provider=Microsoft.ACE.OLEDB.12.0;Data source=' + config.SST_DB_Path + ';');
    ADOConn.prototype.query = async function (table_name) {
        try {
          const users = await connection.query('SELECT * FROM ' + table_name);
          return users
        } catch (error) {
          console.error(error);
        }
    }
    function close() {
        connection.close()
    }
}

function PGConn(connStr) {
    const { Pool } = require('pg')
    const pool = new Pool({
        connectionString: connStr
    })
    PGConn.prototype.close = async function() {
        pool.end()
    }
    PGConn.prototype.insertJSON = async function(table_name, json) {
        const client = await pool.connect()
        try {
            var columns
            var values
            var sets

            var fn = 1
            for (var f in json[0]) {
                if (fn==1) {
                    columns = "("
                    values = "("
                    sets = ""
                } else {
                    columns += ","
                    values += ","
                    sets += ","
                }
                columns += f
                values += "$" + fn
                sets += f + "=$" + fn
                fn++
            }
            columns += ")"
            values += ")"
            var insSQL = "INSERT INTO " + table_name + columns + " VALUES " + values
            var updSQL = "UPDATE " + table_name + " SET " + sets + " WHERE ID=$1"
            var IDs_keys = {}
            try {
                var IDs = await client.query("select ID from " + table_name)
                for (var i = 0; i<IDs.rows.length; i++){
                    IDs_keys[IDs.rows[i].id] = "key"
                }
            } catch (e) {
                await client.query("delete from " + table_name)
            }
            for (var r=0; r<json.length; r++) {
                var SQL = ""
                if (IDs_keys.hasOwnProperty(json[r].ID)) {
                    SQL = updSQL
                } else {
                    SQL = insSQL
                }
                var res = await client.query(SQL, Object.values(json[r]))
            }
            console.log("Success:"+table_name)
        } catch (error) {
            console.error(error)
        } finally {
            client.release()
        }
    }
}

async function migrate(tables, srcConn, dstConn) {
    for (var t = 0; t < tables.length; t++) {
        var json = await adoConn.query(tables[t])
        await dstConn.insertJSON(tables[t], json)
        console.log("End:"+tables[t])
    }
}

var tables =[
    "Mail_Log",
    "Nom_Currencies",
    "Nom_Countries",
    "Legal_Entities",
    "Nom_Asset_Owned",
    "Nom_Asset_Status",
    "Nom_Asset_Type",
    "Nom_Asset_Usage",
    "Nom_Financing_Type",
    "Nom_Log_Types",
    "Nom_NPE_Status",
    "Nom_Scenarios",
    "Nom_Transaction_Types",
    "NPE_List",
    "Assets_List",
    "NPE_History",
    "Asset_Appraisals",
    "Asset_Financials",
    "Asset_Financing",
    "Asset_History",
    "Asset_Insurances",
    "Asset_Rentals",
    "Asset_Repossession",
    "Asset_Sales",
    "Business_Cases",
    "Counterparts",
    "File_Log",
    "FX_Rates",
    "Import_Mapping",
    "LastDate",
    "lst_Reports",
    "lst_Sheets",
    "Meta_Updatable_Tables",
    "orig_shifted",
    "SST_Log",
    "Users",
    "calendar"
]



var pgConn = new PGConn(config.SST_pg_conn)
//pgConn.insertJSON("")
var adoConn = new ADOConn(config.SST_DB_Path)
migrate(tables, adoConn, pgConn)