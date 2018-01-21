VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisOutlookSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private objNS As Outlook.NameSpace
Private WithEvents objNewMailItems As Outlook.Items
Attribute objNewMailItems.VB_VarHelpID = -1

Private Sub Application_Startup()
' Use GetFolderPath function from
'http://slipstick.me/qf
    app.Init
    Set objNewMailItems = GetFolderPath(SST_MailBox_Path).Items
End Sub

Private Sub objNewMailItems_ItemAdd(ByVal Item As Object)
    'Ensure we are only working with e-mail items
    If Item.Class <> OlObjectClass.olMail Then Exit Sub
    Connect
    processMail Item
    disConnect
End Sub

