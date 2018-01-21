Option Explicit

'Public dbConn' As ADODB.Connection
'Public rsLog' As ADODB.Recordset

Sub Connect()
    If dbConn is Nothing then
        Set dbConn = CreateObject("ADODB.Connection")
    End If
    Dim connStr
    connStr = "Provider=" & ADODB_Provider & ";Data source=" & SST_DB_Path & ";"
    If dbConn.state=adStateClosed Then
        dbConn.Open connStr
    End If
    If rsLog is Nothing then
        Set rsLog = CreateObject("ADODB.Recordset")
    End If
    If rsLog.State=adStateClosed Then
        rsLog.Open "SST_Log", dbConn, adOpenForwardOnly, adLockOptimistic
    End If
End Sub

Sub disConnect()
    rsLog.Close
    dbConn.Close
End Sub


Sub Log(src, Msg, log_type, m_ID)' As String, Msg' As String, log_type' As eLog_Type, m_ID' As Long)
    rsLog.AddNew Array("Log_Date", "Log_Source", "Log_Text", "Log_Type", "Mail_ID"), Array(Now(), src, Msg, log_type, m_ID)
    WScript.Echo Now(), src, Msg
    ' Debug.Print src, Msg
End Sub
