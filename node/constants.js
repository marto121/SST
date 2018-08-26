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

const roleSend = 1
const roleConfirm = 2

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
    
    roleSend: roleSend,
    roleConfirm: roleConfirm,

    getStatusName: getStatusName
}