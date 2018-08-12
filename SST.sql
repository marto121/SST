DROP TABLE Asset_Appraisals CASCADE;
DROP TABLE Asset_Financials CASCADE;
DROP TABLE Asset_Financing CASCADE;
DROP TABLE Asset_History CASCADE;
DROP TABLE Asset_Insurances CASCADE;
DROP TABLE Asset_Rentals CASCADE;
DROP TABLE Asset_Repossession CASCADE;
DROP TABLE Asset_Sales CASCADE;
DROP TABLE Assets_List CASCADE;
DROP TABLE Business_Cases CASCADE;
DROP TABLE calendar CASCADE;
DROP TABLE Counterparts CASCADE;
DROP TABLE drop_dup_repos CASCADE;
DROP TABLE File_Log CASCADE;
DROP TABLE FX_Rates CASCADE;
DROP TABLE Import_Mapping CASCADE;
DROP TABLE LastDate CASCADE;
DROP TABLE Legal_Entities CASCADE;
DROP TABLE lst_Reports CASCADE;
DROP TABLE lst_Sheets CASCADE;
DROP TABLE Mail_Log CASCADE;
DROP TABLE Mail_Queue CASCADE;
DROP TABLE Meta_CCY_Conversion CASCADE;
DROP TABLE Meta_Updatable_Tables CASCADE;
DROP TABLE Nom_Asset_Owned CASCADE;
DROP TABLE Nom_Asset_Status CASCADE;
DROP TABLE Nom_Asset_Type CASCADE;
DROP TABLE Nom_Asset_Usage CASCADE;
DROP TABLE Nom_Countries CASCADE;
DROP TABLE Nom_Currencies CASCADE;
DROP TABLE Nom_Financing_Type CASCADE;
DROP TABLE Nom_Log_Types CASCADE;
DROP TABLE Nom_NPE_Status CASCADE;
DROP TABLE Nom_Scenarios CASCADE;
DROP TABLE Nom_Transaction_Types CASCADE;
DROP TABLE NPE_History CASCADE;
DROP TABLE NPE_List CASCADE;
DROP TABLE orig_shifted CASCADE;
DROP TABLE Paste Errors CASCADE;
DROP TABLE Reports CASCADE;
DROP TABLE Sheet1 CASCADE;
DROP TABLE SST_Log CASCADE;
DROP TABLE Update_Log CASCADE;
DROP TABLE Users CASCADE;
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Appraisals (
ID integer,
Appraisal_Asset_ID integer,
Appraisal_Company_ID integer,
Appraisal_Date date,
Appraisal_Currency_ID integer,
Appraisal_Market_Value_CCY double precision,
Appraisal_Market_Value_EUR double precision,
Appraisal_Firesale_Value_CCY double precision,
Appraisal_Firesale_Value_EUR double precision,
Appraisal_Order integer,
m_ID integer
);
-- 6.1.2018 ใ. 23:14:17
CREATE TABLE Asset_Financials (
ID integer,
Asset_ID integer,
Acc_Date date,
Account_No varchar(255),
Account_Name varchar(255),
Amount integer,
Trans_Type_ID integer,
Rep_Date date,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Financing (
ID integer,
Financing_Contract_Code varchar(20),
Financing_Counterpart_ID integer,
Financing_Asset_ID integer,
Financing_Type_ID integer,
Financing_Currency_ID integer,
Financing_Amount_CCY double precision,
Financing_Amount_EUR double precision,
Financing_Reference_Rate varchar(20),
Financing_Margin double precision,
Financing_Rate double precision,
Financing_Start_Date date,
Financing_End_Date date,
Financing_Contract_Date date,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_History (
ID integer,
Asset_ID integer,
Rep_Date date,
Status_Code integer,
Currency_ID integer,
Book_Value_PM double precision,
Inflows double precision,
CAPEX double precision,
Depreciation double precision,
Sales double precision,
Imp_WB double precision,
Book_Value double precision,
Costs double precision,
Income double precision,
Expected_Exit date,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Insurances (
ID integer,
Insurance_Asset_ID integer,
Insurance_Company_ID integer,
Insurance_Start_Date date,
Insurance_End_Date date,
Insurance_Currency_ID integer,
Insurance_Amount_CCY double precision,
Insurance_Amount_EUR double precision,
Insurance_Premium_CCY double precision,
Insurance_Premium_EUR double precision,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Rentals (
ID integer,
Rental_Asset_ID integer,
Rental_Counterpart_ID integer,
Rental_Contract_Date date,
Rental_Start_Date date,
Rental_End_Date date,
Rental_Payment_Date date,
Rental_Currency_ID integer,
Rental_Amount_CCY double precision,
Rental_Amount_EUR double precision,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Repossession (
ID integer,
Repossession_Asset_ID integer,
NPE_Currency_ID integer,
NPE_Amount_CCY double precision,
NPE_Amount_EUR double precision,
LLP_Amount_CCY double precision,
LLP_Amount_EUR double precision,
Purchase_Price_Currency_ID integer,
Appr_Purchase_Price_Net_CCY double precision,
Appr_Purchase_Price_Net_EUR double precision,
Purchase_Price_Net_CCY double precision,
Purchase_Price_Net_EUR double precision,
Purchase_Costs_CCY double precision,
Purchase_Costs_EUR double precision,
Planned_CAPEX_Currency_ID integer,
Planned_CAPEX_CCY double precision,
Planned_CAPEX_EUR double precision,
Planned_CAPEX_Comment varchar(255),
Purchase_Auction_Date date,
Purchase_Contract_Date date,
Purchase_Repossession_Date date,
Purchase_Payment_Date date,
Purchase_Handover_Date date,
Purchase_Registration_Date date,
Purchase_Local_Approval_Date date,
Purchase_Central_Approval_Date date,
Purchase_Prolongation_Date date,
Purchase_Expected_Exit_Date date,
Planned_OPEX_CCY double precision,
Planned_OPEX_EUR double precision,
Planned_OPEX_Comment varchar(255),
Planned_SalesPrice_CCY double precision,
Planned_SalesPrice_EUR double precision,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Asset_Sales (
ID integer,
Sale_Asset_ID integer,
Sale_Counterpart_ID integer,
Sale_Approval_Date date,
Sale_Contract_Date date,
Sale_Transfer_Date date,
Sale_Payment_Date date,
Sale_AML_Check_Date date,
Sale_AML_Pass_Date date,
Sale_Currency_ID integer,
Sale_ApprovedAmt_CCY double precision,
Sale_ApprovedAmt_EUR double precision,
Sale_Amount_CCY double precision,
Sale_Amount_EUR double precision,
Sale_Book_Value_CCY double precision,
Sale_Book_Value_EUR double precision,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Assets_List (
ID integer,
Asset_Code varchar(12),
Asset_NPE_ID integer,
Asset_Name varchar(255),
Asset_Description varchar(255),
Asset_Address varchar(255),
Asset_ZIP varchar(255),
Asset_Region varchar(255),
Asset_Country_ID integer,
Asset_Usage_ID integer,
Asset_Type_ID integer,
Asset_Usable_Area integer,
Asset_Common_Area integer,
Asset_Owned integer,
Comment varchar(255),
m_ID integer
);
-- 9.2.2018 ใ. 15:29:42
CREATE TABLE Business_Cases (
ID integer,
NPE_ID integer,
BC_Date date,
BC_Comment varchar(2000),
BC_Purchase_Date date,
BC_Purchase_Price_EUR double precision,
Exp_CAPEX_EUR double precision,
Exp_CAPEX_Time date,
Exp_Sale_Date date,
Exp_Sale_Price_EUR double precision,
Exp_Interest_EUR double precision,
Exp_OPEX_EUR double precision,
Exp_Income_EUR double precision,
m_ID integer
);
-- 23.2.2018 ใ. 13:06:56
CREATE TABLE calendar (
ID integer,
Rep_Date date,
Prev_Date date,
Send_Date date,
Confirm_Date date
);
-- 22.12.2017 ใ. 13:21:22
CREATE TABLE Counterparts (
ID integer,
Counterpart_Common_Name varchar(255),
Counterpart_First_Name varchar(255),
Counterpart_Last_Name varchar(255),
Counterpart_Company_Name varchar(255),
Counterpart_Type varchar(255)
);
-- 28.3.2018 ใ. 22:02:10
CREATE TABLE drop_dup_repos (
Repossession_Asset_ID integer,
m_ID integer,
CountอเID integer
);
-- 1.3.2018 ใ. 19:11:17
CREATE TABLE File_Log (
ID integer,
m_ID integer,
fileName varchar(255),
fileStatus smallint,
repLE varchar(255),
repDate date
);
-- 9.2.2018 ใ. 13:05:00
CREATE TABLE FX_Rates (
ID integer,
CCY_Code varchar(255),
Scenario varchar(255),
RepDate date,
FX_Rate_Avg double precision,
FX_Rate_Eop double precision
);
-- 9.2.2018 ใ. 15:29:55
CREATE TABLE Import_Mapping (
ID integer,
Sheet_Name varchar(255),
Column_No integer,
Column_Name varchar(255),
Target_Table varchar(255),
Target_Field varchar(255),
Lookup_Table varchar(255),
Lookup_Field varchar(255),
Condition varchar(255),
Key varchar(255),
UpdateMode varchar(255)
);
-- 14.3.2018 ใ. 11:27:07
CREATE TABLE LastDate (
PrevMonth date,
CurrMonth date,
BegYear date
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Legal_Entities (
ID integer,
Tagetik_Code varchar(255),
LE_Name varchar(255),
LE_Country_ID integer,
Active integer
);
-- 1.2.2018 ใ. 15:22:04
CREATE TABLE lst_Reports (
ID integer,
Report_Code varchar(255),
Report_Name varchar(255),
Template_FileName varchar(255)
);
-- 9.2.2018 ใ. 16:08:13
CREATE TABLE lst_Sheets (
ID integer,
Report_ID integer,
Sheet_Name varchar(255),
Sheet_Title varchar(255),
Sheet_Query varchar(255),
Sheet_Columns varchar(2000)
);
-- 1.3.2018 ใ. 19:06:11
CREATE TABLE Mail_Log (
ID integer,
Sender varchar(255),
Receiver varchar(255),
Subject varchar(255),
mailStatus smallint,
authStatus smallint,
answerText varchar(2000),
answerRecipients varchar(255)
);
-- 1.3.2018 ใ. 18:54:24
CREATE TABLE Mail_Queue (
ID integer,
mRecipients varchar(255),
mCC varchar(255),
mSubject varchar(255),
mBody varchar(2000),
mAttachments varchar(255),
mStatus smallint,
mDate date
);
-- 26.2.2018 ใ. 18:52:13
CREATE TABLE Meta_CCY_Conversion (
ID integer,
Ref_Date_Col varchar(255),
Ref_Date_Add_Col varchar(255),
CCY_ID_Col varchar(255),
CCY_Amount_Col varchar(255),
EUR_Amount_Col varchar(255),
Table_Name varchar(255),
Asset_ID_Col varchar(255)
);
-- 23.2.2018 ใ. 10:06:20
CREATE TABLE Meta_Updatable_Tables (
ID integer,
table_name varchar(255),
Parent_Table varchar(255),
Parent_ID varchar(255),
Parent_Code varchar(255),
Key varchar(255),
Del_Key varchar(255),
Add_Fields varchar(255),
sheet_name varchar(255),
Fields_List varchar(2000)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Asset_Owned (
ID integer,
Asset_Owned varchar(255)
);
-- 27.12.2017 ใ. 21:39:44
CREATE TABLE Nom_Asset_Status (
ID integer,
Asset_Status_Code varchar(20),
Asset_Status_Text varchar(50)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Asset_Type (
ID integer,
Asset_Type_Text varchar(255)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Asset_Usage (
ID integer,
Asset_Usage_Text varchar(255)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Countries (
ID integer,
Country_Name varchar(20),
Country_Full_Name varchar(50),
Country_Local_Name varchar(50),
Country_Code varchar(2),
Currency_ID integer,
Country_Code3 varchar(3),
MIS_Code varchar(2)
);
-- 27.2.2018 ใ. 9:08:52
CREATE TABLE Nom_Currencies (
ID integer,
Currency_Code varchar(255),
Currency_Name varchar(255),
Currency_Symbol varchar(3),
Fixed_Rate double precision
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Financing_Type (
ID integer,
Financing_Type varchar(10)
);
-- 3.1.2018 ใ. 18:50:29
CREATE TABLE Nom_Log_Types (
ID varchar(255),
Descr varchar(255),
Color varchar(255)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_NPE_Status (
ID integer,
NPE_Status_Code varchar(10),
NPE_Status_Text varchar(50),
NPE_Parent_Status varchar(255)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Nom_Scenarios (
ID integer,
Scenario_Name varchar(50)
);
-- 2.1.2018 ใ. 19:24:56
CREATE TABLE Nom_Transaction_Types (
ID integer,
Transaction_Code varchar(255)
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE NPE_History (
ID integer,
NPE_ID integer,
Rep_Date date,
NPE_Status_ID integer,
NPE_Scenario_ID integer,
NPE_Rep_Date date,
NPE_Currency varchar(255),
NPE_Amount_CCY double precision,
NPE_Amount_EUR double precision,
LLP_Amount_CCY double precision,
LLP_Amount_EUR double precision,
Purchase_Price_CCY double precision,
Purchase_Price_EUR double precision,
m_ID integer
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE NPE_List (
ID integer,
NPE_Code varchar(255),
NPE_Scenario_ID integer,
NPE_Country_ID integer,
NPE_Name varchar(255),
NPE_Description varchar(255),
NPE_Lender_ID integer,
NPE_Borrower_ID integer,
NPE_Currency_ID integer,
NPE_Amount_Date date,
NPE_Amount_CCY double precision,
NPE_Amount_EUR double precision,
LLP_Amount_CCY double precision,
LLP_Amount_EUR double precision,
NPE_Owned integer,
m_ID integer
);
-- 30.12.2017 ใ. 15:07:51
CREATE TABLE orig_shifted (
ver varchar(255),
sign integer
);
-- 26.2.2018 ใ. 18:34:03
CREATE TABLE Paste Errors (
F1 varchar(255),
F2 varchar(255),
F3 varchar(255),
F4 varchar(255),
F5 varchar(255),
F6 varchar(255),
F7 varchar(255)
);
-- 2.3.2018 ใ. 10:16:27
CREATE TABLE Reports (
ID integer,
Report_Name varchar(255),
Report_Query varchar(255)
);
-- 26.2.2018 ใ. 18:34:50
CREATE TABLE Sheet1 (
F1 varchar(255),
F2 varchar(255),
F3 varchar(255),
F4 varchar(255),
F5 varchar(255),
F6 varchar(255)
);
-- 22.12.2017 ใ. 15:23:43
CREATE TABLE SST_Log (
ID integer,
Log_Date date,
Log_Source varchar(255),
Log_Text varchar(255),
Log_Type varchar(255),
Mail_ID integer
);
-- 27.2.2018 ใ. 14:13:31
CREATE TABLE Update_Log (
ID integer,
Table_Name varchar(255),
R_ID integer,
Column_Name varchar(255),
Old_Value varchar(255),
New_Value varchar(255),
Upd_Time date
);
-- 29.3.2018 ใ. 0:16:27
CREATE TABLE Users (
ID integer,
EMail varchar(255),
FullName varchar(255),
LE_ID integer,
Role smallint,
FirstName varchar(255),
LastName varchar(255),
UserName varchar(255)
);
create UNIQUE index Asset_Appraisals_ApprAssetDate on Asset_Appraisals(Appraisal_Asset_ID,Appraisal_Date,m_ID);
create  index Asset_Appraisals_m_ID on Asset_Appraisals(m_ID);
create  index Asset_Financials_Asset_ID on Asset_Financials(Asset_ID);
create  index Asset_Financials_MIS_Code on Asset_Financials(Trans_Type_ID);
create  index Asset_Financing_m_ID on Asset_Financing(m_ID);
create  index Asset_History_Currency_ID on Asset_History(Currency_ID);
create  index Asset_History_m_ID on Asset_History(m_ID);
create UNIQUE index Asset_Insurances_InsAssetDate on Asset_Insurances(Insurance_Asset_ID,Insurance_Start_Date,m_ID);
create  index Asset_Insurances_m_ID on Asset_Insurances(m_ID);
create  index Asset_Rentals_m_ID on Asset_Rentals(m_ID);
create UNIQUE index Asset_Rentals_RentAssetDate on Asset_Rentals(Rental_Asset_ID,Rental_Contract_Date,m_ID);
create  index Asset_Repossession_m_ID on Asset_Repossession(m_ID);
create UNIQUE index Asset_Repossession_RepAsset on Asset_Repossession(Repossession_Asset_ID,m_ID);
create  index Asset_Sales_m_ID on Asset_Sales(m_ID);
create UNIQUE index Assets_List_AssetCode on Assets_List(Asset_Code,m_ID);
create  index Assets_List_m_ID on Assets_List(m_ID);
create  index Business_Cases_m_ID on Business_Cases(m_ID);
create  index Business_Cases_NPE_ID on Business_Cases(NPE_ID);
create  index File_Log_m_ID on File_Log(m_ID);
create  index FX_Rates_CCY_Code on FX_Rates(CCY_Code);
create  index FX_Rates_Scenario_ID on FX_Rates(Scenario);
create  index Legal_Entities_Tagetik_Code on Legal_Entities(Tagetik_Code);
create UNIQUE index Nom_Asset_Owned_Asset_Type_Text on Nom_Asset_Owned(Asset_Owned);
create UNIQUE index Nom_Asset_Type_Asset_Type_Text on Nom_Asset_Type(Asset_Type_Text);
create UNIQUE index Nom_Asset_Usage_Asset_Usage_Text on Nom_Asset_Usage(Asset_Usage_Text);
create UNIQUE index Nom_Countries_Country_Name on Nom_Countries(Country_Name);
create UNIQUE index Nom_Currencies_Currency_Code on Nom_Currencies(Currency_Code);
create  index Nom_Transaction_Types_Code on Nom_Transaction_Types(Transaction_Code);
create  index NPE_History_m_ID on NPE_History(m_ID);
create  index NPE_List_m_ID on NPE_List(m_ID);
create  index SST_Log_Mail_ID on SST_Log(Mail_ID);
create  index Update_Log_R_ID on Update_Log(R_ID);
ALTER TABLE Asset_Appraisals ADD constraint Asset_Appraisals_PrimaryKey primary key (ID);
ALTER TABLE Asset_Financials ADD constraint Asset_Financials_PrimaryKey primary key (ID);
ALTER TABLE Asset_Financing ADD constraint Asset_Financing_PrimaryKey primary key (ID);
ALTER TABLE Asset_History ADD constraint Asset_History_PrimaryKey primary key (ID);
ALTER TABLE Asset_Insurances ADD constraint Asset_Insurances_PrimaryKey primary key (ID);
ALTER TABLE Asset_Rentals ADD constraint Asset_Rentals_PrimaryKey primary key (ID);
ALTER TABLE Asset_Repossession ADD constraint Asset_Repossession_PrimaryKey primary key (ID);
ALTER TABLE Asset_Sales ADD constraint Asset_Sales_PrimaryKey primary key (ID);
ALTER TABLE Assets_List ADD constraint Assets_List_PrimaryKey primary key (ID);
ALTER TABLE Business_Cases ADD constraint Business_Cases_PrimaryKey primary key (ID);
ALTER TABLE calendar ADD constraint calendar_PrimaryKey primary key (ID);
ALTER TABLE Counterparts ADD constraint Counterparts_PrimaryKey primary key (ID);
ALTER TABLE File_Log ADD constraint File_Log_PrimaryKey primary key (ID);
ALTER TABLE FX_Rates ADD constraint FX_Rates_PrimaryKey primary key (CCY_Code,Scenario,RepDate);
ALTER TABLE Import_Mapping ADD constraint Import_Mapping_PrimaryKey primary key (ID);
ALTER TABLE LastDate ADD constraint LastDate_PrimaryKey primary key (PrevMonth);
ALTER TABLE Legal_Entities ADD constraint Legal_Entities_PrimaryKey primary key (ID);
ALTER TABLE lst_Reports ADD constraint lst_Reports_PrimaryKey primary key (ID);
ALTER TABLE lst_Sheets ADD constraint lst_Sheets_PrimaryKey primary key (ID);
ALTER TABLE Mail_Log ADD constraint Mail_Log_PrimaryKey primary key (ID);
ALTER TABLE Mail_Queue ADD constraint Mail_Queue_PrimaryKey primary key (ID);
ALTER TABLE Meta_CCY_Conversion ADD constraint Meta_CCY_Conversion_PrimaryKey primary key (ID);
ALTER TABLE Meta_Updatable_Tables ADD constraint Meta_Updatable_Tables_PrimaryKey primary key (ID);
ALTER TABLE Nom_Asset_Owned ADD constraint Nom_Asset_Owned_PrimaryKey primary key (ID);
ALTER TABLE Nom_Asset_Status ADD constraint Nom_Asset_Status_PrimaryKey primary key (ID);
ALTER TABLE Nom_Asset_Type ADD constraint Nom_Asset_Type_PrimaryKey primary key (ID);
ALTER TABLE Nom_Asset_Usage ADD constraint Nom_Asset_Usage_PrimaryKey primary key (ID);
ALTER TABLE Nom_Countries ADD constraint Nom_Countries_PrimaryKey primary key (ID);
ALTER TABLE Nom_Currencies ADD constraint Nom_Currencies_PrimaryKey primary key (ID);
ALTER TABLE Nom_Financing_Type ADD constraint Nom_Financing_Type_PrimaryKey primary key (ID);
ALTER TABLE Nom_Log_Types ADD constraint Nom_Log_Types_PrimaryKey primary key (ID);
ALTER TABLE Nom_NPE_Status ADD constraint Nom_NPE_Status_PrimaryKey primary key (ID);
ALTER TABLE Nom_Scenarios ADD constraint Nom_Scenarios_PrimaryKey primary key (ID);
ALTER TABLE Nom_Transaction_Types ADD constraint Nom_Transaction_Types_PrimaryKey primary key (ID);
ALTER TABLE NPE_History ADD constraint NPE_History_PrimaryKey primary key (ID);
ALTER TABLE NPE_List ADD constraint NPE_List_PrimaryKey primary key (ID);
ALTER TABLE Reports ADD constraint Reports_PrimaryKey primary key (ID);
ALTER TABLE SST_Log ADD constraint SST_Log_PrimaryKey primary key (ID);
ALTER TABLE Update_Log ADD constraint Update_Log_PrimaryKey primary key (ID);
ALTER TABLE Users ADD constraint Users_PrimaryKey primary key (EMail,LE_ID);
ALTER TABLE Asset_Appraisals ADD constraint Assets_ListAsset_Appraisals foreign key (Appraisal_Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Financing ADD constraint Assets_ListAsset_Financing foreign key (Financing_Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Financing ADD constraint Nom_Financing_TypeAsset_Financing foreign key (Financing_Type_ID) references Nom_Financing_Type(ID);
ALTER TABLE Asset_History ADD constraint Assets_ListAsset_History foreign key (Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Insurances ADD constraint Assets_ListAsset_Insurances foreign key (Insurance_Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Rentals ADD constraint Assets_ListAsset_Rentals foreign key (Rental_Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Repossession ADD constraint Assets_ListAsset_Repossession foreign key (Repossession_Asset_ID) references Assets_List(ID);
ALTER TABLE Asset_Sales ADD constraint Assets_ListAsset_Sales foreign key (Sale_Asset_ID) references Assets_List(ID);
ALTER TABLE Assets_List ADD constraint Asset_TypeAssets_List foreign key (Asset_Type_ID) references Nom_Asset_Type(ID);
ALTER TABLE Assets_List ADD constraint Asset_UsageAssets_List foreign key (Asset_Usage_ID) references Nom_Asset_Usage(ID);
ALTER TABLE Assets_List ADD constraint CountriesAssets_List foreign key (Asset_Country_ID) references Nom_Countries(ID);
ALTER TABLE Assets_List ADD constraint Nom_Asset_OwnedAssets_List foreign key (Asset_Owned) references Nom_Asset_Owned(ID);
ALTER TABLE Assets_List ADD constraint NPE_ListAssets_List foreign key (Asset_NPE_ID) references NPE_List(ID);
ALTER TABLE Legal_Entities ADD constraint Nom_CountriesLegal_Entities foreign key (LE_Country_ID) references Nom_Countries(ID);
ALTER TABLE NPE_History ADD constraint Nom_NPE_StatusNPE_History foreign key (NPE_Status_ID) references Nom_NPE_Status(ID);
ALTER TABLE NPE_History ADD constraint NPE_ListNPE_History foreign key (NPE_ID) references NPE_List(ID);
ALTER TABLE NPE_List ADD constraint Nom_CountriesNPE_List foreign key (NPE_Country_ID) references Nom_Countries(ID);
ALTER TABLE NPE_List ADD constraint Nom_ScenariosNPE_List foreign key (NPE_Scenario_ID) references Nom_Scenarios(ID);
ALTER TABLE NPE_List ADD constraint Nom_ScenariosNPE_List1 foreign key (NPE_Scenario_ID) references Nom_Scenarios(ID);
ALTER TABLE Users ADD constraint Legal_EntitiesUsers foreign key (LE_ID) references Legal_Entities(ID);
-- 27.2.2018 ใ. 16:10:50
DROP function if exists chk_BC_Exists;
CREATE function chk_BC_Exists() RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO SST_Log ( Log_Date, Log_Source, Log_Text, Log_Type, Mail_ID, ID )
SELECT Now() AS Log_Date, 'chk_BC_Exists' AS Log_Source, 'No business case for ' || npe_code || ' which is in status '' || npe_status_code || ''' AS Log_Text, 2 AS Log_Type, NPE_History.m_ID, Business_Cases.ID
FROM Nom_NPE_Status INNER JOIN (NPE_List INNER JOIN (NPE_History LEFT JOIN Business_Cases ON (NPE_History.m_ID = Business_Cases.m_ID) AND (NPE_History.NPE_ID = Business_Cases.NPE_ID)) ON NPE_List.ID = NPE_History.NPE_ID) ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID
WHERE (((NPE_History.NPE_Status_ID) In (10,19,20)) AND ((Business_Cases.ID) Is Null));

$$;
-- 21.3.2018 ใ. 18:42:53
DROP view if exists chk_BV;
CREATE VIEW chk_BV AS
SELECT Asset_History.Rep_Date, Assets_List.Asset_Code, Assets_List.Asset_Name, Asset_History.Book_Value_PM, Asset_History.Inflows, Asset_History.CAPEX, Asset_History.Depreciation, Asset_History.Sales, Asset_History.Imp_WB, Asset_History.Book_Value, Asset_History.m_ID
FROM Assets_List INNER JOIN Asset_History ON Assets_List.ID = Asset_History.Asset_ID
WHERE (((Round( case when  Asset_History.Book_Value_PM is null  then 0 else Asset_History.Book_Value_PM end + case when  Asset_History.Inflows is null  then 0 else Asset_History.Inflows end + case when  Asset_History.CAPEX is null  then 0 else Asset_History.CAPEX end + case when  Asset_History.Depreciation is null  then 0 else Asset_History.Depreciation end + case when  Asset_History.Sales is null  then 0 else Asset_History.Sales end + case when  Asset_History.Imp_WB is null  then 0 else Asset_History.Imp_WB end - case when  Asset_History.Book_Value is null  then 0 else Asset_History.Book_Value end ,0))<>0) AND ((Asset_History.m_ID)=-1));

-- 27.2.2018 ใ. 18:27:59
DROP view if exists Copy of drop_npe_from_repossessions;
CREATE VIEW Copy of drop_npe_from_repossessions AS
SELECT NPE_List.NPE_Code, Assets_List.Asset_NPE_ID, Sum(Asset_Repossession.NPE_Amount_CCY) AS SumOfNPE_Amount_CCY, Sum(Asset_Repossession.NPE_Amount_EUR) AS SumOfNPE_Amount_EUR, Sum(Asset_Repossession.LLP_Amount_CCY) AS SumOfLLP_Amount_CCY, Sum(Asset_Repossession.LLP_Amount_EUR) AS SumOfLLP_Amount_EUR, Asset_Repossession.NPE_Currency_ID
FROM NPE_List INNER JOIN (Assets_List INNER JOIN Asset_Repossession ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Repossession.m_ID)=131))
GROUP BY NPE_List.NPE_Code, Assets_List.Asset_NPE_ID, Asset_Repossession.NPE_Currency_ID;

-- 2.4.2018 ใ. 8:57:10
DROP function if exists del_Asset_Financials;
CREATE function del_Asset_Financials( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Financials
WHERE m_id=-1
 and Asset_ID in (select old_parent.id from (Asset_Financials as new_tab0 inner join Assets_List new_parent on new_parent.id=new_tab0.Asset_ID) inner join Assets_List old_parent on new_parent.Asset_Code=old_parent.Asset_Code where new_tab0.m_ID=p_m_ID)
 and Rep_Date in (select new_tab1.Rep_Date from Asset_Financials as new_tab1 where new_tab1.m_id=p_m_ID);

$$;
-- 30.12.2017 ใ. 17:28:24
DROP function if exists delAssetAppraisals;
CREATE function delAssetAppraisals() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Appraisals;

$$;
-- 3.12.2017 ใ. 21:57:59
DROP function if exists delAssetFinancing;
CREATE function delAssetFinancing() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Financing;

$$;
-- 3.12.2017 ใ. 21:58:19
DROP function if exists delAssetInsurances;
CREATE function delAssetInsurances() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Insurances;

$$;
-- 30.12.2017 ใ. 17:30:24
DROP function if exists delEmptyAppraisals;
CREATE function delEmptyAppraisals() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Appraisals
WHERE (((Asset_Appraisals.Appraisal_Date) Is Null) AND ((Asset_Appraisals.Appraisal_Market_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Market_Value_EUR)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_EUR)=0));

$$;
-- 30.12.2017 ใ. 17:37:34
DROP function if exists delEmptyFinancing;
CREATE function delEmptyFinancing() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Financing
WHERE (((Asset_Financing.Financing_Amount_CCY)=0) AND ((Asset_Financing.Financing_Amount_EUR)=0) AND ((Asset_Financing.Financing_Start_Date) Is Null) AND ((Asset_Financing.Financing_End_Date) Is Null));

$$;
-- 30.12.2017 ใ. 17:37:42
DROP function if exists delEmptyInsurances;
CREATE function delEmptyInsurances() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Insurances
WHERE (((Asset_Insurances.Insurance_Amount_CCY)=0) AND ((Asset_Insurances.Insurance_Amount_EUR)=0) AND ((Asset_Insurances.Insurance_Premium_CCY)=0) AND ((Asset_Insurances.Insurance_Premium_EUR)=0) AND ((Asset_Insurances.Insurance_Start_Date)='2000-1-1') AND ((Asset_Insurances.Insurance_End_Date) Is Null));

$$;
-- 30.12.2017 ใ. 17:37:22
DROP function if exists delEmptyRentals;
CREATE function delEmptyRentals() RETURNS  void  LANGUAGE 'sql' AS $$
DELETE FROM Asset_Rentals
WHERE (((Asset_Rentals.Rental_Amount_CCY)=0) AND ((Asset_Rentals.Rental_Amount_EUR)=0) AND ((Asset_Rentals.Rental_Contract_Date)='2000-1-1') AND ((Asset_Rentals.Rental_Start_Date) Is Null) AND ((Asset_Rentals.Rental_End_Date) Is Null));

$$;
-- 28.3.2018 ใ. 22:59:26
DROP view if exists drop_del_app;
CREATE VIEW drop_del_app AS
SELECT Asset_Appraisals.ID, Asset_Appraisals.Appraisal_Asset_ID, Asset_Appraisals.Appraisal_Date, Asset_Appraisals.Appraisal_Company_ID, Asset_Appraisals.Appraisal_Currency_ID, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR, Asset_Appraisals.Appraisal_Order, Asset_Appraisals.m_ID, drop_dup_appraisals.MinOfID
FROM Asset_Appraisals INNER JOIN drop_dup_appraisals ON (Asset_Appraisals.Appraisal_Asset_ID = drop_dup_appraisals.Appraisal_Asset_ID) AND (Asset_Appraisals.m_ID = drop_dup_appraisals.m_ID)
WHERE (((drop_dup_appraisals.MaxOfAppraisal_Market_Value_CCY)=MinOfAppraisal_Market_Value_CCY) AND ((drop_dup_appraisals.MaxOfAppraisal_Market_Value_EUR)=MinOfAppraisal_Market_Value_EUR) AND ((drop_dup_appraisals.MaxOfAppraisal_Firesale_Value_CCY)=MinOfAppraisal_Firesale_Value_CCY) AND ((drop_dup_appraisals.MaxOfAppraisal_Firesale_Value_EUR)=MinOfAppraisal_Firesale_Value_EUR) AND ((drop_dup_appraisals.MaxOfAppraisal_Company_ID)=MinOfAppraisal_Company_ID));

-- 28.3.2018 ใ. 22:57:30
DROP view if exists drop_dup_appraisals;
CREATE VIEW drop_dup_appraisals AS
SELECT Asset_Appraisals.Appraisal_Asset_ID, Asset_Appraisals.Appraisal_Date, Asset_Appraisals.m_ID, Count(Asset_Appraisals.ID) AS CountOfID, Max(Asset_Appraisals.Appraisal_Company_ID) AS MaxOfAppraisal_Company_ID, Min(Asset_Appraisals.Appraisal_Company_ID) AS MinOfAppraisal_Company_ID, Max(Asset_Appraisals.Appraisal_Market_Value_CCY) AS MaxOfAppraisal_Market_Value_CCY, Min(Asset_Appraisals.Appraisal_Market_Value_CCY) AS MinOfAppraisal_Market_Value_CCY, Max(Asset_Appraisals.Appraisal_Market_Value_EUR) AS MaxOfAppraisal_Market_Value_EUR, Min(Asset_Appraisals.Appraisal_Market_Value_EUR) AS MinOfAppraisal_Market_Value_EUR, Max(Asset_Appraisals.Appraisal_Firesale_Value_CCY) AS MaxOfAppraisal_Firesale_Value_CCY, Min(Asset_Appraisals.Appraisal_Firesale_Value_CCY) AS MinOfAppraisal_Firesale_Value_CCY, Max(Asset_Appraisals.Appraisal_Firesale_Value_EUR) AS MaxOfAppraisal_Firesale_Value_EUR, Min(Asset_Appraisals.Appraisal_Firesale_Value_EUR) AS MinOfAppraisal_Firesale_Value_EUR, 1 AS Order, Min(Asset_Appraisals.ID) AS MinOfID
FROM Asset_Appraisals
GROUP BY Asset_Appraisals.Appraisal_Asset_ID, Asset_Appraisals.Appraisal_Date, Asset_Appraisals.m_ID, 1
HAVING (((Count(Asset_Appraisals.ID))>1));

-- 27.2.2018 ใ. 18:21:32
DROP view if exists drop_npe_from_repossessions;
CREATE VIEW drop_npe_from_repossessions AS
SELECT NPE_List.NPE_Code, Assets_List.Asset_NPE_ID, Sum(Asset_Repossession.NPE_Amount_CCY) AS SumOfNPE_Amount_CCY, Sum(Asset_Repossession.NPE_Amount_EUR) AS SumOfNPE_Amount_EUR, Sum(Asset_Repossession.LLP_Amount_CCY) AS SumOfLLP_Amount_CCY, Sum(Asset_Repossession.LLP_Amount_EUR) AS SumOfLLP_Amount_EUR, Asset_Repossession.NPE_Currency_ID
FROM NPE_List INNER JOIN (Assets_List INNER JOIN Asset_Repossession ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Repossession.m_ID)=122))
GROUP BY NPE_List.NPE_Code, Assets_List.Asset_NPE_ID, Asset_Repossession.NPE_Currency_ID;

-- 9.2.2018 ใ. 13:09:20
DROP function if exists FX_Pipeline_Update;
CREATE function FX_Pipeline_Update() RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE NPE_List INNER JOIN NPE_History ON NPE_List.ID = NPE_History.NPE_ID, (Nom_Countries INNER JOIN Nom_Currencies ON Nom_Countries.Currency_ID = Nom_Currencies.ID) INNER JOIN FX_Rates ON Nom_Currencies.Currency_Code = FX_Rates.CCY_Code SET NPE_History.NPE_Currency = Currency_Code, NPE_History.NPE_Amount_CCY = npe_history.npe_amount_eur* case when npe_history.NPE_Status_ID=8 then fx_rate_eop else fx_rate_avg end 
WHERE (((Nom_Countries.MIS_Code)=Left(npe_code,2)) And ((NPE_History.m_ID)=-1) And ((FX_Rates.Scenario)='Bud') And ((FX_Rates.RepDate)= case when npe_history.npe_status_id=8 then #12/31/2018# else #12/31/2017# end ));

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Appraisals;
CREATE function ins_Asset_Appraisals( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Appraisals
( Appraisal_Asset_ID, Appraisal_Company_ID, Appraisal_Date, Appraisal_Currency_ID, Appraisal_Market_Value_CCY, Appraisal_Market_Value_EUR, Appraisal_Firesale_Value_CCY, Appraisal_Firesale_Value_EUR, Appraisal_Order, m_ID) SELECT new_parent.ID AS Appraisal_Asset_ID, new_tab.Appraisal_Company_ID AS Appraisal_Company_ID, new_tab.Appraisal_Date AS Appraisal_Date, new_tab.Appraisal_Currency_ID AS Appraisal_Currency_ID, new_tab.Appraisal_Market_Value_CCY AS Appraisal_Market_Value_CCY, new_tab.Appraisal_Market_Value_EUR AS Appraisal_Market_Value_EUR, new_tab.Appraisal_Firesale_Value_CCY AS Appraisal_Firesale_Value_CCY, new_tab.Appraisal_Firesale_Value_EUR AS Appraisal_Firesale_Value_EUR, new_tab.Appraisal_Order AS Appraisal_Order, -1 AS m_ID
FROM (Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Appraisals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Appraisal_Asset_ID=new_parent.id
   and dw_tab.Appraisal_Date=new_tab.Appraisal_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Financials;
CREATE function ins_Asset_Financials( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Financials
( Asset_ID, Acc_Date, Account_No, Account_Name, Amount, Trans_Type_ID, Rep_Date, m_ID) SELECT new_parent.ID AS Asset_ID, new_tab.Acc_Date AS Acc_Date, new_tab.Account_No AS Account_No, new_tab.Account_Name AS Account_Name, new_tab.Amount AS Amount, new_tab.Trans_Type_ID AS Trans_Type_ID, new_tab.Rep_Date AS Rep_Date, -1 AS m_ID
FROM (Asset_Financials AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financials as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Financing;
CREATE function ins_Asset_Financing( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Financing
( Financing_Contract_Code, Financing_Counterpart_ID, Financing_Asset_ID, Financing_Type_ID, Financing_Currency_ID, Financing_Amount_CCY, Financing_Amount_EUR, Financing_Reference_Rate, Financing_Margin, Financing_Rate, Financing_Start_Date, Financing_End_Date, Financing_Contract_Date, m_ID) SELECT new_tab.Financing_Contract_Code AS Financing_Contract_Code, new_tab.Financing_Counterpart_ID AS Financing_Counterpart_ID, new_parent.ID AS Financing_Asset_ID, new_tab.Financing_Type_ID AS Financing_Type_ID, new_tab.Financing_Currency_ID AS Financing_Currency_ID, new_tab.Financing_Amount_CCY AS Financing_Amount_CCY, new_tab.Financing_Amount_EUR AS Financing_Amount_EUR, new_tab.Financing_Reference_Rate AS Financing_Reference_Rate, new_tab.Financing_Margin AS Financing_Margin, new_tab.Financing_Rate AS Financing_Rate, new_tab.Financing_Start_Date AS Financing_Start_Date, new_tab.Financing_End_Date AS Financing_End_Date, new_tab.Financing_Contract_Date AS Financing_Contract_Date, -1 AS m_ID
FROM (Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financing as dw_tab where dw_tab.m_id = -1
   and dw_tab.Financing_Asset_ID=new_parent.id
   and dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID
   and dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_History;
CREATE function ins_Asset_History( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_History
( Asset_ID, Rep_Date, Status_Code, Currency_ID, Book_Value_PM, Inflows, CAPEX, Depreciation, Sales, Imp_WB, Book_Value, Costs, Income, Expected_Exit, m_ID) SELECT new_parent.ID AS Asset_ID, new_tab.Rep_Date AS Rep_Date, new_tab.Status_Code AS Status_Code, new_tab.Currency_ID AS Currency_ID, new_tab.Book_Value_PM AS Book_Value_PM, new_tab.Inflows AS Inflows, new_tab.CAPEX AS CAPEX, new_tab.Depreciation AS Depreciation, new_tab.Sales AS Sales, new_tab.Imp_WB AS Imp_WB, new_tab.Book_Value AS Book_Value, new_tab.Costs AS Costs, new_tab.Income AS Income, new_tab.Expected_Exit AS Expected_Exit, -1 AS m_ID
FROM (Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Insurances;
CREATE function ins_Asset_Insurances( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Insurances
( Insurance_Asset_ID, Insurance_Company_ID, Insurance_Start_Date, Insurance_End_Date, Insurance_Currency_ID, Insurance_Amount_CCY, Insurance_Amount_EUR, Insurance_Premium_CCY, Insurance_Premium_EUR, m_ID) SELECT new_parent.ID AS Insurance_Asset_ID, new_tab.Insurance_Company_ID AS Insurance_Company_ID, new_tab.Insurance_Start_Date AS Insurance_Start_Date, new_tab.Insurance_End_Date AS Insurance_End_Date, new_tab.Insurance_Currency_ID AS Insurance_Currency_ID, new_tab.Insurance_Amount_CCY AS Insurance_Amount_CCY, new_tab.Insurance_Amount_EUR AS Insurance_Amount_EUR, new_tab.Insurance_Premium_CCY AS Insurance_Premium_CCY, new_tab.Insurance_Premium_EUR AS Insurance_Premium_EUR, -1 AS m_ID
FROM (Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Insurances as dw_tab where dw_tab.m_id = -1
   and dw_tab.Insurance_Asset_ID=new_parent.id
   and dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Rentals;
CREATE function ins_Asset_Rentals( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Rentals
( Rental_Asset_ID, Rental_Counterpart_ID, Rental_Contract_Date, Rental_Start_Date, Rental_End_Date, Rental_Payment_Date, Rental_Currency_ID, Rental_Amount_CCY, Rental_Amount_EUR, m_ID) SELECT new_parent.ID AS Rental_Asset_ID, new_tab.Rental_Counterpart_ID AS Rental_Counterpart_ID, new_tab.Rental_Contract_Date AS Rental_Contract_Date, new_tab.Rental_Start_Date AS Rental_Start_Date, new_tab.Rental_End_Date AS Rental_End_Date, new_tab.Rental_Payment_Date AS Rental_Payment_Date, new_tab.Rental_Currency_ID AS Rental_Currency_ID, new_tab.Rental_Amount_CCY AS Rental_Amount_CCY, new_tab.Rental_Amount_EUR AS Rental_Amount_EUR, -1 AS m_ID
FROM (Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Rentals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Rental_Asset_ID=new_parent.id
   and dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Repossession;
CREATE function ins_Asset_Repossession( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Repossession
( Repossession_Asset_ID, NPE_Currency_ID, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_Currency_ID, Appr_Purchase_Price_Net_CCY, Appr_Purchase_Price_Net_EUR, Purchase_Price_Net_CCY, Purchase_Price_Net_EUR, Purchase_Costs_CCY, Purchase_Costs_EUR, Planned_CAPEX_Currency_ID, Planned_CAPEX_CCY, Planned_CAPEX_EUR, Planned_CAPEX_Comment, Purchase_Auction_Date, Purchase_Contract_Date, Purchase_Repossession_Date, Purchase_Payment_Date, Purchase_Handover_Date, Purchase_Registration_Date, Purchase_Local_Approval_Date, Purchase_Central_Approval_Date, Purchase_Prolongation_Date, Purchase_Expected_Exit_Date, Planned_OPEX_CCY, Planned_OPEX_EUR, Planned_OPEX_Comment, Planned_SalesPrice_CCY, Planned_SalesPrice_EUR, m_ID) SELECT new_parent.ID AS Repossession_Asset_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_Currency_ID AS Purchase_Price_Currency_ID, new_tab.Appr_Purchase_Price_Net_CCY AS Appr_Purchase_Price_Net_CCY, new_tab.Appr_Purchase_Price_Net_EUR AS Appr_Purchase_Price_Net_EUR, new_tab.Purchase_Price_Net_CCY AS Purchase_Price_Net_CCY, new_tab.Purchase_Price_Net_EUR AS Purchase_Price_Net_EUR, new_tab.Purchase_Costs_CCY AS Purchase_Costs_CCY, new_tab.Purchase_Costs_EUR AS Purchase_Costs_EUR, new_tab.Planned_CAPEX_Currency_ID AS Planned_CAPEX_Currency_ID, new_tab.Planned_CAPEX_CCY AS Planned_CAPEX_CCY, new_tab.Planned_CAPEX_EUR AS Planned_CAPEX_EUR, new_tab.Planned_CAPEX_Comment AS Planned_CAPEX_Comment, new_tab.Purchase_Auction_Date AS Purchase_Auction_Date, new_tab.Purchase_Contract_Date AS Purchase_Contract_Date, new_tab.Purchase_Repossession_Date AS Purchase_Repossession_Date, new_tab.Purchase_Payment_Date AS Purchase_Payment_Date, new_tab.Purchase_Handover_Date AS Purchase_Handover_Date, new_tab.Purchase_Registration_Date AS Purchase_Registration_Date, new_tab.Purchase_Local_Approval_Date AS Purchase_Local_Approval_Date, new_tab.Purchase_Central_Approval_Date AS Purchase_Central_Approval_Date, new_tab.Purchase_Prolongation_Date AS Purchase_Prolongation_Date, new_tab.Purchase_Expected_Exit_Date AS Purchase_Expected_Exit_Date, new_tab.Planned_OPEX_CCY AS Planned_OPEX_CCY, new_tab.Planned_OPEX_EUR AS Planned_OPEX_EUR, new_tab.Planned_OPEX_Comment AS Planned_OPEX_Comment, new_tab.Planned_SalesPrice_CCY AS Planned_SalesPrice_CCY, new_tab.Planned_SalesPrice_EUR AS Planned_SalesPrice_EUR, -1 AS m_ID
FROM (Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Repossession as dw_tab where dw_tab.m_id = -1
   and dw_tab.Repossession_Asset_ID=new_parent.id
   and dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Asset_Sales;
CREATE function ins_Asset_Sales( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_Sales
( Sale_Asset_ID, Sale_Counterpart_ID, Sale_Approval_Date, Sale_Contract_Date, Sale_Transfer_Date, Sale_Payment_Date, Sale_AML_Check_Date, Sale_AML_Pass_Date, Sale_Currency_ID, Sale_ApprovedAmt_CCY, Sale_ApprovedAmt_EUR, Sale_Amount_CCY, Sale_Amount_EUR, Sale_Book_Value_CCY, Sale_Book_Value_EUR, m_ID) SELECT new_parent.ID AS Sale_Asset_ID, new_tab.Sale_Counterpart_ID AS Sale_Counterpart_ID, new_tab.Sale_Approval_Date AS Sale_Approval_Date, new_tab.Sale_Contract_Date AS Sale_Contract_Date, new_tab.Sale_Transfer_Date AS Sale_Transfer_Date, new_tab.Sale_Payment_Date AS Sale_Payment_Date, new_tab.Sale_AML_Check_Date AS Sale_AML_Check_Date, new_tab.Sale_AML_Pass_Date AS Sale_AML_Pass_Date, new_tab.Sale_Currency_ID AS Sale_Currency_ID, new_tab.Sale_ApprovedAmt_CCY AS Sale_ApprovedAmt_CCY, new_tab.Sale_ApprovedAmt_EUR AS Sale_ApprovedAmt_EUR, new_tab.Sale_Amount_CCY AS Sale_Amount_CCY, new_tab.Sale_Amount_EUR AS Sale_Amount_EUR, new_tab.Sale_Book_Value_CCY AS Sale_Book_Value_CCY, new_tab.Sale_Book_Value_EUR AS Sale_Book_Value_EUR, -1 AS m_ID
FROM (Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Sales as dw_tab where dw_tab.m_id = -1
   and dw_tab.Sale_Asset_ID=new_parent.id
   and dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Assets_List;
CREATE function ins_Assets_List( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Assets_List
( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID) SELECT new_tab.Asset_Code AS Asset_Code, new_parent.ID AS Asset_NPE_ID, new_tab.Asset_Name AS Asset_Name, new_tab.Asset_Description AS Asset_Description, new_tab.Asset_Address AS Asset_Address, new_tab.Asset_ZIP AS Asset_ZIP, new_tab.Asset_Region AS Asset_Region, new_tab.Asset_Country_ID AS Asset_Country_ID, new_tab.Asset_Usage_ID AS Asset_Usage_ID, new_tab.Asset_Type_ID AS Asset_Type_ID, new_tab.Asset_Usable_Area AS Asset_Usable_Area, new_tab.Asset_Common_Area AS Asset_Common_Area, new_tab.Asset_Owned AS Asset_Owned, new_tab.Comment AS Comment, -1 AS m_ID
FROM (Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Assets_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_Code=new_tab.Asset_Code
);

$$;
-- 6.1.2018 ใ. 20:54:53
DROP function if exists ins_Assets_List2;
CREATE function ins_Assets_List2( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Assets_List ( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID )
SELECT Assets_List.Asset_Code, NPE_List_DW.ID, Assets_List.Asset_Name, Assets_List.Asset_Description, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Assets_List.Asset_Country_ID, Assets_List.Asset_Usage_ID, Assets_List.Asset_Type_ID, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Asset_Owned, Assets_List.Comment, -1 AS DW_m_ID
FROM (NPE_List INNER JOIN Assets_List ON NPE_List.ID = Assets_List.Asset_NPE_ID) INNER JOIN NPE_List AS NPE_List_DW ON NPE_List.NPE_Code = NPE_List_DW.NPE_Code
WHERE (((Assets_List.m_ID)=p_m_ID) AND ((Exists (select 1 from Assets_list al_dwh where al_dwh.asset_code=assets_list.Asset_Code))=False));

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_Business_Cases;
CREATE function ins_Business_Cases( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Business_Cases
( NPE_ID, BC_Date, BC_Comment, BC_Purchase_Date, BC_Purchase_Price_EUR, Exp_CAPEX_EUR, Exp_CAPEX_Time, Exp_Sale_Date, Exp_Sale_Price_EUR, Exp_Interest_EUR, Exp_OPEX_EUR, Exp_Income_EUR, m_ID) SELECT new_parent.ID AS NPE_ID, new_tab.BC_Date AS BC_Date, new_tab.BC_Comment AS BC_Comment, new_tab.BC_Purchase_Date AS BC_Purchase_Date, new_tab.BC_Purchase_Price_EUR AS BC_Purchase_Price_EUR, new_tab.Exp_CAPEX_EUR AS Exp_CAPEX_EUR, new_tab.Exp_CAPEX_Time AS Exp_CAPEX_Time, new_tab.Exp_Sale_Date AS Exp_Sale_Date, new_tab.Exp_Sale_Price_EUR AS Exp_Sale_Price_EUR, new_tab.Exp_Interest_EUR AS Exp_Interest_EUR, new_tab.Exp_OPEX_EUR AS Exp_OPEX_EUR, new_tab.Exp_Income_EUR AS Exp_Income_EUR, -1 AS m_ID
FROM (Business_Cases AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Business_Cases as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.BC_Date=new_tab.BC_Date
);

$$;
-- 6.3.2018 ใ. 17:22:29
DROP function if exists ins_CopyActualAssets;
CREATE function ins_CopyActualAssets() RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO Asset_History ( Asset_ID, Rep_Date, Status_Code, Book_Value_PM, Expected_Exit, m_ID )
SELECT Asset_History.Asset_ID, LastDate.CurrMonth, Asset_History.Status_Code, Asset_History.Book_Value, Asset_History.Expected_Exit, Asset_History.m_ID
FROM Asset_History INNER JOIN LastDate ON Asset_History.Rep_Date = LastDate.PrevMonth
WHERE (((Asset_History.m_ID)=-1));

$$;
-- 1.3.2018 ใ. 19:01:16
DROP function if exists ins_CopyActualNPEs;
CREATE function ins_CopyActualNPEs() RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO NPE_History ( NPE_ID, Rep_Date, NPE_Status_ID, NPE_Scenario_ID, NPE_Rep_Date, NPE_Currency, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_CCY, Purchase_Price_EUR, m_ID )
SELECT NPE_History.NPE_ID, LastDate.CurrMonth, NPE_History.NPE_Status_ID, NPE_History.NPE_Scenario_ID, NPE_History.NPE_Rep_Date, NPE_History.NPE_Currency, NPE_History.NPE_Amount_CCY, NPE_History.NPE_Amount_EUR, NPE_History.LLP_Amount_CCY, NPE_History.LLP_Amount_EUR, NPE_History.Purchase_Price_CCY, NPE_History.Purchase_Price_EUR, NPE_History.m_ID
FROM NPE_History INNER JOIN LastDate ON NPE_History.Rep_Date = LastDate.PrevMonth
WHERE (((NPE_History.NPE_Scenario_ID)=6) AND ((NPE_History.m_ID)=-1));

$$;
-- 1.3.2018 ใ. 15:00:26
DROP function if exists ins_CopyActuals;
CREATE function ins_CopyActuals() RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO NPE_History ( NPE_ID, Rep_Date, NPE_Status_ID, NPE_Scenario_ID, NPE_Rep_Date, NPE_Currency, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_CCY, Purchase_Price_EUR, m_ID )
SELECT NPE_History.NPE_ID, LastDate.CurrMonth AS RepDate, Max(NPE_History.NPE_Status_ID) AS MaxOfNPE_Status_ID, 6 AS NPE_Scenario_ID_, Max( case when npe_history.npe_scenario_id=11 then npe_history.npe_rep_date else Null end ) AS FC_Rep_Date, 'EUR' AS NPE_Currency, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_CCY, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_EUR, Sum(NPE_History.LLP_Amount_CCY) AS SumOfLLP_Amount_CCY, Sum(NPE_History.LLP_Amount_EUR) AS SumOfLLP_Amount_EUR, Sum(NPE_History.Purchase_Price_CCY) AS SumOfPurchase_Price_CCY, Sum(NPE_History.Purchase_Price_EUR) AS SumOfPurchase_Price_EUR, NPE_History.m_ID
FROM NPE_History INNER JOIN LastDate ON NPE_History.Rep_Date = LastDate.PrevMonth
WHERE (((NPE_History.NPE_Scenario_ID) In (6,11)))
GROUP BY NPE_History.NPE_ID, LastDate.CurrMonth, 6, NPE_History.m_ID
HAVING (((NPE_History.m_ID)=-1));

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_NPE_History;
CREATE function ins_NPE_History( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO NPE_History
( NPE_ID, Rep_Date, NPE_Status_ID, NPE_Scenario_ID, NPE_Rep_Date, NPE_Currency, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_CCY, Purchase_Price_EUR, m_ID) SELECT new_parent.ID AS NPE_ID, new_tab.Rep_Date AS Rep_Date, new_tab.NPE_Status_ID AS NPE_Status_ID, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Rep_Date AS NPE_Rep_Date, new_tab.NPE_Currency AS NPE_Currency, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_CCY AS Purchase_Price_CCY, new_tab.Purchase_Price_EUR AS Purchase_Price_EUR, -1 AS m_ID
FROM (NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from NPE_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
   and dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID
);

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists ins_NPE_List;
CREATE function ins_NPE_List( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
INSERT INTO NPE_List
( NPE_Code, NPE_Scenario_ID, NPE_Country_ID, NPE_Name, NPE_Description, NPE_Lender_ID, NPE_Borrower_ID, NPE_Currency_ID, NPE_Amount_Date, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, NPE_Owned, m_ID) SELECT new_tab.NPE_Code AS NPE_Code, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Country_ID AS NPE_Country_ID, new_tab.NPE_Name AS NPE_Name, new_tab.NPE_Description AS NPE_Description, new_tab.NPE_Lender_ID AS NPE_Lender_ID, new_tab.NPE_Borrower_ID AS NPE_Borrower_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_Date AS NPE_Amount_Date, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.NPE_Owned AS NPE_Owned, -1 AS m_ID
FROM NPE_List AS new_tab
WHERE new_tab.m_id = p_m_ID
   and not exists (select 1 from NPE_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_Code=new_tab.NPE_Code
);

$$;
-- 30.1.2018 ใ. 16:02:25
DROP view if exists NPE_Status;
CREATE VIEW NPE_Status AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Nom_Scenarios.Scenario_Name, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR, NPE_List.NPE_Owned, NPE_History.Rep_Date, Nom_NPE_Status.NPE_Status_Code, Max(Currencies_1.Currency_Code) AS MaxอเCurrency_Code, Sum(Asset_Repossession.NPE_Amount_CCY) AS SumอเNPE_Amount_CCY, Sum(Asset_Repossession.NPE_Amount_EUR) AS SumอเNPE_Amount_EUR, Sum(Asset_Repossession.LLP_Amount_CCY) AS SumอเLLP_Amount_CCY, Sum(Asset_Repossession.LLP_Amount_EUR) AS SumอเLLP_Amount_EUR
FROM ((Nom_Currencies RIGHT JOIN (NPE_List LEFT JOIN Nom_Scenarios ON NPE_List.NPE_Scenario_ID = Nom_Scenarios.ID) ON Nom_Currencies.ID = NPE_List.NPE_Currency_ID) LEFT JOIN (Assets_List LEFT JOIN (Nom_Currencies AS Currencies_1 RIGHT JOIN Asset_Repossession ON Currencies_1.ID = Asset_Repossession.NPE_Currency_ID) ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID) LEFT JOIN (Nom_NPE_Status RIGHT JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID
GROUP BY NPE_List.NPE_Code, NPE_List.NPE_Name, Nom_Scenarios.Scenario_Name, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR, NPE_List.NPE_Owned, NPE_History.Rep_Date, Nom_NPE_Status.NPE_Status_Code;

-- 19.3.2018 ใ. 17:07:35
DROP view if exists rep_Asset_Status;
CREATE VIEW rep_Asset_Status AS
SELECT Min(Asset_History.Rep_Date) AS Period_From, Max(Asset_History.Rep_Date) AS Period_To, Assets_List.Asset_Code, Assets_List.Asset_Name, Assets_List.Asset_Description, Nom_Asset_Owned.Asset_Owned, Max( case when rep_date=currmonth then Asset_Status_Code else Null end ) AS Status_Code, Nom_Currencies.Currency_Code, Sum(Asset_History.Book_Value_PM) AS SumOfBook_Value_PM, Sum(Inflows/fx_rate_avg) AS Inflows_EUR, Sum(CAPEX/fx_rate_Avg) AS CAPEX_EUR, Sum(Depreciation/fx_rate_avg) AS Depreciation_EUR, Sum(Sales/fx_rate_Avg) AS Sales_EUR, Sum(Imp_WB/FX_Rate_Avg) AS Imp_WB_EUR, Sum( case when Rep_Date=CurrMonth then Book_Value/FX_Rate_EOP else 0 end ) AS Book_Value_Eop, Asset_History.Expected_Exit, FX_Rates.FX_Rate_Eop
FROM LastDate, Nom_Asset_Owned INNER JOIN (Assets_List INNER JOIN (((Nom_Currencies INNER JOIN Asset_History ON Nom_Currencies.ID = Asset_History.Currency_ID) INNER JOIN FX_Rates ON (FX_Rates.RepDate = Asset_History.Rep_Date) AND (Nom_Currencies.Currency_Code = FX_Rates.CCY_Code)) INNER JOIN Nom_Asset_Status ON Asset_History.Status_Code = Nom_Asset_Status.ID) ON Assets_List.ID = Asset_History.Asset_ID) ON Nom_Asset_Owned.ID = Assets_List.Asset_Owned
WHERE (((Asset_History.m_ID)=-1) AND ((FX_Rates.Scenario)='Act') AND ((Asset_History.rep_date) Between begYear And CurrMonth))
GROUP BY Assets_List.Asset_Code, Assets_List.Asset_Name, Assets_List.Asset_Description, Nom_Asset_Owned.Asset_Owned, Nom_Currencies.Currency_Code, Asset_History.Expected_Exit, FX_Rates.FX_Rate_Eop;

-- 2.3.2018 ใ. 10:16:19
DROP view if exists rep_Business_Cases;
CREATE VIEW rep_Business_Cases AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Business_Cases.BC_Date, Business_Cases.BC_Comment, Business_Cases.BC_Purchase_Date, Business_Cases.BC_Purchase_Price_EUR, Business_Cases.Exp_CAPEX_EUR, Business_Cases.Exp_CAPEX_Time, Business_Cases.Exp_Sale_Date, Business_Cases.Exp_Sale_Price_EUR, Business_Cases.Exp_Interest_EUR, Business_Cases.Exp_OPEX_EUR, Business_Cases.Exp_Income_EUR
FROM Business_Cases INNER JOIN NPE_List ON Business_Cases.NPE_ID = NPE_List.ID
WHERE (((Business_Cases.m_ID)=-1));

-- 14.3.2018 ใ. 10:36:49
DROP view if exists rep_Pipeline_Status;
CREATE VIEW rep_Pipeline_Status AS
SELECT Left(NPE_Code,2) AS Country, NPE_List.NPE_Code, NPE_List.NPE_Name, Nom_NPE_Status.NPE_Status_Code, NPE_History.NPE_Rep_Date, NPE_History.NPE_Amount_CCY, NPE_History.NPE_Amount_EUR
FROM (NPE_List INNER JOIN (Nom_NPE_Status INNER JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID) INNER JOIN LastDate ON NPE_History.Rep_Date = LastDate.CurrMonth
WHERE (((NPE_History.m_ID)=-1));

-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Appraisals;
CREATE function sel_Asset_Appraisals( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_Appraisal_Company_ID varchar,new_Appraisal_Company_ID varchar,Appraisal_Date date,old_Appraisal_Currency_ID varchar,new_Appraisal_Currency_ID varchar,old_Appraisal_Market_Value_CCY double precision,new_Appraisal_Market_Value_CCY double precision,old_Appraisal_Market_Value_EUR double precision,new_Appraisal_Market_Value_EUR double precision,old_Appraisal_Firesale_Value_CCY double precision,new_Appraisal_Firesale_Value_CCY double precision,old_Appraisal_Firesale_Value_EUR double precision,new_Appraisal_Firesale_Value_EUR double precision,old_Appraisal_Order integer,new_Appraisal_Order integer,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Appraisal_Company_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Appraisal_Company_ID, tab.Appraisal_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Appraisal_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Appraisal_Currency_ID, max( case when tab.m_id=-1 then  tab.Appraisal_Market_Value_CCY else null end ) AS old_Appraisal_Market_Value_CCY, max( case when tab.m_id<>-1 then  tab.Appraisal_Market_Value_CCY else null end ) AS new_Appraisal_Market_Value_CCY, max( case when tab.m_id=-1 then  tab.Appraisal_Market_Value_EUR else null end ) AS old_Appraisal_Market_Value_EUR, max( case when tab.m_id<>-1 then  tab.Appraisal_Market_Value_EUR else null end ) AS new_Appraisal_Market_Value_EUR, max( case when tab.m_id=-1 then  tab.Appraisal_Firesale_Value_CCY else null end ) AS old_Appraisal_Firesale_Value_CCY, max( case when tab.m_id<>-1 then  tab.Appraisal_Firesale_Value_CCY else null end ) AS new_Appraisal_Firesale_Value_CCY, max( case when tab.m_id=-1 then  tab.Appraisal_Firesale_Value_EUR else null end ) AS old_Appraisal_Firesale_Value_EUR, max( case when tab.m_id<>-1 then  tab.Appraisal_Firesale_Value_EUR else null end ) AS new_Appraisal_Firesale_Value_EUR, max( case when tab.m_id=-1 then  tab.Appraisal_Order else null end ) AS old_Appraisal_Order, max( case when tab.m_id<>-1 then  tab.Appraisal_Order else null end ) AS new_Appraisal_Order,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Appraisals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Appraisal_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Appraisal_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Appraisal_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Appraisal_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Financials;
CREATE function sel_Asset_Financials( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_Acc_Date date,new_Acc_Date date,old_Account_No varchar,new_Account_No varchar,old_Account_Name varchar,new_Account_Name varchar,old_Amount integer,new_Amount integer,old_Trans_Type_ID integer,new_Trans_Type_ID integer,Rep_Date date,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  tab.Acc_Date else null end ) AS old_Acc_Date, max( case when tab.m_id<>-1 then  tab.Acc_Date else null end ) AS new_Acc_Date, max( case when tab.m_id=-1 then  tab.Account_No else null end ) AS old_Account_No, max( case when tab.m_id<>-1 then  tab.Account_No else null end ) AS new_Account_No, max( case when tab.m_id=-1 then  tab.Account_Name else null end ) AS old_Account_Name, max( case when tab.m_id<>-1 then  tab.Account_Name else null end ) AS new_Account_Name, max( case when tab.m_id=-1 then  tab.Amount else null end ) AS old_Amount, max( case when tab.m_id<>-1 then  tab.Amount else null end ) AS new_Amount, max( case when tab.m_id=-1 then  tab.Trans_Type_ID else null end ) AS old_Trans_Type_ID, max( case when tab.m_id<>-1 then  tab.Trans_Type_ID else null end ) AS new_Trans_Type_ID, tab.Rep_Date,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM Asset_Financials AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Financing;
CREATE function sel_Asset_Financing( p_m_ID integer) RETURNS table (old_Financing_Contract_Code varchar,new_Financing_Contract_Code varchar,old_Financing_Counterpart_ID varchar,new_Financing_Counterpart_ID varchar,Asset_Code varchar,Asset_Name varchar,Financing_Type_ID varchar,old_Financing_Currency_ID varchar,new_Financing_Currency_ID varchar,old_Financing_Amount_CCY double precision,new_Financing_Amount_CCY double precision,old_Financing_Amount_EUR double precision,new_Financing_Amount_EUR double precision,old_Financing_Reference_Rate varchar,new_Financing_Reference_Rate varchar,old_Financing_Margin double precision,new_Financing_Margin double precision,old_Financing_Rate double precision,new_Financing_Rate double precision,Financing_Start_Date date,old_Financing_End_Date date,new_Financing_End_Date date,old_Financing_Contract_Date date,new_Financing_Contract_Date date,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT max( case when tab.m_id=-1 then  tab.Financing_Contract_Code else null end ) AS old_Financing_Contract_Code, max( case when tab.m_id<>-1 then  tab.Financing_Contract_Code else null end ) AS new_Financing_Contract_Code, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Financing_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Financing_Counterpart_ID, parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, Nom_Financing_Type1.Financing_Type AS Financing_Type_ID, max( case when tab.m_id=-1 then  Nom_Currencies2.Currency_Code else null end ) AS old_Financing_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies2.Currency_Code else null end ) AS new_Financing_Currency_ID, max( case when tab.m_id=-1 then  tab.Financing_Amount_CCY else null end ) AS old_Financing_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Financing_Amount_CCY else null end ) AS new_Financing_Amount_CCY, max( case when tab.m_id=-1 then  tab.Financing_Amount_EUR else null end ) AS old_Financing_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Financing_Amount_EUR else null end ) AS new_Financing_Amount_EUR, max( case when tab.m_id=-1 then  tab.Financing_Reference_Rate else null end ) AS old_Financing_Reference_Rate, max( case when tab.m_id<>-1 then  tab.Financing_Reference_Rate else null end ) AS new_Financing_Reference_Rate, max( case when tab.m_id=-1 then  tab.Financing_Margin else null end ) AS old_Financing_Margin, max( case when tab.m_id<>-1 then  tab.Financing_Margin else null end ) AS new_Financing_Margin, max( case when tab.m_id=-1 then  tab.Financing_Rate else null end ) AS old_Financing_Rate, max( case when tab.m_id<>-1 then  tab.Financing_Rate else null end ) AS new_Financing_Rate, tab.Financing_Start_Date, max( case when tab.m_id=-1 then  tab.Financing_End_Date else null end ) AS old_Financing_End_Date, max( case when tab.m_id<>-1 then  tab.Financing_End_Date else null end ) AS new_Financing_End_Date, max( case when tab.m_id=-1 then  tab.Financing_Contract_Date else null end ) AS old_Financing_Contract_Date, max( case when tab.m_id<>-1 then  tab.Financing_Contract_Date else null end ) AS new_Financing_Contract_Date,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM (((Asset_Financing AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Financing_Counterpart_ID) LEFT JOIN Nom_Financing_Type AS Nom_Financing_Type1 ON Nom_Financing_Type1.id=tab.Financing_Type_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies2 ON Nom_Currencies2.id=tab.Financing_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Financing_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, Nom_Financing_Type1.Financing_Type, tab.Financing_Start_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_History;
CREATE function sel_Asset_History( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,Rep_Date date,old_Status_Code varchar,new_Status_Code varchar,old_Currency_ID varchar,new_Currency_ID varchar,old_Book_Value_PM double precision,new_Book_Value_PM double precision,old_Inflows double precision,new_Inflows double precision,old_CAPEX double precision,new_CAPEX double precision,old_Depreciation double precision,new_Depreciation double precision,old_Sales double precision,new_Sales double precision,old_Imp_WB double precision,new_Imp_WB double precision,old_Book_Value double precision,new_Book_Value double precision,old_Costs double precision,new_Costs double precision,old_Income double precision,new_Income double precision,old_Expected_Exit date,new_Expected_Exit date,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, tab.Rep_Date, max( case when tab.m_id=-1 then  Nom_Asset_Status0.Asset_Status_Code else null end ) AS old_Status_Code, max( case when tab.m_id<>-1 then  Nom_Asset_Status0.Asset_Status_Code else null end ) AS new_Status_Code, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Currency_ID, max( case when tab.m_id=-1 then  tab.Book_Value_PM else null end ) AS old_Book_Value_PM, max( case when tab.m_id<>-1 then  tab.Book_Value_PM else null end ) AS new_Book_Value_PM, max( case when tab.m_id=-1 then  tab.Inflows else null end ) AS old_Inflows, max( case when tab.m_id<>-1 then  tab.Inflows else null end ) AS new_Inflows, max( case when tab.m_id=-1 then  tab.CAPEX else null end ) AS old_CAPEX, max( case when tab.m_id<>-1 then  tab.CAPEX else null end ) AS new_CAPEX, max( case when tab.m_id=-1 then  tab.Depreciation else null end ) AS old_Depreciation, max( case when tab.m_id<>-1 then  tab.Depreciation else null end ) AS new_Depreciation, max( case when tab.m_id=-1 then  tab.Sales else null end ) AS old_Sales, max( case when tab.m_id<>-1 then  tab.Sales else null end ) AS new_Sales, max( case when tab.m_id=-1 then  tab.Imp_WB else null end ) AS old_Imp_WB, max( case when tab.m_id<>-1 then  tab.Imp_WB else null end ) AS new_Imp_WB, max( case when tab.m_id=-1 then  tab.Book_Value else null end ) AS old_Book_Value, max( case when tab.m_id<>-1 then  tab.Book_Value else null end ) AS new_Book_Value, max( case when tab.m_id=-1 then  tab.Costs else null end ) AS old_Costs, max( case when tab.m_id<>-1 then  tab.Costs else null end ) AS new_Costs, max( case when tab.m_id=-1 then  tab.Income else null end ) AS old_Income, max( case when tab.m_id<>-1 then  tab.Income else null end ) AS new_Income, max( case when tab.m_id=-1 then  tab.Expected_Exit else null end ) AS old_Expected_Exit, max( case when tab.m_id<>-1 then  tab.Expected_Exit else null end ) AS new_Expected_Exit,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_History AS tab LEFT JOIN Nom_Asset_Status AS Nom_Asset_Status0 ON Nom_Asset_Status0.id=tab.Status_Code) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Insurances;
CREATE function sel_Asset_Insurances( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_Insurance_Company_ID varchar,new_Insurance_Company_ID varchar,Insurance_Start_Date date,old_Insurance_End_Date date,new_Insurance_End_Date date,old_Insurance_Currency_ID varchar,new_Insurance_Currency_ID varchar,old_Insurance_Amount_CCY double precision,new_Insurance_Amount_CCY double precision,old_Insurance_Amount_EUR double precision,new_Insurance_Amount_EUR double precision,old_Insurance_Premium_CCY double precision,new_Insurance_Premium_CCY double precision,old_Insurance_Premium_EUR double precision,new_Insurance_Premium_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Insurance_Company_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Insurance_Company_ID, tab.Insurance_Start_Date, max( case when tab.m_id=-1 then  tab.Insurance_End_Date else null end ) AS old_Insurance_End_Date, max( case when tab.m_id<>-1 then  tab.Insurance_End_Date else null end ) AS new_Insurance_End_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Insurance_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Insurance_Currency_ID, max( case when tab.m_id=-1 then  tab.Insurance_Amount_CCY else null end ) AS old_Insurance_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Insurance_Amount_CCY else null end ) AS new_Insurance_Amount_CCY, max( case when tab.m_id=-1 then  tab.Insurance_Amount_EUR else null end ) AS old_Insurance_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Insurance_Amount_EUR else null end ) AS new_Insurance_Amount_EUR, max( case when tab.m_id=-1 then  tab.Insurance_Premium_CCY else null end ) AS old_Insurance_Premium_CCY, max( case when tab.m_id<>-1 then  tab.Insurance_Premium_CCY else null end ) AS new_Insurance_Premium_CCY, max( case when tab.m_id=-1 then  tab.Insurance_Premium_EUR else null end ) AS old_Insurance_Premium_EUR, max( case when tab.m_id<>-1 then  tab.Insurance_Premium_EUR else null end ) AS new_Insurance_Premium_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Insurances AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Insurance_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Insurance_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Insurance_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Insurance_Start_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Rentals;
CREATE function sel_Asset_Rentals( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_Rental_Counterpart_ID varchar,new_Rental_Counterpart_ID varchar,Rental_Contract_Date date,old_Rental_Start_Date date,new_Rental_Start_Date date,old_Rental_End_Date date,new_Rental_End_Date date,old_Rental_Payment_Date date,new_Rental_Payment_Date date,old_Rental_Currency_ID varchar,new_Rental_Currency_ID varchar,old_Rental_Amount_CCY double precision,new_Rental_Amount_CCY double precision,old_Rental_Amount_EUR double precision,new_Rental_Amount_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Rental_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Rental_Counterpart_ID, tab.Rental_Contract_Date, max( case when tab.m_id=-1 then  tab.Rental_Start_Date else null end ) AS old_Rental_Start_Date, max( case when tab.m_id<>-1 then  tab.Rental_Start_Date else null end ) AS new_Rental_Start_Date, max( case when tab.m_id=-1 then  tab.Rental_End_Date else null end ) AS old_Rental_End_Date, max( case when tab.m_id<>-1 then  tab.Rental_End_Date else null end ) AS new_Rental_End_Date, max( case when tab.m_id=-1 then  tab.Rental_Payment_Date else null end ) AS old_Rental_Payment_Date, max( case when tab.m_id<>-1 then  tab.Rental_Payment_Date else null end ) AS new_Rental_Payment_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Rental_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Rental_Currency_ID, max( case when tab.m_id=-1 then  tab.Rental_Amount_CCY else null end ) AS old_Rental_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Rental_Amount_CCY else null end ) AS new_Rental_Amount_CCY, max( case when tab.m_id=-1 then  tab.Rental_Amount_EUR else null end ) AS old_Rental_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Rental_Amount_EUR else null end ) AS new_Rental_Amount_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Rentals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Rental_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Rental_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Rental_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rental_Contract_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Repossession;
CREATE function sel_Asset_Repossession( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_NPE_Currency_ID varchar,new_NPE_Currency_ID varchar,old_NPE_Amount_CCY double precision,new_NPE_Amount_CCY double precision,old_NPE_Amount_EUR double precision,new_NPE_Amount_EUR double precision,old_LLP_Amount_CCY double precision,new_LLP_Amount_CCY double precision,old_LLP_Amount_EUR double precision,new_LLP_Amount_EUR double precision,old_Purchase_Price_Currency_ID varchar,new_Purchase_Price_Currency_ID varchar,old_Appr_Purchase_Price_Net_CCY double precision,new_Appr_Purchase_Price_Net_CCY double precision,old_Appr_Purchase_Price_Net_EUR double precision,new_Appr_Purchase_Price_Net_EUR double precision,old_Purchase_Price_Net_CCY double precision,new_Purchase_Price_Net_CCY double precision,old_Purchase_Price_Net_EUR double precision,new_Purchase_Price_Net_EUR double precision,old_Purchase_Costs_CCY double precision,new_Purchase_Costs_CCY double precision,old_Purchase_Costs_EUR double precision,new_Purchase_Costs_EUR double precision,old_Planned_CAPEX_Currency_ID integer,new_Planned_CAPEX_Currency_ID integer,old_Planned_CAPEX_CCY double precision,new_Planned_CAPEX_CCY double precision,old_Planned_CAPEX_EUR double precision,new_Planned_CAPEX_EUR double precision,old_Planned_CAPEX_Comment varchar,new_Planned_CAPEX_Comment varchar,Purchase_Auction_Date date,old_Purchase_Contract_Date date,new_Purchase_Contract_Date date,old_Purchase_Repossession_Date date,new_Purchase_Repossession_Date date,old_Purchase_Payment_Date date,new_Purchase_Payment_Date date,old_Purchase_Handover_Date date,new_Purchase_Handover_Date date,old_Purchase_Registration_Date date,new_Purchase_Registration_Date date,old_Purchase_Local_Approval_Date date,new_Purchase_Local_Approval_Date date,old_Purchase_Central_Approval_Date date,new_Purchase_Central_Approval_Date date,old_Purchase_Prolongation_Date date,new_Purchase_Prolongation_Date date,old_Purchase_Expected_Exit_Date date,new_Purchase_Expected_Exit_Date date,old_Planned_OPEX_CCY double precision,new_Planned_OPEX_CCY double precision,old_Planned_OPEX_EUR double precision,new_Planned_OPEX_EUR double precision,old_Planned_OPEX_Comment varchar,new_Planned_OPEX_Comment varchar,old_Planned_SalesPrice_CCY double precision,new_Planned_SalesPrice_CCY double precision,old_Planned_SalesPrice_EUR double precision,new_Planned_SalesPrice_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  Nom_Currencies0.Currency_Code else null end ) AS old_NPE_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies0.Currency_Code else null end ) AS new_NPE_Currency_ID, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Purchase_Price_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Purchase_Price_Currency_ID, max( case when tab.m_id=-1 then  tab.Appr_Purchase_Price_Net_CCY else null end ) AS old_Appr_Purchase_Price_Net_CCY, max( case when tab.m_id<>-1 then  tab.Appr_Purchase_Price_Net_CCY else null end ) AS new_Appr_Purchase_Price_Net_CCY, max( case when tab.m_id=-1 then  tab.Appr_Purchase_Price_Net_EUR else null end ) AS old_Appr_Purchase_Price_Net_EUR, max( case when tab.m_id<>-1 then  tab.Appr_Purchase_Price_Net_EUR else null end ) AS new_Appr_Purchase_Price_Net_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Price_Net_CCY else null end ) AS old_Purchase_Price_Net_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Price_Net_CCY else null end ) AS new_Purchase_Price_Net_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Price_Net_EUR else null end ) AS old_Purchase_Price_Net_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Price_Net_EUR else null end ) AS new_Purchase_Price_Net_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Costs_CCY else null end ) AS old_Purchase_Costs_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Costs_CCY else null end ) AS new_Purchase_Costs_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Costs_EUR else null end ) AS old_Purchase_Costs_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Costs_EUR else null end ) AS new_Purchase_Costs_EUR, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_Currency_ID else null end ) AS old_Planned_CAPEX_Currency_ID, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_Currency_ID else null end ) AS new_Planned_CAPEX_Currency_ID, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_CCY else null end ) AS old_Planned_CAPEX_CCY, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_CCY else null end ) AS new_Planned_CAPEX_CCY, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_EUR else null end ) AS old_Planned_CAPEX_EUR, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_EUR else null end ) AS new_Planned_CAPEX_EUR, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_Comment else null end ) AS old_Planned_CAPEX_Comment, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_Comment else null end ) AS new_Planned_CAPEX_Comment, tab.Purchase_Auction_Date, max( case when tab.m_id=-1 then  tab.Purchase_Contract_Date else null end ) AS old_Purchase_Contract_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Contract_Date else null end ) AS new_Purchase_Contract_Date, max( case when tab.m_id=-1 then  tab.Purchase_Repossession_Date else null end ) AS old_Purchase_Repossession_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Repossession_Date else null end ) AS new_Purchase_Repossession_Date, max( case when tab.m_id=-1 then  tab.Purchase_Payment_Date else null end ) AS old_Purchase_Payment_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Payment_Date else null end ) AS new_Purchase_Payment_Date, max( case when tab.m_id=-1 then  tab.Purchase_Handover_Date else null end ) AS old_Purchase_Handover_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Handover_Date else null end ) AS new_Purchase_Handover_Date, max( case when tab.m_id=-1 then  tab.Purchase_Registration_Date else null end ) AS old_Purchase_Registration_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Registration_Date else null end ) AS new_Purchase_Registration_Date, max( case when tab.m_id=-1 then  tab.Purchase_Local_Approval_Date else null end ) AS old_Purchase_Local_Approval_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Local_Approval_Date else null end ) AS new_Purchase_Local_Approval_Date, max( case when tab.m_id=-1 then  tab.Purchase_Central_Approval_Date else null end ) AS old_Purchase_Central_Approval_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Central_Approval_Date else null end ) AS new_Purchase_Central_Approval_Date, max( case when tab.m_id=-1 then  tab.Purchase_Prolongation_Date else null end ) AS old_Purchase_Prolongation_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Prolongation_Date else null end ) AS new_Purchase_Prolongation_Date, max( case when tab.m_id=-1 then  tab.Purchase_Expected_Exit_Date else null end ) AS old_Purchase_Expected_Exit_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Expected_Exit_Date else null end ) AS new_Purchase_Expected_Exit_Date, max( case when tab.m_id=-1 then  tab.Planned_OPEX_CCY else null end ) AS old_Planned_OPEX_CCY, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_CCY else null end ) AS new_Planned_OPEX_CCY, max( case when tab.m_id=-1 then  tab.Planned_OPEX_EUR else null end ) AS old_Planned_OPEX_EUR, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_EUR else null end ) AS new_Planned_OPEX_EUR, max( case when tab.m_id=-1 then  tab.Planned_OPEX_Comment else null end ) AS old_Planned_OPEX_Comment, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_Comment else null end ) AS new_Planned_OPEX_Comment, max( case when tab.m_id=-1 then  tab.Planned_SalesPrice_CCY else null end ) AS old_Planned_SalesPrice_CCY, max( case when tab.m_id<>-1 then  tab.Planned_SalesPrice_CCY else null end ) AS new_Planned_SalesPrice_CCY, max( case when tab.m_id=-1 then  tab.Planned_SalesPrice_EUR else null end ) AS old_Planned_SalesPrice_EUR, max( case when tab.m_id<>-1 then  tab.Planned_SalesPrice_EUR else null end ) AS new_Planned_SalesPrice_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Repossession AS tab LEFT JOIN Nom_Currencies AS Nom_Currencies0 ON Nom_Currencies0.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Purchase_Price_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Repossession_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Purchase_Auction_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Asset_Sales;
CREATE function sel_Asset_Sales( p_m_ID integer) RETURNS table (Asset_Code varchar,Asset_Name varchar,old_Sale_Counterpart_ID varchar,new_Sale_Counterpart_ID varchar,Sale_Approval_Date date,old_Sale_Contract_Date date,new_Sale_Contract_Date date,old_Sale_Transfer_Date date,new_Sale_Transfer_Date date,old_Sale_Payment_Date date,new_Sale_Payment_Date date,old_Sale_AML_Check_Date date,new_Sale_AML_Check_Date date,old_Sale_AML_Pass_Date date,new_Sale_AML_Pass_Date date,old_Sale_Currency_ID varchar,new_Sale_Currency_ID varchar,old_Sale_ApprovedAmt_CCY double precision,new_Sale_ApprovedAmt_CCY double precision,old_Sale_ApprovedAmt_EUR double precision,new_Sale_ApprovedAmt_EUR double precision,old_Sale_Amount_CCY double precision,new_Sale_Amount_CCY double precision,old_Sale_Amount_EUR double precision,new_Sale_Amount_EUR double precision,old_Sale_Book_Value_CCY double precision,new_Sale_Book_Value_CCY double precision,old_Sale_Book_Value_EUR double precision,new_Sale_Book_Value_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Sale_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Sale_Counterpart_ID, tab.Sale_Approval_Date, max( case when tab.m_id=-1 then  tab.Sale_Contract_Date else null end ) AS old_Sale_Contract_Date, max( case when tab.m_id<>-1 then  tab.Sale_Contract_Date else null end ) AS new_Sale_Contract_Date, max( case when tab.m_id=-1 then  tab.Sale_Transfer_Date else null end ) AS old_Sale_Transfer_Date, max( case when tab.m_id<>-1 then  tab.Sale_Transfer_Date else null end ) AS new_Sale_Transfer_Date, max( case when tab.m_id=-1 then  tab.Sale_Payment_Date else null end ) AS old_Sale_Payment_Date, max( case when tab.m_id<>-1 then  tab.Sale_Payment_Date else null end ) AS new_Sale_Payment_Date, max( case when tab.m_id=-1 then  tab.Sale_AML_Check_Date else null end ) AS old_Sale_AML_Check_Date, max( case when tab.m_id<>-1 then  tab.Sale_AML_Check_Date else null end ) AS new_Sale_AML_Check_Date, max( case when tab.m_id=-1 then  tab.Sale_AML_Pass_Date else null end ) AS old_Sale_AML_Pass_Date, max( case when tab.m_id<>-1 then  tab.Sale_AML_Pass_Date else null end ) AS new_Sale_AML_Pass_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Sale_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Sale_Currency_ID, max( case when tab.m_id=-1 then  tab.Sale_ApprovedAmt_CCY else null end ) AS old_Sale_ApprovedAmt_CCY, max( case when tab.m_id<>-1 then  tab.Sale_ApprovedAmt_CCY else null end ) AS new_Sale_ApprovedAmt_CCY, max( case when tab.m_id=-1 then  tab.Sale_ApprovedAmt_EUR else null end ) AS old_Sale_ApprovedAmt_EUR, max( case when tab.m_id<>-1 then  tab.Sale_ApprovedAmt_EUR else null end ) AS new_Sale_ApprovedAmt_EUR, max( case when tab.m_id=-1 then  tab.Sale_Amount_CCY else null end ) AS old_Sale_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Sale_Amount_CCY else null end ) AS new_Sale_Amount_CCY, max( case when tab.m_id=-1 then  tab.Sale_Amount_EUR else null end ) AS old_Sale_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Sale_Amount_EUR else null end ) AS new_Sale_Amount_EUR, max( case when tab.m_id=-1 then  tab.Sale_Book_Value_CCY else null end ) AS old_Sale_Book_Value_CCY, max( case when tab.m_id<>-1 then  tab.Sale_Book_Value_CCY else null end ) AS new_Sale_Book_Value_CCY, max( case when tab.m_id=-1 then  tab.Sale_Book_Value_EUR else null end ) AS old_Sale_Book_Value_EUR, max( case when tab.m_id<>-1 then  tab.Sale_Book_Value_EUR else null end ) AS new_Sale_Book_Value_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Sales AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Sale_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Sale_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Sale_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Sale_Approval_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Assets_List;
CREATE function sel_Assets_List( p_m_ID integer) RETURNS table (Asset_Code varchar,old_NPE_Code varchar,new_NPE_Code varchar,old_Asset_Name varchar,new_Asset_Name varchar,old_Asset_Description varchar,new_Asset_Description varchar,old_Asset_Address varchar,new_Asset_Address varchar,old_Asset_ZIP varchar,new_Asset_ZIP varchar,old_Asset_Region varchar,new_Asset_Region varchar,old_Asset_Country_ID varchar,new_Asset_Country_ID varchar,old_Asset_Usage_ID varchar,new_Asset_Usage_ID varchar,old_Asset_Type_ID varchar,new_Asset_Type_ID varchar,old_Asset_Usable_Area integer,new_Asset_Usable_Area integer,old_Asset_Common_Area integer,new_Asset_Common_Area integer,old_Asset_Owned varchar,new_Asset_Owned varchar,old_Comment varchar,new_Comment varchar,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT tab.Asset_Code, max( case when tab.m_id=-1 then  parent.NPE_Code else null end ) AS old_NPE_Code, max( case when tab.m_id<>-1 then  parent.NPE_Code else null end ) AS new_NPE_Code, max( case when tab.m_id=-1 then  tab.Asset_Name else null end ) AS old_Asset_Name, max( case when tab.m_id<>-1 then  tab.Asset_Name else null end ) AS new_Asset_Name, max( case when tab.m_id=-1 then  tab.Asset_Description else null end ) AS old_Asset_Description, max( case when tab.m_id<>-1 then  tab.Asset_Description else null end ) AS new_Asset_Description, max( case when tab.m_id=-1 then  tab.Asset_Address else null end ) AS old_Asset_Address, max( case when tab.m_id<>-1 then  tab.Asset_Address else null end ) AS new_Asset_Address, max( case when tab.m_id=-1 then  tab.Asset_ZIP else null end ) AS old_Asset_ZIP, max( case when tab.m_id<>-1 then  tab.Asset_ZIP else null end ) AS new_Asset_ZIP, max( case when tab.m_id=-1 then  tab.Asset_Region else null end ) AS old_Asset_Region, max( case when tab.m_id<>-1 then  tab.Asset_Region else null end ) AS new_Asset_Region, max( case when tab.m_id=-1 then  Nom_Countries0.Country_Name else null end ) AS old_Asset_Country_ID, max( case when tab.m_id<>-1 then  Nom_Countries0.Country_Name else null end ) AS new_Asset_Country_ID, max( case when tab.m_id=-1 then  Nom_Asset_Usage1.Asset_Usage_Text else null end ) AS old_Asset_Usage_ID, max( case when tab.m_id<>-1 then  Nom_Asset_Usage1.Asset_Usage_Text else null end ) AS new_Asset_Usage_ID, max( case when tab.m_id=-1 then  Nom_Asset_Type2.Asset_Type_Text else null end ) AS old_Asset_Type_ID, max( case when tab.m_id<>-1 then  Nom_Asset_Type2.Asset_Type_Text else null end ) AS new_Asset_Type_ID, max( case when tab.m_id=-1 then  tab.Asset_Usable_Area else null end ) AS old_Asset_Usable_Area, max( case when tab.m_id<>-1 then  tab.Asset_Usable_Area else null end ) AS new_Asset_Usable_Area, max( case when tab.m_id=-1 then  tab.Asset_Common_Area else null end ) AS old_Asset_Common_Area, max( case when tab.m_id<>-1 then  tab.Asset_Common_Area else null end ) AS new_Asset_Common_Area, max( case when tab.m_id=-1 then  Nom_Asset_Owned3.Asset_Owned else null end ) AS old_Asset_Owned, max( case when tab.m_id<>-1 then  Nom_Asset_Owned3.Asset_Owned else null end ) AS new_Asset_Owned, max( case when tab.m_id=-1 then  tab.Comment else null end ) AS old_Comment, max( case when tab.m_id<>-1 then  tab.Comment else null end ) AS new_Comment,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((((Assets_List AS tab LEFT JOIN Nom_Countries AS Nom_Countries0 ON Nom_Countries0.id=tab.Asset_Country_ID) LEFT JOIN Nom_Asset_Usage AS Nom_Asset_Usage1 ON Nom_Asset_Usage1.id=tab.Asset_Usage_ID) LEFT JOIN Nom_Asset_Type AS Nom_Asset_Type2 ON Nom_Asset_Type2.id=tab.Asset_Type_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned3 ON Nom_Asset_Owned3.id=tab.Asset_Owned) INNER JOIN NPE_List AS parent ON parent.id=tab.Asset_NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.Asset_Code
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_Business_Cases;
CREATE function sel_Business_Cases( p_m_ID integer) RETURNS table (NPE_Code varchar,NPE_Name varchar,BC_Date date,old_BC_Comment varchar,new_BC_Comment varchar,old_BC_Purchase_Date date,new_BC_Purchase_Date date,old_BC_Purchase_Price_EUR double precision,new_BC_Purchase_Price_EUR double precision,old_Exp_CAPEX_EUR double precision,new_Exp_CAPEX_EUR double precision,old_Exp_CAPEX_Time date,new_Exp_CAPEX_Time date,old_Exp_Sale_Date date,new_Exp_Sale_Date date,old_Exp_Sale_Price_EUR double precision,new_Exp_Sale_Price_EUR double precision,old_Exp_Interest_EUR double precision,new_Exp_Interest_EUR double precision,old_Exp_OPEX_EUR double precision,new_Exp_OPEX_EUR double precision,old_Exp_Income_EUR double precision,new_Exp_Income_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.NPE_Code,  case when Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) Is Null then Max(parent.NPE_Name) else Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) end  AS NPE_Name, tab.BC_Date, max( case when tab.m_id=-1 then  tab.BC_Comment else null end ) AS old_BC_Comment, max( case when tab.m_id<>-1 then  tab.BC_Comment else null end ) AS new_BC_Comment, max( case when tab.m_id=-1 then  tab.BC_Purchase_Date else null end ) AS old_BC_Purchase_Date, max( case when tab.m_id<>-1 then  tab.BC_Purchase_Date else null end ) AS new_BC_Purchase_Date, max( case when tab.m_id=-1 then  tab.BC_Purchase_Price_EUR else null end ) AS old_BC_Purchase_Price_EUR, max( case when tab.m_id<>-1 then  tab.BC_Purchase_Price_EUR else null end ) AS new_BC_Purchase_Price_EUR, max( case when tab.m_id=-1 then  tab.Exp_CAPEX_EUR else null end ) AS old_Exp_CAPEX_EUR, max( case when tab.m_id<>-1 then  tab.Exp_CAPEX_EUR else null end ) AS new_Exp_CAPEX_EUR, max( case when tab.m_id=-1 then  tab.Exp_CAPEX_Time else null end ) AS old_Exp_CAPEX_Time, max( case when tab.m_id<>-1 then  tab.Exp_CAPEX_Time else null end ) AS new_Exp_CAPEX_Time, max( case when tab.m_id=-1 then  tab.Exp_Sale_Date else null end ) AS old_Exp_Sale_Date, max( case when tab.m_id<>-1 then  tab.Exp_Sale_Date else null end ) AS new_Exp_Sale_Date, max( case when tab.m_id=-1 then  tab.Exp_Sale_Price_EUR else null end ) AS old_Exp_Sale_Price_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Sale_Price_EUR else null end ) AS new_Exp_Sale_Price_EUR, max( case when tab.m_id=-1 then  tab.Exp_Interest_EUR else null end ) AS old_Exp_Interest_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Interest_EUR else null end ) AS new_Exp_Interest_EUR, max( case when tab.m_id=-1 then  tab.Exp_OPEX_EUR else null end ) AS old_Exp_OPEX_EUR, max( case when tab.m_id<>-1 then  tab.Exp_OPEX_EUR else null end ) AS new_Exp_OPEX_EUR, max( case when tab.m_id=-1 then  tab.Exp_Income_EUR else null end ) AS old_Exp_Income_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Income_EUR else null end ) AS new_Exp_Income_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM Business_Cases AS tab INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.BC_Date
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_NPE_History;
CREATE function sel_NPE_History( p_m_ID integer) RETURNS table (NPE_Code varchar,NPE_Name varchar,Rep_Date date,old_NPE_Status_ID varchar,new_NPE_Status_ID varchar,NPE_Scenario_ID varchar,old_NPE_Rep_Date date,new_NPE_Rep_Date date,old_NPE_Currency varchar,new_NPE_Currency varchar,old_NPE_Amount_CCY double precision,new_NPE_Amount_CCY double precision,old_NPE_Amount_EUR double precision,new_NPE_Amount_EUR double precision,old_LLP_Amount_CCY double precision,new_LLP_Amount_CCY double precision,old_LLP_Amount_EUR double precision,new_LLP_Amount_EUR double precision,old_Purchase_Price_CCY double precision,new_Purchase_Price_CCY double precision,old_Purchase_Price_EUR double precision,new_Purchase_Price_EUR double precision,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT parent.NPE_Code,  case when Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) Is Null then Max(parent.NPE_Name) else Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) end  AS NPE_Name, tab.Rep_Date, max( case when tab.m_id=-1 then  Nom_NPE_Status0.NPE_Status_Code else null end ) AS old_NPE_Status_ID, max( case when tab.m_id<>-1 then  Nom_NPE_Status0.NPE_Status_Code else null end ) AS new_NPE_Status_ID, Nom_Scenarios1.Scenario_Name AS NPE_Scenario_ID, max( case when tab.m_id=-1 then  tab.NPE_Rep_Date else null end ) AS old_NPE_Rep_Date, max( case when tab.m_id<>-1 then  tab.NPE_Rep_Date else null end ) AS new_NPE_Rep_Date, max( case when tab.m_id=-1 then  tab.NPE_Currency else null end ) AS old_NPE_Currency, max( case when tab.m_id<>-1 then  tab.NPE_Currency else null end ) AS new_NPE_Currency, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Price_CCY else null end ) AS old_Purchase_Price_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Price_CCY else null end ) AS new_Purchase_Price_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Price_EUR else null end ) AS old_Purchase_Price_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Price_EUR else null end ) AS new_Purchase_Price_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((NPE_History AS tab LEFT JOIN Nom_NPE_Status AS Nom_NPE_Status0 ON Nom_NPE_Status0.id=tab.NPE_Status_ID) LEFT JOIN Nom_Scenarios AS Nom_Scenarios1 ON Nom_Scenarios1.id=tab.NPE_Scenario_ID) INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.Rep_Date, Nom_Scenarios1.Scenario_Name
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists sel_NPE_List;
CREATE function sel_NPE_List( p_m_ID integer) RETURNS table (NPE_Code varchar,old_NPE_Scenario_ID varchar,new_NPE_Scenario_ID varchar,old_NPE_Country_ID varchar,new_NPE_Country_ID varchar,old_NPE_Name varchar,new_NPE_Name varchar,old_NPE_Description varchar,new_NPE_Description varchar,old_NPE_Lender_ID varchar,new_NPE_Lender_ID varchar,old_NPE_Borrower_ID varchar,new_NPE_Borrower_ID varchar,old_NPE_Currency_ID varchar,new_NPE_Currency_ID varchar,old_NPE_Amount_Date date,new_NPE_Amount_Date date,old_NPE_Amount_CCY double precision,new_NPE_Amount_CCY double precision,old_NPE_Amount_EUR double precision,new_NPE_Amount_EUR double precision,old_LLP_Amount_CCY double precision,new_LLP_Amount_CCY double precision,old_LLP_Amount_EUR double precision,new_LLP_Amount_EUR double precision,old_NPE_Owned varchar,new_NPE_Owned varchar,Record_Status varchar) LANGUAGE 'sql' AS $$
SELECT tab.NPE_Code, max( case when tab.m_id=-1 then  Nom_Scenarios0.Scenario_Name else null end ) AS old_NPE_Scenario_ID, max( case when tab.m_id<>-1 then  Nom_Scenarios0.Scenario_Name else null end ) AS new_NPE_Scenario_ID, max( case when tab.m_id=-1 then  Nom_Countries1.Country_Name else null end ) AS old_NPE_Country_ID, max( case when tab.m_id<>-1 then  Nom_Countries1.Country_Name else null end ) AS new_NPE_Country_ID, max( case when tab.m_id=-1 then  tab.NPE_Name else null end ) AS old_NPE_Name, max( case when tab.m_id<>-1 then  tab.NPE_Name else null end ) AS new_NPE_Name, max( case when tab.m_id=-1 then  tab.NPE_Description else null end ) AS old_NPE_Description, max( case when tab.m_id<>-1 then  tab.NPE_Description else null end ) AS new_NPE_Description, max( case when tab.m_id=-1 then  vwCounterparts2.Descr else null end ) AS old_NPE_Lender_ID, max( case when tab.m_id<>-1 then  vwCounterparts2.Descr else null end ) AS new_NPE_Lender_ID, max( case when tab.m_id=-1 then  vwCounterparts3.Descr else null end ) AS old_NPE_Borrower_ID, max( case when tab.m_id<>-1 then  vwCounterparts3.Descr else null end ) AS new_NPE_Borrower_ID, max( case when tab.m_id=-1 then  Nom_Currencies4.Currency_Code else null end ) AS old_NPE_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies4.Currency_Code else null end ) AS new_NPE_Currency_ID, max( case when tab.m_id=-1 then  tab.NPE_Amount_Date else null end ) AS old_NPE_Amount_Date, max( case when tab.m_id<>-1 then  tab.NPE_Amount_Date else null end ) AS new_NPE_Amount_Date, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  Nom_Asset_Owned5.Asset_Owned else null end ) AS old_NPE_Owned, max( case when tab.m_id<>-1 then  Nom_Asset_Owned5.Asset_Owned else null end ) AS new_NPE_Owned,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM (((((NPE_List AS tab LEFT JOIN Nom_Scenarios AS Nom_Scenarios0 ON Nom_Scenarios0.id=tab.NPE_Scenario_ID) LEFT JOIN Nom_Countries AS Nom_Countries1 ON Nom_Countries1.id=tab.NPE_Country_ID) LEFT JOIN vwCounterparts AS vwCounterparts2 ON vwCounterparts2.id=tab.NPE_Lender_ID) LEFT JOIN vwCounterparts AS vwCounterparts3 ON vwCounterparts3.id=tab.NPE_Borrower_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies4 ON Nom_Currencies4.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned5 ON Nom_Asset_Owned5.id=tab.NPE_Owned
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.NPE_Code
HAVING max(tab.m_id)>-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Appraisals;
CREATE function upd_Asset_Appraisals( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Appraisals AS dw_tab ON (dw_tab.Appraisal_Date=new_tab.Appraisal_Date) AND (dw_tab.Appraisal_Asset_ID=new_parent.id) SET dw_tab.Appraisal_Company_ID =  case when new_tab.Appraisal_Company_ID is null then dw_tab.Appraisal_Company_ID else new_tab.Appraisal_Company_ID end , dw_tab.Appraisal_Currency_ID =  case when new_tab.Appraisal_Currency_ID is null then dw_tab.Appraisal_Currency_ID else new_tab.Appraisal_Currency_ID end , dw_tab.Appraisal_Market_Value_CCY =  case when new_tab.Appraisal_Market_Value_CCY is null then dw_tab.Appraisal_Market_Value_CCY else new_tab.Appraisal_Market_Value_CCY end , dw_tab.Appraisal_Market_Value_EUR =  case when new_tab.Appraisal_Market_Value_EUR is null then dw_tab.Appraisal_Market_Value_EUR else new_tab.Appraisal_Market_Value_EUR end , dw_tab.Appraisal_Firesale_Value_CCY =  case when new_tab.Appraisal_Firesale_Value_CCY is null then dw_tab.Appraisal_Firesale_Value_CCY else new_tab.Appraisal_Firesale_Value_CCY end , dw_tab.Appraisal_Firesale_Value_EUR =  case when new_tab.Appraisal_Firesale_Value_EUR is null then dw_tab.Appraisal_Firesale_Value_EUR else new_tab.Appraisal_Firesale_Value_EUR end , dw_tab.Appraisal_Order =  case when new_tab.Appraisal_Order is null then dw_tab.Appraisal_Order else new_tab.Appraisal_Order end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Financing;
CREATE function upd_Asset_Financing( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Financing AS dw_tab ON (dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date) AND (dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID) AND (dw_tab.Financing_Asset_ID=new_parent.id) SET dw_tab.Financing_Contract_Code =  case when new_tab.Financing_Contract_Code is null then dw_tab.Financing_Contract_Code else new_tab.Financing_Contract_Code end , dw_tab.Financing_Counterpart_ID =  case when new_tab.Financing_Counterpart_ID is null then dw_tab.Financing_Counterpart_ID else new_tab.Financing_Counterpart_ID end , dw_tab.Financing_Currency_ID =  case when new_tab.Financing_Currency_ID is null then dw_tab.Financing_Currency_ID else new_tab.Financing_Currency_ID end , dw_tab.Financing_Amount_CCY =  case when new_tab.Financing_Amount_CCY is null then dw_tab.Financing_Amount_CCY else new_tab.Financing_Amount_CCY end , dw_tab.Financing_Amount_EUR =  case when new_tab.Financing_Amount_EUR is null then dw_tab.Financing_Amount_EUR else new_tab.Financing_Amount_EUR end , dw_tab.Financing_Reference_Rate =  case when new_tab.Financing_Reference_Rate is null then dw_tab.Financing_Reference_Rate else new_tab.Financing_Reference_Rate end , dw_tab.Financing_Margin =  case when new_tab.Financing_Margin is null then dw_tab.Financing_Margin else new_tab.Financing_Margin end , dw_tab.Financing_Rate =  case when new_tab.Financing_Rate is null then dw_tab.Financing_Rate else new_tab.Financing_Rate end , dw_tab.Financing_End_Date =  case when new_tab.Financing_End_Date is null then dw_tab.Financing_End_Date else new_tab.Financing_End_Date end , dw_tab.Financing_Contract_Date =  case when new_tab.Financing_Contract_Date is null then dw_tab.Financing_Contract_Date else new_tab.Financing_Contract_Date end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_History;
CREATE function upd_Asset_History( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_History AS dw_tab ON (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.Asset_ID=new_parent.id) SET dw_tab.Status_Code =  case when new_tab.Status_Code is null then dw_tab.Status_Code else new_tab.Status_Code end , dw_tab.Currency_ID =  case when new_tab.Currency_ID is null then dw_tab.Currency_ID else new_tab.Currency_ID end , dw_tab.Book_Value_PM =  case when new_tab.Book_Value_PM is null then dw_tab.Book_Value_PM else new_tab.Book_Value_PM end , dw_tab.Inflows =  case when new_tab.Inflows is null then dw_tab.Inflows else new_tab.Inflows end , dw_tab.CAPEX =  case when new_tab.CAPEX is null then dw_tab.CAPEX else new_tab.CAPEX end , dw_tab.Depreciation =  case when new_tab.Depreciation is null then dw_tab.Depreciation else new_tab.Depreciation end , dw_tab.Sales =  case when new_tab.Sales is null then dw_tab.Sales else new_tab.Sales end , dw_tab.Imp_WB =  case when new_tab.Imp_WB is null then dw_tab.Imp_WB else new_tab.Imp_WB end , dw_tab.Book_Value =  case when new_tab.Book_Value is null then dw_tab.Book_Value else new_tab.Book_Value end , dw_tab.Costs =  case when new_tab.Costs is null then dw_tab.Costs else new_tab.Costs end , dw_tab.Income =  case when new_tab.Income is null then dw_tab.Income else new_tab.Income end , dw_tab.Expected_Exit =  case when new_tab.Expected_Exit is null then dw_tab.Expected_Exit else new_tab.Expected_Exit end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Insurances;
CREATE function upd_Asset_Insurances( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Insurances AS dw_tab ON (dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date) AND (dw_tab.Insurance_Asset_ID=new_parent.id) SET dw_tab.Insurance_Company_ID =  case when new_tab.Insurance_Company_ID is null then dw_tab.Insurance_Company_ID else new_tab.Insurance_Company_ID end , dw_tab.Insurance_End_Date =  case when new_tab.Insurance_End_Date is null then dw_tab.Insurance_End_Date else new_tab.Insurance_End_Date end , dw_tab.Insurance_Currency_ID =  case when new_tab.Insurance_Currency_ID is null then dw_tab.Insurance_Currency_ID else new_tab.Insurance_Currency_ID end , dw_tab.Insurance_Amount_CCY =  case when new_tab.Insurance_Amount_CCY is null then dw_tab.Insurance_Amount_CCY else new_tab.Insurance_Amount_CCY end , dw_tab.Insurance_Amount_EUR =  case when new_tab.Insurance_Amount_EUR is null then dw_tab.Insurance_Amount_EUR else new_tab.Insurance_Amount_EUR end , dw_tab.Insurance_Premium_CCY =  case when new_tab.Insurance_Premium_CCY is null then dw_tab.Insurance_Premium_CCY else new_tab.Insurance_Premium_CCY end , dw_tab.Insurance_Premium_EUR =  case when new_tab.Insurance_Premium_EUR is null then dw_tab.Insurance_Premium_EUR else new_tab.Insurance_Premium_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Rentals;
CREATE function upd_Asset_Rentals( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Rentals AS dw_tab ON (dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date) AND (dw_tab.Rental_Asset_ID=new_parent.id) SET dw_tab.Rental_Counterpart_ID =  case when new_tab.Rental_Counterpart_ID is null then dw_tab.Rental_Counterpart_ID else new_tab.Rental_Counterpart_ID end , dw_tab.Rental_Start_Date =  case when new_tab.Rental_Start_Date is null then dw_tab.Rental_Start_Date else new_tab.Rental_Start_Date end , dw_tab.Rental_End_Date =  case when new_tab.Rental_End_Date is null then dw_tab.Rental_End_Date else new_tab.Rental_End_Date end , dw_tab.Rental_Payment_Date =  case when new_tab.Rental_Payment_Date is null then dw_tab.Rental_Payment_Date else new_tab.Rental_Payment_Date end , dw_tab.Rental_Currency_ID =  case when new_tab.Rental_Currency_ID is null then dw_tab.Rental_Currency_ID else new_tab.Rental_Currency_ID end , dw_tab.Rental_Amount_CCY =  case when new_tab.Rental_Amount_CCY is null then dw_tab.Rental_Amount_CCY else new_tab.Rental_Amount_CCY end , dw_tab.Rental_Amount_EUR =  case when new_tab.Rental_Amount_EUR is null then dw_tab.Rental_Amount_EUR else new_tab.Rental_Amount_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Repossession;
CREATE function upd_Asset_Repossession( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Repossession AS dw_tab ON (dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date) AND (dw_tab.Repossession_Asset_ID=new_parent.id) SET dw_tab.NPE_Currency_ID =  case when new_tab.NPE_Currency_ID is null then dw_tab.NPE_Currency_ID else new_tab.NPE_Currency_ID end , dw_tab.NPE_Amount_CCY =  case when new_tab.NPE_Amount_CCY is null then dw_tab.NPE_Amount_CCY else new_tab.NPE_Amount_CCY end , dw_tab.NPE_Amount_EUR =  case when new_tab.NPE_Amount_EUR is null then dw_tab.NPE_Amount_EUR else new_tab.NPE_Amount_EUR end , dw_tab.LLP_Amount_CCY =  case when new_tab.LLP_Amount_CCY is null then dw_tab.LLP_Amount_CCY else new_tab.LLP_Amount_CCY end , dw_tab.LLP_Amount_EUR =  case when new_tab.LLP_Amount_EUR is null then dw_tab.LLP_Amount_EUR else new_tab.LLP_Amount_EUR end , dw_tab.Purchase_Price_Currency_ID =  case when new_tab.Purchase_Price_Currency_ID is null then dw_tab.Purchase_Price_Currency_ID else new_tab.Purchase_Price_Currency_ID end , dw_tab.Appr_Purchase_Price_Net_CCY =  case when new_tab.Appr_Purchase_Price_Net_CCY is null then dw_tab.Appr_Purchase_Price_Net_CCY else new_tab.Appr_Purchase_Price_Net_CCY end , dw_tab.Appr_Purchase_Price_Net_EUR =  case when new_tab.Appr_Purchase_Price_Net_EUR is null then dw_tab.Appr_Purchase_Price_Net_EUR else new_tab.Appr_Purchase_Price_Net_EUR end , dw_tab.Purchase_Price_Net_CCY =  case when new_tab.Purchase_Price_Net_CCY is null then dw_tab.Purchase_Price_Net_CCY else new_tab.Purchase_Price_Net_CCY end , dw_tab.Purchase_Price_Net_EUR =  case when new_tab.Purchase_Price_Net_EUR is null then dw_tab.Purchase_Price_Net_EUR else new_tab.Purchase_Price_Net_EUR end , dw_tab.Purchase_Costs_CCY =  case when new_tab.Purchase_Costs_CCY is null then dw_tab.Purchase_Costs_CCY else new_tab.Purchase_Costs_CCY end , dw_tab.Purchase_Costs_EUR =  case when new_tab.Purchase_Costs_EUR is null then dw_tab.Purchase_Costs_EUR else new_tab.Purchase_Costs_EUR end , dw_tab.Planned_CAPEX_Currency_ID =  case when new_tab.Planned_CAPEX_Currency_ID is null then dw_tab.Planned_CAPEX_Currency_ID else new_tab.Planned_CAPEX_Currency_ID end , dw_tab.Planned_CAPEX_CCY =  case when new_tab.Planned_CAPEX_CCY is null then dw_tab.Planned_CAPEX_CCY else new_tab.Planned_CAPEX_CCY end , dw_tab.Planned_CAPEX_EUR =  case when new_tab.Planned_CAPEX_EUR is null then dw_tab.Planned_CAPEX_EUR else new_tab.Planned_CAPEX_EUR end , dw_tab.Planned_CAPEX_Comment =  case when new_tab.Planned_CAPEX_Comment is null then dw_tab.Planned_CAPEX_Comment else new_tab.Planned_CAPEX_Comment end , dw_tab.Purchase_Contract_Date =  case when new_tab.Purchase_Contract_Date is null then dw_tab.Purchase_Contract_Date else new_tab.Purchase_Contract_Date end , dw_tab.Purchase_Repossession_Date =  case when new_tab.Purchase_Repossession_Date is null then dw_tab.Purchase_Repossession_Date else new_tab.Purchase_Repossession_Date end , dw_tab.Purchase_Payment_Date =  case when new_tab.Purchase_Payment_Date is null then dw_tab.Purchase_Payment_Date else new_tab.Purchase_Payment_Date end , dw_tab.Purchase_Handover_Date =  case when new_tab.Purchase_Handover_Date is null then dw_tab.Purchase_Handover_Date else new_tab.Purchase_Handover_Date end , dw_tab.Purchase_Registration_Date =  case when new_tab.Purchase_Registration_Date is null then dw_tab.Purchase_Registration_Date else new_tab.Purchase_Registration_Date end , dw_tab.Purchase_Local_Approval_Date =  case when new_tab.Purchase_Local_Approval_Date is null then dw_tab.Purchase_Local_Approval_Date else new_tab.Purchase_Local_Approval_Date end , dw_tab.Purchase_Central_Approval_Date =  case when new_tab.Purchase_Central_Approval_Date is null then dw_tab.Purchase_Central_Approval_Date else new_tab.Purchase_Central_Approval_Date end , dw_tab.Purchase_Prolongation_Date =  case when new_tab.Purchase_Prolongation_Date is null then dw_tab.Purchase_Prolongation_Date else new_tab.Purchase_Prolongation_Date end , dw_tab.Purchase_Expected_Exit_Date =  case when new_tab.Purchase_Expected_Exit_Date is null then dw_tab.Purchase_Expected_Exit_Date else new_tab.Purchase_Expected_Exit_Date end , dw_tab.Planned_OPEX_CCY =  case when new_tab.Planned_OPEX_CCY is null then dw_tab.Planned_OPEX_CCY else new_tab.Planned_OPEX_CCY end , dw_tab.Planned_OPEX_EUR =  case when new_tab.Planned_OPEX_EUR is null then dw_tab.Planned_OPEX_EUR else new_tab.Planned_OPEX_EUR end , dw_tab.Planned_OPEX_Comment =  case when new_tab.Planned_OPEX_Comment is null then dw_tab.Planned_OPEX_Comment else new_tab.Planned_OPEX_Comment end , dw_tab.Planned_SalesPrice_CCY =  case when new_tab.Planned_SalesPrice_CCY is null then dw_tab.Planned_SalesPrice_CCY else new_tab.Planned_SalesPrice_CCY end , dw_tab.Planned_SalesPrice_EUR =  case when new_tab.Planned_SalesPrice_EUR is null then dw_tab.Planned_SalesPrice_EUR else new_tab.Planned_SalesPrice_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Asset_Sales;
CREATE function upd_Asset_Sales( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Sales AS dw_tab ON (dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date) AND (dw_tab.Sale_Asset_ID=new_parent.id) SET dw_tab.Sale_Counterpart_ID =  case when new_tab.Sale_Counterpart_ID is null then dw_tab.Sale_Counterpart_ID else new_tab.Sale_Counterpart_ID end , dw_tab.Sale_Contract_Date =  case when new_tab.Sale_Contract_Date is null then dw_tab.Sale_Contract_Date else new_tab.Sale_Contract_Date end , dw_tab.Sale_Transfer_Date =  case when new_tab.Sale_Transfer_Date is null then dw_tab.Sale_Transfer_Date else new_tab.Sale_Transfer_Date end , dw_tab.Sale_Payment_Date =  case when new_tab.Sale_Payment_Date is null then dw_tab.Sale_Payment_Date else new_tab.Sale_Payment_Date end , dw_tab.Sale_AML_Check_Date =  case when new_tab.Sale_AML_Check_Date is null then dw_tab.Sale_AML_Check_Date else new_tab.Sale_AML_Check_Date end , dw_tab.Sale_AML_Pass_Date =  case when new_tab.Sale_AML_Pass_Date is null then dw_tab.Sale_AML_Pass_Date else new_tab.Sale_AML_Pass_Date end , dw_tab.Sale_Currency_ID =  case when new_tab.Sale_Currency_ID is null then dw_tab.Sale_Currency_ID else new_tab.Sale_Currency_ID end , dw_tab.Sale_ApprovedAmt_CCY =  case when new_tab.Sale_ApprovedAmt_CCY is null then dw_tab.Sale_ApprovedAmt_CCY else new_tab.Sale_ApprovedAmt_CCY end , dw_tab.Sale_ApprovedAmt_EUR =  case when new_tab.Sale_ApprovedAmt_EUR is null then dw_tab.Sale_ApprovedAmt_EUR else new_tab.Sale_ApprovedAmt_EUR end , dw_tab.Sale_Amount_CCY =  case when new_tab.Sale_Amount_CCY is null then dw_tab.Sale_Amount_CCY else new_tab.Sale_Amount_CCY end , dw_tab.Sale_Amount_EUR =  case when new_tab.Sale_Amount_EUR is null then dw_tab.Sale_Amount_EUR else new_tab.Sale_Amount_EUR end , dw_tab.Sale_Book_Value_CCY =  case when new_tab.Sale_Book_Value_CCY is null then dw_tab.Sale_Book_Value_CCY else new_tab.Sale_Book_Value_CCY end , dw_tab.Sale_Book_Value_EUR =  case when new_tab.Sale_Book_Value_EUR is null then dw_tab.Sale_Book_Value_EUR else new_tab.Sale_Book_Value_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Assets_List;
CREATE function upd_Assets_List( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN Assets_List AS dw_tab ON dw_tab.Asset_Code=new_tab.Asset_Code SET dw_tab.Asset_NPE_ID = new_tab.Asset_NPE_ID, dw_tab.Asset_Name =  case when new_tab.Asset_Name is null then dw_tab.Asset_Name else new_tab.Asset_Name end , dw_tab.Asset_Description =  case when new_tab.Asset_Description is null then dw_tab.Asset_Description else new_tab.Asset_Description end , dw_tab.Asset_Address =  case when new_tab.Asset_Address is null then dw_tab.Asset_Address else new_tab.Asset_Address end , dw_tab.Asset_ZIP =  case when new_tab.Asset_ZIP is null then dw_tab.Asset_ZIP else new_tab.Asset_ZIP end , dw_tab.Asset_Region =  case when new_tab.Asset_Region is null then dw_tab.Asset_Region else new_tab.Asset_Region end , dw_tab.Asset_Country_ID =  case when new_tab.Asset_Country_ID is null then dw_tab.Asset_Country_ID else new_tab.Asset_Country_ID end , dw_tab.Asset_Usage_ID =  case when new_tab.Asset_Usage_ID is null then dw_tab.Asset_Usage_ID else new_tab.Asset_Usage_ID end , dw_tab.Asset_Type_ID =  case when new_tab.Asset_Type_ID is null then dw_tab.Asset_Type_ID else new_tab.Asset_Type_ID end , dw_tab.Asset_Usable_Area =  case when new_tab.Asset_Usable_Area is null then dw_tab.Asset_Usable_Area else new_tab.Asset_Usable_Area end , dw_tab.Asset_Common_Area =  case when new_tab.Asset_Common_Area is null then dw_tab.Asset_Common_Area else new_tab.Asset_Common_Area end , dw_tab.Asset_Owned =  case when new_tab.Asset_Owned is null then dw_tab.Asset_Owned else new_tab.Asset_Owned end , dw_tab.Comment =  case when new_tab.Comment is null then dw_tab.Comment else new_tab.Comment end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_Business_Cases;
CREATE function upd_Business_Cases( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((Business_Cases AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN Business_Cases AS dw_tab ON (dw_tab.BC_Date=new_tab.BC_Date) AND (dw_tab.NPE_ID=new_parent.id) SET dw_tab.BC_Comment =  case when new_tab.BC_Comment is null then dw_tab.BC_Comment else new_tab.BC_Comment end , dw_tab.BC_Purchase_Date =  case when new_tab.BC_Purchase_Date is null then dw_tab.BC_Purchase_Date else new_tab.BC_Purchase_Date end , dw_tab.BC_Purchase_Price_EUR =  case when new_tab.BC_Purchase_Price_EUR is null then dw_tab.BC_Purchase_Price_EUR else new_tab.BC_Purchase_Price_EUR end , dw_tab.Exp_CAPEX_EUR =  case when new_tab.Exp_CAPEX_EUR is null then dw_tab.Exp_CAPEX_EUR else new_tab.Exp_CAPEX_EUR end , dw_tab.Exp_CAPEX_Time =  case when new_tab.Exp_CAPEX_Time is null then dw_tab.Exp_CAPEX_Time else new_tab.Exp_CAPEX_Time end , dw_tab.Exp_Sale_Date =  case when new_tab.Exp_Sale_Date is null then dw_tab.Exp_Sale_Date else new_tab.Exp_Sale_Date end , dw_tab.Exp_Sale_Price_EUR =  case when new_tab.Exp_Sale_Price_EUR is null then dw_tab.Exp_Sale_Price_EUR else new_tab.Exp_Sale_Price_EUR end , dw_tab.Exp_Interest_EUR =  case when new_tab.Exp_Interest_EUR is null then dw_tab.Exp_Interest_EUR else new_tab.Exp_Interest_EUR end , dw_tab.Exp_OPEX_EUR =  case when new_tab.Exp_OPEX_EUR is null then dw_tab.Exp_OPEX_EUR else new_tab.Exp_OPEX_EUR end , dw_tab.Exp_Income_EUR =  case when new_tab.Exp_Income_EUR is null then dw_tab.Exp_Income_EUR else new_tab.Exp_Income_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 27.2.2018 ใ. 18:21:32
DROP function if exists upd_npe_from_repossessions;
CREATE function upd_npe_from_repossessions() RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE drop_npe_from_repossessions INNER JOIN NPE_List ON drop_npe_from_repossessions.NPE_Code = NPE_List.NPE_Code SET NPE_List.NPE_Amount_CCY = SumOfNPE_Amount_CCY, NPE_List.NPE_Amount_EUR = SumOfNPE_Amount_EUR, NPE_List.LLP_Amount_CCY = SumOfLLP_Amount_CCY, NPE_List.LLP_Amount_EUR = SumOfLLP_Amount_EUR
WHERE (((NPE_List.NPE_Amount_CCY)=0) AND ((NPE_List.NPE_Amount_EUR)=0) AND ((NPE_List.LLP_Amount_CCY)=0) AND ((NPE_List.LLP_Amount_EUR)=0) AND ((NPE_List.m_ID)=-1));

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_NPE_History;
CREATE function upd_NPE_History( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE ((NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN NPE_History AS dw_tab ON (dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID) AND (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.NPE_ID=new_parent.id) SET dw_tab.NPE_Status_ID =  case when new_tab.NPE_Status_ID is null then dw_tab.NPE_Status_ID else new_tab.NPE_Status_ID end , dw_tab.NPE_Rep_Date =  case when new_tab.NPE_Rep_Date is null then dw_tab.NPE_Rep_Date else new_tab.NPE_Rep_Date end , dw_tab.NPE_Currency =  case when new_tab.NPE_Currency is null then dw_tab.NPE_Currency else new_tab.NPE_Currency end , dw_tab.NPE_Amount_CCY =  case when new_tab.NPE_Amount_CCY is null then dw_tab.NPE_Amount_CCY else new_tab.NPE_Amount_CCY end , dw_tab.NPE_Amount_EUR =  case when new_tab.NPE_Amount_EUR is null then dw_tab.NPE_Amount_EUR else new_tab.NPE_Amount_EUR end , dw_tab.LLP_Amount_CCY =  case when new_tab.LLP_Amount_CCY is null then dw_tab.LLP_Amount_CCY else new_tab.LLP_Amount_CCY end , dw_tab.LLP_Amount_EUR =  case when new_tab.LLP_Amount_EUR is null then dw_tab.LLP_Amount_EUR else new_tab.LLP_Amount_EUR end , dw_tab.Purchase_Price_CCY =  case when new_tab.Purchase_Price_CCY is null then dw_tab.Purchase_Price_CCY else new_tab.Purchase_Price_CCY end , dw_tab.Purchase_Price_EUR =  case when new_tab.Purchase_Price_EUR is null then dw_tab.Purchase_Price_EUR else new_tab.Purchase_Price_EUR end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 2.4.2018 ใ. 8:57:10
DROP function if exists upd_NPE_List;
CREATE function upd_NPE_List( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE NPE_List AS new_tab INNER JOIN NPE_List AS dw_tab ON dw_tab.NPE_Code=new_tab.NPE_Code SET dw_tab.NPE_Scenario_ID =  case when new_tab.NPE_Scenario_ID is null then dw_tab.NPE_Scenario_ID else new_tab.NPE_Scenario_ID end , dw_tab.NPE_Country_ID =  case when new_tab.NPE_Country_ID is null then dw_tab.NPE_Country_ID else new_tab.NPE_Country_ID end , dw_tab.NPE_Name =  case when new_tab.NPE_Name is null then dw_tab.NPE_Name else new_tab.NPE_Name end , dw_tab.NPE_Description =  case when new_tab.NPE_Description is null then dw_tab.NPE_Description else new_tab.NPE_Description end , dw_tab.NPE_Lender_ID =  case when new_tab.NPE_Lender_ID is null then dw_tab.NPE_Lender_ID else new_tab.NPE_Lender_ID end , dw_tab.NPE_Borrower_ID =  case when new_tab.NPE_Borrower_ID is null then dw_tab.NPE_Borrower_ID else new_tab.NPE_Borrower_ID end , dw_tab.NPE_Currency_ID =  case when new_tab.NPE_Currency_ID is null then dw_tab.NPE_Currency_ID else new_tab.NPE_Currency_ID end , dw_tab.NPE_Amount_Date =  case when new_tab.NPE_Amount_Date is null then dw_tab.NPE_Amount_Date else new_tab.NPE_Amount_Date end , dw_tab.NPE_Amount_CCY =  case when new_tab.NPE_Amount_CCY is null then dw_tab.NPE_Amount_CCY else new_tab.NPE_Amount_CCY end , dw_tab.NPE_Amount_EUR =  case when new_tab.NPE_Amount_EUR is null then dw_tab.NPE_Amount_EUR else new_tab.NPE_Amount_EUR end , dw_tab.LLP_Amount_CCY =  case when new_tab.LLP_Amount_CCY is null then dw_tab.LLP_Amount_CCY else new_tab.LLP_Amount_CCY end , dw_tab.LLP_Amount_EUR =  case when new_tab.LLP_Amount_EUR is null then dw_tab.LLP_Amount_EUR else new_tab.LLP_Amount_EUR end , dw_tab.NPE_Owned =  case when new_tab.NPE_Owned is null then dw_tab.NPE_Owned else new_tab.NPE_Owned end 
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1;

$$;
-- 19.2.2018 ใ. 9:01:13
DROP function if exists upd_old_Linked_Mails_Reject;
CREATE function upd_old_Linked_Mails_Reject( p_m_ID integer) RETURNS  void  LANGUAGE 'sql' AS $$
UPDATE Mail_Log SET Mail_Log.mailStatus = 3
WHERE (((Mail_Log.ID) In (select old_m_id from vw_old_linked_mails)));

$$;
-- 22.3.2018 ใ. 9:15:58
DROP view if exists vw_Appr_Periods;
CREATE VIEW vw_Appr_Periods AS
SELECT Assets_List.ID, Switch( case when  book_value is null  then  case when  Asset_Repossession.Purchase_Price_Net_EUR is null  then 2000000 else Asset_Repossession.Purchase_Price_Net_EUR end  else book_value end <1000000,36, case when  book_value is null  then  case when  Asset_Repossession.Purchase_Price_Net_EUR is null  then 2000000 else Asset_Repossession.Purchase_Price_Net_EUR end  else book_value end <1500000,24,1,12) AS AppraisalPeriod
FROM NPE_List INNER JOIN ((Assets_List INNER JOIN (Asset_History INNER JOIN LastDate ON Asset_History.Rep_Date = LastDate.CurrMonth) ON Assets_List.ID = Asset_History.Asset_ID) LEFT JOIN Asset_Repossession ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
GROUP BY Assets_List.ID, Switch( case when  book_value is null  then  case when  Asset_Repossession.Purchase_Price_Net_EUR is null  then 2000000 else Asset_Repossession.Purchase_Price_Net_EUR end  else book_value end <1000000,36, case when  book_value is null  then  case when  Asset_Repossession.Purchase_Price_Net_EUR is null  then 2000000 else Asset_Repossession.Purchase_Price_Net_EUR end  else book_value end <1500000,24,1,12);

-- 22.3.2018 ใ. 9:15:58
DROP view if exists vw_Appraisals_Exp;
CREATE VIEW vw_Appraisals_Exp AS
SELECT Asset_Appraisals.Appraisal_Asset_ID, Counterparts.Counterpart_Common_Name AS Appraisal_Company, Asset_Appraisals.Appraisal_Date, Nom_Currencies.Currency_Code, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR,  case when  AppraisalPeriod is null  then Null else DateAdd('m',AppraisalPeriod,Appraisal_Date) end  AS Appraisal_Expiration
FROM vw_Appr_Periods INNER JOIN ((Nom_Currencies RIGHT JOIN (vw_Last_Appraisals INNER JOIN Asset_Appraisals ON (vw_Last_Appraisals.LastDate = Asset_Appraisals.Appraisal_Date) AND (vw_Last_Appraisals.Appraisal_Asset_ID = Asset_Appraisals.Appraisal_Asset_ID)) ON Nom_Currencies.ID = Asset_Appraisals.Appraisal_Currency_ID) LEFT JOIN Counterparts ON Asset_Appraisals.Appraisal_Company_ID = Counterparts.ID) ON vw_Appr_Periods.ID = Asset_Appraisals.Appraisal_Asset_ID
WHERE (((Asset_Appraisals.m_ID)=-1));

-- 8.3.2018 ใ. 10:35:25
DROP view if exists vw_Asset_Appraisals;
CREATE VIEW vw_Asset_Appraisals AS
SELECT Asset_Appraisals.*
FROM Asset_Appraisals
WHERE ((( case when  Appraisal_Market_Value_CCY is null  then 0 else Appraisal_Market_Value_CCY end + case when  Appraisal_Market_Value_EUR is null  then 0 else Appraisal_Market_Value_EUR end + case when  Appraisal_Firesale_Value_CCY is null  then 0 else Appraisal_Firesale_Value_CCY end + case when  Appraisal_Firesale_Value_EUR is null  then 0 else Appraisal_Firesale_Value_EUR end )<>0) AND ((Asset_Appraisals.m_ID)=-1));

-- 27.2.2018 ใ. 14:28:29
DROP view if exists vw_asset_ccy_id;
CREATE VIEW vw_asset_ccy_id AS
SELECT Assets_List.ID, Assets_List.Asset_Code, Nom_Countries.Currency_ID
FROM Assets_List, Nom_Countries
WHERE (((Left(asset_code,2))=mis_code));

-- 23.2.2018 ใ. 19:00:39
DROP view if exists vw_CountryLE;
CREATE VIEW vw_CountryLE AS
SELECT Nom_Countries.MIS_Code, Tagetik_Code || 'p_' || le_name AS Rep_LE
FROM Nom_Countries INNER JOIN Legal_Entities ON Nom_Countries.ID = Legal_Entities.LE_Country_ID
WHERE (((Legal_Entities.Active)=1));

-- 12.3.2018 ใ. 8:59:04
DROP view if exists vw_Curr_Deadlines;
CREATE VIEW vw_Curr_Deadlines AS
SELECT LastDate.CurrMonth, Legal_Entities.Tagetik_Code, Legal_Entities.LE_Name, calendar.Send_Date, calendar.Confirm_Date
FROM Legal_Entities, calendar INNER JOIN LastDate ON calendar.Rep_Date = LastDate.CurrMonth
WHERE (((Legal_Entities.Active)=1));

-- 7.3.2018 ใ. 13:02:07
DROP view if exists vw_dup_repossessions;
CREATE VIEW vw_dup_repossessions AS
SELECT Asset_Repossession.Repossession_Asset_ID, Asset_Repossession.m_ID, Count(Asset_Repossession.Repossession_Asset_ID) AS CountOfRepossession_Asset_ID
FROM Asset_Repossession
GROUP BY Asset_Repossession.Repossession_Asset_ID, Asset_Repossession.m_ID
HAVING (((Asset_Repossession.m_ID)=-1) AND ((Count(Asset_Repossession.Repossession_Asset_ID))>1));

-- 22.3.2018 ใ. 9:16:49
DROP view if exists vw_Insurances_Exp;
CREATE VIEW vw_Insurances_Exp AS
SELECT Asset_Insurances.Insurance_Asset_ID, Counterparts.Counterpart_Common_Name AS Insurance_Company, Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date, Nom_Currencies.Currency_Code, Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (vw_Last_Insurances INNER JOIN (Nom_Currencies RIGHT JOIN (Counterparts RIGHT JOIN Asset_Insurances ON Counterparts.ID = Asset_Insurances.Insurance_Company_ID) ON Nom_Currencies.ID = Asset_Insurances.Insurance_Currency_ID) ON (vw_Last_Insurances.LastDate = Asset_Insurances.Insurance_End_Date) AND (vw_Last_Insurances.Insurance_Asset_ID = Asset_Insurances.Insurance_Asset_ID)) ON Assets_List.ID = Asset_Insurances.Insurance_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Insurances.m_ID)=-1));

-- 22.3.2018 ใ. 9:15:58
DROP view if exists vw_Last_Appraisals;
CREATE VIEW vw_Last_Appraisals AS
SELECT Asset_Appraisals.Appraisal_Asset_ID, Max(Asset_Appraisals.Appraisal_Date) AS LastDate
FROM Asset_Appraisals
WHERE (((Asset_Appraisals.m_ID)=-1))
GROUP BY Asset_Appraisals.Appraisal_Asset_ID;

-- 22.3.2018 ใ. 9:16:49
DROP view if exists vw_Last_Insurances;
CREATE VIEW vw_Last_Insurances AS
SELECT Asset_Insurances.Insurance_Asset_ID, Max(Asset_Insurances.Insurance_End_Date) AS LastDate
FROM Asset_Insurances
WHERE (((Asset_Insurances.m_ID)=-1))
GROUP BY Asset_Insurances.Insurance_Asset_ID;

-- 22.3.2018 ใ. 9:17:18
DROP view if exists vw_Last_Rentals;
CREATE VIEW vw_Last_Rentals AS
SELECT Asset_Rentals.Rental_Asset_ID, Max(Asset_Rentals.Rental_End_Date) AS LastDate
FROM Asset_Rentals
WHERE (((Asset_Rentals.m_ID)=-1))
GROUP BY Asset_Rentals.Rental_Asset_ID;

-- 9.2.2018 ใ. 15:58:36
DROP view if exists vw_LE_Sender;
CREATE VIEW vw_LE_Sender AS
SELECT Users.FullName, legal_entities.Tagetik_Code, Mail_Log.ID
FROM legal_entities INNER JOIN (Mail_Log INNER JOIN Users ON Mail_Log.Sender = Users.EMail) ON legal_entities.ID = Users.LE_ID;

-- 2.3.2018 ใ. 9:44:33
DROP view if exists vw_LEs;
CREATE VIEW vw_LEs AS
SELECT Legal_Entities.ID, '(' || country_code || ') ' || tagetik_code || ' - ' || le_name AS Text
FROM Legal_Entities LEFT JOIN Nom_Countries ON Legal_Entities.LE_Country_ID = Nom_Countries.ID;

-- 19.2.2018 ใ. 8:57:20
DROP function if exists vw_Mail_auth_sender;
CREATE function vw_Mail_auth_sender( p_mSender varchar,p_m_ID integer) RETURNS table (Object_Code varchar) LANGUAGE 'sql' AS $$
SELECT vw_Mail_Objects.Object_Code
FROM vw_Mail_Objects
WHERE (((vw_Mail_Objects.m_ID)=p_m_ID) AND ((Not Exists (select country_code from vwUserCountry where country_code = object_country and email=p_mSender))=True))
GROUP BY vw_Mail_Objects.Object_Code;

$$;
-- 19.2.2018 ใ. 8:52:55
DROP view if exists vw_Mail_Countries;
CREATE VIEW vw_Mail_Countries AS
SELECT Users.EMail, Nom_Countries.MIS_Code
FROM Nom_Countries INNER JOIN (Legal_Entities INNER JOIN Users ON Legal_Entities.ID = Users.LE_ID) ON Nom_Countries.ID = Legal_Entities.LE_Country_ID
GROUP BY Users.EMail, Nom_Countries.MIS_Code;

-- 19.2.2018 ใ. 8:57:20
DROP view if exists vw_Mail_Objects;
CREATE VIEW vw_Mail_Objects AS
SELECT NPE_Code as Object_Code, Left(NPE_Code,2) as Object_Country, m_ID from NPE_List
UNION ALL SELECT Asset_Code as Object_Code, left(Asset_Code,2) as Object_Country, m_ID from Assets_List;

-- 23.2.2018 ใ. 13:25:45
DROP view if exists vw_Mail_Roles;
CREATE VIEW vw_Mail_Roles AS
SELECT vw_Mail_Objects.m_ID, vwUserCountry.EMail, vwUserCountry.Role
FROM vw_Mail_Objects INNER JOIN vwUserCountry ON vw_Mail_Objects.Object_Country = vwUserCountry.Country_Code
GROUP BY vw_Mail_Objects.m_ID, vwUserCountry.EMail, vwUserCountry.Role;

-- 27.2.2018 ใ. 14:28:14
DROP view if exists vw_npe_ccy_id;
CREATE VIEW vw_npe_ccy_id AS
SELECT NPE_List.ID, NPE_List.NPE_Code, Nom_Countries.Currency_ID
FROM NPE_List, Nom_Countries
WHERE (((Left(NPE_code,2))=mis_code));

-- 1.3.2018 ใ. 19:24:48
DROP view if exists vw_NPE_Pipeline;
CREATE VIEW vw_NPE_Pipeline AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Max(Nom_NPE_Status.NPE_Status_Code) AS Status, Max( case when npe_history.npe_scenario_id=6 then npe_history.npe_rep_date else Null end ) AS FC_Rep_Date, NPE_History.NPE_Currency, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_ccy else 0 end ) AS FC_NPE_CCY, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_EUR, NPE_List.NPE_Scenario_ID, Sum( case when npe_history.npe_scenario_id=2 then npe_history.npe_amount_eur else 0 end ) AS MYP_Original, Sum( case when npe_history.npe_scenario_id=3 then npe_history.npe_amount_eur else 0 end ) AS MYP_Update, Sum( case when npe_history.npe_scenario_id=6 then npe_history.npe_amount_ccy else 0 end ) AS Actual_CCY, Sum( case when npe_history.npe_scenario_id=6 then npe_history.npe_amount_eur else 0 end ) AS Actual_EUR, Sum( case when npe_history.npe_scenario_id=6 then npe_history.llp_amount_ccy else 0 end ) AS Actual_LLP_CCY, Sum( case when npe_history.npe_scenario_id=6 then npe_history.llp_amount_eur else 0 end ) AS Actual_LLP_EUR
FROM NPE_List INNER JOIN (Nom_NPE_Status RIGHT JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID
WHERE (((NPE_History.Rep_Date) In (select currmonth from lastDate)) AND ((NPE_History.m_ID)=-1) AND ((NPE_History.NPE_Scenario_ID) In (2,3,6,11)))
GROUP BY NPE_List.NPE_Code, NPE_List.NPE_Name, NPE_History.NPE_Currency, NPE_List.NPE_Scenario_ID
HAVING (((Max(Nom_NPE_Status.NPE_Status_Code)) In ('Approved','Pipeline')));

-- 1.3.2018 ใ. 14:56:33
DROP view if exists vw_NPE_Pipeline_old;
CREATE VIEW vw_NPE_Pipeline_old AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Max(Nom_NPE_Status.NPE_Status_Code) AS Status, Max( case when npe_history.npe_scenario_id=11 then npe_history.npe_rep_date else Null end ) AS FC_Rep_Date, NPE_History.NPE_Currency, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_ccy else 0 end ) AS FC_NPE_CCY, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_EUR, NPE_List.NPE_Scenario_ID, Sum( case when npe_history.npe_scenario_id=2 then npe_history.npe_amount_eur else 0 end ) AS MYP_Original, Sum( case when npe_history.npe_scenario_id=3 then npe_history.npe_amount_eur else 0 end ) AS MYP_Update, Sum( case when npe_history.npe_scenario_id=6 then npe_history.npe_amount_ccy else 0 end ) AS Actual_CCY, Sum( case when npe_history.npe_scenario_id=6 then npe_history.npe_amount_eur else 0 end ) AS Actual_EUR, Sum( case when npe_history.npe_scenario_id=6 then npe_history.llp_amount_ccy else 0 end ) AS Actual_LLP_CCY, Sum( case when npe_history.npe_scenario_id=6 then npe_history.llp_amount_eur else 0 end ) AS Actual_LLP_EUR
FROM NPE_List INNER JOIN (Nom_NPE_Status RIGHT JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID
WHERE (((NPE_History.Rep_Date) In (select currmonth from lastDate)) AND ((NPE_History.m_ID)=-1) AND ((NPE_History.NPE_Scenario_ID) In (2,3,6,11)))
GROUP BY NPE_List.NPE_Code, NPE_List.NPE_Name, NPE_History.NPE_Currency, NPE_List.NPE_Scenario_ID
HAVING (((Max(Nom_NPE_Status.NPE_Status_Code)) In ('Approved','Pipeline')));

-- 5.2.2018 ใ. 17:42:57
DROP function if exists vw_NPE_Shifts;
CREATE function vw_NPE_Shifts( p_base_year varchar,p_comp_scenario varchar,p_base_scenario varchar) RETURNS table (rep_year double precision,Base_NPE double precision,Comp_NPE double precision,Shift_NPE double precision,New_NPE double precision,Delta_NPE double precision) LANGUAGE 'sql' AS $$
SELECT inn.rep_year, Sum(inn.baseNpe) AS Base_NPE, Sum(inn.compNpe) AS Comp_NPE, Sum(inn.ShiftNPE) AS Shift_NPE, Comp_NPE-Base_NPE-Shift_NPE AS New_NPE, Comp_NPE-Base_NPE AS Delta_NPE
FROM (SELECT  case when ver='Original' then Year(NPE_Rep_Date) else (select  case when ver='ShiftedTo' then extract(year from s.npe_rep_date) else p_base_year end  as shift_year from npe_history s where s.npe_scenario_id=p_comp_scenario and extract(year from s.npe_rep_date)<>p_base_year and s.npe_id=npe_history.npe_id) end  AS Rep_Year, ( case when npe_scenario_id=p_base_scenario And ver='Original' then npe_amount_eur else 0 end ) AS BaseNPE, ( case when npe_scenario_id=p_comp_scenario And ver='Original' then npe_amount_eur else 0 end ) AS CompNPE, ( case when npe_scenario_id=p_base_scenario And ver<>'Original' then npe_amount_eur*Sign else 0 end ) AS ShiftNPE, ver, npe_id FROM NPE_History, Orig_Shifted WHERE (((NPE_History.NPE_Scenario_ID) In (p_base_scenario,p_comp_scenario)) And ((NPE_History.NPE_Amount_EUR)<>0)) And Not (npe_scenario_id=p_base_scenario And ver<>'Original' And extract(year from npe_rep_date)<>p_base_year))  AS inn
WHERE (((inn.rep_year) Is Not Null))
GROUP BY inn.rep_year;

$$;
-- 19.2.2018 ใ. 9:48:33
DROP function if exists vw_old_Linked_Mails;
CREATE function vw_old_Linked_Mails( p_m_ID integer) RETURNS table (m_ID integer,old_m_ID integer) LANGUAGE 'sql' AS $$
SELECT vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID AS old_m_ID
FROM vw_Mail_Objects INNER JOIN vw_Mail_Objects AS vw_Mail_Objects_1 ON vw_Mail_Objects.Object_Code = vw_Mail_Objects_1.Object_Code
WHERE (((vw_Mail_Objects.m_ID)<>-1) And ((vw_Mail_Objects_1.m_ID)<>vw_Mail_Objects.m_ID And (vw_Mail_Objects_1.m_ID)<>-1) And ((vw_Mail_Objects.m_ID)=p_m_ID))
GROUP BY vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID;

$$;
-- 22.3.2018 ใ. 9:17:18
DROP view if exists vw_Rentals_Exp;
CREATE VIEW vw_Rentals_Exp AS
SELECT Asset_Rentals.Rental_Asset_ID, Counterparts.Counterpart_Common_Name AS Tenant, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date, Asset_Rentals.Rental_Payment_Date, Nom_Currencies.Currency_Code, Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR
FROM (((Asset_Rentals INNER JOIN vw_Last_Rentals ON (vw_Last_Rentals.LastDate = Asset_Rentals.Rental_End_Date) AND (Asset_Rentals.Rental_Asset_ID = vw_Last_Rentals.Rental_Asset_ID)) LEFT JOIN Nom_Currencies ON Asset_Rentals.Rental_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Rentals.Rental_Counterpart_ID = Counterparts.ID) LEFT JOIN Asset_Sales ON Asset_Rentals.Rental_Asset_ID = Asset_Sales.Sale_Asset_ID
WHERE (((Asset_Rentals.m_ID)=-1) AND ((Asset_Sales.Sale_Contract_Date) Is Null));

-- 22.3.2018 ใ. 9:15:58
DROP view if exists vw_sh_Appraisals;
CREATE VIEW vw_sh_Appraisals AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, vw_Appraisals_Exp.Appraisal_Company, vw_Appraisals_Exp.Appraisal_Date, vw_Appraisals_Exp.Currency_Code, vw_Appraisals_Exp.Appraisal_Market_Value_CCY, vw_Appraisals_Exp.Appraisal_Market_Value_EUR, vw_Appraisals_Exp.Appraisal_Firesale_Value_CCY, vw_Appraisals_Exp.Appraisal_Firesale_Value_EUR, Switch(Appraisal_Date Is Null,'No Appraisal',CurrMonth>Appraisal_Expiration,'Expired Appraisal',Appraisal_Expiration<DateAdd('m',2,CurrMonth),'Appraisal Expiring Soon',1,'Appraisal OK') AS Appraisal_Status
FROM NPE_List INNER JOIN ((vw_Appraisals_Exp RIGHT JOIN Assets_List ON vw_Appraisals_Exp.Appraisal_Asset_ID = Assets_List.ID) INNER JOIN (LastDate INNER JOIN Asset_History ON LastDate.CurrMonth = Asset_History.Rep_Date) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 1.3.2018 ใ. 9:29:18
DROP view if exists vw_sh_Appraisals_Old;
CREATE VIEW vw_sh_Appraisals_Old AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Switch(appraisal_asset_id Is Null,'No Appraisal',(select currMonth from lastdate) Not Between  case when  appraisal_date is null  then DateSerial(2000,1,1) else Appraisal_Date end  And DateAdd('m',appraisalPeriod, case when  appraisal_date is null  then DateSerial(2000,1,1) else Appraisal_Date end ),'Appraisal expired or not yet valid',Appraisal_Market_Value_EUR=0,'Appraisal value is 0',1,'OK') AS Appraisal_Status, Counterparts.Counterpart_Common_Name AS Appraisal_Company, Asset_Appraisals.Appraisal_Date, Nom_Currencies.Currency_Code, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR
FROM NPE_List INNER JOIN (((vw_Appr_Periods RIGHT JOIN Assets_List ON vw_Appr_Periods.ID = Assets_List.ID) LEFT JOIN (Counterparts RIGHT JOIN (vw_Asset_Appraisals AS Asset_Appraisals LEFT JOIN Nom_Currencies ON Asset_Appraisals.Appraisal_Currency_ID = Nom_Currencies.ID) ON Counterparts.ID = Asset_Appraisals.Appraisal_Company_ID) ON Assets_List.ID = Asset_Appraisals.Appraisal_Asset_ID) INNER JOIN (LastDate INNER JOIN Asset_History ON LastDate.PrevMonth = Asset_History.Rep_Date) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1) AND ((Asset_History.Book_Value)<>0));

-- 22.3.2018 ใ. 9:16:07
DROP view if exists vw_sh_Asset_Info;
CREATE VIEW vw_sh_Asset_Info AS
SELECT NPE_List.NPE_Code, Assets_List.Asset_Code, Assets_List.Asset_Name, Assets_List.Asset_Description, Nom_Asset_Owned.Asset_Owned, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Nom_Countries.Country_Name, Nom_Asset_Usage.Asset_Usage_Text, Nom_Asset_Type.Asset_Type_Text, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Comment
FROM NPE_List INNER JOIN (Nom_Countries RIGHT JOIN (Nom_Asset_Usage RIGHT JOIN (Nom_Asset_Type RIGHT JOIN (Assets_List LEFT JOIN Nom_Asset_Owned ON Assets_List.Asset_Owned = Nom_Asset_Owned.ID) ON Nom_Asset_Type.ID = Assets_List.Asset_Type_ID) ON Nom_Asset_Usage.ID = Assets_List.Asset_Usage_ID) ON Nom_Countries.ID = Assets_List.Asset_Country_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 22.3.2018 ใ. 9:16:19
DROP view if exists vw_sh_Asset_Status;
CREATE VIEW vw_sh_Asset_Status AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Nom_Asset_Status.Asset_Status_Code, Asset_History.Book_Value_PM, Asset_History.Inflows, Asset_History.CAPEX, Asset_History.Depreciation, Asset_History.Sales, Asset_History.Imp_WB, Asset_History.Book_Value, Asset_History.Costs, Asset_History.Income, Asset_History.Expected_Exit
FROM NPE_List INNER JOIN (Assets_List INNER JOIN ((Asset_History INNER JOIN LastDate ON Asset_History.Rep_Date = LastDate.CurrMonth) INNER JOIN Nom_Asset_Status ON Asset_History.Status_Code = Nom_Asset_Status.ID) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_History.m_ID)=-1) And ((Nom_Asset_Status.Asset_Status_Code='Sold' And Round(Asset_History.Book_Value_PM,2)=0)=False))
ORDER BY Assets_List.Asset_Code;

-- 22.3.2018 ใ. 9:16:30
DROP view if exists vw_sh_Business_Cases;
CREATE VIEW vw_sh_Business_Cases AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Business_Cases.BC_Date, Business_Cases.BC_Comment, Business_Cases.BC_Purchase_Date, Business_Cases.BC_Purchase_Price_EUR, Business_Cases.Exp_CAPEX_EUR, Business_Cases.Exp_CAPEX_Time, Business_Cases.Exp_Sale_Date, Business_Cases.Exp_Sale_Price_EUR, Business_Cases.Exp_Interest_EUR, Business_Cases.Exp_OPEX_EUR, Business_Cases.Exp_Income_EUR
FROM NPE_List INNER JOIN Business_Cases ON NPE_List.ID = Business_Cases.NPE_ID
WHERE (((Business_Cases.m_ID)=-1))
ORDER BY NPE_List.NPE_Code;

-- 22.3.2018 ใ. 9:16:40
DROP view if exists vw_sh_Financing;
CREATE VIEW vw_sh_Financing AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, vwCounterparts.Descr AS Lender, Asset_Financing.Financing_Contract_Code, Nom_Financing_Type.Financing_Type, Nom_Currencies.Currency_Code, Asset_Financing.Financing_Amount_CCY, Asset_Financing.Financing_Amount_EUR, Asset_Financing.Financing_Reference_Rate, Asset_Financing.Financing_Margin, Asset_Financing.Financing_Rate, Asset_Financing.Financing_Contract_Date, Asset_Financing.Financing_Start_Date, Asset_Financing.Financing_End_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (((Asset_Financing LEFT JOIN Nom_Currencies ON Asset_Financing.Financing_Currency_ID = Nom_Currencies.ID) LEFT JOIN Nom_Financing_Type ON Asset_Financing.Financing_Type_ID = Nom_Financing_Type.ID) LEFT JOIN vwCounterparts ON Asset_Financing.Financing_Counterpart_ID = vwCounterparts.ID) ON Assets_List.ID = Asset_Financing.Financing_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Financing.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 22.3.2018 ใ. 9:16:49
DROP view if exists vw_sh_Insurances;
CREATE VIEW vw_sh_Insurances AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, vw_Insurances_Exp.Insurance_Company, vw_Insurances_Exp.Insurance_Start_Date, vw_Insurances_Exp.Insurance_End_Date, vw_Insurances_Exp.Currency_Code, vw_Insurances_Exp.Insurance_Amount_CCY, vw_Insurances_Exp.Insurance_Amount_EUR, vw_Insurances_Exp.Insurance_Premium_CCY, vw_Insurances_Exp.Insurance_Premium_EUR, Switch(Insurance_End_Date Is Null,'No Insurance',CurrMonth>Insurance_End_Date,'Expired Insurance',Insurance_End_Date<DateAdd('m',2,CurrMonth),'Insurance Expiring Soon',1,'Insurance OK') AS Insurance_Status
FROM NPE_List INNER JOIN ((Assets_List LEFT JOIN vw_Insurances_Exp ON Assets_List.ID = vw_Insurances_Exp.Insurance_Asset_ID) INNER JOIN (LastDate INNER JOIN Asset_History ON LastDate.CurrMonth = Asset_History.Rep_Date) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 1.3.2018 ใ. 12:11:22
DROP view if exists vw_sh_Insurances_Old;
CREATE VIEW vw_sh_Insurances_Old AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name,  case when Asset_Insurances.ID Is Null then 'No Insurance' else  case when Date() Not Between  case when  Insurance_Start_Date is null  then DateSerial(2000,1,1) else Insurance_Start_Date end  And  case when  Insurance_End_Date is null  then DateSerial(2000,1,1) else Insurance_End_Date end  then 'Expired insurance' else  case when Insurance_Amount_EUR<=0 then 'Invalid insurance amount in EUR' else  null  end  end  end  AS Insurance_Status, Counterparts.counterpart_common_name AS Insurance_Company, Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date, Nom_Currencies.Currency_Code, Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Insurances LEFT JOIN Nom_Currencies ON Asset_Insurances.Insurance_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Insurances.Insurance_Company_ID = Counterparts.ID) ON Assets_List.ID = Asset_Insurances.Insurance_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Insurances.m_ID)=-1));

-- 22.3.2018 ใ. 9:17:03
DROP view if exists vw_sh_NPEs_Identified;
CREATE VIEW vw_sh_NPEs_Identified AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, NPE_List.NPE_Description, Nom_Countries.Country_Name, Lender.Descr AS Lender, Borrower.Descr AS Borrower, NPE_List.NPE_Amount_Date, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR
FROM Nom_Countries RIGHT JOIN (Nom_Currencies RIGHT JOIN ((NPE_List LEFT JOIN vwCounterparts AS Lender ON NPE_List.NPE_Lender_ID = Lender.ID) LEFT JOIN vwCounterparts AS Borrower ON NPE_List.NPE_Borrower_ID = Borrower.ID) ON Nom_Currencies.ID = NPE_List.NPE_Currency_ID) ON Nom_Countries.ID = NPE_List.NPE_Country_ID
WHERE (((NPE_List.m_ID)=-1))
ORDER BY NPE_List.NPE_Code;

-- 22.3.2018 ใ. 9:17:18
DROP view if exists vw_sh_Rentals;
CREATE VIEW vw_sh_Rentals AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, vw_Rentals_Exp.Tenant, vw_Rentals_Exp.Rental_Contract_Date, vw_Rentals_Exp.Rental_Start_Date, vw_Rentals_Exp.Rental_End_Date, vw_Rentals_Exp.Rental_Payment_Date, vw_Rentals_Exp.Currency_Code, vw_Rentals_Exp.Rental_Amount_CCY, vw_Rentals_Exp.Rental_Amount_EUR, Switch(Rental_End_Date Is Null,'Not Rented',CurrMonth>Rental_End_Date,'Expired Rental Contract',Rental_End_Date<DateAdd('m',2,CurrMonth),'Rental Contract Expiring Soon',1,'Rental Contract OK') AS Rental_Status
FROM LastDate, NPE_List INNER JOIN (Assets_List INNER JOIN vw_Rentals_Exp ON Assets_List.ID = vw_Rentals_Exp.Rental_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 1.3.2018 ใ. 14:14:29
DROP view if exists vw_sh_Rentals_Old;
CREATE VIEW vw_sh_Rentals_Old AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name,  case when Asset_Rentals.ID Is Null then 'No Tenant' else Counterpart_Common_Name end  AS Tenant, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date, Asset_Rentals.Rental_Payment_Date, Nom_Currencies.Currency_Code, Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Rentals LEFT JOIN Counterparts ON Asset_Rentals.Rental_Counterpart_ID = Counterparts.ID) LEFT JOIN Nom_Currencies ON Asset_Rentals.Rental_Currency_ID = Nom_Currencies.ID) ON Assets_List.ID = Asset_Rentals.Rental_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Rentals.m_ID)=-1));

-- 22.3.2018 ใ. 9:17:31
DROP view if exists vw_sh_Repossessions;
CREATE VIEW vw_sh_Repossessions AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Asset_Repossession.Purchase_Auction_Date, Asset_Repossession.Purchase_Contract_Date, Asset_Repossession.Purchase_Handover_Date, Asset_Repossession.Purchase_Payment_Date, Purchase_Currency.Currency_Code, Asset_Repossession.Appr_Purchase_Price_Net_CCY, Asset_Repossession.Appr_Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Price_Net_CCY, Asset_Repossession.Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Costs_CCY, Asset_Repossession.Purchase_Costs_EUR, Asset_Repossession.Planned_CAPEX_CCY, Asset_Repossession.Planned_CAPEX_EUR, Asset_Repossession.Planned_CAPEX_Comment, Asset_Repossession.Planned_OPEX_CCY, Asset_Repossession.Planned_OPEX_EUR, Asset_Repossession.Planned_OPEX_Comment, Asset_Repossession.Planned_SalesPrice_CCY, Asset_Repossession.Planned_SalesPrice_EUR
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (Nom_Currencies AS Purchase_Currency RIGHT JOIN (Asset_Repossession LEFT JOIN Nom_Currencies AS NPE_Currency ON Asset_Repossession.NPE_Currency_ID = NPE_Currency.ID) ON Purchase_Currency.ID = Asset_Repossession.Purchase_Price_Currency_ID) ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Repossession.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 22.3.2018 ใ. 9:17:40
DROP view if exists vw_sh_Sales;
CREATE VIEW vw_sh_Sales AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Counterparts.counterpart_common_name AS Buyer, Asset_Sales.Sale_Approval_Date, Asset_Sales.Sale_Contract_Date, Asset_Sales.Sale_Transfer_Date, Asset_Sales.Sale_Payment_Date, Nom_Currencies.Currency_Code, Asset_Sales.Sale_ApprovedAmt_CCY, Asset_Sales.Sale_ApprovedAmt_EUR, Asset_Sales.Sale_Amount_CCY, Asset_Sales.Sale_Amount_EUR, Asset_Sales.Sale_Book_Value_CCY, Asset_Sales.Sale_Book_Value_EUR, Asset_Sales.Sale_AML_Check_Date, Asset_Sales.Sale_AML_Pass_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN ((Asset_Sales LEFT JOIN Nom_Currencies ON Asset_Sales.Sale_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Sales.Sale_Counterpart_ID = Counterparts.ID) ON Assets_List.ID = Asset_Sales.Sale_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Sales.m_ID)=-1))
ORDER BY Assets_List.Asset_Code;

-- 29.12.2017 ใ. 9:51:44
DROP view if exists vw_Shifts;
CREATE VIEW vw_Shifts AS
SELECT inn.npe_id, Max(inn.base_rep_year) AS base_rep_year_, Max(inn.new_rep_year) AS new_rep_year_, Sum(inn.base_amount_eur) AS base_amount_eur_, Sum(inn.new_amount_eur) AS new_amount_eur_,  case when Max(base_rep_year)=2017 And Max(new_rep_year)<>2017 And Max(new_rep_year)<>0 then Max(new_rep_year) else Null end  AS Shifted_To
FROM (SELECT NPE_History.NPE_ID, extract(year from NPE_History.NPE_Rep_Date) as base_rep_year, 0 as new_rep_year, NPE_History.NPE_Amount_EUR as base_amount_eur, null as new_amount_eur
FROM NPE_History
where npe_scenario_id=2 and npe_amount_eur<>0 and npe_amount_eur is not null
union all
SELECT NPE_History.NPE_ID, 0 as base_Rep_year, extract(year from NPE_History.NPE_Rep_Date), null, NPE_History.NPE_Amount_EUR
FROM NPE_History
where npe_scenario_id=11 and npe_amount_eur<>0 and npe_amount_eur is not null
)  AS inn
GROUP BY inn.npe_id;

-- 29.12.2017 ใ. 10:02:44
DROP view if exists vw_shifts_final;
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

-- 12.3.2018 ใ. 9:49:19
DROP view if exists vw_Submission_Stats;
CREATE VIEW vw_Submission_Stats AS
SELECT vw_Curr_Deadlines.CurrMonth, vw_Curr_Deadlines.Tagetik_Code, vw_Curr_Deadlines.LE_Name, Mail_Log.Sender, Max(Mail_Log.mailStatus) AS MaxOfmailStatus, vw_Curr_Deadlines.Send_Date, vw_Curr_Deadlines.Confirm_Date,  case when mailStatus=1 then 'Received' else  case when mailStatus=2 then 'Confirmed' else '' end  end  AS Status
FROM vw_Curr_Deadlines LEFT JOIN (File_Log LEFT JOIN Mail_Log ON File_Log.m_ID = Mail_Log.ID) ON (vw_Curr_Deadlines.CurrMonth = File_Log.repDate) AND (vw_Curr_Deadlines.Tagetik_Code = File_Log.repLE)
WHERE (((Mail_Log.mailStatus)<3 Or (Mail_Log.mailStatus) Is Null))
GROUP BY vw_Curr_Deadlines.CurrMonth, vw_Curr_Deadlines.Tagetik_Code, vw_Curr_Deadlines.LE_Name, Mail_Log.Sender, vw_Curr_Deadlines.Send_Date, vw_Curr_Deadlines.Confirm_Date,  case when mailStatus=1 then 'Received' else  case when mailStatus=2 then 'Confirmed' else '' end  end 
HAVING (((Mail_Log.Sender) Not In ('mkrastev.external@unicredit.eu','natasa.muric@unicredit.eu'))) OR (((Mail_Log.Sender) Is Null));

-- 28.3.2018 ใ. 23:45:08
DROP view if exists vwCounterparts;
CREATE VIEW vwCounterparts AS
SELECT Counterparts.ID, Counterparts.Counterpart_Common_Name AS Descr, Trim(Counterpart_Type || ' ' || Counterpart_First_Name || ' ' || counterpart_Last_Name || ' ' || Counterpart_Company_Name) AS Descr2
FROM Counterparts;

-- 19.2.2018 ใ. 8:41:44
DROP view if exists vwFileRights;
CREATE VIEW vwFileRights AS
SELECT File_Log.m_ID, Mail_Log.Sender, File_Log.fileName, Legal_Entities.Tagetik_Code, Legal_Entities.LE_Name, File_Log.repLE
FROM File_Log INNER JOIN (Mail_Log LEFT JOIN (Users LEFT JOIN Legal_Entities ON Users.le_id = Legal_Entities.id) ON Mail_Log.Sender = Users.EMail) ON File_Log.m_ID = Mail_Log.ID
WHERE (((Legal_Entities.Tagetik_Code)= case when  RepLE is null  then Tagetik_Code else RepLE end ));

-- 23.2.2018 ใ. 13:25:45
DROP view if exists vwUserCountry;
CREATE VIEW vwUserCountry AS
SELECT Users.EMail, Nom_Countries.MIS_Code AS Country_Code, Users.Role
FROM Nom_Countries RIGHT JOIN (Legal_Entities INNER JOIN Users ON Legal_Entities.ID = Users.LE_ID) ON Nom_Countries.ID = Legal_Entities.LE_Country_ID;

