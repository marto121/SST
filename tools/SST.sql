CREATE TABLE Asset_Appraisals (
ID Long(4),
Appraisal_Asset_ID Long(4),
Appraisal_Company_ID Long(4),
Appraisal_Date Date/Time(8),
Appraisal_Currency_ID Long(4),
Appraisal_Market_Value_CCY Double(8),
Appraisal_Market_Value_EUR Double(8),
Appraisal_Firesale_Value_CCY Double(8),
Appraisal_Firesale_Value_EUR Double(8),
Appraisal_Order Long(4),
m_ID Long(4)
)
CREATE TABLE Asset_Financials (
ID Long(4),
Asset_ID Long(4),
Acc_Date Date/Time(8),
Account_No Text(255),
Account_Name Text(255),
Amount Long(4),
Trans_Type_ID Long(4),
Rep_Date Date/Time(8),
m_ID Long(4)
)
CREATE TABLE Asset_Financing (
ID Long(4),
Financing_Contract_Code Text(20),
Financing_Counterpart_ID Long(4),
Financing_Asset_ID Long(4),
Financing_Type_ID Long(4),
Financing_Currency_ID Long(4),
Financing_Amount_CCY Double(8),
Financing_Amount_EUR Double(8),
Financing_Reference_Rate Text(10),
Financing_Margin Double(8),
Financing_Rate Double(8),
Financing_Start_Date Date/Time(8),
Financing_End_Date Date/Time(8),
Financing_Contract_Date Date/Time(8),
m_ID Long(4)
)
CREATE TABLE Asset_History (
ID Long(4),
Asset_ID Long(4),
Rep_Date Date/Time(8),
Status_Code Long(4),
Book_Value Double(8),
OPEX Double(8),
CAPEX Double(8),
Expected_Exit Date/Time(8),
m_ID Long(4)
)
CREATE TABLE Asset_Insurances (
ID Long(4),
Insurance_Asset_ID Long(4),
Insurance_Company_ID Long(4),
Insurance_Start_Date Date/Time(8),
Insurance_End_Date Date/Time(8),
Insurance_Currency_ID Long(4),
Insurance_Amount_CCY Double(8),
Insurance_Amount_EUR Double(8),
Insurance_Premium_CCY Double(8),
Insurance_Premium_EUR Double(8),
m_ID Long(4)
)
CREATE TABLE Asset_Rentals (
ID Long(4),
Rental_Asset_ID Long(4),
Rental_Counterpart_ID Long(4),
Rental_Contract_Date Date/Time(8),
Rental_Start_Date Date/Time(8),
Rental_End_Date Date/Time(8),
Rental_Payment_Date Date/Time(8),
Rental_Currency_ID Long(4),
Rental_Amount_CCY Double(8),
Rental_Amount_EUR Double(8),
m_ID Long(4)
)
CREATE TABLE Asset_Repossession (
ID Long(4),
Repossession_Asset_ID Long(4),
NPE_Currency_ID Long(4),
NPE_Amount_CCY Double(8),
NPE_Amount_EUR Double(8),
LLP_Amount_CCY Double(8),
LLP_Amount_EUR Double(8),
Purchase_Price_Currency_ID Long(4),
Appr_Purchase_Price_Net_CCY Double(8),
Appr_Purchase_Price_Net_EUR Double(8),
Purchase_Price_Net_CCY Double(8),
Purchase_Price_Net_EUR Double(8),
Purchase_Costs_CCY Double(8),
Purchase_Costs_EUR Double(8),
Planned_CAPEX_Currency_ID Long(4),
Planned_CAPEX_CCY Double(8),
Planned_CAPEX_EUR Double(8),
Planned_CAPEX_Comment Text(255),
Purchase_Auction_Date Date/Time(8),
Purchase_Contract_Date Date/Time(8),
Purchase_Repossession_Date Date/Time(8),
Purchase_Payment_Date Date/Time(8),
Purchase_Handover_Date Date/Time(8),
Purchase_Registration_Date Date/Time(8),
Purchase_Local_Approval_Date Date/Time(8),
Purchase_Central_Approval_Date Date/Time(8),
Purchase_Prolongation_Date Date/Time(8),
Purchase_Expected_Exit_Date Date/Time(8),
Planned_OPEX_CCY Double(8),
Planned_OPEX_EUR Double(8),
Planned_OPEX_Comment Text(255),
Planned_SalesPrice_CCY Double(8),
Planned_SalesPrice_EUR Double(8),
m_ID Long(4)
)
CREATE TABLE Asset_Sales (
ID Long(4),
Sale_Asset_ID Long(4),
Sale_Counterpart_ID Long(4),
Sale_Approval_Date Date/Time(8),
Sale_Contract_Date Date/Time(8),
Sale_Transfer_Date Date/Time(8),
Sale_Payment_Date Date/Time(8),
Sale_AML_Check_Date Date/Time(8),
Sale_AML_Pass_Date Date/Time(8),
Sale_Currency_ID Long(4),
Sale_ApprovedAmt_CCY Double(8),
Sale_ApprovedAmt_EUR Double(8),
Sale_Amount_CCY Double(8),
Sale_Amount_EUR Double(8),
Sale_Book_Value_CCY Double(8),
Sale_Book_Value_EUR Double(8),
m_ID Long(4)
)
CREATE TABLE Assets_List (
ID Long(4),
Asset_Code Text(12),
Asset_NPE_ID Long(4),
Asset_Name Text(255),
Asset_Description Text(255),
Asset_Address Text(255),
Asset_ZIP Text(255),
Asset_Region Text(255),
Asset_Country_ID Long(4),
Asset_Usage_ID Long(4),
Asset_Type_ID Long(4),
Asset_Usable_Area Long(4),
Asset_Common_Area Long(4),
Asset_Owned Long(4),
Comment Text(255),
m_ID Long(4)
)
CREATE TABLE Counterparts (
ID Long(4),
Counterpart_Common_Name Text(255),
Counterpart_First_Name Text(255),
Counterpart_Last_Name Text(255),
Counterpart_Company_Name Text(255),
Counterpart_Type Text(255)
)
CREATE TABLE File_Log (
ID Long(4),
m_ID Long(4),
fileName Text(255),
fileStatus Integer(2)
)
CREATE TABLE Import_Mapping (
»ƒ Long(4),
Sheet_Name Text(255),
Column_No Long(4),
Column_Name Text(255),
Target_Table Text(255),
Target_Field Text(255),
Lookup_Table Text(255),
Lookup_Field Text(255),
Condition Text(255),
Key Text(255),
UpdateMode Text(255)
)
CREATE TABLE LastDate (
LastDate Date/Time(8)
)
CREATE TABLE Legal_Entities (
ID Long(4),
Tagetik_Code Text(255),
LE_Name Text(255),
LE_Country_ID Long(4)
)
CREATE TABLE lst_Reports (
ID Long(4),
Report_Code Text(255),
Report_Name Text(255)
)
CREATE TABLE lst_Sheets (
ID Long(4),
Report_ID Long(4),
Sheet_Name Text(255),
Sheet_Title Text(255),
Sheet_Query Text(255)
)
CREATE TABLE Mail_Log (
ID Long(4),
Sender Text(255),
Receiver Text(255),
Subject Text(255),
mailStatus Integer(2)
)
CREATE TABLE Meta_Updatable_Tables (
ID Long(4),
table_name Text(255),
Parent_Table Text(255),
Parent_ID Text(255),
Parent_Code Text(255),
Key Text(255),
Del_Key Text(255)
)
CREATE TABLE MSysAccessStorage (
DateCreate Date/Time(8),
DateUpdate Date/Time(8),
Id Long(4),
Lv Long Binary (OLE Object)(0),
Name Text(128),
ParentId Long(4),
Type Long(4)
)
CREATE TABLE MSysAccessXML (
Id Long(4),
LValue Long Binary (OLE Object)(0),
ObjectGuid GUID(16),
ObjectName Text(65),
Property Text(65),
Value Text(255)
)
CREATE TABLE MSysACEs (
ACM Long(4),
FInheritable Boolean(1),
ObjectId Long(4),
SID Binary(510)
)
CREATE TABLE MSysComplexColumns (
ColumnName Text(255),
ComplexID Long(4),
ComplexTypeObjectID Long(4),
ConceptualTableID Long(4),
FlatTableID Long(4)
)
CREATE TABLE MSysNameMap (
GUID GUID(16),
Id Long(4),
Name Text(65),
NameMap Long Binary (OLE Object)(0),
Type Long(4)
)
CREATE TABLE MSysNavPaneGroupCategories (
Filter Text(255),
Flags Long(4),
Id Long(4),
Name Text(255),
Position Long(4),
SelectedObjectID Long(4),
Type Long(4)
)
CREATE TABLE MSysNavPaneGroups (
Flags Long(4),
GroupCategoryID Long(4),
Id Long(4),
Name Text(255),
Object Type Group Long(4),
ObjectID Long(4),
Position Long(4)
)
CREATE TABLE MSysNavPaneGroupToObjects (
Flags Long(4),
GroupID Long(4),
Icon Long(4),
Id Long(4),
Name Text(255),
ObjectID Long(4),
Position Long(4)
)
CREATE TABLE MSysNavPaneObjectIDs (
Id Long(4),
Name Text(65),
Type Long(4)
)
CREATE TABLE MSysObjects (
Connect Memo(0),
Database Memo(0),
DateCreate Date/Time(8),
DateUpdate Date/Time(8),
Flags Long(4),
ForeignName Text(255),
Id Long(4),
Lv Long Binary (OLE Object)(0),
LvExtra Long Binary (OLE Object)(0),
LvModule Long Binary (OLE Object)(0),
LvProp Long Binary (OLE Object)(0),
Name Text(255),
Owner Binary(510),
ParentId Long(4),
RmtInfoLong Long Binary (OLE Object)(0),
RmtInfoShort Binary(510),
Type Integer(2)
)
CREATE TABLE MSysQueries (
Attribute Byte(1),
Expression Memo(0),
Flag Integer(2),
LvExtra Long(4),
Name1 Text(255),
Name2 Text(255),
ObjectId Long(4),
Order Binary(510)
)
CREATE TABLE MSysRelationships (
ccolumn Long(4),
grbit Long(4),
icolumn Long(4),
szColumn Text(255),
szObject Text(255),
szReferencedColumn Text(255),
szReferencedObject Text(255),
szRelationship Text(255)
)
CREATE TABLE MSysResources (
Data Unknown(4),
Extension Text(255),
Id Long(4),
Name Text(255),
Type Text(255)
)
CREATE TABLE Nom_Asset_Owned (
ID Long(4),
Asset_Owned Text(255)
)
CREATE TABLE Nom_Asset_Status (
ID Long(4),
Asset_Status_Code Text(20),
Asset_Status_Text Text(50)
)
CREATE TABLE Nom_Asset_Type (
ID Long(4),
Asset_Type_Text Text(255)
)
CREATE TABLE Nom_Asset_Usage (
ID Long(4),
Asset_Usage_Text Text(255)
)
CREATE TABLE Nom_Countries (
ID Long(4),
Country_Name Text(20),
Country_Full_Name Text(50),
Country_Local_Name Text(50),
Country_Code Text(2),
Currency_ID Long(4)
)
CREATE TABLE Nom_Currencies (
ID Long(4),
Currency_Code Text(255),
Currency_Name Text(255),
Currency_Symbol Text(3)
)
CREATE TABLE Nom_Financing_Type (
ID Long(4),
Financing_Type Text(10)
)
CREATE TABLE Nom_Log_Types (
ID Text(255),
Descr Text(255),
Color Text(255)
)
CREATE TABLE Nom_NPE_Status (
ID Long(4),
NPE_Status_Code Text(10),
NPE_Status_Text Text(50)
)
CREATE TABLE Nom_Scenarios (
ID Long(4),
Scenario_Name Text(50)
)
CREATE TABLE Nom_Transaction_Types (
ID Long(4),
Transaction_Code Text(255)
)
CREATE TABLE NPE_History (
ID Long(4),
NPE_ID Long(4),
Rep_Date Date/Time(8),
NPE_Status_ID Long(4),
NPE_Scenario_ID Long(4),
NPE_Rep_Date Date/Time(8),
NPE_Currency Text(255),
NPE_Amount_CCY Double(8),
NPE_Amount_EUR Double(8),
LLP_Amount_CCY Double(8),
LLP_Amount_EUR Double(8),
m_ID Long(4)
)
CREATE TABLE NPE_List (
ID Long(4),
NPE_Code Text(255),
NPE_Scenario_ID Long(4),
NPE_Country_ID Long(4),
NPE_Name Text(255),
NPE_Description Text(255),
NPE_Lender_ID Long(4),
NPE_Borrower_ID Long(4),
NPE_Currency_ID Long(4),
NPE_Amount_Date Date/Time(8),
NPE_Amount_CCY Double(8),
NPE_Amount_EUR Double(8),
LLP_Amount_CCY Double(8),
LLP_Amount_EUR Double(8),
NPE_Owned Long(4),
m_ID Long(4)
)
CREATE TABLE orig_shifted (
ver Text(255),
sign Long(4)
)
CREATE TABLE SST_Log (
ID Long(4),
Log_Date Date/Time(8),
Log_Source Text(255),
Log_Text Text(255),
Log_Type Text(255),
Mail_ID Long(4)
)
CREATE TABLE Users (
ID Long(4),
EMail Text(255),
FullName Text(255),
LE_ID Long(4)
)
CREATE VIEW del_Asset_Financials AS 
DELETE *
FROM Asset_Financials
WHERE m_id=-1
 and Asset_ID in (select old_parent.id from (Asset_Financials as new_tab0 inner join Assets_List new_parent on new_parent.id=new_tab0.Asset_ID) inner join Assets_List old_parent on new_parent.Asset_Code=old_parent.Asset_Code where new_tab0.m_ID=[:m_ID])
 and Rep_Date in (select new_tab1.Rep_Date from Asset_Financials as new_tab1 where new_tab1.m_id=[:m_ID]);

