set sst_db_path=C:\MyPrograms\SST2\UCTAM_SST.accdb
set mon=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%
set sst_target_path=I:\UCTAM_CFO\SST\Backups\UCTAM_SST_%mon%.accdb

echo Creating backup copy of %sst_db_path% to %sst_target_path%
copy "%sst_db_path%" "%sst_target_path%"
