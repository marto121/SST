'Attribute VB_Name = "utils"
Option Explicit

Function getMailHeader(oItem, header)
    Dim headers
    headers = oItem.propertyAccessor.GetProperty(PR_TRANSPORT_MESSAGE_HEADERS)
    if header = "" Then
        getMailHeader = headers
    Else
        Dim lines
        lines = split(headers, vbNewLine)
        Dim l
        For l = 0 to UBound(lines)
            if LCase(Left(lines(l),len(header))) = LCase(header) Then
                getMailHeader = Right(lines(l), Len(lines(l)) - InStr(lines(l),":")-1 )
                Exit Function
            End If
        Next
    End If
End Function

Function GetFolderPath(ByVal FolderPath)' As String)' As Outlook.Folder
    Dim oFolder' As Outlook.Folder
    Dim FoldersArray' As Variant
    Dim i' As Integer

    Do while true
        On Error Resume Next
        If Left(FolderPath, 2) = "\\" Then
            FolderPath = Right(FolderPath, Len(FolderPath) - 2)
        End If
        'Convert folderpath to array
        FoldersArray = Split(FolderPath, "\")
        Set oFolder = oOutlook.Session.Folders.Item(FoldersArray(0))
        If Err<>0 Then
            WScript.Echo Now(), "Error obtaining Outlook session / Folder " & FoldersArray(0)
            Exit Do
        End If
        If Not oFolder Is Nothing Then
            For i = 1 To UBound(FoldersArray, 1)
                Dim SubFolders' As Outlook.Folders
                Set SubFolders = oFolder.Folders
                Set oFolder = SubFolders.Item(FoldersArray(i))
                If Err<>0 Then
                    WScript.Echo Now(), "Error obtaining Outlook session / Folder " & FoldersArray(i)
                    Exit Do
                End If
                If oFolder Is Nothing Then
                    Set GetFolderPath = Nothing
                End If
            Next
        End If
        'Return the oFolder
        Set GetFolderPath = oFolder
        On Error Goto 0
        Exit Function
    Loop        
GetFolderPath_Error:
    Set GetFolderPath = Nothing
    On Error Goto 0
    Exit Function
End Function

Function getFileExt(fileName)' As String)' As String
    Dim s
    s = Split(fileName, ".")
    getFileExt = s(UBound(s))
End Function

Function transpose(cells)
    Dim transposed
    ReDim transposed(Ubound(cells,2), UBound(cells,1))
    Dim r, c
    for r = 0 to Ubound(cells,2)
        for c = 0 to UBound(cells,1)
            transposed(r,c)=cells(c,r)
        Next
    Next
    transpose = transposed
End Function

