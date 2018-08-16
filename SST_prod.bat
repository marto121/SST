echo %date% %time% >>C:\MyPrograms\SST_Log\sst_err.log
cscript.exe C:\MyPrograms\SST\SST.wsf 1>> C:\MyPrograms\SST_Log\sst.log 2>>C:\MyPrograms\SST_Log\sst_err.log
call C:\MyPrograms\SST\backup.bat
