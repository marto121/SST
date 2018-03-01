var settings = require('./settings')

function SST() {
    var SST_DB_Path="";
    var SST_Att_Path="";
    var SST_MailBox_Path="";
    var initialized = false;
    var regedit = require('regedit')
    regedit.list(settings.SST_Reg_Key,function(a,b,c){console.log("1",a,b,c)})
    var stream = regedit.list(settings.SST_Reg_Key)
    stream.on('data', function (entry) {
        if (entry.data.values.hasOwnProperty(settings.SST_DB_Reg_Path)) {
            SST_DB_Path = entry.data.values[settings.SST_DB_Reg_Path].value;
            console.log("In Stream")
        }
        if (entry.data.values.hasOwnProperty(settings.SST_Att_Reg_Path))
            SST_Att_Path = entry.data.values[settings.SST_Att_Reg_Path].value;
        if (entry.data.values.hasOwnProperty(settings.SST_MailBox_Reg_Path))
            SST_MailBox_Path = entry.data.values[settings.SST_MailBox_Reg_Path].value;
        initialized = true;
    })
    setTimeout(function(){console.log(SST_DB_Path,initialized)},3000)
    //while (!initialized) setTimeout(function(){console.log("test")},200);
    console.log("After Stream")
    this.getDB = function() {
        return SST_DB_Path;
    }
}
SST.prototype.init = function() {
    
}

var s = new SST()
s.init();
console.log(s.getDB())