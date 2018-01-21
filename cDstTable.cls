'VERSION 1.0 CLASS
'BEGIN
'  MultiUse = -1  'True
'END
'Attribute VB_Name = "cDstTable"
'Attribute VB_GlobalNameSpace = False
'Attribute VB_Creatable = False
'Attribute VB_PredeclaredId = False
'Attribute VB_Exposed = False

Class cDstTable
    Public cmd' As ADODB.Command
    Public key' As Dictionary
    Public cols' As Dictionary
    Public codeLists' As Dictionary
    Public newOnlyCols' As Dictionary
End Class


