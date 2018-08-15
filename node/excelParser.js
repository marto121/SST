module.exports = {
    parseExcel: parseExcel
}
    
    var db = require('./db')
    var config = require('./config')
    var constants = require('./constants')
    
    async function getDefs() {
        var defs = {}
        var res = await db.query('SELECT * FROM import_mapping', [])//, (err, res) => {
            res.rows.forEach(function(row){
                if (!defs[row.sheet_name])defs[row.sheet_name]={};
                if (row.target_table) {
                    if (!defs[row.sheet_name][row.target_table]) {
                        defs[row.sheet_name][row.target_table]={sheet_name:row.sheet_name,key:[],columns:[],conditions:[{cond_col:"all",cond_val:"all"}]};
                    }
                    cond_val = "all"
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
                        defs[row.sheet_name][row.target_table][row.target_field]={lookup_field:[],target_table:null, lookup_table:null, cond_val:"all"};
                    }
                    with (defs[row.sheet_name][row.target_table][row.target_field]) {
                        if(row.lookup_field)lookup_field.push(row.lookup_field)
                        target_table=row.target_table;
                        lookup_table=row.lookup_table;
                        cond_val_=cond_val;
                        updatemode=row.updatemode;
                    }
                    if (row.key)defs[row.sheet_name][row.target_table].key.push(row.key)
                }
            })
            for (var sh in defs) {
                if (defs.hasOwnProperty(sh)) {
                    for (var tt in defs[sh]) {
                        if (defs[sh].hasOwnProperty(tt)) {
                            defs[sh][tt].conditions.forEach(function(cond){
                                var columns = "m_ID"
                                var values = "$1"
                                var update = "m_ID=excluded.m_ID"
                                var key = "m_ID"
                                var i = 2
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
                                for (var c in defs[sh][tt]) {
                                    if (defs[sh][tt].hasOwnProperty(c) && c!="key" && c!="columns" && c!="conditions" && c!="sheet_name") {
                                        with (defs[sh][tt][c]){
                                            if (cond_val_=="all"|cond_val_==cond.cond_val){
                                                columns += ", " + c;
                                                if (updatemode=="KeepOld") {
                                                    update += ", " + c + " = coalesce("+c+", excluded." + c + ")";
                                                } else {
                                                    update += ", " + c + " = excluded." + c;
                                                }
                                                if (lookup_field.length>0) {
                                                    insert += ((ins==0)?"with":",") + " ins" + ins + " as (insert into " + lookup_table
                                                    ins++;
                                                    var ins_columns = ""
                                                    var ins_values = ""
                                                    var ins_cond = ""
                                                    values += ", (select id from " + lookup_table + " where ";
                                                    if (lookup_table.toLowerCase()=="npe_list"|lookup_table.toLowerCase()=="assets_list") {
                                                        ins_columns += ", m_ID"
                                                        ins_values = ", $1"
                                                        ins_cond += "m_ID=$1"
                                                        values += "m_ID=$1"
                                                    } else {
                                                        values += "1=1"
                                                        ins_cond += "1=1"
                                                    }
                                                    lookup_field.forEach(function(lf){
                                                        if (values.indexOf(" and coalesce(" + lf + ",'-')=coalesce($")==-1) {
                                                            ins_columns += ", " + lf
                                                            ins_values += ", cast($" +i + " as varchar)" 
                                                            ins_cond += " and coalesce(" + lf + ",'-')=coalesce($" + i + ",'-')"
                                                            values +=   " and coalesce(" + lf + ",'-')=coalesce($" + i + ",'-')";
                                                            i++;
                                                        }
                                                    });
                                                    values += ")"
                                                    insert += "("+ins_columns.substring(2)+") select " + ins_values.substring(2)
                                                    insert += " where not exists (select 1 from " + lookup_table + " where " + ins_cond + "))"
                                                } else {
                                                    values += ", $" + i;
                                                    i++
                                                }
                                            }
                                        }
                                    }
                                }
                                if (cond.cond_col!="all") {
                                    columns += ", " + cond.cond_col;
                                    values += ", $" +i
                                    update += ", " + cond.cond_col + " = excluded." + cond.cond_col
                                }
                                cond.sql = insert
                                    + "INSERT INTO " + tt + "(" + columns + ") "
                                    + "VALUES (" + values + ") "
                                    + "ON CONFLICT (" + key + ") "
                                    + "DO UPDATE SET " +  update 
                            })
                        }
                    }
                }
            }
        //})
        return defs;
    }
    
    async function parseExcel(fName, m_ID) {
        var result = {Rep_LE: null, Rep_Date: null};
        if(typeof require !== 'undefined') XLSX = require('xlsx');

        try {
            var workbook = XLSX.readFile(fName,{cellDates:true});
        } catch (e) {
            db.log ("Import", "Error parsing excel file \":" + fName + "\". The error is " + e.toString(),  constants.tSys, m_ID)
            return result;
        }
        
        var Rep_LE = "All";
        var Rep_Date = 0;

        // Check for valid reporting period
        var priorMonthEnd = new Date();
        priorMonthEnd.setDate(0);
        priorMonthEnd = priorMonthEnd.getFullYear()*100 + priorMonthEnd.getMonth();

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
        var d = new Date();
        d.setFullYear(Rep_Date/100)
        d.setMonth(Rep_Date%100+1)
        d.setDate(0)
        Rep_Date = d
        result.Rep_Date = Rep_Date

        workbook.Workbook.Names.forEach(function(n){
            if (n.Name=="Rep_LE") {
                Rep_LE = workbook.Sheets[n.Ref.split("!")[0]][n.Ref.split("!")[1].split(":")[0].replace("$","")].v;
            }
            if (n.Name=="Rep_Date") {
                Rep_Date = workbook.Sheets[n.Ref.split("!")[0]][n.Ref.split("!")[1].split(":")[0].replace("$","")].v;
            }
        })

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
            db.log ("Import", "Importing data for legal entity " + Rep_LE, constants.tLog, m_ID);
        }

        result.Rep_LE = Rep_LE

        res = await db.query("select * from vw_LE_Sender where Tagetik_Code=$1 and id=$2",[Rep_LE, m_ID])
        if (res.rows==0) {
            db.log ("Import", "You are not allowed to work with Legal Entity " + Rep_LE + ". Processing stopped.", constants.tErr, m_ID)
            return result;
        }        

        const defs = await getDefs();

        for (const element of workbook.SheetNames) {
            if (defs[element]) {
                var def=defs[element]
                db.log ("Import", "Start loading sheet: " + element, constants.tLog, m_ID)
                var sh=workbook.Sheets[element];
                var range = XLSX.utils.decode_range(sh['!ref'])
                for (r=1; r<=range.e.r; r++) {

                    var ce = sh[XLSX.utils.encode_cell({c:0, r:r})]
                    if (!ce||ce.v==null) {
                        ce = sh[XLSX.utils.encode_cell({c:1, r:r})]
                        if (ce&&ce.v!=null) {
                            db.log ("Import", "Error on Sheet \"" + element + "\", row " + (r+1) + ": first column cannot be empty!", constants.tErr, m_ID)
                        } else {
                            continue;
                        }
                    }
                        
                    for (var tt in def) {
                        if (def.hasOwnProperty(tt)) {
                            for (const cond of def[tt].conditions) {
                                var params = compile_params(sh, r, def[tt], cond.cond_val, {Rep_LE:Rep_LE, Rep_Date:Rep_Date}, m_ID)
                                try {
                                    await db.query(cond.sql, params);
                                } catch (err) {
                                    db.log ("Import", "Sheet \"" + def[tt].sheet_name +"\", row " + r + ". Error text: " + err.toString(), constants.tErr, m_ID, constants.tLog, m_ID)
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
                db.log ("Import", "Sheet with name: " + element + " not recognized. Skipping...", constants.tWar, m_ID)
            }
        };
        return result;
    }
    
    function compile_params(sh, r, def, cond_val, statics, m_ID) {
        var params = [m_ID]
    
        def.columns.forEach(function(col) {
            if (col.cond_val=="all"|col.cond_val==cond_val) {
                if (col.column==97) {
                    params.push(statics.Rep_LE)
                } else if (col.column==98) {
                    params.push(r)
                } else if (col.column==99) {
                    params.push(statics.Rep_Date)
                } else {
                    var ce = sh[XLSX.utils.encode_cell({c:col.column-1, r:r})]
                    if (!ce) {
                        ce = {v:null}
                    }
                    if (col.key!=null&&ce.v==null) {
                        db.log("Import", "Sheet \"" + def.sheet_name +"\", row " + r + ", column \"" + col.name + "\" can not be empty!", constants.tErr, m_ID)
                    }
                    if (col.name.toLowerCase()=="sale_id"&&ce.v==null) ce.v=ce.Rep_Date.getFullYear()*100+ce.Rep_Date.getMonth();
                    params.push(ce.v)
                }
            }
        })
        if (cond_val!="all") {
            params.push(cond_val);
        }
        return params
    }

