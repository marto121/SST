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
        "lst_Checks",
        "lst_Updates",
        "Meta_Updatable_Tables",
        "orig_shifted",
        "SST_Log",
        "Users",
        "calendar",
        "Mail_Queue",
        "Meta_CCY_Conversion",
        "Equity_History",
        "Procurement_Actions",
        "Reports",
        "Update_Log"
    ]
    var config = require('./config')
    var db = require('./db')
var fs = require('fs')
var connectionString = config.SST_pg_conn;

    tables.forEach(function(t){
        db.query("select * from reset_sequence($1,\'ID\')", [t])
    })