CREATE VIEW delAssetAppraisals AS 
DELETE *
FROM Asset_Appraisals;

CREATE VIEW delAssetFinancing AS 
DELETE *
FROM Asset_Financing;

CREATE VIEW delAssetInsurances AS 
DELETE *
FROM Asset_Insurances;

CREATE VIEW delEmptyAppraisals AS 
DELETE Asset_Appraisals.Appraisal_Date, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR
FROM Asset_Appraisals
WHERE (((Asset_Appraisals.Appraisal_Date) Is Null) AND ((Asset_Appraisals.Appraisal_Market_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Market_Value_EUR)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_EUR)=0));

CREATE VIEW delEmptyFinancing AS 
DELETE Asset_Financing.Financing_Amount_CCY, Asset_Financing.Financing_Amount_EUR, Asset_Financing.Financing_Start_Date, Asset_Financing.Financing_End_Date
FROM Asset_Financing
WHERE (((Asset_Financing.Financing_Amount_CCY)=0) AND ((Asset_Financing.Financing_Amount_EUR)=0) AND ((Asset_Financing.Financing_Start_Date) Is Null) AND ((Asset_Financing.Financing_End_Date) Is Null));

CREATE VIEW delEmptyInsurances AS 
DELETE Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR, Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date
FROM Asset_Insurances
WHERE (((Asset_Insurances.Insurance_Amount_CCY)=0) AND ((Asset_Insurances.Insurance_Amount_EUR)=0) AND ((Asset_Insurances.Insurance_Premium_CCY)=0) AND ((Asset_Insurances.Insurance_Premium_EUR)=0) AND ((Asset_Insurances.Insurance_Start_Date)=#1/1/2000#) AND ((Asset_Insurances.Insurance_End_Date) Is Null));

CREATE VIEW delEmptyRentals AS 
DELETE Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date
FROM Asset_Rentals
WHERE (((Asset_Rentals.Rental_Amount_CCY)=0) AND ((Asset_Rentals.Rental_Amount_EUR)=0) AND ((Asset_Rentals.Rental_Contract_Date)=#1/1/2000#) AND ((Asset_Rentals.Rental_Start_Date) Is Null) AND ((Asset_Rentals.Rental_End_Date) Is Null));

CREATE VIEW ins_Asset_Appraisals AS 
INSERT INTO Asset_Appraisals
SELECT new_parent.ID AS Appraisal_Asset_ID, new_tab.Appraisal_Company_ID AS Appraisal_Company_ID, new_tab.Appraisal_Date AS Appraisal_Date, new_tab.Appraisal_Currency_ID AS Appraisal_Currency_ID, new_tab.Appraisal_Market_Value_CCY AS Appraisal_Market_Value_CCY, new_tab.Appraisal_Market_Value_EUR AS Appraisal_Market_Value_EUR, new_tab.Appraisal_Firesale_Value_CCY AS Appraisal_Firesale_Value_CCY, new_tab.Appraisal_Firesale_Value_EUR AS Appraisal_Firesale_Value_EUR, new_tab.Appraisal_Order AS Appraisal_Order, -1 AS m_ID
FROM (Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Appraisals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Appraisal_Asset_ID=new_parent.id
   and dw_tab.Appraisal_Date=new_tab.Appraisal_Date
);

CREATE VIEW ins_Asset_Financials AS 
INSERT INTO Asset_Financials
SELECT new_parent.ID AS Asset_ID, new_tab.Acc_Date AS Acc_Date, new_tab.Account_No AS Account_No, new_tab.Account_Name AS Account_Name, new_tab.Amount AS Amount, new_tab.Trans_Type_ID AS Trans_Type_ID, new_tab.Rep_Date AS Rep_Date, -1 AS m_ID
FROM (Asset_Financials AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financials as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

CREATE VIEW ins_Asset_Financing AS 
INSERT INTO Asset_Financing
SELECT new_tab.Financing_Contract_Code AS Financing_Contract_Code, new_tab.Financing_Counterpart_ID AS Financing_Counterpart_ID, new_parent.ID AS Financing_Asset_ID, new_tab.Financing_Type_ID AS Financing_Type_ID, new_tab.Financing_Currency_ID AS Financing_Currency_ID, new_tab.Financing_Amount_CCY AS Financing_Amount_CCY, new_tab.Financing_Amount_EUR AS Financing_Amount_EUR, new_tab.Financing_Reference_Rate AS Financing_Reference_Rate, new_tab.Financing_Margin AS Financing_Margin, new_tab.Financing_Rate AS Financing_Rate, new_tab.Financing_Start_Date AS Financing_Start_Date, new_tab.Financing_End_Date AS Financing_End_Date, new_tab.Financing_Contract_Date AS Financing_Contract_Date, -1 AS m_ID
FROM (Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financing as dw_tab where dw_tab.m_id = -1
   and dw_tab.Financing_Asset_ID=new_parent.id
   and dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID
   and dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date
);

CREATE VIEW ins_Asset_History AS 
INSERT INTO Asset_History
SELECT new_parent.ID AS Asset_ID, new_tab.Rep_Date AS Rep_Date, new_tab.Status_Code AS Status_Code, new_tab.Book_Value AS Book_Value, new_tab.OPEX AS OPEX, new_tab.CAPEX AS CAPEX, new_tab.Expected_Exit AS Expected_Exit, -1 AS m_ID
FROM (Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

CREATE VIEW ins_Asset_Insurances AS 
INSERT INTO Asset_Insurances
SELECT new_parent.ID AS Insurance_Asset_ID, new_tab.Insurance_Company_ID AS Insurance_Company_ID, new_tab.Insurance_Start_Date AS Insurance_Start_Date, new_tab.Insurance_End_Date AS Insurance_End_Date, new_tab.Insurance_Currency_ID AS Insurance_Currency_ID, new_tab.Insurance_Amount_CCY AS Insurance_Amount_CCY, new_tab.Insurance_Amount_EUR AS Insurance_Amount_EUR, new_tab.Insurance_Premium_CCY AS Insurance_Premium_CCY, new_tab.Insurance_Premium_EUR AS Insurance_Premium_EUR, -1 AS m_ID
FROM (Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Insurances as dw_tab where dw_tab.m_id = -1
   and dw_tab.Insurance_Asset_ID=new_parent.id
   and dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date
);

CREATE VIEW ins_Asset_Rentals AS 
INSERT INTO Asset_Rentals
SELECT new_parent.ID AS Rental_Asset_ID, new_tab.Rental_Counterpart_ID AS Rental_Counterpart_ID, new_tab.Rental_Contract_Date AS Rental_Contract_Date, new_tab.Rental_Start_Date AS Rental_Start_Date, new_tab.Rental_End_Date AS Rental_End_Date, new_tab.Rental_Payment_Date AS Rental_Payment_Date, new_tab.Rental_Currency_ID AS Rental_Currency_ID, new_tab.Rental_Amount_CCY AS Rental_Amount_CCY, new_tab.Rental_Amount_EUR AS Rental_Amount_EUR, -1 AS m_ID
FROM (Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Rentals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Rental_Asset_ID=new_parent.id
   and dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date
);

CREATE VIEW ins_Asset_Repossession AS 
INSERT INTO Asset_Repossession
SELECT new_parent.ID AS Repossession_Asset_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_Currency_ID AS Purchase_Price_Currency_ID, new_tab.Appr_Purchase_Price_Net_CCY AS Appr_Purchase_Price_Net_CCY, new_tab.Appr_Purchase_Price_Net_EUR AS Appr_Purchase_Price_Net_EUR, new_tab.Purchase_Price_Net_CCY AS Purchase_Price_Net_CCY, new_tab.Purchase_Price_Net_EUR AS Purchase_Price_Net_EUR, new_tab.Purchase_Costs_CCY AS Purchase_Costs_CCY, new_tab.Purchase_Costs_EUR AS Purchase_Costs_EUR, new_tab.Planned_CAPEX_Currency_ID AS Planned_CAPEX_Currency_ID, new_tab.Planned_CAPEX_CCY AS Planned_CAPEX_CCY, new_tab.Planned_CAPEX_EUR AS Planned_CAPEX_EUR, new_tab.Planned_CAPEX_Comment AS Planned_CAPEX_Comment, new_tab.Purchase_Auction_Date AS Purchase_Auction_Date, new_tab.Purchase_Contract_Date AS Purchase_Contract_Date, new_tab.Purchase_Repossession_Date AS Purchase_Repossession_Date, new_tab.Purchase_Payment_Date AS Purchase_Payment_Date, new_tab.Purchase_Handover_Date AS Purchase_Handover_Date, new_tab.Purchase_Registration_Date AS Purchase_Registration_Date, new_tab.Purchase_Local_Approval_Date AS Purchase_Local_Approval_Date, new_tab.Purchase_Central_Approval_Date AS Purchase_Central_Approval_Date, new_tab.Purchase_Prolongation_Date AS Purchase_Prolongation_Date, new_tab.Purchase_Expected_Exit_Date AS Purchase_Expected_Exit_Date, new_tab.Planned_OPEX_CCY AS Planned_OPEX_CCY, new_tab.Planned_OPEX_EUR AS Planned_OPEX_EUR, new_tab.Planned_OPEX_Comment AS Planned_OPEX_Comment, new_tab.Planned_SalesPrice_CCY AS Planned_SalesPrice_CCY, new_tab.Planned_SalesPrice_EUR AS Planned_SalesPrice_EUR, -1 AS m_ID
FROM (Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Repossession as dw_tab where dw_tab.m_id = -1
   and dw_tab.Repossession_Asset_ID=new_parent.id
   and dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date
);

CREATE VIEW ins_Asset_Sales AS 
INSERT INTO Asset_Sales
SELECT new_parent.ID AS Sale_Asset_ID, new_tab.Sale_Counterpart_ID AS Sale_Counterpart_ID, new_tab.Sale_Approval_Date AS Sale_Approval_Date, new_tab.Sale_Contract_Date AS Sale_Contract_Date, new_tab.Sale_Transfer_Date AS Sale_Transfer_Date, new_tab.Sale_Payment_Date AS Sale_Payment_Date, new_tab.Sale_AML_Check_Date AS Sale_AML_Check_Date, new_tab.Sale_AML_Pass_Date AS Sale_AML_Pass_Date, new_tab.Sale_Currency_ID AS Sale_Currency_ID, new_tab.Sale_ApprovedAmt_CCY AS Sale_ApprovedAmt_CCY, new_tab.Sale_ApprovedAmt_EUR AS Sale_ApprovedAmt_EUR, new_tab.Sale_Amount_CCY AS Sale_Amount_CCY, new_tab.Sale_Amount_EUR AS Sale_Amount_EUR, new_tab.Sale_Book_Value_CCY AS Sale_Book_Value_CCY, new_tab.Sale_Book_Value_EUR AS Sale_Book_Value_EUR, -1 AS m_ID
FROM (Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Sales as dw_tab where dw_tab.m_id = -1
   and dw_tab.Sale_Asset_ID=new_parent.id
   and dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date
);

CREATE VIEW ins_Assets_List AS 
INSERT INTO Assets_List
SELECT new_tab.Asset_Code AS Asset_Code, new_parent.ID AS Asset_NPE_ID, new_tab.Asset_Name AS Asset_Name, new_tab.Asset_Description AS Asset_Description, new_tab.Asset_Address AS Asset_Address, new_tab.Asset_ZIP AS Asset_ZIP, new_tab.Asset_Region AS Asset_Region, new_tab.Asset_Country_ID AS Asset_Country_ID, new_tab.Asset_Usage_ID AS Asset_Usage_ID, new_tab.Asset_Type_ID AS Asset_Type_ID, new_tab.Asset_Usable_Area AS Asset_Usable_Area, new_tab.Asset_Common_Area AS Asset_Common_Area, new_tab.Asset_Owned AS Asset_Owned, new_tab.Comment AS Comment, -1 AS m_ID
FROM (Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from Assets_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_Code=new_tab.Asset_Code
);

CREATE VIEW ins_Assets_List2 AS 
INSERT INTO Assets_List ( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID )
SELECT Assets_List.Asset_Code, NPE_List_DW.ID, Assets_List.Asset_Name, Assets_List.Asset_Description, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Assets_List.Asset_Country_ID, Assets_List.Asset_Usage_ID, Assets_List.Asset_Type_ID, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Asset_Owned, Assets_List.Comment, -1 AS DW_m_ID
FROM (NPE_List INNER JOIN Assets_List ON NPE_List.ID = Assets_List.Asset_NPE_ID) INNER JOIN NPE_List AS NPE_List_DW ON NPE_List.NPE_Code = NPE_List_DW.NPE_Code
WHERE (((Assets_List.m_ID)=[:m_ID]) AND ((Exists (select 1 from Assets_list al_dwh where al_dwh.asset_code=assets_list.Asset_Code))=False));

CREATE VIEW ins_NPE_History AS 
INSERT INTO NPE_History
SELECT new_parent.ID AS NPE_ID, new_tab.Rep_Date AS Rep_Date, new_tab.NPE_Status_ID AS NPE_Status_ID, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Rep_Date AS NPE_Rep_Date, new_tab.NPE_Currency AS NPE_Currency, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, -1 AS m_ID
FROM (NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = [:m_ID]
 and new_parent.m_id=-1
   and not exists (select 1 from NPE_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
   and dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID
);

CREATE VIEW ins_NPE_List AS 
INSERT INTO NPE_List
SELECT new_tab.NPE_Code AS NPE_Code, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Country_ID AS NPE_Country_ID, new_tab.NPE_Name AS NPE_Name, new_tab.NPE_Description AS NPE_Description, new_tab.NPE_Lender_ID AS NPE_Lender_ID, new_tab.NPE_Borrower_ID AS NPE_Borrower_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_Date AS NPE_Amount_Date, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.NPE_Owned AS NPE_Owned, -1 AS m_ID
FROM NPE_List AS new_tab
WHERE new_tab.m_id = [:m_ID]
   and not exists (select 1 from NPE_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_Code=new_tab.NPE_Code
);

CREATE VIEW NPE_per_scenario AS 
TRANSFORM Sum(NPE_History.NPE_Amount_EUR) AS SumÕ‡NPE_Amount_EUR
SELECT Year([npe_rep_date]) AS [Year]
FROM NPE_History INNER JOIN Nom_Scenarios ON NPE_History.NPE_Scenario_ID = Nom_Scenarios.ID
WHERE (((NPE_History.NPE_Amount_EUR)<>0))
GROUP BY Year([npe_rep_date])
PIVOT Nom_Scenarios.Scenario_Name;

CREATE VIEW NPE_Status AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Nom_Scenarios.Scenario_Name, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR, NPE_List.NPE_Owned, NPE_History.NPE_Status_Date, Nom_NPE_Status.NPE_Status_Code, Max(Currencies_1.Currency_Code) AS MaxÕ‡Currency_Code, Sum(Asset_Repossession.NPE_Amount_CCY) AS SumÕ‡NPE_Amount_CCY, Sum(Asset_Repossession.NPE_Amount_EUR) AS SumÕ‡NPE_Amount_EUR, Sum(Asset_Repossession.LLP_Amount_CCY) AS SumÕ‡LLP_Amount_CCY, Sum(Asset_Repossession.LLP_Amount_EUR) AS SumÕ‡LLP_Amount_EUR
FROM ((Nom_Currencies RIGHT JOIN (NPE_List LEFT JOIN Nom_Scenarios ON NPE_List.NPE_Scenario_ID = Nom_Scenarios.ID) ON Nom_Currencies.ID = NPE_List.NPE_Currency_ID) LEFT JOIN (Assets_List LEFT JOIN (Nom_Currencies AS Currencies_1 RIGHT JOIN Asset_Repossession ON Currencies_1.ID = Asset_Repossession.NPE_Currency_ID) ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID) LEFT JOIN (Nom_NPE_Status RIGHT JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID
GROUP BY NPE_List.NPE_Code, NPE_List.NPE_Name, Nom_Scenarios.Scenario_Name, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR, NPE_List.NPE_Owned, NPE_History.NPE_Status_Date, Nom_NPE_Status.NPE_Status_Code;

CREATE VIEW sel_Asset_Appraisals AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, Counterparts0.Counterpart_Common_Name,null)) AS old_Appraisal_Company_ID, max(iif(tab.m_id<>-1, Counterparts0.Counterpart_Common_Name,null)) AS new_Appraisal_Company_ID, tab.Appraisal_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Appraisal_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Appraisal_Currency_ID, max(iif(tab.m_id=-1, tab.Appraisal_Market_Value_CCY,null)) AS old_Appraisal_Market_Value_CCY, max(iif(tab.m_id<>-1, tab.Appraisal_Market_Value_CCY,null)) AS new_Appraisal_Market_Value_CCY, max(iif(tab.m_id=-1, tab.Appraisal_Market_Value_EUR,null)) AS old_Appraisal_Market_Value_EUR, max(iif(tab.m_id<>-1, tab.Appraisal_Market_Value_EUR,null)) AS new_Appraisal_Market_Value_EUR, max(iif(tab.m_id=-1, tab.Appraisal_Firesale_Value_CCY,null)) AS old_Appraisal_Firesale_Value_CCY, max(iif(tab.m_id<>-1, tab.Appraisal_Firesale_Value_CCY,null)) AS new_Appraisal_Firesale_Value_CCY, max(iif(tab.m_id=-1, tab.Appraisal_Firesale_Value_EUR,null)) AS old_Appraisal_Firesale_Value_EUR, max(iif(tab.m_id<>-1, tab.Appraisal_Firesale_Value_EUR,null)) AS new_Appraisal_Firesale_Value_EUR, max(iif(tab.m_id=-1, tab.Appraisal_Order,null)) AS old_Appraisal_Order, max(iif(tab.m_id<>-1, tab.Appraisal_Order,null)) AS new_Appraisal_Order
FROM ((Asset_Appraisals AS tab LEFT JOIN Counterparts AS Counterparts0 ON Counterparts0.id=tab.Appraisal_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Appraisal_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Appraisal_Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Appraisal_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Financials AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, tab.Acc_Date,null)) AS old_Acc_Date, max(iif(tab.m_id<>-1, tab.Acc_Date,null)) AS new_Acc_Date, max(iif(tab.m_id=-1, tab.Account_No,null)) AS old_Account_No, max(iif(tab.m_id<>-1, tab.Account_No,null)) AS new_Account_No, max(iif(tab.m_id=-1, tab.Account_Name,null)) AS old_Account_Name, max(iif(tab.m_id<>-1, tab.Account_Name,null)) AS new_Account_Name, max(iif(tab.m_id=-1, tab.Amount,null)) AS old_Amount, max(iif(tab.m_id<>-1, tab.Amount,null)) AS new_Amount, max(iif(tab.m_id=-1, tab.Trans_Type_ID,null)) AS old_Trans_Type_ID, max(iif(tab.m_id<>-1, tab.Trans_Type_ID,null)) AS new_Trans_Type_ID, tab.Rep_Date
FROM Asset_Financials AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Rep_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Financing AS 
SELECT Max(IIf(Tab.m_id=-1,Tab.Financing_Contract_Code,Null)) AS old_Financing_Contract_Code, Max(IIf(Tab.m_id<>-1,Tab.Financing_Contract_Code,Null)) AS new_Financing_Contract_Code, Max(IIf(Tab.m_id=-1,vwCounterparts0.Descr,Null)) AS old_Financing_Counterpart_ID, Max(IIf(Tab.m_id<>-1,vwCounterparts0.Descr,Null)) AS new_Financing_Counterpart_ID, parent.Asset_Code, (select Nom_Financing_Type.Financing_Type from Nom_Financing_Type where id=tab.Financing_Type_ID) AS Financing_Type_ID, Max(IIf(Tab.m_id=-1,Nom_Currencies2.Currency_Code,Null)) AS old_Financing_Currency_ID, Max(IIf(Tab.m_id<>-1,Nom_Currencies2.Currency_Code,Null)) AS new_Financing_Currency_ID, Max(IIf(Tab.m_id=-1,Tab.Financing_Amount_CCY,Null)) AS old_Financing_Amount_CCY, Max(IIf(Tab.m_id<>-1,Tab.Financing_Amount_CCY,Null)) AS new_Financing_Amount_CCY, Max(IIf(Tab.m_id=-1,Tab.Financing_Amount_EUR,Null)) AS old_Financing_Amount_EUR, Max(IIf(Tab.m_id<>-1,Tab.Financing_Amount_EUR,Null)) AS new_Financing_Amount_EUR, Max(IIf(Tab.m_id=-1,Tab.Financing_Reference_Rate,Null)) AS old_Financing_Reference_Rate, Max(IIf(Tab.m_id<>-1,Tab.Financing_Reference_Rate,Null)) AS new_Financing_Reference_Rate, Max(IIf(Tab.m_id=-1,Tab.Financing_Margin,Null)) AS old_Financing_Margin, Max(IIf(Tab.m_id<>-1,Tab.Financing_Margin,Null)) AS new_Financing_Margin, Max(IIf(Tab.m_id=-1,Tab.Financing_Rate,Null)) AS old_Financing_Rate, Max(IIf(Tab.m_id<>-1,Tab.Financing_Rate,Null)) AS new_Financing_Rate, tab.Financing_Start_Date, Max(IIf(Tab.m_id=-1,Tab.Financing_End_Date,Null)) AS old_Financing_End_Date, Max(IIf(Tab.m_id<>-1,Tab.Financing_End_Date,Null)) AS new_Financing_End_Date, Max(IIf(Tab.m_id=-1,Tab.Financing_Contract_Date,Null)) AS old_Financing_Contract_Date, Max(IIf(Tab.m_id<>-1,Tab.Financing_Contract_Date,Null)) AS new_Financing_Contract_Date
FROM (((Asset_Financing AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON tab.Financing_Counterpart_ID = vwCounterparts0.id) LEFT JOIN Nom_Financing_Type AS Nom_Financing_Type1 ON tab.Financing_Type_ID = Nom_Financing_Type1.id) LEFT JOIN Nom_Currencies AS Nom_Currencies2 ON tab.Financing_Currency_ID = Nom_Currencies2.id) INNER JOIN Assets_List AS parent ON tab.Financing_Asset_ID = parent.id
WHERE (((tab.m_id) In ([:m_ID],-1)))
GROUP BY parent.Asset_Code, tab.Financing_Start_Date, tab.Financing_Type_ID
HAVING (((Max(tab.m_id))>-1));

CREATE VIEW sel_Asset_History AS 
SELECT parent.Asset_Code, tab.Rep_Date, max(iif(tab.m_id=-1, tab.Status_Code,null)) AS old_Status_Code, max(iif(tab.m_id<>-1, tab.Status_Code,null)) AS new_Status_Code, max(iif(tab.m_id=-1, tab.Book_Value,null)) AS old_Book_Value, max(iif(tab.m_id<>-1, tab.Book_Value,null)) AS new_Book_Value, max(iif(tab.m_id=-1, tab.OPEX,null)) AS old_OPEX, max(iif(tab.m_id<>-1, tab.OPEX,null)) AS new_OPEX, max(iif(tab.m_id=-1, tab.CAPEX,null)) AS old_CAPEX, max(iif(tab.m_id<>-1, tab.CAPEX,null)) AS new_CAPEX, max(iif(tab.m_id=-1, tab.Expected_Exit,null)) AS old_Expected_Exit, max(iif(tab.m_id<>-1, tab.Expected_Exit,null)) AS new_Expected_Exit
FROM Asset_History AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Rep_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Insurances AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Insurance_Company_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Insurance_Company_ID, tab.Insurance_Start_Date, max(iif(tab.m_id=-1, tab.Insurance_End_Date,null)) AS old_Insurance_End_Date, max(iif(tab.m_id<>-1, tab.Insurance_End_Date,null)) AS new_Insurance_End_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Insurance_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Insurance_Currency_ID, max(iif(tab.m_id=-1, tab.Insurance_Amount_CCY,null)) AS old_Insurance_Amount_CCY, max(iif(tab.m_id<>-1, tab.Insurance_Amount_CCY,null)) AS new_Insurance_Amount_CCY, max(iif(tab.m_id=-1, tab.Insurance_Amount_EUR,null)) AS old_Insurance_Amount_EUR, max(iif(tab.m_id<>-1, tab.Insurance_Amount_EUR,null)) AS new_Insurance_Amount_EUR, max(iif(tab.m_id=-1, tab.Insurance_Premium_CCY,null)) AS old_Insurance_Premium_CCY, max(iif(tab.m_id<>-1, tab.Insurance_Premium_CCY,null)) AS new_Insurance_Premium_CCY, max(iif(tab.m_id=-1, tab.Insurance_Premium_EUR,null)) AS old_Insurance_Premium_EUR, max(iif(tab.m_id<>-1, tab.Insurance_Premium_EUR,null)) AS new_Insurance_Premium_EUR
FROM ((Asset_Insurances AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Insurance_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Insurance_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Insurance_Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Insurance_Start_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Rentals AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Rental_Counterpart_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Rental_Counterpart_ID, tab.Rental_Contract_Date, max(iif(tab.m_id=-1, tab.Rental_Start_Date,null)) AS old_Rental_Start_Date, max(iif(tab.m_id<>-1, tab.Rental_Start_Date,null)) AS new_Rental_Start_Date, max(iif(tab.m_id=-1, tab.Rental_End_Date,null)) AS old_Rental_End_Date, max(iif(tab.m_id<>-1, tab.Rental_End_Date,null)) AS new_Rental_End_Date, max(iif(tab.m_id=-1, tab.Rental_Payment_Date,null)) AS old_Rental_Payment_Date, max(iif(tab.m_id<>-1, tab.Rental_Payment_Date,null)) AS new_Rental_Payment_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Rental_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Rental_Currency_ID, max(iif(tab.m_id=-1, tab.Rental_Amount_CCY,null)) AS old_Rental_Amount_CCY, max(iif(tab.m_id<>-1, tab.Rental_Amount_CCY,null)) AS new_Rental_Amount_CCY, max(iif(tab.m_id=-1, tab.Rental_Amount_EUR,null)) AS old_Rental_Amount_EUR, max(iif(tab.m_id<>-1, tab.Rental_Amount_EUR,null)) AS new_Rental_Amount_EUR
FROM ((Asset_Rentals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Rental_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Rental_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Rental_Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Rental_Contract_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Repossession AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, tab.NPE_Currency_ID,null)) AS old_NPE_Currency_ID, max(iif(tab.m_id<>-1, tab.NPE_Currency_ID,null)) AS new_NPE_Currency_ID, max(iif(tab.m_id=-1, tab.NPE_Amount_CCY,null)) AS old_NPE_Amount_CCY, max(iif(tab.m_id<>-1, tab.NPE_Amount_CCY,null)) AS new_NPE_Amount_CCY, max(iif(tab.m_id=-1, tab.NPE_Amount_EUR,null)) AS old_NPE_Amount_EUR, max(iif(tab.m_id<>-1, tab.NPE_Amount_EUR,null)) AS new_NPE_Amount_EUR, max(iif(tab.m_id=-1, tab.LLP_Amount_CCY,null)) AS old_LLP_Amount_CCY, max(iif(tab.m_id<>-1, tab.LLP_Amount_CCY,null)) AS new_LLP_Amount_CCY, max(iif(tab.m_id=-1, tab.LLP_Amount_EUR,null)) AS old_LLP_Amount_EUR, max(iif(tab.m_id<>-1, tab.LLP_Amount_EUR,null)) AS new_LLP_Amount_EUR, max(iif(tab.m_id=-1, tab.Purchase_Price_Currency_ID,null)) AS old_Purchase_Price_Currency_ID, max(iif(tab.m_id<>-1, tab.Purchase_Price_Currency_ID,null)) AS new_Purchase_Price_Currency_ID, max(iif(tab.m_id=-1, tab.Appr_Purchase_Price_Net_CCY,null)) AS old_Appr_Purchase_Price_Net_CCY, max(iif(tab.m_id<>-1, tab.Appr_Purchase_Price_Net_CCY,null)) AS new_Appr_Purchase_Price_Net_CCY, max(iif(tab.m_id=-1, tab.Appr_Purchase_Price_Net_EUR,null)) AS old_Appr_Purchase_Price_Net_EUR, max(iif(tab.m_id<>-1, tab.Appr_Purchase_Price_Net_EUR,null)) AS new_Appr_Purchase_Price_Net_EUR, max(iif(tab.m_id=-1, tab.Purchase_Price_Net_CCY,null)) AS old_Purchase_Price_Net_CCY, max(iif(tab.m_id<>-1, tab.Purchase_Price_Net_CCY,null)) AS new_Purchase_Price_Net_CCY, max(iif(tab.m_id=-1, tab.Purchase_Price_Net_EUR,null)) AS old_Purchase_Price_Net_EUR, max(iif(tab.m_id<>-1, tab.Purchase_Price_Net_EUR,null)) AS new_Purchase_Price_Net_EUR, max(iif(tab.m_id=-1, tab.Purchase_Costs_CCY,null)) AS old_Purchase_Costs_CCY, max(iif(tab.m_id<>-1, tab.Purchase_Costs_CCY,null)) AS new_Purchase_Costs_CCY, max(iif(tab.m_id=-1, tab.Purchase_Costs_EUR,null)) AS old_Purchase_Costs_EUR, max(iif(tab.m_id<>-1, tab.Purchase_Costs_EUR,null)) AS new_Purchase_Costs_EUR, max(iif(tab.m_id=-1, tab.Planned_CAPEX_Currency_ID,null)) AS old_Planned_CAPEX_Currency_ID, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_Currency_ID,null)) AS new_Planned_CAPEX_Currency_ID, max(iif(tab.m_id=-1, tab.Planned_CAPEX_CCY,null)) AS old_Planned_CAPEX_CCY, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_CCY,null)) AS new_Planned_CAPEX_CCY, max(iif(tab.m_id=-1, tab.Planned_CAPEX_EUR,null)) AS old_Planned_CAPEX_EUR, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_EUR,null)) AS new_Planned_CAPEX_EUR, max(iif(tab.m_id=-1, tab.Planned_CAPEX_Comment,null)) AS old_Planned_CAPEX_Comment, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_Comment,null)) AS new_Planned_CAPEX_Comment, tab.Purchase_Auction_Date, max(iif(tab.m_id=-1, tab.Purchase_Contract_Date,null)) AS old_Purchase_Contract_Date, max(iif(tab.m_id<>-1, tab.Purchase_Contract_Date,null)) AS new_Purchase_Contract_Date, max(iif(tab.m_id=-1, tab.Purchase_Repossession_Date,null)) AS old_Purchase_Repossession_Date, max(iif(tab.m_id<>-1, tab.Purchase_Repossession_Date,null)) AS new_Purchase_Repossession_Date, max(iif(tab.m_id=-1, tab.Purchase_Payment_Date,null)) AS old_Purchase_Payment_Date, max(iif(tab.m_id<>-1, tab.Purchase_Payment_Date,null)) AS new_Purchase_Payment_Date, max(iif(tab.m_id=-1, tab.Purchase_Handover_Date,null)) AS old_Purchase_Handover_Date, max(iif(tab.m_id<>-1, tab.Purchase_Handover_Date,null)) AS new_Purchase_Handover_Date, max(iif(tab.m_id=-1, tab.Purchase_Registration_Date,null)) AS old_Purchase_Registration_Date, max(iif(tab.m_id<>-1, tab.Purchase_Registration_Date,null)) AS new_Purchase_Registration_Date, max(iif(tab.m_id=-1, tab.Purchase_Local_Approval_Date,null)) AS old_Purchase_Local_Approval_Date, max(iif(tab.m_id<>-1, tab.Purchase_Local_Approval_Date,null)) AS new_Purchase_Local_Approval_Date, max(iif(tab.m_id=-1, tab.Purchase_Central_Approval_Date,null)) AS old_Purchase_Central_Approval_Date, max(iif(tab.m_id<>-1, tab.Purchase_Central_Approval_Date,null)) AS new_Purchase_Central_Approval_Date, max(iif(tab.m_id=-1, tab.Purchase_Prolongation_Date,null)) AS old_Purchase_Prolongation_Date, max(iif(tab.m_id<>-1, tab.Purchase_Prolongation_Date,null)) AS new_Purchase_Prolongation_Date, max(iif(tab.m_id=-1, tab.Purchase_Expected_Exit_Date,null)) AS old_Purchase_Expected_Exit_Date, max(iif(tab.m_id<>-1, tab.Purchase_Expected_Exit_Date,null)) AS new_Purchase_Expected_Exit_Date, max(iif(tab.m_id=-1, tab.Planned_OPEX_CCY,null)) AS old_Planned_OPEX_CCY, max(iif(tab.m_id<>-1, tab.Planned_OPEX_CCY,null)) AS new_Planned_OPEX_CCY, max(iif(tab.m_id=-1, tab.Planned_OPEX_EUR,null)) AS old_Planned_OPEX_EUR, max(iif(tab.m_id<>-1, tab.Planned_OPEX_EUR,null)) AS new_Planned_OPEX_EUR, max(iif(tab.m_id=-1, tab.Planned_OPEX_Comment,null)) AS old_Planned_OPEX_Comment, max(iif(tab.m_id<>-1, tab.Planned_OPEX_Comment,null)) AS new_Planned_OPEX_Comment, max(iif(tab.m_id=-1, tab.Planned_SalesPrice_CCY,null)) AS old_Planned_SalesPrice_CCY, max(iif(tab.m_id<>-1, tab.Planned_SalesPrice_CCY,null)) AS new_Planned_SalesPrice_CCY, max(iif(tab.m_id=-1, tab.Planned_SalesPrice_EUR,null)) AS old_Planned_SalesPrice_EUR, max(iif(tab.m_id<>-1, tab.Planned_SalesPrice_EUR,null)) AS new_Planned_SalesPrice_EUR
FROM Asset_Repossession AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Repossession_Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Purchase_Auction_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Asset_Sales AS 
SELECT parent.Asset_Code, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Sale_Counterpart_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Sale_Counterpart_ID, tab.Sale_Approval_Date, max(iif(tab.m_id=-1, tab.Sale_Contract_Date,null)) AS old_Sale_Contract_Date, max(iif(tab.m_id<>-1, tab.Sale_Contract_Date,null)) AS new_Sale_Contract_Date, max(iif(tab.m_id=-1, tab.Sale_Transfer_Date,null)) AS old_Sale_Transfer_Date, max(iif(tab.m_id<>-1, tab.Sale_Transfer_Date,null)) AS new_Sale_Transfer_Date, max(iif(tab.m_id=-1, tab.Sale_Payment_Date,null)) AS old_Sale_Payment_Date, max(iif(tab.m_id<>-1, tab.Sale_Payment_Date,null)) AS new_Sale_Payment_Date, max(iif(tab.m_id=-1, tab.Sale_AML_Check_Date,null)) AS old_Sale_AML_Check_Date, max(iif(tab.m_id<>-1, tab.Sale_AML_Check_Date,null)) AS new_Sale_AML_Check_Date, max(iif(tab.m_id=-1, tab.Sale_AML_Pass_Date,null)) AS old_Sale_AML_Pass_Date, max(iif(tab.m_id<>-1, tab.Sale_AML_Pass_Date,null)) AS new_Sale_AML_Pass_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Sale_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Sale_Currency_ID, max(iif(tab.m_id=-1, tab.Sale_ApprovedAmt_CCY,null)) AS old_Sale_ApprovedAmt_CCY, max(iif(tab.m_id<>-1, tab.Sale_ApprovedAmt_CCY,null)) AS new_Sale_ApprovedAmt_CCY, max(iif(tab.m_id=-1, tab.Sale_ApprovedAmt_EUR,null)) AS old_Sale_ApprovedAmt_EUR, max(iif(tab.m_id<>-1, tab.Sale_ApprovedAmt_EUR,null)) AS new_Sale_ApprovedAmt_EUR, max(iif(tab.m_id=-1, tab.Sale_Amount_CCY,null)) AS old_Sale_Amount_CCY, max(iif(tab.m_id<>-1, tab.Sale_Amount_CCY,null)) AS new_Sale_Amount_CCY, max(iif(tab.m_id=-1, tab.Sale_Amount_EUR,null)) AS old_Sale_Amount_EUR, max(iif(tab.m_id<>-1, tab.Sale_Amount_EUR,null)) AS new_Sale_Amount_EUR, max(iif(tab.m_id=-1, tab.Sale_Book_Value_CCY,null)) AS old_Sale_Book_Value_CCY, max(iif(tab.m_id<>-1, tab.Sale_Book_Value_CCY,null)) AS new_Sale_Book_Value_CCY, max(iif(tab.m_id=-1, tab.Sale_Book_Value_EUR,null)) AS old_Sale_Book_Value_EUR, max(iif(tab.m_id<>-1, tab.Sale_Book_Value_EUR,null)) AS new_Sale_Book_Value_EUR
FROM ((Asset_Sales AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Sale_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Sale_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Sale_Asset_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code, Sale_Approval_Date
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_Assets_List AS 
SELECT tab.Asset_Code, max(iif(tab.m_id=-1, parent.NPE_Code,null)) AS old_NPE_Code, max(iif(tab.m_id<>-1, parent.NPE_Code,null)) AS new_NPE_Code, max(iif(tab.m_id=-1, tab.Asset_Name,null)) AS old_Asset_Name, max(iif(tab.m_id<>-1, tab.Asset_Name,null)) AS new_Asset_Name, max(iif(tab.m_id=-1, tab.Asset_Description,null)) AS old_Asset_Description, max(iif(tab.m_id<>-1, tab.Asset_Description,null)) AS new_Asset_Description, max(iif(tab.m_id=-1, tab.Asset_Address,null)) AS old_Asset_Address, max(iif(tab.m_id<>-1, tab.Asset_Address,null)) AS new_Asset_Address, max(iif(tab.m_id=-1, tab.Asset_ZIP,null)) AS old_Asset_ZIP, max(iif(tab.m_id<>-1, tab.Asset_ZIP,null)) AS new_Asset_ZIP, max(iif(tab.m_id=-1, tab.Asset_Region,null)) AS old_Asset_Region, max(iif(tab.m_id<>-1, tab.Asset_Region,null)) AS new_Asset_Region, max(iif(tab.m_id=-1, Nom_Countries0.Country_Name,null)) AS old_Asset_Country_ID, max(iif(tab.m_id<>-1, Nom_Countries0.Country_Name,null)) AS new_Asset_Country_ID, max(iif(tab.m_id=-1, Nom_Asset_Usage1.Asset_Usage_Text,null)) AS old_Asset_Usage_ID, max(iif(tab.m_id<>-1, Nom_Asset_Usage1.Asset_Usage_Text,null)) AS new_Asset_Usage_ID, max(iif(tab.m_id=-1, Nom_Asset_Type2.Asset_Type_Text,null)) AS old_Asset_Type_ID, max(iif(tab.m_id<>-1, Nom_Asset_Type2.Asset_Type_Text,null)) AS new_Asset_Type_ID, max(iif(tab.m_id=-1, tab.Asset_Usable_Area,null)) AS old_Asset_Usable_Area, max(iif(tab.m_id<>-1, tab.Asset_Usable_Area,null)) AS new_Asset_Usable_Area, max(iif(tab.m_id=-1, tab.Asset_Common_Area,null)) AS old_Asset_Common_Area, max(iif(tab.m_id<>-1, tab.Asset_Common_Area,null)) AS new_Asset_Common_Area, max(iif(tab.m_id=-1, Nom_Asset_Owned3.Asset_Owned,null)) AS old_Asset_Owned, max(iif(tab.m_id<>-1, Nom_Asset_Owned3.Asset_Owned,null)) AS new_Asset_Owned, max(iif(tab.m_id=-1, tab.Comment,null)) AS old_Comment, max(iif(tab.m_id<>-1, tab.Comment,null)) AS new_Comment
FROM ((((Assets_List AS tab LEFT JOIN Nom_Countries AS Nom_Countries0 ON Nom_Countries0.id=tab.Asset_Country_ID) LEFT JOIN Nom_Asset_Usage AS Nom_Asset_Usage1 ON Nom_Asset_Usage1.id=tab.Asset_Usage_ID) LEFT JOIN Nom_Asset_Type AS Nom_Asset_Type2 ON Nom_Asset_Type2.id=tab.Asset_Type_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned3 ON Nom_Asset_Owned3.id=tab.Asset_Owned) INNER JOIN NPE_List AS parent ON parent.id=tab.Asset_NPE_ID
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY Asset_Code
HAVING max(tab.m_id)>-1;

CREATE VIEW sel_NPE_History AS 
SELECT parent.NPE_Code, tab.Rep_Date, Max(IIf(Tab.m_id=-1,Tab.NPE_Status_ID,Null)) AS old_NPE_Status_ID, Max(IIf(Tab.m_id<>-1,Tab.NPE_Status_ID,Null)) AS new_NPE_Status_ID, tab.NPE_Scenario_ID, Max(IIf(Tab.m_id=-1,Tab.NPE_Rep_Date,Null)) AS old_NPE_Rep_Date, Max(IIf(Tab.m_id<>-1,Tab.NPE_Rep_Date,Null)) AS new_NPE_Rep_Date, Max(IIf(Tab.m_id=-1,Tab.NPE_Currency,Null)) AS old_NPE_Currency, Max(IIf(Tab.m_id<>-1,Tab.NPE_Currency,Null)) AS new_NPE_Currency, Max(IIf(Tab.m_id=-1,Tab.NPE_Amount_CCY,Null)) AS old_NPE_Amount_CCY, Max(IIf(Tab.m_id<>-1,Tab.NPE_Amount_CCY,Null)) AS new_NPE_Amount_CCY, Max(IIf(Tab.m_id=-1,Tab.NPE_Amount_EUR,Null)) AS old_NPE_Amount_EUR, Max(IIf(Tab.m_id<>-1,Tab.NPE_Amount_EUR,Null)) AS new_NPE_Amount_EUR, Max(IIf(Tab.m_id=-1,Tab.LLP_Amount_CCY,Null)) AS old_LLP_Amount_CCY, Max(IIf(Tab.m_id<>-1,Tab.LLP_Amount_CCY,Null)) AS new_LLP_Amount_CCY, Max(IIf(Tab.m_id=-1,Tab.LLP_Amount_EUR,Null)) AS old_LLP_Amount_EUR, Max(IIf(Tab.m_id<>-1,Tab.LLP_Amount_EUR,Null)) AS new_LLP_Amount_EUR
FROM NPE_History AS tab INNER JOIN NPE_List AS parent ON tab.NPE_ID = parent.id
WHERE (((tab.m_id) In ([:m_ID],-1)))
GROUP BY parent.NPE_Code, tab.Rep_Date, tab.NPE_Scenario_ID
HAVING (((Max(tab.m_id))>-1));

CREATE VIEW sel_NPE_List AS 
SELECT tab.NPE_Code, max(iif(tab.m_id=-1, Nom_Scenarios0.Scenario_Name,null)) AS old_NPE_Scenario_ID, max(iif(tab.m_id<>-1, Nom_Scenarios0.Scenario_Name,null)) AS new_NPE_Scenario_ID, max(iif(tab.m_id=-1, Nom_Countries1.Country_Name,null)) AS old_NPE_Country_ID, max(iif(tab.m_id<>-1, Nom_Countries1.Country_Name,null)) AS new_NPE_Country_ID, max(iif(tab.m_id=-1, tab.NPE_Name,null)) AS old_NPE_Name, max(iif(tab.m_id<>-1, tab.NPE_Name,null)) AS new_NPE_Name, max(iif(tab.m_id=-1, tab.NPE_Description,null)) AS old_NPE_Description, max(iif(tab.m_id<>-1, tab.NPE_Description,null)) AS new_NPE_Description, max(iif(tab.m_id=-1, vwCounterparts2.Descr,null)) AS old_NPE_Lender_ID, max(iif(tab.m_id<>-1, vwCounterparts2.Descr,null)) AS new_NPE_Lender_ID, max(iif(tab.m_id=-1, vwCounterparts3.Descr,null)) AS old_NPE_Borrower_ID, max(iif(tab.m_id<>-1, vwCounterparts3.Descr,null)) AS new_NPE_Borrower_ID, max(iif(tab.m_id=-1, Nom_Currencies4.Currency_Code,null)) AS old_NPE_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies4.Currency_Code,null)) AS new_NPE_Currency_ID, max(iif(tab.m_id=-1, tab.NPE_Amount_Date,null)) AS old_NPE_Amount_Date, max(iif(tab.m_id<>-1, tab.NPE_Amount_Date,null)) AS new_NPE_Amount_Date, max(iif(tab.m_id=-1, tab.NPE_Amount_CCY,null)) AS old_NPE_Amount_CCY, max(iif(tab.m_id<>-1, tab.NPE_Amount_CCY,null)) AS new_NPE_Amount_CCY, max(iif(tab.m_id=-1, tab.NPE_Amount_EUR,null)) AS old_NPE_Amount_EUR, max(iif(tab.m_id<>-1, tab.NPE_Amount_EUR,null)) AS new_NPE_Amount_EUR, max(iif(tab.m_id=-1, tab.LLP_Amount_CCY,null)) AS old_LLP_Amount_CCY, max(iif(tab.m_id<>-1, tab.LLP_Amount_CCY,null)) AS new_LLP_Amount_CCY, max(iif(tab.m_id=-1, tab.LLP_Amount_EUR,null)) AS old_LLP_Amount_EUR, max(iif(tab.m_id<>-1, tab.LLP_Amount_EUR,null)) AS new_LLP_Amount_EUR, max(iif(tab.m_id=-1, Nom_Asset_Owned5.Asset_Owned,null)) AS old_NPE_Owned, max(iif(tab.m_id<>-1, Nom_Asset_Owned5.Asset_Owned,null)) AS new_NPE_Owned
FROM (((((NPE_List AS tab LEFT JOIN Nom_Scenarios AS Nom_Scenarios0 ON Nom_Scenarios0.id=tab.NPE_Scenario_ID) LEFT JOIN Nom_Countries AS Nom_Countries1 ON Nom_Countries1.id=tab.NPE_Country_ID) LEFT JOIN vwCounterparts AS vwCounterparts2 ON vwCounterparts2.id=tab.NPE_Lender_ID) LEFT JOIN vwCounterparts AS vwCounterparts3 ON vwCounterparts3.id=tab.NPE_Borrower_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies4 ON Nom_Currencies4.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned5 ON Nom_Asset_Owned5.id=tab.NPE_Owned
WHERE tab.m_id in ([:m_ID],-1)
GROUP BY NPE_Code
HAVING max(tab.m_id)>-1;

CREATE VIEW upd_Asset_Appraisals AS 
UPDATE ((Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Appraisals AS dw_tab ON (dw_tab.Appraisal_Date=new_tab.Appraisal_Date) AND (dw_tab.Appraisal_Asset_ID=new_parent.id) SET dw_tab.Appraisal_Company_ID = iif(new_tab.Appraisal_Company_ID is null,dw_tab.Appraisal_Company_ID,new_tab.Appraisal_Company_ID), dw_tab.Appraisal_Currency_ID = iif(new_tab.Appraisal_Currency_ID is null,dw_tab.Appraisal_Currency_ID,new_tab.Appraisal_Currency_ID), dw_tab.Appraisal_Market_Value_CCY = iif(new_tab.Appraisal_Market_Value_CCY is null,dw_tab.Appraisal_Market_Value_CCY,new_tab.Appraisal_Market_Value_CCY), dw_tab.Appraisal_Market_Value_EUR = iif(new_tab.Appraisal_Market_Value_EUR is null,dw_tab.Appraisal_Market_Value_EUR,new_tab.Appraisal_Market_Value_EUR), dw_tab.Appraisal_Firesale_Value_CCY = iif(new_tab.Appraisal_Firesale_Value_CCY is null,dw_tab.Appraisal_Firesale_Value_CCY,new_tab.Appraisal_Firesale_Value_CCY), dw_tab.Appraisal_Firesale_Value_EUR = iif(new_tab.Appraisal_Firesale_Value_EUR is null,dw_tab.Appraisal_Firesale_Value_EUR,new_tab.Appraisal_Firesale_Value_EUR), dw_tab.Appraisal_Order = iif(new_tab.Appraisal_Order is null,dw_tab.Appraisal_Order,new_tab.Appraisal_Order)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_Financing AS 
UPDATE ((Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Financing AS dw_tab ON (dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date) AND (dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID) AND (dw_tab.Financing_Asset_ID=new_parent.id) SET dw_tab.Financing_Contract_Code = iif(new_tab.Financing_Contract_Code is null,dw_tab.Financing_Contract_Code,new_tab.Financing_Contract_Code), dw_tab.Financing_Counterpart_ID = iif(new_tab.Financing_Counterpart_ID is null,dw_tab.Financing_Counterpart_ID,new_tab.Financing_Counterpart_ID), dw_tab.Financing_Currency_ID = iif(new_tab.Financing_Currency_ID is null,dw_tab.Financing_Currency_ID,new_tab.Financing_Currency_ID), dw_tab.Financing_Amount_CCY = iif(new_tab.Financing_Amount_CCY is null,dw_tab.Financing_Amount_CCY,new_tab.Financing_Amount_CCY), dw_tab.Financing_Amount_EUR = iif(new_tab.Financing_Amount_EUR is null,dw_tab.Financing_Amount_EUR,new_tab.Financing_Amount_EUR), dw_tab.Financing_Reference_Rate = iif(new_tab.Financing_Reference_Rate is null,dw_tab.Financing_Reference_Rate,new_tab.Financing_Reference_Rate), dw_tab.Financing_Margin = iif(new_tab.Financing_Margin is null,dw_tab.Financing_Margin,new_tab.Financing_Margin), dw_tab.Financing_Rate = iif(new_tab.Financing_Rate is null,dw_tab.Financing_Rate,new_tab.Financing_Rate), dw_tab.Financing_End_Date = iif(new_tab.Financing_End_Date is null,dw_tab.Financing_End_Date,new_tab.Financing_End_Date), dw_tab.Financing_Contract_Date = iif(new_tab.Financing_Contract_Date is null,dw_tab.Financing_Contract_Date,new_tab.Financing_Contract_Date)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_History AS 
UPDATE ((Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_History AS dw_tab ON (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.Asset_ID=new_parent.id) SET dw_tab.Status_Code = iif(new_tab.Status_Code is null,dw_tab.Status_Code,new_tab.Status_Code), dw_tab.Book_Value = iif(new_tab.Book_Value is null,dw_tab.Book_Value,new_tab.Book_Value), dw_tab.OPEX = iif(new_tab.OPEX is null,dw_tab.OPEX,new_tab.OPEX), dw_tab.CAPEX = iif(new_tab.CAPEX is null,dw_tab.CAPEX,new_tab.CAPEX), dw_tab.Expected_Exit = iif(new_tab.Expected_Exit is null,dw_tab.Expected_Exit,new_tab.Expected_Exit)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_Insurances AS 
UPDATE ((Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Insurances AS dw_tab ON (dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date) AND (dw_tab.Insurance_Asset_ID=new_parent.id) SET dw_tab.Insurance_Company_ID = iif(new_tab.Insurance_Company_ID is null,dw_tab.Insurance_Company_ID,new_tab.Insurance_Company_ID), dw_tab.Insurance_End_Date = iif(new_tab.Insurance_End_Date is null,dw_tab.Insurance_End_Date,new_tab.Insurance_End_Date), dw_tab.Insurance_Currency_ID = iif(new_tab.Insurance_Currency_ID is null,dw_tab.Insurance_Currency_ID,new_tab.Insurance_Currency_ID), dw_tab.Insurance_Amount_CCY = iif(new_tab.Insurance_Amount_CCY is null,dw_tab.Insurance_Amount_CCY,new_tab.Insurance_Amount_CCY), dw_tab.Insurance_Amount_EUR = iif(new_tab.Insurance_Amount_EUR is null,dw_tab.Insurance_Amount_EUR,new_tab.Insurance_Amount_EUR), dw_tab.Insurance_Premium_CCY = iif(new_tab.Insurance_Premium_CCY is null,dw_tab.Insurance_Premium_CCY,new_tab.Insurance_Premium_CCY), dw_tab.Insurance_Premium_EUR = iif(new_tab.Insurance_Premium_EUR is null,dw_tab.Insurance_Premium_EUR,new_tab.Insurance_Premium_EUR)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_Rentals AS 
UPDATE ((Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Rentals AS dw_tab ON (dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date) AND (dw_tab.Rental_Asset_ID=new_parent.id) SET dw_tab.Rental_Counterpart_ID = iif(new_tab.Rental_Counterpart_ID is null,dw_tab.Rental_Counterpart_ID,new_tab.Rental_Counterpart_ID), dw_tab.Rental_Start_Date = iif(new_tab.Rental_Start_Date is null,dw_tab.Rental_Start_Date,new_tab.Rental_Start_Date), dw_tab.Rental_End_Date = iif(new_tab.Rental_End_Date is null,dw_tab.Rental_End_Date,new_tab.Rental_End_Date), dw_tab.Rental_Payment_Date = iif(new_tab.Rental_Payment_Date is null,dw_tab.Rental_Payment_Date,new_tab.Rental_Payment_Date), dw_tab.Rental_Currency_ID = iif(new_tab.Rental_Currency_ID is null,dw_tab.Rental_Currency_ID,new_tab.Rental_Currency_ID), dw_tab.Rental_Amount_CCY = iif(new_tab.Rental_Amount_CCY is null,dw_tab.Rental_Amount_CCY,new_tab.Rental_Amount_CCY), dw_tab.Rental_Amount_EUR = iif(new_tab.Rental_Amount_EUR is null,dw_tab.Rental_Amount_EUR,new_tab.Rental_Amount_EUR)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_Repossession AS 
UPDATE ((Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Repossession AS dw_tab ON (dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date) AND (dw_tab.Repossession_Asset_ID=new_parent.id) SET dw_tab.NPE_Currency_ID = iif(new_tab.NPE_Currency_ID is null,dw_tab.NPE_Currency_ID,new_tab.NPE_Currency_ID), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR), dw_tab.Purchase_Price_Currency_ID = iif(new_tab.Purchase_Price_Currency_ID is null,dw_tab.Purchase_Price_Currency_ID,new_tab.Purchase_Price_Currency_ID), dw_tab.Appr_Purchase_Price_Net_CCY = iif(new_tab.Appr_Purchase_Price_Net_CCY is null,dw_tab.Appr_Purchase_Price_Net_CCY,new_tab.Appr_Purchase_Price_Net_CCY), dw_tab.Appr_Purchase_Price_Net_EUR = iif(new_tab.Appr_Purchase_Price_Net_EUR is null,dw_tab.Appr_Purchase_Price_Net_EUR,new_tab.Appr_Purchase_Price_Net_EUR), dw_tab.Purchase_Price_Net_CCY = iif(new_tab.Purchase_Price_Net_CCY is null,dw_tab.Purchase_Price_Net_CCY,new_tab.Purchase_Price_Net_CCY), dw_tab.Purchase_Price_Net_EUR = iif(new_tab.Purchase_Price_Net_EUR is null,dw_tab.Purchase_Price_Net_EUR,new_tab.Purchase_Price_Net_EUR), dw_tab.Purchase_Costs_CCY = iif(new_tab.Purchase_Costs_CCY is null,dw_tab.Purchase_Costs_CCY,new_tab.Purchase_Costs_CCY), dw_tab.Purchase_Costs_EUR = iif(new_tab.Purchase_Costs_EUR is null,dw_tab.Purchase_Costs_EUR,new_tab.Purchase_Costs_EUR), dw_tab.Planned_CAPEX_Currency_ID = iif(new_tab.Planned_CAPEX_Currency_ID is null,dw_tab.Planned_CAPEX_Currency_ID,new_tab.Planned_CAPEX_Currency_ID), dw_tab.Planned_CAPEX_CCY = iif(new_tab.Planned_CAPEX_CCY is null,dw_tab.Planned_CAPEX_CCY,new_tab.Planned_CAPEX_CCY), dw_tab.Planned_CAPEX_EUR = iif(new_tab.Planned_CAPEX_EUR is null,dw_tab.Planned_CAPEX_EUR,new_tab.Planned_CAPEX_EUR), dw_tab.Planned_CAPEX_Comment = iif(new_tab.Planned_CAPEX_Comment is null,dw_tab.Planned_CAPEX_Comment,new_tab.Planned_CAPEX_Comment), dw_tab.Purchase_Contract_Date = iif(new_tab.Purchase_Contract_Date is null,dw_tab.Purchase_Contract_Date,new_tab.Purchase_Contract_Date), dw_tab.Purchase_Repossession_Date = iif(new_tab.Purchase_Repossession_Date is null,dw_tab.Purchase_Repossession_Date,new_tab.Purchase_Repossession_Date), dw_tab.Purchase_Payment_Date = iif(new_tab.Purchase_Payment_Date is null,dw_tab.Purchase_Payment_Date,new_tab.Purchase_Payment_Date), dw_tab.Purchase_Handover_Date = iif(new_tab.Purchase_Handover_Date is null,dw_tab.Purchase_Handover_Date,new_tab.Purchase_Handover_Date), dw_tab.Purchase_Registration_Date = iif(new_tab.Purchase_Registration_Date is null,dw_tab.Purchase_Registration_Date,new_tab.Purchase_Registration_Date), dw_tab.Purchase_Local_Approval_Date = iif(new_tab.Purchase_Local_Approval_Date is null,dw_tab.Purchase_Local_Approval_Date,new_tab.Purchase_Local_Approval_Date), dw_tab.Purchase_Central_Approval_Date = iif(new_tab.Purchase_Central_Approval_Date is null,dw_tab.Purchase_Central_Approval_Date,new_tab.Purchase_Central_Approval_Date), dw_tab.Purchase_Prolongation_Date = iif(new_tab.Purchase_Prolongation_Date is null,dw_tab.Purchase_Prolongation_Date,new_tab.Purchase_Prolongation_Date), dw_tab.Purchase_Expected_Exit_Date = iif(new_tab.Purchase_Expected_Exit_Date is null,dw_tab.Purchase_Expected_Exit_Date,new_tab.Purchase_Expected_Exit_Date), dw_tab.Planned_OPEX_CCY = iif(new_tab.Planned_OPEX_CCY is null,dw_tab.Planned_OPEX_CCY,new_tab.Planned_OPEX_CCY), dw_tab.Planned_OPEX_EUR = iif(new_tab.Planned_OPEX_EUR is null,dw_tab.Planned_OPEX_EUR,new_tab.Planned_OPEX_EUR), dw_tab.Planned_OPEX_Comment = iif(new_tab.Planned_OPEX_Comment is null,dw_tab.Planned_OPEX_Comment,new_tab.Planned_OPEX_Comment), dw_tab.Planned_SalesPrice_CCY = iif(new_tab.Planned_SalesPrice_CCY is null,dw_tab.Planned_SalesPrice_CCY,new_tab.Planned_SalesPrice_CCY), dw_tab.Planned_SalesPrice_EUR = iif(new_tab.Planned_SalesPrice_EUR is null,dw_tab.Planned_SalesPrice_EUR,new_tab.Planned_SalesPrice_EUR)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Asset_Sales AS 
UPDATE ((Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Sales AS dw_tab ON (dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date) AND (dw_tab.Sale_Asset_ID=new_parent.id) SET dw_tab.Sale_Counterpart_ID = iif(new_tab.Sale_Counterpart_ID is null,dw_tab.Sale_Counterpart_ID,new_tab.Sale_Counterpart_ID), dw_tab.Sale_Contract_Date = iif(new_tab.Sale_Contract_Date is null,dw_tab.Sale_Contract_Date,new_tab.Sale_Contract_Date), dw_tab.Sale_Transfer_Date = iif(new_tab.Sale_Transfer_Date is null,dw_tab.Sale_Transfer_Date,new_tab.Sale_Transfer_Date), dw_tab.Sale_Payment_Date = iif(new_tab.Sale_Payment_Date is null,dw_tab.Sale_Payment_Date,new_tab.Sale_Payment_Date), dw_tab.Sale_AML_Check_Date = iif(new_tab.Sale_AML_Check_Date is null,dw_tab.Sale_AML_Check_Date,new_tab.Sale_AML_Check_Date), dw_tab.Sale_AML_Pass_Date = iif(new_tab.Sale_AML_Pass_Date is null,dw_tab.Sale_AML_Pass_Date,new_tab.Sale_AML_Pass_Date), dw_tab.Sale_Currency_ID = iif(new_tab.Sale_Currency_ID is null,dw_tab.Sale_Currency_ID,new_tab.Sale_Currency_ID), dw_tab.Sale_ApprovedAmt_CCY = iif(new_tab.Sale_ApprovedAmt_CCY is null,dw_tab.Sale_ApprovedAmt_CCY,new_tab.Sale_ApprovedAmt_CCY), dw_tab.Sale_ApprovedAmt_EUR = iif(new_tab.Sale_ApprovedAmt_EUR is null,dw_tab.Sale_ApprovedAmt_EUR,new_tab.Sale_ApprovedAmt_EUR), dw_tab.Sale_Amount_CCY = iif(new_tab.Sale_Amount_CCY is null,dw_tab.Sale_Amount_CCY,new_tab.Sale_Amount_CCY), dw_tab.Sale_Amount_EUR = iif(new_tab.Sale_Amount_EUR is null,dw_tab.Sale_Amount_EUR,new_tab.Sale_Amount_EUR), dw_tab.Sale_Book_Value_CCY = iif(new_tab.Sale_Book_Value_CCY is null,dw_tab.Sale_Book_Value_CCY,new_tab.Sale_Book_Value_CCY), dw_tab.Sale_Book_Value_EUR = iif(new_tab.Sale_Book_Value_EUR is null,dw_tab.Sale_Book_Value_EUR,new_tab.Sale_Book_Value_EUR)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_Assets_List AS 
UPDATE ((Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN Assets_List AS dw_tab ON dw_tab.Asset_Code=new_tab.Asset_Code SET dw_tab.Asset_NPE_ID = new_tab.Asset_NPE_ID, dw_tab.Asset_Name = iif(new_tab.Asset_Name is null,dw_tab.Asset_Name,new_tab.Asset_Name), dw_tab.Asset_Description = iif(new_tab.Asset_Description is null,dw_tab.Asset_Description,new_tab.Asset_Description), dw_tab.Asset_Address = iif(new_tab.Asset_Address is null,dw_tab.Asset_Address,new_tab.Asset_Address), dw_tab.Asset_ZIP = iif(new_tab.Asset_ZIP is null,dw_tab.Asset_ZIP,new_tab.Asset_ZIP), dw_tab.Asset_Region = iif(new_tab.Asset_Region is null,dw_tab.Asset_Region,new_tab.Asset_Region), dw_tab.Asset_Country_ID = iif(new_tab.Asset_Country_ID is null,dw_tab.Asset_Country_ID,new_tab.Asset_Country_ID), dw_tab.Asset_Usage_ID = iif(new_tab.Asset_Usage_ID is null,dw_tab.Asset_Usage_ID,new_tab.Asset_Usage_ID), dw_tab.Asset_Type_ID = iif(new_tab.Asset_Type_ID is null,dw_tab.Asset_Type_ID,new_tab.Asset_Type_ID), dw_tab.Asset_Usable_Area = iif(new_tab.Asset_Usable_Area is null,dw_tab.Asset_Usable_Area,new_tab.Asset_Usable_Area), dw_tab.Asset_Common_Area = iif(new_tab.Asset_Common_Area is null,dw_tab.Asset_Common_Area,new_tab.Asset_Common_Area), dw_tab.Asset_Owned = iif(new_tab.Asset_Owned is null,dw_tab.Asset_Owned,new_tab.Asset_Owned), dw_tab.Comment = iif(new_tab.Comment is null,dw_tab.Comment,new_tab.Comment)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_NPE_History AS 
UPDATE ((NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN NPE_History AS dw_tab ON (dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID) AND (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.NPE_ID=new_parent.id) SET dw_tab.NPE_Status_ID = iif(new_tab.NPE_Status_ID is null,dw_tab.NPE_Status_ID,new_tab.NPE_Status_ID), dw_tab.NPE_Rep_Date = iif(new_tab.NPE_Rep_Date is null,dw_tab.NPE_Rep_Date,new_tab.NPE_Rep_Date), dw_tab.NPE_Currency = iif(new_tab.NPE_Currency is null,dw_tab.NPE_Currency,new_tab.NPE_Currency), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW upd_NPE_List AS 
UPDATE NPE_List AS new_tab INNER JOIN NPE_List AS dw_tab ON dw_tab.NPE_Code=new_tab.NPE_Code SET dw_tab.NPE_Scenario_ID = iif(new_tab.NPE_Scenario_ID is null,dw_tab.NPE_Scenario_ID,new_tab.NPE_Scenario_ID), dw_tab.NPE_Country_ID = iif(new_tab.NPE_Country_ID is null,dw_tab.NPE_Country_ID,new_tab.NPE_Country_ID), dw_tab.NPE_Name = iif(new_tab.NPE_Name is null,dw_tab.NPE_Name,new_tab.NPE_Name), dw_tab.NPE_Description = iif(new_tab.NPE_Description is null,dw_tab.NPE_Description,new_tab.NPE_Description), dw_tab.NPE_Lender_ID = iif(new_tab.NPE_Lender_ID is null,dw_tab.NPE_Lender_ID,new_tab.NPE_Lender_ID), dw_tab.NPE_Borrower_ID = iif(new_tab.NPE_Borrower_ID is null,dw_tab.NPE_Borrower_ID,new_tab.NPE_Borrower_ID), dw_tab.NPE_Currency_ID = iif(new_tab.NPE_Currency_ID is null,dw_tab.NPE_Currency_ID,new_tab.NPE_Currency_ID), dw_tab.NPE_Amount_Date = iif(new_tab.NPE_Amount_Date is null,dw_tab.NPE_Amount_Date,new_tab.NPE_Amount_Date), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR), dw_tab.NPE_Owned = iif(new_tab.NPE_Owned is null,dw_tab.NPE_Owned,new_tab.NPE_Owned)
WHERE new_tab.m_id = [:m_ID] and dw_tab.m_id=-1;

CREATE VIEW vw_Appr_Periods AS 
SELECT Assets_List.ID, Switch(IIf(IsNull([book_value]),IIf(IsNull([Asset_Repossession].[Purchase_Price_Net_EUR]),2000000,[Asset_Repossession].[Purchase_Price_Net_EUR]),[book_value])<1000000,36,IIf(IsNull([book_value]),IIf(IsNull([Asset_Repossession].[Purchase_Price_Net_EUR]),2000000,[Asset_Repossession].[Purchase_Price_Net_EUR]),[book_value])<1500000,24,1,12) AS AppraisalPeriod
FROM NPE_List INNER JOIN ((Assets_List LEFT JOIN (Asset_History LEFT JOIN LastDate ON Asset_History.[Rep_Date] = LastDate.LastDate) ON Assets_List.ID = Asset_History.Asset_ID) LEFT JOIN Asset_Repossession ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_LE_Sender AS 
SELECT Users.FullName, legal_entities.Tagetik_Code, Mail_Log.ID
FROM Mail_Log INNER JOIN (legal_entities INNER JOIN Users ON legal_entities.ID = Users.LE_ID) ON Mail_Log.Sender = Users.EMail;

CREATE VIEW vw_LEs AS 
SELECT Legal_Entities.ID, "(" & [country_code] & ") " & [tagetik_code] & " - " & [le_name] AS [Text]
FROM Legal_Entities LEFT JOIN Nom_Countries ON Legal_Entities.LE_Country_ID = Nom_Countries.ID;

CREATE VIEW vw_NPE_Shifts AS 
SELECT inn.rep_year, Sum(inn.baseNpe) AS Base_NPE, Sum(inn.compNpe) AS Comp_NPE, Sum(inn.ShiftNPE) AS Shift_NPE, Comp_NPE-Base_NPE-Shift_NPE AS New_NPE, Comp_NPE-Base_NPE AS Delta_NPE
FROM (SELECT iif(ver="Original",Year([NPE_Rep_Date]),(select iif(ver="ShiftedTo",year(s.npe_rep_date),:base_year) as shift_year from npe_history s where s.npe_scenario_id=:comp_scenario and year(s.npe_rep_date)<>:base_year and s.npe_id=npe_history.npe_id)) AS Rep_Year, (IIf([npe_scenario_id]=[:base_scenario] And ver="Original",[npe_amount_eur],0)) AS BaseNPE, (IIf([npe_scenario_id]=[:comp_scenario] And ver="Original",[npe_amount_eur],0)) AS CompNPE, (IIf([npe_scenario_id]=[:base_scenario] And ver<>"Original",[npe_amount_eur]*Sign,0)) AS ShiftNPE, ver, npe_id FROM NPE_History, Orig_Shifted WHERE (((NPE_History.NPE_Scenario_ID) In ([:base_scenario],[:comp_scenario])) And ((NPE_History.NPE_Amount_EUR)<>0)) And Not (npe_scenario_id=[:base_scenario] And ver<>"Original" And year(npe_rep_date)<>[:base_year]))  AS inn
WHERE (((inn.[rep_year]) Is Not Null))
GROUP BY inn.rep_year;

CREATE VIEW vw_sh_Appraisals AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Switch([appraisal_asset_id] Is Null,"No Appraisal",(select [LastDate] from lastdate) Not Between IIf(IsNull([appraisal_date]),DateSerial(2000,1,1),[Appraisal_Date]) And DateAdd("m",[appraisalPeriod],IIf(IsNull([appraisal_date]),DateSerial(2000,1,1),[Appraisal_Date])),"Appraisal expired or not yet valid",[Appraisal_Market_Value_EUR]=0,"Appraisal value is 0",1,"OK") AS Appraisal_Status, Counterparts.Counterpart_Common_Name AS Appraisal_Company, Asset_Appraisals.Appraisal_Date, Nom_Currencies.Currency_Code, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR
FROM NPE_List INNER JOIN ((vw_Appr_Periods RIGHT JOIN Assets_List ON vw_Appr_Periods.ID = Assets_List.ID) LEFT JOIN (Counterparts RIGHT JOIN (Asset_Appraisals LEFT JOIN Nom_Currencies ON Asset_Appraisals.Appraisal_Currency_ID = Nom_Currencies.ID) ON Counterparts.ID = Asset_Appraisals.Appraisal_Company_ID) ON Assets_List.ID = Asset_Appraisals.Appraisal_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_sh_Financing AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Counterparts.Counterpart_Common_Name, Nom_Financing_Type.Financing_Type, Nom_Currencies.Currency_Code, Asset_Financing.Financing_Amount_CCY, Asset_Financing.Financing_Amount_EUR, Asset_Financing.Financing_Reference_Rate, Asset_Financing.Financing_Margin, Asset_Financing.Financing_Rate, Asset_Financing.Financing_Contract_Date, Asset_Financing.Financing_Start_Date, Asset_Financing.Financing_End_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (((Asset_Financing INNER JOIN Nom_Currencies ON Asset_Financing.Financing_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Financing.Financing_Counterpart_ID = Counterparts.ID) LEFT JOIN Nom_Financing_Type ON Asset_Financing.Financing_Type_ID = Nom_Financing_Type.ID) ON Assets_List.ID = Asset_Financing.Financing_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_sh_Insurances AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, IIf([Asset_Insurances].[ID] Is Null,"No Insurance",IIf(Date() Not Between IIf(IsNull([Insurance_Start_Date]),DateSerial(2000,1,1),[Insurance_Start_Date]) And IIf(IsNull([Insurance_End_Date]),DateSerial(2000,1,1),[Insurance_End_Date]),"Expired insurance",IIf([Insurance_Amount_EUR]<=0,"Invalid insurance amount in EUR"))) AS [Insurance Status], Counterparts.counterpart_common_name AS [Insurance Company], Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date, Nom_Currencies.Currency_Code, Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Insurances LEFT JOIN Nom_Currencies ON Asset_Insurances.Insurance_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Insurances.Insurance_Company_ID = Counterparts.ID) ON Assets_List.ID = Asset_Insurances.Insurance_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_sh_Rentals AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, IIf([Asset_Rentals].[ID] Is Null,"No Tenant",[Counterpart_Common_Name]) AS Tenant, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date, Asset_Rentals.Rental_Payment_Date, Nom_Currencies.Currency_Code, Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Rentals LEFT JOIN Counterparts ON Asset_Rentals.Rental_Counterpart_ID = Counterparts.ID) LEFT JOIN Nom_Currencies ON Asset_Rentals.Rental_Currency_ID = Nom_Currencies.ID) ON Assets_List.ID = Asset_Rentals.Rental_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_sh_Repossessions AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Asset_Repossession.Purchase_Auction_Date, Asset_Repossession.Purchase_Contract_Date, Asset_Repossession.Purchase_Handover_Date, Asset_Repossession.Purchase_Payment_Date, Purchase_Currency.Currency_Code, Asset_Repossession.Appr_Purchase_Price_Net_CCY, Asset_Repossession.Appr_Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Price_Net_CCY, Asset_Repossession.Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Costs_CCY, Asset_Repossession.Purchase_Costs_EUR, Asset_Repossession.Planned_CAPEX_CCY, Asset_Repossession.Planned_CAPEX_EUR, Asset_Repossession.Planned_CAPEX_Comment, Asset_Repossession.Planned_OPEX_CCY, Asset_Repossession.Planned_OPEX_EUR, Asset_Repossession.Planned_OPEX_Comment, Asset_Repossession.Planned_SalesPrice_CCY, Asset_Repossession.Planned_SalesPrice_EUR
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (Nom_Currencies AS Purchase_Currency RIGHT JOIN (Asset_Repossession LEFT JOIN Nom_Currencies AS NPE_Currency ON Asset_Repossession.NPE_Currency_ID = NPE_Currency.ID) ON Purchase_Currency.ID = Asset_Repossession.Purchase_Price_Currency_ID) ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_sh_Sales AS 
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Counterparts.counterpart_common_name AS Buyer, Asset_Sales.Sale_Approval_Date, Asset_Sales.Sale_Contract_Date, Asset_Sales.Sale_Transfer_Date, Asset_Sales.Sale_Payment_Date, Nom_Currencies.Currency_Code, Asset_Sales.Sale_ApprovedAmt_CCY, Asset_Sales.Sale_ApprovedAmt_EUR, Asset_Sales.Sale_Amount_CCY, Asset_Sales.Sale_Amount_EUR, Asset_Sales.Sale_Book_Value_CCY, Asset_Sales.Sale_Book_Value_EUR, Asset_Sales.Sale_AML_Check_Date, Asset_Sales.Sale_AML_Pass_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN ((Asset_Sales INNER JOIN Nom_Currencies ON Asset_Sales.Sale_Currency_ID = Nom_Currencies.ID) INNER JOIN Counterparts ON Asset_Sales.Sale_Counterpart_ID = Counterparts.ID) ON Assets_List.ID = Asset_Sales.Sale_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID;

CREATE VIEW vw_Shifts AS 
SELECT inn.npe_id, Max(inn.base_rep_year) AS base_rep_year_, Max(inn.new_rep_year) AS new_rep_year_, Sum(inn.base_amount_eur) AS base_amount_eur_, Sum(inn.new_amount_eur) AS new_amount_eur_, IIf(Max(base_rep_year)=2017 And Max(new_rep_year)<>2017 And Max(new_rep_year)<>0,Max(new_rep_year),Null) AS Shifted_To
FROM (SELECT NPE_History.NPE_ID, year(NPE_History.NPE_Rep_Date) as base_rep_year, 0 as new_rep_year, NPE_History.NPE_Amount_EUR as base_amount_eur, null as new_amount_eur
FROM NPE_History
where npe_scenario_id=2 and npe_amount_eur<>0 and npe_amount_eur is not null
union all
SELECT NPE_History.NPE_ID, 0 as base_Rep_year, year(NPE_History.NPE_Rep_Date), null, NPE_History.NPE_Amount_EUR
FROM NPE_History
where npe_scenario_id=11 and npe_amount_eur<>0 and npe_amount_eur is not null
)  AS inn
GROUP BY inn.npe_id;

CREATE VIEW vw_shifts_final AS 
SELECT year, sum(base_amount_eur_) AS base_amount_eur, sum(new_amount_eur_) AS new_amount_eur, sum(shifted_amount_eur_) AS shifted_amount_eur, sum(new_amount_eur_)-sum(base_amount_eur_)-sum(shifted_amount_eur_) AS newly_identified_eur
FROM (SELECT vw_Shifts.base_rep_year_ as year, vw_Shifts.base_amount_eur_, 0 as new_amount_eur_, 0 as shifted_amount_eur_
FROM vw_Shifts
where base_amount_eur_<>0 and base_amount_eur_ is not null
union all
SELECT vw_Shifts.new_rep_year_, null, vw_Shifts.new_amount_eur_, null
FROM vw_Shifts
where new_amount_eur_<>0 and new_amount_eur_ is not null
union all
SELECT vw_Shifts.shifted_to, null, null, vw_Shifts.base_amount_eur_
FROM vw_Shifts
where base_amount_eur_<>0 and base_amount_eur_ is not null and shifted_to is not null
union all
SELECT 2017, null, null, -vw_Shifts.base_amount_eur_
FROM vw_Shifts
where base_amount_eur_<>0 and base_amount_eur_ is not null and shifted_to is not null

)  AS inn
GROUP BY year;

CREATE VIEW vwCounterparts AS 
SELECT Counterparts.ID, [Counterpart_Type] & " " & [Counterpart_First_Name] & " " & [counterpart_Last_Name] & " " & [Counterpart_Company_Name] AS Descr
FROM Counterparts;

CREATE VIEW vwUserCountry AS 
SELECT Users.EMail, Nom_Countries.Country_Code
FROM Nom_Countries RIGHT JOIN (Legal_Entities INNER JOIN Users ON Legal_Entities.ID = Users.LE_ID) ON Nom_Countries.ID = Legal_Entities.LE_Country_ID;

