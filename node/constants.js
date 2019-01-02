'use strict'
const tLog = 0
const tWar = 1
const tErr = 2
const tInfo = 3
const tSys = 4

const statusReceived = 0
const statusProcessed = 1
const statusConfirmed = 2
const statusRejected = 3
const statusError = 9

const roleView = 0
const roleSend = 1 //The user can send data to the SST
const roleConfirm = 2 //The user can confirm data

function getStatusName(inStatus) {
    if (inStatus == statusReceived) 
        getStatusName = "[received]"
    else if (inStatus == statusProcessed) 
        getStatusName = "[processed]"
    else if (inStatus = statusConfirmed)
        getStatusName = "[confirmed]"
    else if (inStatus = statusRejected)
        getStatusName = "[rejected]"
    else
        getStatusName = "[unknown]";
}

module.exports = {
    tLog: tLog,
    tWar: tWar,
    tErr: tErr,
    tInfo: tInfo,
    tSys: tSys,
    statusReceived: statusReceived,
    statusProcessed: statusProcessed,
    statusConfirmed: statusConfirmed,
    statusRejected: statusRejected,
    statusError: statusError,
    
    roleView: roleView,
    roleSend: roleSend,
    roleConfirm: roleConfirm,

    getStatusName: getStatusName
}