'use strict'

module.exports = {
    parseExcel: parseExcel
}
    
    const Excel = require('exceljs');
    const db = require('./db')
    const constants = require('./constants')
    
    async function getDefs() {
        var defs = {}
        var res = await db.query('SELECT * FROM import_mapping-- where sheet_name=\'Asset_Status\'', [])//, (err, res) => {
            res.rows.forEach(function(row){
                if (!defs[row.sheet_name])defs[row.sheet_name]={};
                if (row.target_table) {
                    if (!defs[row.sheet_name][row.target_table]) {
                        defs[row.sheet_name][row.target_table]={col_no:1,sheet_name:row.sheet_name,key:[],columns:[],conditions:[{cond_col:"all",cond_val:"all"}]};
                    }
                    var cond_val = "all"
                    if (row.condition!=null) {
                        var cond_col = row.condition.split("=")[0]
                        cond_val = row.condition.split("=")[1];
                        defs[row.sheet_name][row.target_table].conditions.push({cond_col:cond_col,cond_val:cond_val});
                        delete defs[row.sheet_name][row.target_table].conditions.all
                    }
                    if (defs[row.sheet_name][row.target_table].conditions.length>1){
                        defs[row.sheet_name][row.target_table].conditions.shift()
                    }
                    defs[row.sheet_name][row.target_table].columns.push({column:row.column_no, cond_val:cond_val, key:row.key, name:row.column_name});
                    if (!defs[row.sheet_name][row.target_table][row.target_field]) {
                        if(!row.lookup_field)defs[row.sheet_name][row.target_table].col_no++;
                        defs[row.sheet_name][row.target_table][row.target_field]={col_no:defs[row.sheet_name][row.target_table].col_no,lookup_field:[],target_table:null, lookup_table:null, cond_val:[]};
                    }
                    if(row.lookup_field) {
                        var thislf = defs[row.sheet_name][row.target_table][row.target_field].lookup_field
                        var included = false
                        thislf.forEach(function(l){if(l.lookup_field==row.lookup_field)included=true})
                        if (!included) {
                            defs[row.sheet_name][row.target_table].col_no++
                            defs[row.sheet_name][row.target_table][row.target_field].lookup_field.push({col_no:defs[row.sheet_name][row.target_table].col_no, lookup_field:row.lookup_field})
                        }
                    }
                    defs[row.sheet_name][row.target_table][row.target_field].target_table=row.target_table;
                    defs[row.sheet_name][row.target_table][row.target_field].lookup_table=row.lookup_table;
                    if(!defs[row.sheet_name][row.target_table][row.target_field].cond_val.includes(cond_val))
                        defs[row.sheet_name][row.target_table][row.target_field].cond_val.push(cond_val);
                    defs[row.sheet_name][row.target_table][row.target_field].updatemode=row.updatemode;
                    if (row.key)defs[row.sheet_name][row.target_table].key.push(row.key)
                }
            })
            for (var sh in defs) {
                if (defs.hasOwnProperty(sh)) {
                    for (var tt in defs[sh]) {
                        if (defs[sh].hasOwnProperty(tt)) {
                            defs[sh][tt].conditions.forEach(function(cond){
                                var columns = "m_ID"
                                var all_values = "$1"
                                var update = "m_ID=excluded.m_ID"
                                var key = "m_ID"
                                defs[sh][tt].key.forEach (function(k){
                                    if (key.indexOf(", "+k)==-1) {
                                        key += ", " + k 
                                    }
                                })
                                if (cond.cond_col!="all") {
                                    key += ", " + cond.cond_col;
                                }
            
                                var insert = ""
                                var ins = 0
                                var i = 2
                                for (var c in defs[sh][tt]) {
                                    if (defs[sh][tt].hasOwnProperty(c) && c!="key" && c!="columns" && c!="conditions" && c!="sheet_name" && c!="col_no") {
                                        const this_col = defs[sh][tt][c]
                                        if (this_col.cond_val.includes("all")|this_col.cond_val.includes(cond.cond_val)){
                                            columns += ", " + c;
                                            if (this_col.updatemode=="KeepOld") {
                                                update += ", " + c + " = coalesce("+c+", excluded." + c + ")";
                                            } else {
                                                update += ", " + c + " = excluded." + c;
                                            }
                                            if (this_col.lookup_field.length>0) {
                                                insert += ((ins==0)?"with":",") + " ins" + ins + " as (insert into " + this_col.lookup_table
                                                var ins_columns = ""
                                                var ins_values = ""
                                                var ins_cond = ""
                                                var values = ", coalesce((select id from ins" + ins + "),(select min(id) from " + this_col.lookup_table + " where ";
                                                ins++;
                                                if (this_col.lookup_table.toLowerCase()=="npe_list"|this_col.lookup_table.toLowerCase()=="assets_list") {
                                                    ins_columns += ", m_ID"
                                                    ins_values = ", $1"
                                                    ins_cond += "m_ID=$1"
                                                    values += "m_ID=$1"
                                                } else {
                                                    values += "1=1"
                                                    ins_cond += "1=1"
                                                }
                                                this_col.lookup_field.forEach(function(lf){
                                                    if (values.indexOf(" and coalesce(" + lf.lookup_field + ",'-')=coalesce($")==-1) {
                                                        ins_columns += ", " + lf.lookup_field
                                                        i = lf.col_no
                                                        if (lf.lookup_field=="NPE_Code") { // @TODO FIND BETTER SOLUTION
                                                            ins_values += ", left(cast($" + i + " as varchar),8)" 
                                                            ins_cond += " and coalesce(" + lf.lookup_field + ",'-')=left(coalesce($" + i + ",'-'),8)"
                                                            values +=   " and coalesce(" + lf.lookup_field + ",'-')=left(coalesce($" + i + ",'-'),8)";
                                                        } else {
                                                            ins_values += ", cast($" + i + " as varchar)" 
                                                            ins_cond += " and coalesce(" + lf.lookup_field + ",'-')=coalesce($" + i + ",'-')"
                                                            values +=   " and coalesce(" + lf.lookup_field + ",'-')=coalesce($" + i + ",'-')";
                                                        }
                                                    }
                                                });
                                                values += "))"
                                                insert += "("+ins_columns.substring(2)+") select " + ins_values.substring(2)
                                                insert += " where not exists (select 1 from " + this_col.lookup_table + " where " + ins_cond + ")"
                                                insert += " returning *)"
                                                all_values += values;
                                            } else {
                                                i = this_col.col_no
                                                all_values += ", $" + i;
                                            }
                                        }
                                    }
                                }
                                if (cond.cond_col!="all") {
                                    i++
                                    columns += ", " + cond.cond_col;
                                    all_values += ", $" + i
                                    update += ", " + cond.cond_col + " = excluded." + cond.cond_col
                                }
                                cond.sql = insert
                                    + "INSERT INTO " + tt + "(" + columns + ") "
                                    + "VALUES (" + all_values + ") "
                                    + "ON CONFLICT (" + key + ") "
                                    + "DO UPDATE SET " +  update + " "
                                    + "RETURNING ID, (select last_value from " + tt + "_id_seq)"
                                //console.log(cond.sql)
                            })
                        }
                    }
                }
            }
        //})
        return defs;
    }
    
    async function parseExcel(fName, m_ID) {
        var result = {Rep_LE: null, Rep_Date: null, toStatus: constants.statusRejected};
        try {
            var wb = new Excel.Workbook();
            await wb.xlsx.readFile(fName)
        } catch (e) {
            db.log ("Import", "Error parsing excel file \":" + fName + "\". The error is " + e.toString(),  constants.tSys, m_ID)
            return result;
        }
        
        var Rep_LE = "All";
        var Rep_Date = 0;

        // Check for valid reporting period
        var priorMonthEnd = new Date();
        priorMonthEnd.setDate(0);
        priorMonthEnd = priorMonthEnd.getFullYear()*100 + priorMonthEnd.getMonth()+1;

        var a = null;
        var c = null
        var rng = wb.definedNames.getRanges("Rep_LE")
        if (rng.ranges[0]) {
            a = rng.ranges[0].split("!")
            c = wb.getWorksheet(a[0]).getCell(a[1])
            Rep_LE = c.value
        }
        rng = wb.definedNames.getRanges("Rep_Date")
        if (rng.ranges[0]) {
            a = rng.ranges[0].split("!")
            c = wb.getWorksheet(a[0]).getCell(a[1])
            Rep_Date = c.value
        }
        if (Rep_Date == 0) {
            db.log ("Import", "No or invalid reporting date specified in the file (Name=Rep_Date). Assuming end of previous month.", constants.tWar, m_ID);
            Rep_Date = priorMonthEnd;
        }
        //Check reporting date is in the future
        if (Rep_Date > priorMonthEnd) {
            db.log ("Import", "Reporting date specified in the file (Name=Rep_Date) is in the future. Assuming end of previous month.", constants.tWar, m_ID)
            Rep_Date = priorMonthEnd
        }
        if (Rep_Date < 201712) {
            db.log ("Import", "Reporting date specified in the file (Name=Rep_Date) is before 201712. Loading aborted.", constants.tErr, m_ID)
        }

        if (Rep_LE=="All") {
            const res = await db.query("select Tagetik_Code from vw_LE_Sender where id = $1",[m_ID])
            if (res.rows.length==0) {
                db.log ("Import", "No Legal Entity specified in the file (Name=Rep_LE). Assuming access to all Legal entities.", constants.tWar, m_ID);
            } else {
                Rep_LE = res.rows[0].tagetik_code;
            }
        } else if (Rep_LE == "") {
            db.log ("Import", "No Legal entity specified in the file. Processing stopped.", constants.tErr, m_ID)
            return result
        } else {
            Rep_LE = Rep_LE.split(":")[0];
            db.log ("Import", "Importing data for legal entity " + Rep_LE, constants.tLog, m_ID);
        }

        result.Rep_LE = Rep_LE
        result.Rep_Date = intToDate(parseInt(Rep_Date))

        const res = await db.query("select * from vw_LE_Sender where Tagetik_Code=$1 and id=$2",[Rep_LE, m_ID])
        if (res.rows==0) {
            db.log ("Import", "You are not allowed to work with Legal Entity " + Rep_LE + ". Processing stopped.", constants.tErr, m_ID)
            return result;
        }        

        const defs = await getDefs();
//return result// disable actual parsing
        for (var sh of wb.worksheets) {
            if (defs[sh.name]) {
                var def=defs[sh.name]
                db.log ("Import", "Start loading sheet: " + sh.name, constants.tLog, m_ID)
                for (var rowNumber = 2; rowNumber <= sh.rowCount; rowNumber++) {
                    var row = sh.getRow(rowNumber);
                    var ce = row.getCell(1)
                    if (ce.value==null) {
                        ce = row.getCell(2)
                        if (ce.value!=null) {
                            db.log ("Import", "Error on Sheet \"" + sh.name + "\", row " + (rowNumber+1) + ": first column cannot be empty!", constants.tErr, m_ID)
                        } else {
                            continue;
                        }
                    }
                    
                    for (var tt in def) {
                        if (def.hasOwnProperty(tt)) {
                            for (const cond of def[tt].conditions) {
                                var params = compile_params(row, rowNumber, def[tt], cond.cond_val, result, m_ID)
                                try {
                                    const ins_res = await db.query(cond.sql, params.params);
                                    //First check if we are inserting status for missing NPE/Asset
                                    if ( (tt.toLowerCase()=="assets_list"&&sh.name.toLowerCase()=="asset_status")
                                        || (tt.toLowerCase()=="npe_list"&&sh.name.toLowerCase()=="pipeline_status") ) {
                                        if (ins_res.rows[0].id==ins_res.rows[0].last_value) {
                                            db.log ("Import", "Sheet \"" + def[tt].sheet_name + "\", row " + (rowNumber) + ". NPE/Asset not registered. Only name will be available.", constants.tWar, m_ID, constants.tLog, m_ID);
                                        } else{
                                            //this case is OK
                                        }
                                    } else if(ins_res.rows[0].id<ins_res.rows[0].last_value) {
                                        console.log(tt, sh.name);
                                        db.log ("Import", "Sheet \"" + def[tt].sheet_name + "\", row " + (rowNumber) + ". Duplicate row overwritten: " + JSON.stringify(params.keys.key_columns) + " " + JSON.stringify(params.keys.key_values), constants.tWar, m_ID, constants.tLog, m_ID)
                                    }
                                } catch (err) {
                                    db.log ("Import", "Sheet \"" + def[tt].sheet_name + "\", row " + (rowNumber) + ". Error text: " + err.toString() + ". SQL: " + cond.sql + params.params, constants.tErr, m_ID, constants.tLog, m_ID)
                                }
                            }
                        }
                    }
                }
                /*            for (var c in sh) {
                    if (c.substring(0,1)!="!") {
                        if (sh.hasOwnProperty(c))
                        var ce=sh[c]
                            console.log(XLSX.utils.decode_cell(c))
                        }
                }*/
            } else {
                //console.log (defs)
                db.log ("Import", "Sheet with name: " + sh.name + " not recognized. Skipping...", constants.tWar, m_ID)
            }
        };
        result.toStatus = constants.statusProcessed;
        return result;
    }
    
    function compile_params(row, rowNumber, def, cond_val, statics, m_ID) {
        var params = [m_ID]
        var key_columns = [];
        var key_values = [];
    
        def.columns.forEach(function(col) {
            if (col.cond_val=="all"|col.cond_val==cond_val) {
                if (col.column==97) {
                    params.push(statics.Rep_LE)
                } else if (col.column==98) {
                    params.push(rowNumber)
                } else if (col.column==99) {
                    params.push(statics.Rep_Date)
                } else {
                    const ce = row.getCell(col.column);
                    const cell_value = (ce.type==6)?ce.result:ce.value;
                    if (col.key!=null){
                        key_columns.push(col.name);
                        key_values.push((cell_value instanceof Date)?cell_value.toLocaleDateString():cell_value);
                        if(ce.value==null) {
                            const defaultValue = getDefaultValue(col.name, statics);
                            if (defaultValue) {
                                ce.value = defaultValue;
                            } else {
                                db.log("Import", "Sheet \"" + def.sheet_name +"\", row " + (rowNumber+1) + ", column \"" + col.name + "\" can not be empty!", constants.tErr, m_ID);
                            }
                        }
                    }
//                    if (col.name.toLowerCase()=="sale_id"&&ce.value==null) ce.value=statics.Rep_Date.getFullYear()*100+statics.Rep_Date.getMonth();
                    
                    params.push(cell_value)
                }
            }
        })
        if (cond_val!="all") {
            params.push(cond_val);
        }
        return {params:params, keys:{key_columns:key_columns, key_values:key_values}}
    }

function getDefaultValue(col_name, statics) {
    var result = null;
    if (col_name.toLowerCase()=="sale_id") {
        result = statics.Rep_Date.getFullYear()*100+statics.Rep_Date.getMonth();
    } else if (col_name.toLowerCase().indexOf("date")>-1) {
        result = new Date(2000,0,1)
    }
    return result;
}
function intToDate(intDate) {
    var d = new Date()
    d.setFullYear(Math.trunc(intDate/100))
    d.setMonth(intDate%100)
    d.setDate(0)
    return d
}