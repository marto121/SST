-- 09.02.2018 19:25:12
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
-- 06.01.2018 23:14:17
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
-- 23.02.2018 15:59:00
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
-- 09.02.2018 19:25:12
CREATE TABLE Asset_History (
ID integer,
Asset_ID integer,
Rep_Date date,
Status_Code integer,
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
-- 09.02.2018 19:25:12
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
-- 09.02.2018 19:25:12
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
-- 22.02.2018 18:44:38
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
-- 09.02.2018 19:25:12
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
-- 09.02.2018 19:25:12
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
-- 09.02.2018 15:29:42
CREATE TABLE Business_Cases (
ID integer,
NPE_ID integer,
BC_Date date,
BC_Comment Memo,
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
-- 23.02.2018 13:06:56
CREATE TABLE calendar (
ID integer,
Rep_Date date,
Prev_Date date,
Send_Date date,
Confirm_Date date
);
-- 22.12.2017 13:21:22
CREATE TABLE Counterparts (
ID integer,
Counterpart_Common_Name varchar(255),
Counterpart_First_Name varchar(255),
Counterpart_Last_Name varchar(255),
Counterpart_Company_Name varchar(255),
Counterpart_Type varchar(255)
);
-- 23.02.2018 13:12:07
CREATE TABLE File_Log (
ID integer,
m_ID integer,
fileName varchar(255),
fileStatus smallint,
repLE varchar(255),
repDate date
);
-- 09.02.2018 13:05:00
CREATE TABLE FX_Rates (
ID integer,
CCY_Code varchar(255),
Scenario varchar(255),
RepDate date,
FX_Rate_Avg double precision,
FX_Rate_Eop double precision
);
-- 09.02.2018 15:29:55
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
-- 06.02.2018 11:19:34
CREATE TABLE LastDate (
PrevMonth date,
CurrMonth date
);
-- 23.02.2018 17:23:39
CREATE TABLE Legal_Entities (
ID integer,
Tagetik_Code varchar(255),
LE_Name varchar(255),
LE_Country_ID integer,
Active integer
);
-- 01.02.2018 15:22:04
CREATE TABLE lst_Reports (
ID integer,
Report_Code varchar(255),
Report_Name varchar(255),
Template_FileName varchar(255)
);
-- 09.02.2018 16:08:13
CREATE TABLE lst_Sheets (
ID integer,
Report_ID integer,
Sheet_Name varchar(255),
Sheet_Title varchar(255),
Sheet_Query varchar(255),
Sheet_Columns Memo
);
-- 23.02.2018 18:07:39
CREATE TABLE Mail_Log (
ID integer,
Sender varchar(255),
Receiver varchar(255),
Subject varchar(255),
mailStatus smallint,
authStatus smallint,
answerText Memo,
answerRecipients varchar(255)
);
-- 23.02.2018 10:06:20
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
Fields_List Memo
);
-- 27.12.2017 21:23:58
CREATE TABLE Nom_Asset_Owned (
ID integer,
Asset_Owned varchar(255)
);
-- 27.12.2017 21:39:44
CREATE TABLE Nom_Asset_Status (
ID integer,
Asset_Status_Code varchar(20),
Asset_Status_Text varchar(50)
);
-- 09.02.2018 19:25:12
CREATE TABLE Nom_Asset_Type (
ID integer,
Asset_Type_Text varchar(255)
);
-- 09.02.2018 19:25:12
CREATE TABLE Nom_Asset_Usage (
ID integer,
Asset_Usage_Text varchar(255)
);
-- 15.02.2018 09:41:34
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
-- 27.12.2017 21:24:08
CREATE TABLE Nom_Currencies (
ID integer,
Currency_Code varchar(255),
Currency_Name varchar(255),
Currency_Symbol varchar(3)
);
-- 09.02.2018 19:25:12
CREATE TABLE Nom_Financing_Type (
ID integer,
Financing_Type varchar(10)
);
-- 03.01.2018 18:50:29
CREATE TABLE Nom_Log_Types (
ID varchar(255),
Descr varchar(255),
Color varchar(255)
);
-- 09.02.2018 19:25:12
CREATE TABLE Nom_NPE_Status (
ID integer,
NPE_Status_Code varchar(10),
NPE_Status_Text varchar(50)
);
-- 09.02.2018 19:25:12
CREATE TABLE Nom_Scenarios (
ID integer,
Scenario_Name varchar(50)
);
-- 02.01.2018 19:24:56
CREATE TABLE Nom_Transaction_Types (
ID integer,
Transaction_Code varchar(255)
);
-- 09.02.2018 19:25:12
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
-- 15.02.2018 09:41:34
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
-- 30.12.2017 15:07:51
CREATE TABLE orig_shifted (
ver varchar(255),
sign integer
);
-- 22.12.2017 15:23:43
CREATE TABLE SST_Log (
ID integer,
Log_Date date,
Log_Source varchar(255),
Log_Text varchar(255),
Log_Type varchar(255),
Mail_ID integer
);
-- 23.02.2018 12:54:21
CREATE TABLE Users (
ID integer,
EMail varchar(255),
FullName varchar(255),
LE_ID integer,
Role smallint,
FirstName varchar(255),
LastName varchar(255)
);
create  index Asset_Financials_Asset_ID on Asset_Financials(Asset_ID);
create  index Asset_Financials_MIS_Code on Asset_Financials(Trans_Type_ID);
create  index Business_Cases_m_ID on Business_Cases(m_ID);
create  index Business_Cases_NPE_ID on Business_Cases(NPE_ID);
create  index FX_Rates_CCY_Code on FX_Rates(CCY_Code);
create  index FX_Rates_Scenario_ID on FX_Rates(Scenario);
create  index Legal_Entities_Tagetik_Code on Legal_Entities(Tagetik_Code);
create UNIQUE index Nom_Asset_Owned_Asset_Type_Text on Nom_Asset_Owned(Asset_Owned);
create UNIQUE index Nom_Asset_Type_Asset_Type_Text on Nom_Asset_Type(Asset_Type_Text);
create UNIQUE index Nom_Asset_Usage_Asset_Usage_Text on Nom_Asset_Usage(Asset_Usage_Text);
create UNIQUE index Nom_Countries_Country_Name on Nom_Countries(Country_Name);
create UNIQUE index Nom_Currencies_Currency_Code on Nom_Currencies(Currency_Code);
create  index Nom_Transaction_Types_Code on Nom_Transaction_Types(Transaction_Code);
create  index SST_Log_Mail_ID on SST_Log(Mail_ID);
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
ALTER TABLE SST_Log ADD constraint SST_Log_PrimaryKey primary key (ID);
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
ALTER TABLE Assets_List ADD constraint NPE_ListAssets_List foreign key (Asset_NPE_ID) references NPE_List(ID);
ALTER TABLE Legal_Entities ADD constraint Nom_CountriesLegal_Entities foreign key (LE_Country_ID) references Nom_Countries(ID);
ALTER TABLE NPE_History ADD constraint Nom_NPE_StatusNPE_History foreign key (NPE_Status_ID) references Nom_NPE_Status(ID);
ALTER TABLE NPE_History ADD constraint NPE_ListNPE_History foreign key (NPE_ID) references NPE_List(ID);
ALTER TABLE NPE_List ADD constraint Nom_CountriesNPE_List foreign key (NPE_Country_ID) references Nom_Countries(ID);
ALTER TABLE NPE_List ADD constraint Nom_ScenariosNPE_List foreign key (NPE_Scenario_ID) references Nom_Scenarios(ID);
ALTER TABLE NPE_List ADD constraint Nom_ScenariosNPE_List1 foreign key (NPE_Scenario_ID) references Nom_Scenarios(ID);
ALTER TABLE Users ADD constraint Legal_EntitiesUsers foreign key (LE_ID) references Legal_Entities(ID);
-- 23.02.2018 17:38:56
CREATE function del_Asset_Financials( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
DELETE
FROM Asset_Financials
WHERE m_id=-1
 and Asset_ID in (select old_parent.id from (Asset_Financials as new_tab0 inner join Assets_List new_parent on new_parent.id=new_tab0.Asset_ID) inner join Assets_List old_parent on new_parent.Asset_Code=old_parent.Asset_Code where new_tab0.m_ID=p_m_ID)
 and Rep_Date in (select new_tab1.Rep_Date from Asset_Financials as new_tab1 where new_tab1.m_id=p_m_ID);

$$;
-- 30.12.2017 17:28:24
CREATE function delAssetAppraisals() RETURNS void LANGUAGE 'sql' AS $$
DELETE
FROM Asset_Appraisals;

$$;
-- 03.12.2017 21:57:59
CREATE function delAssetFinancing() RETURNS void LANGUAGE 'sql' AS $$
DELETE
FROM Asset_Financing;

$$;
-- 03.12.2017 21:58:19
CREATE function delAssetInsurances() RETURNS void LANGUAGE 'sql' AS $$
DELETE
FROM Asset_Insurances;

$$;
-- 30.12.2017 17:30:24
CREATE function delEmptyAppraisals() RETURNS void LANGUAGE 'sql' AS $$
DELETE Asset_Appraisals.Appraisal_Date, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR
FROM Asset_Appraisals
WHERE (((Asset_Appraisals.Appraisal_Date) Is Null) AND ((Asset_Appraisals.Appraisal_Market_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Market_Value_EUR)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_EUR)=0));

$$;
-- 30.12.2017 17:37:34
CREATE function delEmptyFinancing() RETURNS void LANGUAGE 'sql' AS $$
DELETE Asset_Financing.Financing_Amount_CCY, Asset_Financing.Financing_Amount_EUR, Asset_Financing.Financing_Start_Date, Asset_Financing.Financing_End_Date
FROM Asset_Financing
WHERE (((Asset_Financing.Financing_Amount_CCY)=0) AND ((Asset_Financing.Financing_Amount_EUR)=0) AND ((Asset_Financing.Financing_Start_Date) Is Null) AND ((Asset_Financing.Financing_End_Date) Is Null));

$$;
-- 30.12.2017 17:37:42
CREATE function delEmptyInsurances() RETURNS void LANGUAGE 'sql' AS $$
DELETE Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR, Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date
FROM Asset_Insurances
WHERE (((Asset_Insurances.Insurance_Amount_CCY)=0) AND ((Asset_Insurances.Insurance_Amount_EUR)=0) AND ((Asset_Insurances.Insurance_Premium_CCY)=0) AND ((Asset_Insurances.Insurance_Premium_EUR)=0) AND ((Asset_Insurances.Insurance_Start_Date)='2000-1-1') AND ((Asset_Insurances.Insurance_End_Date) Is Null));

$$;
-- 30.12.2017 17:37:22
CREATE function delEmptyRentals() RETURNS void LANGUAGE 'sql' AS $$
DELETE Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date
FROM Asset_Rentals
WHERE (((Asset_Rentals.Rental_Amount_CCY)=0) AND ((Asset_Rentals.Rental_Amount_EUR)=0) AND ((Asset_Rentals.Rental_Contract_Date)='2000-1-1') AND ((Asset_Rentals.Rental_Start_Date) Is Null) AND ((Asset_Rentals.Rental_End_Date) Is Null));

$$;
-- 09.02.2018 13:09:20
CREATE function FX_Pipeline_Update() RETURNS void LANGUAGE 'sql' AS $$
UPDATE NPE_List INNER JOIN NPE_History ON NPE_List.ID = NPE_History.NPE_ID, (Nom_Countries INNER JOIN Nom_Currencies ON Nom_Countries.Currency_ID = Nom_Currencies.ID) INNER JOIN FX_Rates ON Nom_Currencies.Currency_Code = FX_Rates.CCY_Code SET NPE_History.NPE_Currency = Currency_Code, NPE_History.NPE_Amount_CCY = npe_history.npe_amount_eur*IIf(npe_history.NPE_Status_ID=8,fx_rate_eop,fx_rate_avg)
WHERE (((Nom_Countries.MIS_Code)=Left(npe_code,2)) And ((NPE_History.m_ID)=-1) And ((FX_Rates.Scenario)="Bud") And ((FX_Rates.RepDate)=IIf(npe_history.npe_status_id=8,#12/31/2018#,#12/31/2017#)));

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Appraisals( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Appraisals
SELECT new_parent.ID AS Appraisal_Asset_ID, new_tab.Appraisal_Company_ID AS Appraisal_Company_ID, new_tab.Appraisal_Date AS Appraisal_Date, new_tab.Appraisal_Currency_ID AS Appraisal_Currency_ID, new_tab.Appraisal_Market_Value_CCY AS Appraisal_Market_Value_CCY, new_tab.Appraisal_Market_Value_EUR AS Appraisal_Market_Value_EUR, new_tab.Appraisal_Firesale_Value_CCY AS Appraisal_Firesale_Value_CCY, new_tab.Appraisal_Firesale_Value_EUR AS Appraisal_Firesale_Value_EUR, new_tab.Appraisal_Order AS Appraisal_Order, -1 AS m_ID
FROM (Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Appraisals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Appraisal_Asset_ID=new_parent.id
   and dw_tab.Appraisal_Date=new_tab.Appraisal_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Financials( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Financials
SELECT new_parent.ID AS Asset_ID, new_tab.Acc_Date AS Acc_Date, new_tab.Account_No AS Account_No, new_tab.Account_Name AS Account_Name, new_tab.Amount AS Amount, new_tab.Trans_Type_ID AS Trans_Type_ID, new_tab.Rep_Date AS Rep_Date, -1 AS m_ID
FROM (Asset_Financials AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financials as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Financing( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Financing
SELECT new_tab.Financing_Contract_Code AS Financing_Contract_Code, new_tab.Financing_Counterpart_ID AS Financing_Counterpart_ID, new_parent.ID AS Financing_Asset_ID, new_tab.Financing_Type_ID AS Financing_Type_ID, new_tab.Financing_Currency_ID AS Financing_Currency_ID, new_tab.Financing_Amount_CCY AS Financing_Amount_CCY, new_tab.Financing_Amount_EUR AS Financing_Amount_EUR, new_tab.Financing_Reference_Rate AS Financing_Reference_Rate, new_tab.Financing_Margin AS Financing_Margin, new_tab.Financing_Rate AS Financing_Rate, new_tab.Financing_Start_Date AS Financing_Start_Date, new_tab.Financing_End_Date AS Financing_End_Date, new_tab.Financing_Contract_Date AS Financing_Contract_Date, -1 AS m_ID
FROM (Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financing as dw_tab where dw_tab.m_id = -1
   and dw_tab.Financing_Asset_ID=new_parent.id
   and dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID
   and dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_History( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_History
SELECT new_parent.ID AS Asset_ID, new_tab.Rep_Date AS Rep_Date, new_tab.Status_Code AS Status_Code, new_tab.Inflows AS Inflows, new_tab.CAPEX AS CAPEX, new_tab.Depreciation AS Depreciation, new_tab.Sales AS Sales, new_tab.Imp_WB AS Imp_WB, new_tab.Book_Value AS Book_Value, new_tab.Costs AS Costs, new_tab.Income AS Income, new_tab.Expected_Exit AS Expected_Exit, -1 AS m_ID
FROM (Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Insurances( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Insurances
SELECT new_parent.ID AS Insurance_Asset_ID, new_tab.Insurance_Company_ID AS Insurance_Company_ID, new_tab.Insurance_Start_Date AS Insurance_Start_Date, new_tab.Insurance_End_Date AS Insurance_End_Date, new_tab.Insurance_Currency_ID AS Insurance_Currency_ID, new_tab.Insurance_Amount_CCY AS Insurance_Amount_CCY, new_tab.Insurance_Amount_EUR AS Insurance_Amount_EUR, new_tab.Insurance_Premium_CCY AS Insurance_Premium_CCY, new_tab.Insurance_Premium_EUR AS Insurance_Premium_EUR, -1 AS m_ID
FROM (Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Insurances as dw_tab where dw_tab.m_id = -1
   and dw_tab.Insurance_Asset_ID=new_parent.id
   and dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Rentals( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Rentals
SELECT new_parent.ID AS Rental_Asset_ID, new_tab.Rental_Counterpart_ID AS Rental_Counterpart_ID, new_tab.Rental_Contract_Date AS Rental_Contract_Date, new_tab.Rental_Start_Date AS Rental_Start_Date, new_tab.Rental_End_Date AS Rental_End_Date, new_tab.Rental_Payment_Date AS Rental_Payment_Date, new_tab.Rental_Currency_ID AS Rental_Currency_ID, new_tab.Rental_Amount_CCY AS Rental_Amount_CCY, new_tab.Rental_Amount_EUR AS Rental_Amount_EUR, -1 AS m_ID
FROM (Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Rentals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Rental_Asset_ID=new_parent.id
   and dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Repossession( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Repossession
SELECT new_parent.ID AS Repossession_Asset_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_Currency_ID AS Purchase_Price_Currency_ID, new_tab.Appr_Purchase_Price_Net_CCY AS Appr_Purchase_Price_Net_CCY, new_tab.Appr_Purchase_Price_Net_EUR AS Appr_Purchase_Price_Net_EUR, new_tab.Purchase_Price_Net_CCY AS Purchase_Price_Net_CCY, new_tab.Purchase_Price_Net_EUR AS Purchase_Price_Net_EUR, new_tab.Purchase_Costs_CCY AS Purchase_Costs_CCY, new_tab.Purchase_Costs_EUR AS Purchase_Costs_EUR, new_tab.Planned_CAPEX_Currency_ID AS Planned_CAPEX_Currency_ID, new_tab.Planned_CAPEX_CCY AS Planned_CAPEX_CCY, new_tab.Planned_CAPEX_EUR AS Planned_CAPEX_EUR, new_tab.Planned_CAPEX_Comment AS Planned_CAPEX_Comment, new_tab.Purchase_Auction_Date AS Purchase_Auction_Date, new_tab.Purchase_Contract_Date AS Purchase_Contract_Date, new_tab.Purchase_Repossession_Date AS Purchase_Repossession_Date, new_tab.Purchase_Payment_Date AS Purchase_Payment_Date, new_tab.Purchase_Handover_Date AS Purchase_Handover_Date, new_tab.Purchase_Registration_Date AS Purchase_Registration_Date, new_tab.Purchase_Local_Approval_Date AS Purchase_Local_Approval_Date, new_tab.Purchase_Central_Approval_Date AS Purchase_Central_Approval_Date, new_tab.Purchase_Prolongation_Date AS Purchase_Prolongation_Date, new_tab.Purchase_Expected_Exit_Date AS Purchase_Expected_Exit_Date, new_tab.Planned_OPEX_CCY AS Planned_OPEX_CCY, new_tab.Planned_OPEX_EUR AS Planned_OPEX_EUR, new_tab.Planned_OPEX_Comment AS Planned_OPEX_Comment, new_tab.Planned_SalesPrice_CCY AS Planned_SalesPrice_CCY, new_tab.Planned_SalesPrice_EUR AS Planned_SalesPrice_EUR, -1 AS m_ID
FROM (Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Repossession as dw_tab where dw_tab.m_id = -1
   and dw_tab.Repossession_Asset_ID=new_parent.id
   and dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Asset_Sales( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_Sales
SELECT new_parent.ID AS Sale_Asset_ID, new_tab.Sale_Counterpart_ID AS Sale_Counterpart_ID, new_tab.Sale_Approval_Date AS Sale_Approval_Date, new_tab.Sale_Contract_Date AS Sale_Contract_Date, new_tab.Sale_Transfer_Date AS Sale_Transfer_Date, new_tab.Sale_Payment_Date AS Sale_Payment_Date, new_tab.Sale_AML_Check_Date AS Sale_AML_Check_Date, new_tab.Sale_AML_Pass_Date AS Sale_AML_Pass_Date, new_tab.Sale_Currency_ID AS Sale_Currency_ID, new_tab.Sale_ApprovedAmt_CCY AS Sale_ApprovedAmt_CCY, new_tab.Sale_ApprovedAmt_EUR AS Sale_ApprovedAmt_EUR, new_tab.Sale_Amount_CCY AS Sale_Amount_CCY, new_tab.Sale_Amount_EUR AS Sale_Amount_EUR, new_tab.Sale_Book_Value_CCY AS Sale_Book_Value_CCY, new_tab.Sale_Book_Value_EUR AS Sale_Book_Value_EUR, -1 AS m_ID
FROM (Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Sales as dw_tab where dw_tab.m_id = -1
   and dw_tab.Sale_Asset_ID=new_parent.id
   and dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Assets_List( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Assets_List
SELECT new_tab.Asset_Code AS Asset_Code, new_parent.ID AS Asset_NPE_ID, new_tab.Asset_Name AS Asset_Name, new_tab.Asset_Description AS Asset_Description, new_tab.Asset_Address AS Asset_Address, new_tab.Asset_ZIP AS Asset_ZIP, new_tab.Asset_Region AS Asset_Region, new_tab.Asset_Country_ID AS Asset_Country_ID, new_tab.Asset_Usage_ID AS Asset_Usage_ID, new_tab.Asset_Type_ID AS Asset_Type_ID, new_tab.Asset_Usable_Area AS Asset_Usable_Area, new_tab.Asset_Common_Area AS Asset_Common_Area, new_tab.Asset_Owned AS Asset_Owned, new_tab.Comment AS Comment, -1 AS m_ID
FROM (Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Assets_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_Code=new_tab.Asset_Code
);

$$;
-- 06.01.2018 20:54:53
CREATE function ins_Assets_List2( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Assets_List ( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID )
SELECT Assets_List.Asset_Code, NPE_List_DW.ID, Assets_List.Asset_Name, Assets_List.Asset_Description, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Assets_List.Asset_Country_ID, Assets_List.Asset_Usage_ID, Assets_List.Asset_Type_ID, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Asset_Owned, Assets_List.Comment, -1 AS DW_m_ID
FROM (NPE_List INNER JOIN Assets_List ON NPE_List.ID = Assets_List.Asset_NPE_ID) INNER JOIN NPE_List AS NPE_List_DW ON NPE_List.NPE_Code = NPE_List_DW.NPE_Code
WHERE (((Assets_List.m_ID)=p_m_ID) AND ((Exists (select 1 from Assets_list al_dwh where al_dwh.asset_code=assets_list.Asset_Code))=False));

$$;
-- 23.02.2018 17:38:56
CREATE function ins_Business_Cases( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Business_Cases
SELECT new_parent.ID AS NPE_ID, new_tab.BC_Date AS BC_Date, new_tab.BC_Comment AS BC_Comment, new_tab.BC_Purchase_Date AS BC_Purchase_Date, new_tab.BC_Purchase_Price_EUR AS BC_Purchase_Price_EUR, new_tab.Exp_CAPEX_EUR AS Exp_CAPEX_EUR, new_tab.Exp_CAPEX_Time AS Exp_CAPEX_Time, new_tab.Exp_Sale_Date AS Exp_Sale_Date, new_tab.Exp_Sale_Price_EUR AS Exp_Sale_Price_EUR, new_tab.Exp_Interest_EUR AS Exp_Interest_EUR, new_tab.Exp_OPEX_EUR AS Exp_OPEX_EUR, new_tab.Exp_Income_EUR AS Exp_Income_EUR, -1 AS m_ID
FROM (Business_Cases AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Business_Cases as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.BC_Date=new_tab.BC_Date
);

$$;
-- 07.02.2018 16:54:43
CREATE function ins_CopyActualAssets() RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO Asset_History ( Asset_ID, Rep_Date, Status_Code, Book_Value, OPEX, CAPEX, Expected_Exit, m_ID )
SELECT Asset_History.Asset_ID, LastDate.CurrMonth, Asset_History.Status_Code, Asset_History.Book_Value, 0 AS OPEX, 0 AS CAPEX, IIf(IsNull(Expected_Exit),'2000-1-1',asset_History.expected_Exit) AS Expected_Exit_, Asset_History.m_ID
FROM Asset_History INNER JOIN LastDate ON Asset_History.Rep_Date = LastDate.PrevMonth
WHERE (((Asset_History.m_ID)=-1));

$$;
-- 07.02.2018 18:41:59
CREATE function ins_CopyActuals() RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO NPE_History ( NPE_ID, Rep_Date, NPE_Status_ID, NPE_Scenario_ID, NPE_Rep_Date, NPE_Currency, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_CCY, Purchase_Price_EUR, m_ID )
SELECT NPE_History.NPE_ID, LastDate.CurrMonth AS RepDate, Max(NPE_History.NPE_Status_ID) AS MaxOfNPE_Status_ID, 6 AS NPE_Scenario_ID_, Max(IIf(npe_history.npe_scenario_id=11,npe_history.npe_rep_date,Null)) AS FC_Rep_Date, "EUR" AS NPE_Currency, Sum(IIf(npe_history.npe_scenario_id=11,npe_history.npe_amount_eur,0)) AS FC_NPE_CCY, Sum(IIf(npe_history.npe_scenario_id=11,npe_history.npe_amount_eur,0)) AS FC_NPE_EUR, Sum(NPE_History.LLP_Amount_CCY) AS SumOfLLP_Amount_CCY, Sum(NPE_History.LLP_Amount_EUR) AS SumOfLLP_Amount_EUR, Sum(NPE_History.Purchase_Price_CCY) AS SumOfPurchase_Price_CCY, Sum(NPE_History.Purchase_Price_EUR) AS SumOfPurchase_Price_EUR, NPE_History.m_ID
FROM NPE_History INNER JOIN LastDate ON NPE_History.Rep_Date = LastDate.PrevMonth
WHERE (((NPE_History.NPE_Scenario_ID) In (6,11)))
GROUP BY NPE_History.NPE_ID, LastDate.CurrMonth, 6, NPE_History.m_ID
HAVING (((NPE_History.m_ID)=-1));

$$;
-- 23.02.2018 17:38:56
CREATE function ins_NPE_History( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO NPE_History
SELECT new_parent.ID AS NPE_ID, new_tab.Rep_Date AS Rep_Date, new_tab.NPE_Status_ID AS NPE_Status_ID, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Rep_Date AS NPE_Rep_Date, new_tab.NPE_Currency AS NPE_Currency, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_CCY AS Purchase_Price_CCY, new_tab.Purchase_Price_EUR AS Purchase_Price_EUR, -1 AS m_ID
FROM (NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from NPE_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
   and dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID
);

$$;
-- 23.02.2018 17:38:56
CREATE function ins_NPE_List( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
INSERT INTO NPE_List
SELECT new_tab.NPE_Code AS NPE_Code, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Country_ID AS NPE_Country_ID, new_tab.NPE_Name AS NPE_Name, new_tab.NPE_Description AS NPE_Description, new_tab.NPE_Lender_ID AS NPE_Lender_ID, new_tab.NPE_Borrower_ID AS NPE_Borrower_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_Date AS NPE_Amount_Date, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.NPE_Owned AS NPE_Owned, -1 AS m_ID
FROM NPE_List AS new_tab
WHERE new_tab.m_id = p_m_ID
   and not exists (select 1 from NPE_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_Code=new_tab.NPE_Code
);

$$;
-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Appraisals AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Appraisal_Company_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Appraisal_Company_ID, tab.Appraisal_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Appraisal_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Appraisal_Currency_ID, max(iif(tab.m_id=-1, tab.Appraisal_Market_Value_CCY,null)) AS old_Appraisal_Market_Value_CCY, max(iif(tab.m_id<>-1, tab.Appraisal_Market_Value_CCY,null)) AS new_Appraisal_Market_Value_CCY, max(iif(tab.m_id=-1, tab.Appraisal_Market_Value_EUR,null)) AS old_Appraisal_Market_Value_EUR, max(iif(tab.m_id<>-1, tab.Appraisal_Market_Value_EUR,null)) AS new_Appraisal_Market_Value_EUR, max(iif(tab.m_id=-1, tab.Appraisal_Firesale_Value_CCY,null)) AS old_Appraisal_Firesale_Value_CCY, max(iif(tab.m_id<>-1, tab.Appraisal_Firesale_Value_CCY,null)) AS new_Appraisal_Firesale_Value_CCY, max(iif(tab.m_id=-1, tab.Appraisal_Firesale_Value_EUR,null)) AS old_Appraisal_Firesale_Value_EUR, max(iif(tab.m_id<>-1, tab.Appraisal_Firesale_Value_EUR,null)) AS new_Appraisal_Firesale_Value_EUR, max(iif(tab.m_id=-1, tab.Appraisal_Order,null)) AS old_Appraisal_Order, max(iif(tab.m_id<>-1, tab.Appraisal_Order,null)) AS new_Appraisal_Order, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((Asset_Appraisals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Appraisal_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Appraisal_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Appraisal_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Appraisal_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Financials AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, tab.Acc_Date,null)) AS old_Acc_Date, max(iif(tab.m_id<>-1, tab.Acc_Date,null)) AS new_Acc_Date, max(iif(tab.m_id=-1, tab.Account_No,null)) AS old_Account_No, max(iif(tab.m_id<>-1, tab.Account_No,null)) AS new_Account_No, max(iif(tab.m_id=-1, tab.Account_Name,null)) AS old_Account_Name, max(iif(tab.m_id<>-1, tab.Account_Name,null)) AS new_Account_Name, max(iif(tab.m_id=-1, tab.Amount,null)) AS old_Amount, max(iif(tab.m_id<>-1, tab.Amount,null)) AS new_Amount, max(iif(tab.m_id=-1, tab.Trans_Type_ID,null)) AS old_Trans_Type_ID, max(iif(tab.m_id<>-1, tab.Trans_Type_ID,null)) AS new_Trans_Type_ID, tab.Rep_Date, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM Asset_Financials AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Financing AS
SELECT max(iif(tab.m_id=-1, tab.Financing_Contract_Code,null)) AS old_Financing_Contract_Code, max(iif(tab.m_id<>-1, tab.Financing_Contract_Code,null)) AS new_Financing_Contract_Code, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Financing_Counterpart_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Financing_Counterpart_ID, parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, Nom_Financing_Type1.Financing_Type AS Financing_Type_ID, max(iif(tab.m_id=-1, Nom_Currencies2.Currency_Code,null)) AS old_Financing_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies2.Currency_Code,null)) AS new_Financing_Currency_ID, max(iif(tab.m_id=-1, tab.Financing_Amount_CCY,null)) AS old_Financing_Amount_CCY, max(iif(tab.m_id<>-1, tab.Financing_Amount_CCY,null)) AS new_Financing_Amount_CCY, max(iif(tab.m_id=-1, tab.Financing_Amount_EUR,null)) AS old_Financing_Amount_EUR, max(iif(tab.m_id<>-1, tab.Financing_Amount_EUR,null)) AS new_Financing_Amount_EUR, max(iif(tab.m_id=-1, tab.Financing_Reference_Rate,null)) AS old_Financing_Reference_Rate, max(iif(tab.m_id<>-1, tab.Financing_Reference_Rate,null)) AS new_Financing_Reference_Rate, max(iif(tab.m_id=-1, tab.Financing_Margin,null)) AS old_Financing_Margin, max(iif(tab.m_id<>-1, tab.Financing_Margin,null)) AS new_Financing_Margin, max(iif(tab.m_id=-1, tab.Financing_Rate,null)) AS old_Financing_Rate, max(iif(tab.m_id<>-1, tab.Financing_Rate,null)) AS new_Financing_Rate, tab.Financing_Start_Date, max(iif(tab.m_id=-1, tab.Financing_End_Date,null)) AS old_Financing_End_Date, max(iif(tab.m_id<>-1, tab.Financing_End_Date,null)) AS new_Financing_End_Date, max(iif(tab.m_id=-1, tab.Financing_Contract_Date,null)) AS old_Financing_Contract_Date, max(iif(tab.m_id<>-1, tab.Financing_Contract_Date,null)) AS new_Financing_Contract_Date, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM (((Asset_Financing AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Financing_Counterpart_ID) LEFT JOIN Nom_Financing_Type AS Nom_Financing_Type1 ON Nom_Financing_Type1.id=tab.Financing_Type_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies2 ON Nom_Currencies2.id=tab.Financing_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Financing_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, Nom_Financing_Type1.Financing_Type, tab.Financing_Start_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_History AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, tab.Rep_Date, max(iif(tab.m_id=-1, Nom_Asset_Status0.Asset_Status_Code,null)) AS old_Status_Code, max(iif(tab.m_id<>-1, Nom_Asset_Status0.Asset_Status_Code,null)) AS new_Status_Code, max(iif(tab.m_id=-1, tab.Inflows,null)) AS old_Inflows, max(iif(tab.m_id<>-1, tab.Inflows,null)) AS new_Inflows, max(iif(tab.m_id=-1, tab.CAPEX,null)) AS old_CAPEX, max(iif(tab.m_id<>-1, tab.CAPEX,null)) AS new_CAPEX, max(iif(tab.m_id=-1, tab.Depreciation,null)) AS old_Depreciation, max(iif(tab.m_id<>-1, tab.Depreciation,null)) AS new_Depreciation, max(iif(tab.m_id=-1, tab.Sales,null)) AS old_Sales, max(iif(tab.m_id<>-1, tab.Sales,null)) AS new_Sales, max(iif(tab.m_id=-1, tab.Imp_WB,null)) AS old_Imp_WB, max(iif(tab.m_id<>-1, tab.Imp_WB,null)) AS new_Imp_WB, max(iif(tab.m_id=-1, tab.Book_Value,null)) AS old_Book_Value, max(iif(tab.m_id<>-1, tab.Book_Value,null)) AS new_Book_Value, max(iif(tab.m_id=-1, tab.Costs,null)) AS old_Costs, max(iif(tab.m_id<>-1, tab.Costs,null)) AS new_Costs, max(iif(tab.m_id=-1, tab.Income,null)) AS old_Income, max(iif(tab.m_id<>-1, tab.Income,null)) AS new_Income, max(iif(tab.m_id=-1, tab.Expected_Exit,null)) AS old_Expected_Exit, max(iif(tab.m_id<>-1, tab.Expected_Exit,null)) AS new_Expected_Exit, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM (Asset_History AS tab LEFT JOIN Nom_Asset_Status AS Nom_Asset_Status0 ON Nom_Asset_Status0.id=tab.Status_Code) INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Insurances AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Insurance_Company_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Insurance_Company_ID, tab.Insurance_Start_Date, max(iif(tab.m_id=-1, tab.Insurance_End_Date,null)) AS old_Insurance_End_Date, max(iif(tab.m_id<>-1, tab.Insurance_End_Date,null)) AS new_Insurance_End_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Insurance_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Insurance_Currency_ID, max(iif(tab.m_id=-1, tab.Insurance_Amount_CCY,null)) AS old_Insurance_Amount_CCY, max(iif(tab.m_id<>-1, tab.Insurance_Amount_CCY,null)) AS new_Insurance_Amount_CCY, max(iif(tab.m_id=-1, tab.Insurance_Amount_EUR,null)) AS old_Insurance_Amount_EUR, max(iif(tab.m_id<>-1, tab.Insurance_Amount_EUR,null)) AS new_Insurance_Amount_EUR, max(iif(tab.m_id=-1, tab.Insurance_Premium_CCY,null)) AS old_Insurance_Premium_CCY, max(iif(tab.m_id<>-1, tab.Insurance_Premium_CCY,null)) AS new_Insurance_Premium_CCY, max(iif(tab.m_id=-1, tab.Insurance_Premium_EUR,null)) AS old_Insurance_Premium_EUR, max(iif(tab.m_id<>-1, tab.Insurance_Premium_EUR,null)) AS new_Insurance_Premium_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((Asset_Insurances AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Insurance_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Insurance_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Insurance_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Insurance_Start_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Rentals AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Rental_Counterpart_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Rental_Counterpart_ID, tab.Rental_Contract_Date, max(iif(tab.m_id=-1, tab.Rental_Start_Date,null)) AS old_Rental_Start_Date, max(iif(tab.m_id<>-1, tab.Rental_Start_Date,null)) AS new_Rental_Start_Date, max(iif(tab.m_id=-1, tab.Rental_End_Date,null)) AS old_Rental_End_Date, max(iif(tab.m_id<>-1, tab.Rental_End_Date,null)) AS new_Rental_End_Date, max(iif(tab.m_id=-1, tab.Rental_Payment_Date,null)) AS old_Rental_Payment_Date, max(iif(tab.m_id<>-1, tab.Rental_Payment_Date,null)) AS new_Rental_Payment_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Rental_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Rental_Currency_ID, max(iif(tab.m_id=-1, tab.Rental_Amount_CCY,null)) AS old_Rental_Amount_CCY, max(iif(tab.m_id<>-1, tab.Rental_Amount_CCY,null)) AS new_Rental_Amount_CCY, max(iif(tab.m_id=-1, tab.Rental_Amount_EUR,null)) AS old_Rental_Amount_EUR, max(iif(tab.m_id<>-1, tab.Rental_Amount_EUR,null)) AS new_Rental_Amount_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((Asset_Rentals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Rental_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Rental_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Rental_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rental_Contract_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Repossession AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, Nom_Currencies0.Currency_Code,null)) AS old_NPE_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies0.Currency_Code,null)) AS new_NPE_Currency_ID, max(iif(tab.m_id=-1, tab.NPE_Amount_CCY,null)) AS old_NPE_Amount_CCY, max(iif(tab.m_id<>-1, tab.NPE_Amount_CCY,null)) AS new_NPE_Amount_CCY, max(iif(tab.m_id=-1, tab.NPE_Amount_EUR,null)) AS old_NPE_Amount_EUR, max(iif(tab.m_id<>-1, tab.NPE_Amount_EUR,null)) AS new_NPE_Amount_EUR, max(iif(tab.m_id=-1, tab.LLP_Amount_CCY,null)) AS old_LLP_Amount_CCY, max(iif(tab.m_id<>-1, tab.LLP_Amount_CCY,null)) AS new_LLP_Amount_CCY, max(iif(tab.m_id=-1, tab.LLP_Amount_EUR,null)) AS old_LLP_Amount_EUR, max(iif(tab.m_id<>-1, tab.LLP_Amount_EUR,null)) AS new_LLP_Amount_EUR, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Purchase_Price_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Purchase_Price_Currency_ID, max(iif(tab.m_id=-1, tab.Appr_Purchase_Price_Net_CCY,null)) AS old_Appr_Purchase_Price_Net_CCY, max(iif(tab.m_id<>-1, tab.Appr_Purchase_Price_Net_CCY,null)) AS new_Appr_Purchase_Price_Net_CCY, max(iif(tab.m_id=-1, tab.Appr_Purchase_Price_Net_EUR,null)) AS old_Appr_Purchase_Price_Net_EUR, max(iif(tab.m_id<>-1, tab.Appr_Purchase_Price_Net_EUR,null)) AS new_Appr_Purchase_Price_Net_EUR, max(iif(tab.m_id=-1, tab.Purchase_Price_Net_CCY,null)) AS old_Purchase_Price_Net_CCY, max(iif(tab.m_id<>-1, tab.Purchase_Price_Net_CCY,null)) AS new_Purchase_Price_Net_CCY, max(iif(tab.m_id=-1, tab.Purchase_Price_Net_EUR,null)) AS old_Purchase_Price_Net_EUR, max(iif(tab.m_id<>-1, tab.Purchase_Price_Net_EUR,null)) AS new_Purchase_Price_Net_EUR, max(iif(tab.m_id=-1, tab.Purchase_Costs_CCY,null)) AS old_Purchase_Costs_CCY, max(iif(tab.m_id<>-1, tab.Purchase_Costs_CCY,null)) AS new_Purchase_Costs_CCY, max(iif(tab.m_id=-1, tab.Purchase_Costs_EUR,null)) AS old_Purchase_Costs_EUR, max(iif(tab.m_id<>-1, tab.Purchase_Costs_EUR,null)) AS new_Purchase_Costs_EUR, max(iif(tab.m_id=-1, tab.Planned_CAPEX_Currency_ID,null)) AS old_Planned_CAPEX_Currency_ID, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_Currency_ID,null)) AS new_Planned_CAPEX_Currency_ID, max(iif(tab.m_id=-1, tab.Planned_CAPEX_CCY,null)) AS old_Planned_CAPEX_CCY, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_CCY,null)) AS new_Planned_CAPEX_CCY, max(iif(tab.m_id=-1, tab.Planned_CAPEX_EUR,null)) AS old_Planned_CAPEX_EUR, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_EUR,null)) AS new_Planned_CAPEX_EUR, max(iif(tab.m_id=-1, tab.Planned_CAPEX_Comment,null)) AS old_Planned_CAPEX_Comment, max(iif(tab.m_id<>-1, tab.Planned_CAPEX_Comment,null)) AS new_Planned_CAPEX_Comment, tab.Purchase_Auction_Date, max(iif(tab.m_id=-1, tab.Purchase_Contract_Date,null)) AS old_Purchase_Contract_Date, max(iif(tab.m_id<>-1, tab.Purchase_Contract_Date,null)) AS new_Purchase_Contract_Date, max(iif(tab.m_id=-1, tab.Purchase_Repossession_Date,null)) AS old_Purchase_Repossession_Date, max(iif(tab.m_id<>-1, tab.Purchase_Repossession_Date,null)) AS new_Purchase_Repossession_Date, max(iif(tab.m_id=-1, tab.Purchase_Payment_Date,null)) AS old_Purchase_Payment_Date, max(iif(tab.m_id<>-1, tab.Purchase_Payment_Date,null)) AS new_Purchase_Payment_Date, max(iif(tab.m_id=-1, tab.Purchase_Handover_Date,null)) AS old_Purchase_Handover_Date, max(iif(tab.m_id<>-1, tab.Purchase_Handover_Date,null)) AS new_Purchase_Handover_Date, max(iif(tab.m_id=-1, tab.Purchase_Registration_Date,null)) AS old_Purchase_Registration_Date, max(iif(tab.m_id<>-1, tab.Purchase_Registration_Date,null)) AS new_Purchase_Registration_Date, max(iif(tab.m_id=-1, tab.Purchase_Local_Approval_Date,null)) AS old_Purchase_Local_Approval_Date, max(iif(tab.m_id<>-1, tab.Purchase_Local_Approval_Date,null)) AS new_Purchase_Local_Approval_Date, max(iif(tab.m_id=-1, tab.Purchase_Central_Approval_Date,null)) AS old_Purchase_Central_Approval_Date, max(iif(tab.m_id<>-1, tab.Purchase_Central_Approval_Date,null)) AS new_Purchase_Central_Approval_Date, max(iif(tab.m_id=-1, tab.Purchase_Prolongation_Date,null)) AS old_Purchase_Prolongation_Date, max(iif(tab.m_id<>-1, tab.Purchase_Prolongation_Date,null)) AS new_Purchase_Prolongation_Date, max(iif(tab.m_id=-1, tab.Purchase_Expected_Exit_Date,null)) AS old_Purchase_Expected_Exit_Date, max(iif(tab.m_id<>-1, tab.Purchase_Expected_Exit_Date,null)) AS new_Purchase_Expected_Exit_Date, max(iif(tab.m_id=-1, tab.Planned_OPEX_CCY,null)) AS old_Planned_OPEX_CCY, max(iif(tab.m_id<>-1, tab.Planned_OPEX_CCY,null)) AS new_Planned_OPEX_CCY, max(iif(tab.m_id=-1, tab.Planned_OPEX_EUR,null)) AS old_Planned_OPEX_EUR, max(iif(tab.m_id<>-1, tab.Planned_OPEX_EUR,null)) AS new_Planned_OPEX_EUR, max(iif(tab.m_id=-1, tab.Planned_OPEX_Comment,null)) AS old_Planned_OPEX_Comment, max(iif(tab.m_id<>-1, tab.Planned_OPEX_Comment,null)) AS new_Planned_OPEX_Comment, max(iif(tab.m_id=-1, tab.Planned_SalesPrice_CCY,null)) AS old_Planned_SalesPrice_CCY, max(iif(tab.m_id<>-1, tab.Planned_SalesPrice_CCY,null)) AS new_Planned_SalesPrice_CCY, max(iif(tab.m_id=-1, tab.Planned_SalesPrice_EUR,null)) AS old_Planned_SalesPrice_EUR, max(iif(tab.m_id<>-1, tab.Planned_SalesPrice_EUR,null)) AS new_Planned_SalesPrice_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((Asset_Repossession AS tab LEFT JOIN Nom_Currencies AS Nom_Currencies0 ON Nom_Currencies0.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Purchase_Price_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Repossession_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Purchase_Auction_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Asset_Sales AS
SELECT parent.Asset_Code, IIf(Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null)) Is Null,Max(parent.Asset_Name),Max(IIf(tab.m_id<>-1,parent.Asset_Name,Null))) AS Asset_Name, max(iif(tab.m_id=-1, vwCounterparts0.Descr,null)) AS old_Sale_Counterpart_ID, max(iif(tab.m_id<>-1, vwCounterparts0.Descr,null)) AS new_Sale_Counterpart_ID, tab.Sale_Approval_Date, max(iif(tab.m_id=-1, tab.Sale_Contract_Date,null)) AS old_Sale_Contract_Date, max(iif(tab.m_id<>-1, tab.Sale_Contract_Date,null)) AS new_Sale_Contract_Date, max(iif(tab.m_id=-1, tab.Sale_Transfer_Date,null)) AS old_Sale_Transfer_Date, max(iif(tab.m_id<>-1, tab.Sale_Transfer_Date,null)) AS new_Sale_Transfer_Date, max(iif(tab.m_id=-1, tab.Sale_Payment_Date,null)) AS old_Sale_Payment_Date, max(iif(tab.m_id<>-1, tab.Sale_Payment_Date,null)) AS new_Sale_Payment_Date, max(iif(tab.m_id=-1, tab.Sale_AML_Check_Date,null)) AS old_Sale_AML_Check_Date, max(iif(tab.m_id<>-1, tab.Sale_AML_Check_Date,null)) AS new_Sale_AML_Check_Date, max(iif(tab.m_id=-1, tab.Sale_AML_Pass_Date,null)) AS old_Sale_AML_Pass_Date, max(iif(tab.m_id<>-1, tab.Sale_AML_Pass_Date,null)) AS new_Sale_AML_Pass_Date, max(iif(tab.m_id=-1, Nom_Currencies1.Currency_Code,null)) AS old_Sale_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies1.Currency_Code,null)) AS new_Sale_Currency_ID, max(iif(tab.m_id=-1, tab.Sale_ApprovedAmt_CCY,null)) AS old_Sale_ApprovedAmt_CCY, max(iif(tab.m_id<>-1, tab.Sale_ApprovedAmt_CCY,null)) AS new_Sale_ApprovedAmt_CCY, max(iif(tab.m_id=-1, tab.Sale_ApprovedAmt_EUR,null)) AS old_Sale_ApprovedAmt_EUR, max(iif(tab.m_id<>-1, tab.Sale_ApprovedAmt_EUR,null)) AS new_Sale_ApprovedAmt_EUR, max(iif(tab.m_id=-1, tab.Sale_Amount_CCY,null)) AS old_Sale_Amount_CCY, max(iif(tab.m_id<>-1, tab.Sale_Amount_CCY,null)) AS new_Sale_Amount_CCY, max(iif(tab.m_id=-1, tab.Sale_Amount_EUR,null)) AS old_Sale_Amount_EUR, max(iif(tab.m_id<>-1, tab.Sale_Amount_EUR,null)) AS new_Sale_Amount_EUR, max(iif(tab.m_id=-1, tab.Sale_Book_Value_CCY,null)) AS old_Sale_Book_Value_CCY, max(iif(tab.m_id<>-1, tab.Sale_Book_Value_CCY,null)) AS new_Sale_Book_Value_CCY, max(iif(tab.m_id=-1, tab.Sale_Book_Value_EUR,null)) AS old_Sale_Book_Value_EUR, max(iif(tab.m_id<>-1, tab.Sale_Book_Value_EUR,null)) AS new_Sale_Book_Value_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((Asset_Sales AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Sale_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Sale_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Sale_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Sale_Approval_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Assets_List AS
SELECT tab.Asset_Code, max(iif(tab.m_id=-1, parent.NPE_Code,null)) AS old_NPE_Code, max(iif(tab.m_id<>-1, parent.NPE_Code,null)) AS new_NPE_Code, max(iif(tab.m_id=-1, tab.Asset_Name,null)) AS old_Asset_Name, max(iif(tab.m_id<>-1, tab.Asset_Name,null)) AS new_Asset_Name, max(iif(tab.m_id=-1, tab.Asset_Description,null)) AS old_Asset_Description, max(iif(tab.m_id<>-1, tab.Asset_Description,null)) AS new_Asset_Description, max(iif(tab.m_id=-1, tab.Asset_Address,null)) AS old_Asset_Address, max(iif(tab.m_id<>-1, tab.Asset_Address,null)) AS new_Asset_Address, max(iif(tab.m_id=-1, tab.Asset_ZIP,null)) AS old_Asset_ZIP, max(iif(tab.m_id<>-1, tab.Asset_ZIP,null)) AS new_Asset_ZIP, max(iif(tab.m_id=-1, tab.Asset_Region,null)) AS old_Asset_Region, max(iif(tab.m_id<>-1, tab.Asset_Region,null)) AS new_Asset_Region, max(iif(tab.m_id=-1, Nom_Countries0.Country_Name,null)) AS old_Asset_Country_ID, max(iif(tab.m_id<>-1, Nom_Countries0.Country_Name,null)) AS new_Asset_Country_ID, max(iif(tab.m_id=-1, Nom_Asset_Usage1.Asset_Usage_Text,null)) AS old_Asset_Usage_ID, max(iif(tab.m_id<>-1, Nom_Asset_Usage1.Asset_Usage_Text,null)) AS new_Asset_Usage_ID, max(iif(tab.m_id=-1, Nom_Asset_Type2.Asset_Type_Text,null)) AS old_Asset_Type_ID, max(iif(tab.m_id<>-1, Nom_Asset_Type2.Asset_Type_Text,null)) AS new_Asset_Type_ID, max(iif(tab.m_id=-1, tab.Asset_Usable_Area,null)) AS old_Asset_Usable_Area, max(iif(tab.m_id<>-1, tab.Asset_Usable_Area,null)) AS new_Asset_Usable_Area, max(iif(tab.m_id=-1, tab.Asset_Common_Area,null)) AS old_Asset_Common_Area, max(iif(tab.m_id<>-1, tab.Asset_Common_Area,null)) AS new_Asset_Common_Area, max(iif(tab.m_id=-1, Nom_Asset_Owned3.Asset_Owned,null)) AS old_Asset_Owned, max(iif(tab.m_id<>-1, Nom_Asset_Owned3.Asset_Owned,null)) AS new_Asset_Owned, max(iif(tab.m_id=-1, tab.Comment,null)) AS old_Comment, max(iif(tab.m_id<>-1, tab.Comment,null)) AS new_Comment, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((((Assets_List AS tab LEFT JOIN Nom_Countries AS Nom_Countries0 ON Nom_Countries0.id=tab.Asset_Country_ID) LEFT JOIN Nom_Asset_Usage AS Nom_Asset_Usage1 ON Nom_Asset_Usage1.id=tab.Asset_Usage_ID) LEFT JOIN Nom_Asset_Type AS Nom_Asset_Type2 ON Nom_Asset_Type2.id=tab.Asset_Type_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned3 ON Nom_Asset_Owned3.id=tab.Asset_Owned) INNER JOIN NPE_List AS parent ON parent.id=tab.Asset_NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.Asset_Code
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_Business_Cases AS
SELECT parent.NPE_Code, IIf(Max(IIf(tab.m_id<>-1,parent.NPE_Name,Null)) Is Null,Max(parent.NPE_Name),Max(IIf(tab.m_id<>-1,parent.NPE_Name,Null))) AS NPE_Name, tab.BC_Date, max(iif(tab.m_id=-1, tab.BC_Comment,null)) AS old_BC_Comment, max(iif(tab.m_id<>-1, tab.BC_Comment,null)) AS new_BC_Comment, max(iif(tab.m_id=-1, tab.BC_Purchase_Date,null)) AS old_BC_Purchase_Date, max(iif(tab.m_id<>-1, tab.BC_Purchase_Date,null)) AS new_BC_Purchase_Date, max(iif(tab.m_id=-1, tab.BC_Purchase_Price_EUR,null)) AS old_BC_Purchase_Price_EUR, max(iif(tab.m_id<>-1, tab.BC_Purchase_Price_EUR,null)) AS new_BC_Purchase_Price_EUR, max(iif(tab.m_id=-1, tab.Exp_CAPEX_EUR,null)) AS old_Exp_CAPEX_EUR, max(iif(tab.m_id<>-1, tab.Exp_CAPEX_EUR,null)) AS new_Exp_CAPEX_EUR, max(iif(tab.m_id=-1, tab.Exp_CAPEX_Time,null)) AS old_Exp_CAPEX_Time, max(iif(tab.m_id<>-1, tab.Exp_CAPEX_Time,null)) AS new_Exp_CAPEX_Time, max(iif(tab.m_id=-1, tab.Exp_Sale_Date,null)) AS old_Exp_Sale_Date, max(iif(tab.m_id<>-1, tab.Exp_Sale_Date,null)) AS new_Exp_Sale_Date, max(iif(tab.m_id=-1, tab.Exp_Sale_Price_EUR,null)) AS old_Exp_Sale_Price_EUR, max(iif(tab.m_id<>-1, tab.Exp_Sale_Price_EUR,null)) AS new_Exp_Sale_Price_EUR, max(iif(tab.m_id=-1, tab.Exp_Interest_EUR,null)) AS old_Exp_Interest_EUR, max(iif(tab.m_id<>-1, tab.Exp_Interest_EUR,null)) AS new_Exp_Interest_EUR, max(iif(tab.m_id=-1, tab.Exp_OPEX_EUR,null)) AS old_Exp_OPEX_EUR, max(iif(tab.m_id<>-1, tab.Exp_OPEX_EUR,null)) AS new_Exp_OPEX_EUR, max(iif(tab.m_id=-1, tab.Exp_Income_EUR,null)) AS old_Exp_Income_EUR, max(iif(tab.m_id<>-1, tab.Exp_Income_EUR,null)) AS new_Exp_Income_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM Business_Cases AS tab INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.BC_Date
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_NPE_History AS
SELECT parent.NPE_Code, IIf(Max(IIf(tab.m_id<>-1,parent.NPE_Name,Null)) Is Null,Max(parent.NPE_Name),Max(IIf(tab.m_id<>-1,parent.NPE_Name,Null))) AS NPE_Name, tab.Rep_Date, max(iif(tab.m_id=-1, Nom_NPE_Status0.NPE_Status_Code,null)) AS old_NPE_Status_ID, max(iif(tab.m_id<>-1, Nom_NPE_Status0.NPE_Status_Code,null)) AS new_NPE_Status_ID, Nom_Scenarios1.Scenario_Name AS NPE_Scenario_ID, max(iif(tab.m_id=-1, tab.NPE_Rep_Date,null)) AS old_NPE_Rep_Date, max(iif(tab.m_id<>-1, tab.NPE_Rep_Date,null)) AS new_NPE_Rep_Date, max(iif(tab.m_id=-1, tab.NPE_Currency,null)) AS old_NPE_Currency, max(iif(tab.m_id<>-1, tab.NPE_Currency,null)) AS new_NPE_Currency, max(iif(tab.m_id=-1, tab.NPE_Amount_CCY,null)) AS old_NPE_Amount_CCY, max(iif(tab.m_id<>-1, tab.NPE_Amount_CCY,null)) AS new_NPE_Amount_CCY, max(iif(tab.m_id=-1, tab.NPE_Amount_EUR,null)) AS old_NPE_Amount_EUR, max(iif(tab.m_id<>-1, tab.NPE_Amount_EUR,null)) AS new_NPE_Amount_EUR, max(iif(tab.m_id=-1, tab.LLP_Amount_CCY,null)) AS old_LLP_Amount_CCY, max(iif(tab.m_id<>-1, tab.LLP_Amount_CCY,null)) AS new_LLP_Amount_CCY, max(iif(tab.m_id=-1, tab.LLP_Amount_EUR,null)) AS old_LLP_Amount_EUR, max(iif(tab.m_id<>-1, tab.LLP_Amount_EUR,null)) AS new_LLP_Amount_EUR, max(iif(tab.m_id=-1, tab.Purchase_Price_CCY,null)) AS old_Purchase_Price_CCY, max(iif(tab.m_id<>-1, tab.Purchase_Price_CCY,null)) AS new_Purchase_Price_CCY, max(iif(tab.m_id=-1, tab.Purchase_Price_EUR,null)) AS old_Purchase_Price_EUR, max(iif(tab.m_id<>-1, tab.Purchase_Price_EUR,null)) AS new_Purchase_Price_EUR, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM ((NPE_History AS tab LEFT JOIN Nom_NPE_Status AS Nom_NPE_Status0 ON Nom_NPE_Status0.id=tab.NPE_Status_ID) LEFT JOIN Nom_Scenarios AS Nom_Scenarios1 ON Nom_Scenarios1.id=tab.NPE_Scenario_ID) INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.Rep_Date, Nom_Scenarios1.Scenario_Name
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE VIEW sel_NPE_List AS
SELECT tab.NPE_Code, max(iif(tab.m_id=-1, Nom_Scenarios0.Scenario_Name,null)) AS old_NPE_Scenario_ID, max(iif(tab.m_id<>-1, Nom_Scenarios0.Scenario_Name,null)) AS new_NPE_Scenario_ID, max(iif(tab.m_id=-1, Nom_Countries1.Country_Name,null)) AS old_NPE_Country_ID, max(iif(tab.m_id<>-1, Nom_Countries1.Country_Name,null)) AS new_NPE_Country_ID, max(iif(tab.m_id=-1, tab.NPE_Name,null)) AS old_NPE_Name, max(iif(tab.m_id<>-1, tab.NPE_Name,null)) AS new_NPE_Name, max(iif(tab.m_id=-1, tab.NPE_Description,null)) AS old_NPE_Description, max(iif(tab.m_id<>-1, tab.NPE_Description,null)) AS new_NPE_Description, max(iif(tab.m_id=-1, vwCounterparts2.Descr,null)) AS old_NPE_Lender_ID, max(iif(tab.m_id<>-1, vwCounterparts2.Descr,null)) AS new_NPE_Lender_ID, max(iif(tab.m_id=-1, vwCounterparts3.Descr,null)) AS old_NPE_Borrower_ID, max(iif(tab.m_id<>-1, vwCounterparts3.Descr,null)) AS new_NPE_Borrower_ID, max(iif(tab.m_id=-1, Nom_Currencies4.Currency_Code,null)) AS old_NPE_Currency_ID, max(iif(tab.m_id<>-1, Nom_Currencies4.Currency_Code,null)) AS new_NPE_Currency_ID, max(iif(tab.m_id=-1, tab.NPE_Amount_Date,null)) AS old_NPE_Amount_Date, max(iif(tab.m_id<>-1, tab.NPE_Amount_Date,null)) AS new_NPE_Amount_Date, max(iif(tab.m_id=-1, tab.NPE_Amount_CCY,null)) AS old_NPE_Amount_CCY, max(iif(tab.m_id<>-1, tab.NPE_Amount_CCY,null)) AS new_NPE_Amount_CCY, max(iif(tab.m_id=-1, tab.NPE_Amount_EUR,null)) AS old_NPE_Amount_EUR, max(iif(tab.m_id<>-1, tab.NPE_Amount_EUR,null)) AS new_NPE_Amount_EUR, max(iif(tab.m_id=-1, tab.LLP_Amount_CCY,null)) AS old_LLP_Amount_CCY, max(iif(tab.m_id<>-1, tab.LLP_Amount_CCY,null)) AS new_LLP_Amount_CCY, max(iif(tab.m_id=-1, tab.LLP_Amount_EUR,null)) AS old_LLP_Amount_EUR, max(iif(tab.m_id<>-1, tab.LLP_Amount_EUR,null)) AS new_LLP_Amount_EUR, max(iif(tab.m_id=-1, Nom_Asset_Owned5.Asset_Owned,null)) AS old_NPE_Owned, max(iif(tab.m_id<>-1, Nom_Asset_Owned5.Asset_Owned,null)) AS new_NPE_Owned, iif(min(tab.m_ID)>-1,"New","") AS Record_Status
FROM (((((NPE_List AS tab LEFT JOIN Nom_Scenarios AS Nom_Scenarios0 ON Nom_Scenarios0.id=tab.NPE_Scenario_ID) LEFT JOIN Nom_Countries AS Nom_Countries1 ON Nom_Countries1.id=tab.NPE_Country_ID) LEFT JOIN vwCounterparts AS vwCounterparts2 ON vwCounterparts2.id=tab.NPE_Lender_ID) LEFT JOIN vwCounterparts AS vwCounterparts3 ON vwCounterparts3.id=tab.NPE_Borrower_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies4 ON Nom_Currencies4.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned5 ON Nom_Asset_Owned5.id=tab.NPE_Owned
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.NPE_Code
HAVING max(tab.m_id)>-1;

-- 23.02.2018 17:38:56
CREATE function upd_Asset_Appraisals( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Appraisals AS dw_tab ON (dw_tab.Appraisal_Date=new_tab.Appraisal_Date) AND (dw_tab.Appraisal_Asset_ID=new_parent.id) SET dw_tab.Appraisal_Company_ID = iif(new_tab.Appraisal_Company_ID is null,dw_tab.Appraisal_Company_ID,new_tab.Appraisal_Company_ID), dw_tab.Appraisal_Currency_ID = iif(new_tab.Appraisal_Currency_ID is null,dw_tab.Appraisal_Currency_ID,new_tab.Appraisal_Currency_ID), dw_tab.Appraisal_Market_Value_CCY = iif(new_tab.Appraisal_Market_Value_CCY is null,dw_tab.Appraisal_Market_Value_CCY,new_tab.Appraisal_Market_Value_CCY), dw_tab.Appraisal_Market_Value_EUR = iif(new_tab.Appraisal_Market_Value_EUR is null,dw_tab.Appraisal_Market_Value_EUR,new_tab.Appraisal_Market_Value_EUR), dw_tab.Appraisal_Firesale_Value_CCY = iif(new_tab.Appraisal_Firesale_Value_CCY is null,dw_tab.Appraisal_Firesale_Value_CCY,new_tab.Appraisal_Firesale_Value_CCY), dw_tab.Appraisal_Firesale_Value_EUR = iif(new_tab.Appraisal_Firesale_Value_EUR is null,dw_tab.Appraisal_Firesale_Value_EUR,new_tab.Appraisal_Firesale_Value_EUR), dw_tab.Appraisal_Order = iif(new_tab.Appraisal_Order is null,dw_tab.Appraisal_Order,new_tab.Appraisal_Order)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_Financing( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Financing AS dw_tab ON (dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date) AND (dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID) AND (dw_tab.Financing_Asset_ID=new_parent.id) SET dw_tab.Financing_Contract_Code = iif(new_tab.Financing_Contract_Code is null,dw_tab.Financing_Contract_Code,new_tab.Financing_Contract_Code), dw_tab.Financing_Counterpart_ID = iif(new_tab.Financing_Counterpart_ID is null,dw_tab.Financing_Counterpart_ID,new_tab.Financing_Counterpart_ID), dw_tab.Financing_Currency_ID = iif(new_tab.Financing_Currency_ID is null,dw_tab.Financing_Currency_ID,new_tab.Financing_Currency_ID), dw_tab.Financing_Amount_CCY = iif(new_tab.Financing_Amount_CCY is null,dw_tab.Financing_Amount_CCY,new_tab.Financing_Amount_CCY), dw_tab.Financing_Amount_EUR = iif(new_tab.Financing_Amount_EUR is null,dw_tab.Financing_Amount_EUR,new_tab.Financing_Amount_EUR), dw_tab.Financing_Reference_Rate = iif(new_tab.Financing_Reference_Rate is null,dw_tab.Financing_Reference_Rate,new_tab.Financing_Reference_Rate), dw_tab.Financing_Margin = iif(new_tab.Financing_Margin is null,dw_tab.Financing_Margin,new_tab.Financing_Margin), dw_tab.Financing_Rate = iif(new_tab.Financing_Rate is null,dw_tab.Financing_Rate,new_tab.Financing_Rate), dw_tab.Financing_End_Date = iif(new_tab.Financing_End_Date is null,dw_tab.Financing_End_Date,new_tab.Financing_End_Date), dw_tab.Financing_Contract_Date = iif(new_tab.Financing_Contract_Date is null,dw_tab.Financing_Contract_Date,new_tab.Financing_Contract_Date)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_History( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_History AS dw_tab ON (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.Asset_ID=new_parent.id) SET dw_tab.Status_Code = iif(new_tab.Status_Code is null,dw_tab.Status_Code,new_tab.Status_Code), dw_tab.Inflows = iif(new_tab.Inflows is null,dw_tab.Inflows,new_tab.Inflows), dw_tab.CAPEX = iif(new_tab.CAPEX is null,dw_tab.CAPEX,new_tab.CAPEX), dw_tab.Depreciation = iif(new_tab.Depreciation is null,dw_tab.Depreciation,new_tab.Depreciation), dw_tab.Sales = iif(new_tab.Sales is null,dw_tab.Sales,new_tab.Sales), dw_tab.Imp_WB = iif(new_tab.Imp_WB is null,dw_tab.Imp_WB,new_tab.Imp_WB), dw_tab.Book_Value = iif(new_tab.Book_Value is null,dw_tab.Book_Value,new_tab.Book_Value), dw_tab.Costs = iif(new_tab.Costs is null,dw_tab.Costs,new_tab.Costs), dw_tab.Income = iif(new_tab.Income is null,dw_tab.Income,new_tab.Income), dw_tab.Expected_Exit = iif(new_tab.Expected_Exit is null,dw_tab.Expected_Exit,new_tab.Expected_Exit)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_Insurances( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Insurances AS dw_tab ON (dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date) AND (dw_tab.Insurance_Asset_ID=new_parent.id) SET dw_tab.Insurance_Company_ID = iif(new_tab.Insurance_Company_ID is null,dw_tab.Insurance_Company_ID,new_tab.Insurance_Company_ID), dw_tab.Insurance_End_Date = iif(new_tab.Insurance_End_Date is null,dw_tab.Insurance_End_Date,new_tab.Insurance_End_Date), dw_tab.Insurance_Currency_ID = iif(new_tab.Insurance_Currency_ID is null,dw_tab.Insurance_Currency_ID,new_tab.Insurance_Currency_ID), dw_tab.Insurance_Amount_CCY = iif(new_tab.Insurance_Amount_CCY is null,dw_tab.Insurance_Amount_CCY,new_tab.Insurance_Amount_CCY), dw_tab.Insurance_Amount_EUR = iif(new_tab.Insurance_Amount_EUR is null,dw_tab.Insurance_Amount_EUR,new_tab.Insurance_Amount_EUR), dw_tab.Insurance_Premium_CCY = iif(new_tab.Insurance_Premium_CCY is null,dw_tab.Insurance_Premium_CCY,new_tab.Insurance_Premium_CCY), dw_tab.Insurance_Premium_EUR = iif(new_tab.Insurance_Premium_EUR is null,dw_tab.Insurance_Premium_EUR,new_tab.Insurance_Premium_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_Rentals( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Rentals AS dw_tab ON (dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date) AND (dw_tab.Rental_Asset_ID=new_parent.id) SET dw_tab.Rental_Counterpart_ID = iif(new_tab.Rental_Counterpart_ID is null,dw_tab.Rental_Counterpart_ID,new_tab.Rental_Counterpart_ID), dw_tab.Rental_Start_Date = iif(new_tab.Rental_Start_Date is null,dw_tab.Rental_Start_Date,new_tab.Rental_Start_Date), dw_tab.Rental_End_Date = iif(new_tab.Rental_End_Date is null,dw_tab.Rental_End_Date,new_tab.Rental_End_Date), dw_tab.Rental_Payment_Date = iif(new_tab.Rental_Payment_Date is null,dw_tab.Rental_Payment_Date,new_tab.Rental_Payment_Date), dw_tab.Rental_Currency_ID = iif(new_tab.Rental_Currency_ID is null,dw_tab.Rental_Currency_ID,new_tab.Rental_Currency_ID), dw_tab.Rental_Amount_CCY = iif(new_tab.Rental_Amount_CCY is null,dw_tab.Rental_Amount_CCY,new_tab.Rental_Amount_CCY), dw_tab.Rental_Amount_EUR = iif(new_tab.Rental_Amount_EUR is null,dw_tab.Rental_Amount_EUR,new_tab.Rental_Amount_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_Repossession( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Repossession AS dw_tab ON (dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date) AND (dw_tab.Repossession_Asset_ID=new_parent.id) SET dw_tab.NPE_Currency_ID = iif(new_tab.NPE_Currency_ID is null,dw_tab.NPE_Currency_ID,new_tab.NPE_Currency_ID), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR), dw_tab.Purchase_Price_Currency_ID = iif(new_tab.Purchase_Price_Currency_ID is null,dw_tab.Purchase_Price_Currency_ID,new_tab.Purchase_Price_Currency_ID), dw_tab.Appr_Purchase_Price_Net_CCY = iif(new_tab.Appr_Purchase_Price_Net_CCY is null,dw_tab.Appr_Purchase_Price_Net_CCY,new_tab.Appr_Purchase_Price_Net_CCY), dw_tab.Appr_Purchase_Price_Net_EUR = iif(new_tab.Appr_Purchase_Price_Net_EUR is null,dw_tab.Appr_Purchase_Price_Net_EUR,new_tab.Appr_Purchase_Price_Net_EUR), dw_tab.Purchase_Price_Net_CCY = iif(new_tab.Purchase_Price_Net_CCY is null,dw_tab.Purchase_Price_Net_CCY,new_tab.Purchase_Price_Net_CCY), dw_tab.Purchase_Price_Net_EUR = iif(new_tab.Purchase_Price_Net_EUR is null,dw_tab.Purchase_Price_Net_EUR,new_tab.Purchase_Price_Net_EUR), dw_tab.Purchase_Costs_CCY = iif(new_tab.Purchase_Costs_CCY is null,dw_tab.Purchase_Costs_CCY,new_tab.Purchase_Costs_CCY), dw_tab.Purchase_Costs_EUR = iif(new_tab.Purchase_Costs_EUR is null,dw_tab.Purchase_Costs_EUR,new_tab.Purchase_Costs_EUR), dw_tab.Planned_CAPEX_Currency_ID = iif(new_tab.Planned_CAPEX_Currency_ID is null,dw_tab.Planned_CAPEX_Currency_ID,new_tab.Planned_CAPEX_Currency_ID), dw_tab.Planned_CAPEX_CCY = iif(new_tab.Planned_CAPEX_CCY is null,dw_tab.Planned_CAPEX_CCY,new_tab.Planned_CAPEX_CCY), dw_tab.Planned_CAPEX_EUR = iif(new_tab.Planned_CAPEX_EUR is null,dw_tab.Planned_CAPEX_EUR,new_tab.Planned_CAPEX_EUR), dw_tab.Planned_CAPEX_Comment = iif(new_tab.Planned_CAPEX_Comment is null,dw_tab.Planned_CAPEX_Comment,new_tab.Planned_CAPEX_Comment), dw_tab.Purchase_Contract_Date = iif(new_tab.Purchase_Contract_Date is null,dw_tab.Purchase_Contract_Date,new_tab.Purchase_Contract_Date), dw_tab.Purchase_Repossession_Date = iif(new_tab.Purchase_Repossession_Date is null,dw_tab.Purchase_Repossession_Date,new_tab.Purchase_Repossession_Date), dw_tab.Purchase_Payment_Date = iif(new_tab.Purchase_Payment_Date is null,dw_tab.Purchase_Payment_Date,new_tab.Purchase_Payment_Date), dw_tab.Purchase_Handover_Date = iif(new_tab.Purchase_Handover_Date is null,dw_tab.Purchase_Handover_Date,new_tab.Purchase_Handover_Date), dw_tab.Purchase_Registration_Date = iif(new_tab.Purchase_Registration_Date is null,dw_tab.Purchase_Registration_Date,new_tab.Purchase_Registration_Date), dw_tab.Purchase_Local_Approval_Date = iif(new_tab.Purchase_Local_Approval_Date is null,dw_tab.Purchase_Local_Approval_Date,new_tab.Purchase_Local_Approval_Date), dw_tab.Purchase_Central_Approval_Date = iif(new_tab.Purchase_Central_Approval_Date is null,dw_tab.Purchase_Central_Approval_Date,new_tab.Purchase_Central_Approval_Date), dw_tab.Purchase_Prolongation_Date = iif(new_tab.Purchase_Prolongation_Date is null,dw_tab.Purchase_Prolongation_Date,new_tab.Purchase_Prolongation_Date), dw_tab.Purchase_Expected_Exit_Date = iif(new_tab.Purchase_Expected_Exit_Date is null,dw_tab.Purchase_Expected_Exit_Date,new_tab.Purchase_Expected_Exit_Date), dw_tab.Planned_OPEX_CCY = iif(new_tab.Planned_OPEX_CCY is null,dw_tab.Planned_OPEX_CCY,new_tab.Planned_OPEX_CCY), dw_tab.Planned_OPEX_EUR = iif(new_tab.Planned_OPEX_EUR is null,dw_tab.Planned_OPEX_EUR,new_tab.Planned_OPEX_EUR), dw_tab.Planned_OPEX_Comment = iif(new_tab.Planned_OPEX_Comment is null,dw_tab.Planned_OPEX_Comment,new_tab.Planned_OPEX_Comment), dw_tab.Planned_SalesPrice_CCY = iif(new_tab.Planned_SalesPrice_CCY is null,dw_tab.Planned_SalesPrice_CCY,new_tab.Planned_SalesPrice_CCY), dw_tab.Planned_SalesPrice_EUR = iif(new_tab.Planned_SalesPrice_EUR is null,dw_tab.Planned_SalesPrice_EUR,new_tab.Planned_SalesPrice_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Asset_Sales( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code) INNER JOIN Asset_Sales AS dw_tab ON (dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date) AND (dw_tab.Sale_Asset_ID=new_parent.id) SET dw_tab.Sale_Counterpart_ID = iif(new_tab.Sale_Counterpart_ID is null,dw_tab.Sale_Counterpart_ID,new_tab.Sale_Counterpart_ID), dw_tab.Sale_Contract_Date = iif(new_tab.Sale_Contract_Date is null,dw_tab.Sale_Contract_Date,new_tab.Sale_Contract_Date), dw_tab.Sale_Transfer_Date = iif(new_tab.Sale_Transfer_Date is null,dw_tab.Sale_Transfer_Date,new_tab.Sale_Transfer_Date), dw_tab.Sale_Payment_Date = iif(new_tab.Sale_Payment_Date is null,dw_tab.Sale_Payment_Date,new_tab.Sale_Payment_Date), dw_tab.Sale_AML_Check_Date = iif(new_tab.Sale_AML_Check_Date is null,dw_tab.Sale_AML_Check_Date,new_tab.Sale_AML_Check_Date), dw_tab.Sale_AML_Pass_Date = iif(new_tab.Sale_AML_Pass_Date is null,dw_tab.Sale_AML_Pass_Date,new_tab.Sale_AML_Pass_Date), dw_tab.Sale_Currency_ID = iif(new_tab.Sale_Currency_ID is null,dw_tab.Sale_Currency_ID,new_tab.Sale_Currency_ID), dw_tab.Sale_ApprovedAmt_CCY = iif(new_tab.Sale_ApprovedAmt_CCY is null,dw_tab.Sale_ApprovedAmt_CCY,new_tab.Sale_ApprovedAmt_CCY), dw_tab.Sale_ApprovedAmt_EUR = iif(new_tab.Sale_ApprovedAmt_EUR is null,dw_tab.Sale_ApprovedAmt_EUR,new_tab.Sale_ApprovedAmt_EUR), dw_tab.Sale_Amount_CCY = iif(new_tab.Sale_Amount_CCY is null,dw_tab.Sale_Amount_CCY,new_tab.Sale_Amount_CCY), dw_tab.Sale_Amount_EUR = iif(new_tab.Sale_Amount_EUR is null,dw_tab.Sale_Amount_EUR,new_tab.Sale_Amount_EUR), dw_tab.Sale_Book_Value_CCY = iif(new_tab.Sale_Book_Value_CCY is null,dw_tab.Sale_Book_Value_CCY,new_tab.Sale_Book_Value_CCY), dw_tab.Sale_Book_Value_EUR = iif(new_tab.Sale_Book_Value_EUR is null,dw_tab.Sale_Book_Value_EUR,new_tab.Sale_Book_Value_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Assets_List( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN Assets_List AS dw_tab ON dw_tab.Asset_Code=new_tab.Asset_Code SET dw_tab.Asset_NPE_ID = new_tab.Asset_NPE_ID, dw_tab.Asset_Name = iif(new_tab.Asset_Name is null,dw_tab.Asset_Name,new_tab.Asset_Name), dw_tab.Asset_Description = iif(new_tab.Asset_Description is null,dw_tab.Asset_Description,new_tab.Asset_Description), dw_tab.Asset_Address = iif(new_tab.Asset_Address is null,dw_tab.Asset_Address,new_tab.Asset_Address), dw_tab.Asset_ZIP = iif(new_tab.Asset_ZIP is null,dw_tab.Asset_ZIP,new_tab.Asset_ZIP), dw_tab.Asset_Region = iif(new_tab.Asset_Region is null,dw_tab.Asset_Region,new_tab.Asset_Region), dw_tab.Asset_Country_ID = iif(new_tab.Asset_Country_ID is null,dw_tab.Asset_Country_ID,new_tab.Asset_Country_ID), dw_tab.Asset_Usage_ID = iif(new_tab.Asset_Usage_ID is null,dw_tab.Asset_Usage_ID,new_tab.Asset_Usage_ID), dw_tab.Asset_Type_ID = iif(new_tab.Asset_Type_ID is null,dw_tab.Asset_Type_ID,new_tab.Asset_Type_ID), dw_tab.Asset_Usable_Area = iif(new_tab.Asset_Usable_Area is null,dw_tab.Asset_Usable_Area,new_tab.Asset_Usable_Area), dw_tab.Asset_Common_Area = iif(new_tab.Asset_Common_Area is null,dw_tab.Asset_Common_Area,new_tab.Asset_Common_Area), dw_tab.Asset_Owned = iif(new_tab.Asset_Owned is null,dw_tab.Asset_Owned,new_tab.Asset_Owned), dw_tab.Comment = iif(new_tab.Comment is null,dw_tab.Comment,new_tab.Comment)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_Business_Cases( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((Business_Cases AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN Business_Cases AS dw_tab ON (dw_tab.BC_Date=new_tab.BC_Date) AND (dw_tab.NPE_ID=new_parent.id) SET dw_tab.BC_Comment = iif(new_tab.BC_Comment is null,dw_tab.BC_Comment,new_tab.BC_Comment), dw_tab.BC_Purchase_Date = iif(new_tab.BC_Purchase_Date is null,dw_tab.BC_Purchase_Date,new_tab.BC_Purchase_Date), dw_tab.BC_Purchase_Price_EUR = iif(new_tab.BC_Purchase_Price_EUR is null,dw_tab.BC_Purchase_Price_EUR,new_tab.BC_Purchase_Price_EUR), dw_tab.Exp_CAPEX_EUR = iif(new_tab.Exp_CAPEX_EUR is null,dw_tab.Exp_CAPEX_EUR,new_tab.Exp_CAPEX_EUR), dw_tab.Exp_CAPEX_Time = iif(new_tab.Exp_CAPEX_Time is null,dw_tab.Exp_CAPEX_Time,new_tab.Exp_CAPEX_Time), dw_tab.Exp_Sale_Date = iif(new_tab.Exp_Sale_Date is null,dw_tab.Exp_Sale_Date,new_tab.Exp_Sale_Date), dw_tab.Exp_Sale_Price_EUR = iif(new_tab.Exp_Sale_Price_EUR is null,dw_tab.Exp_Sale_Price_EUR,new_tab.Exp_Sale_Price_EUR), dw_tab.Exp_Interest_EUR = iif(new_tab.Exp_Interest_EUR is null,dw_tab.Exp_Interest_EUR,new_tab.Exp_Interest_EUR), dw_tab.Exp_OPEX_EUR = iif(new_tab.Exp_OPEX_EUR is null,dw_tab.Exp_OPEX_EUR,new_tab.Exp_OPEX_EUR), dw_tab.Exp_Income_EUR = iif(new_tab.Exp_Income_EUR is null,dw_tab.Exp_Income_EUR,new_tab.Exp_Income_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_NPE_History( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE ((NPE_History AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code) INNER JOIN NPE_History AS dw_tab ON (dw_tab.NPE_Scenario_ID=new_tab.NPE_Scenario_ID) AND (dw_tab.Rep_Date=new_tab.Rep_Date) AND (dw_tab.NPE_ID=new_parent.id) SET dw_tab.NPE_Status_ID = iif(new_tab.NPE_Status_ID is null,dw_tab.NPE_Status_ID,new_tab.NPE_Status_ID), dw_tab.NPE_Rep_Date = iif(new_tab.NPE_Rep_Date is null,dw_tab.NPE_Rep_Date,new_tab.NPE_Rep_Date), dw_tab.NPE_Currency = iif(new_tab.NPE_Currency is null,dw_tab.NPE_Currency,new_tab.NPE_Currency), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR), dw_tab.Purchase_Price_CCY = iif(new_tab.Purchase_Price_CCY is null,dw_tab.Purchase_Price_CCY,new_tab.Purchase_Price_CCY), dw_tab.Purchase_Price_EUR = iif(new_tab.Purchase_Price_EUR is null,dw_tab.Purchase_Price_EUR,new_tab.Purchase_Price_EUR)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1
 and new_parent.m_id=-1;

$$;
-- 23.02.2018 17:38:56
CREATE function upd_NPE_List( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE NPE_List AS new_tab INNER JOIN NPE_List AS dw_tab ON dw_tab.NPE_Code=new_tab.NPE_Code SET dw_tab.NPE_Scenario_ID = iif(new_tab.NPE_Scenario_ID is null,dw_tab.NPE_Scenario_ID,new_tab.NPE_Scenario_ID), dw_tab.NPE_Country_ID = iif(new_tab.NPE_Country_ID is null,dw_tab.NPE_Country_ID,new_tab.NPE_Country_ID), dw_tab.NPE_Name = iif(new_tab.NPE_Name is null,dw_tab.NPE_Name,new_tab.NPE_Name), dw_tab.NPE_Description = iif(new_tab.NPE_Description is null,dw_tab.NPE_Description,new_tab.NPE_Description), dw_tab.NPE_Lender_ID = iif(new_tab.NPE_Lender_ID is null,dw_tab.NPE_Lender_ID,new_tab.NPE_Lender_ID), dw_tab.NPE_Borrower_ID = iif(new_tab.NPE_Borrower_ID is null,dw_tab.NPE_Borrower_ID,new_tab.NPE_Borrower_ID), dw_tab.NPE_Currency_ID = iif(new_tab.NPE_Currency_ID is null,dw_tab.NPE_Currency_ID,new_tab.NPE_Currency_ID), dw_tab.NPE_Amount_Date = iif(new_tab.NPE_Amount_Date is null,dw_tab.NPE_Amount_Date,new_tab.NPE_Amount_Date), dw_tab.NPE_Amount_CCY = iif(new_tab.NPE_Amount_CCY is null,dw_tab.NPE_Amount_CCY,new_tab.NPE_Amount_CCY), dw_tab.NPE_Amount_EUR = iif(new_tab.NPE_Amount_EUR is null,dw_tab.NPE_Amount_EUR,new_tab.NPE_Amount_EUR), dw_tab.LLP_Amount_CCY = iif(new_tab.LLP_Amount_CCY is null,dw_tab.LLP_Amount_CCY,new_tab.LLP_Amount_CCY), dw_tab.LLP_Amount_EUR = iif(new_tab.LLP_Amount_EUR is null,dw_tab.LLP_Amount_EUR,new_tab.LLP_Amount_EUR), dw_tab.NPE_Owned = iif(new_tab.NPE_Owned is null,dw_tab.NPE_Owned,new_tab.NPE_Owned)
WHERE new_tab.m_id = p_m_ID and dw_tab.m_id=-1;

$$;
-- 19.02.2018 09:01:13
CREATE function upd_old_Linked_Mails_Reject( p_m_ID varchar) RETURNS void LANGUAGE 'sql' AS $$
UPDATE Mail_Log SET Mail_Log.mailStatus = 3
WHERE (((Mail_Log.ID) In (select old_m_id from vw_old_linked_mails)));

$$;
-- 23.02.2018 12:04:45
CREATE VIEW vw_Appr_Periods AS
SELECT Assets_List.ID, Switch(IIf(IsNull(book_value),IIf(IsNull(Asset_Repossession.Purchase_Price_Net_EUR),2000000,Asset_Repossession.Purchase_Price_Net_EUR),book_value)<1000000,36,IIf(IsNull(book_value),IIf(IsNull(Asset_Repossession.Purchase_Price_Net_EUR),2000000,Asset_Repossession.Purchase_Price_Net_EUR),book_value)<1500000,24,1,12) AS AppraisalPeriod
FROM NPE_List INNER JOIN ((Assets_List LEFT JOIN (Asset_History LEFT JOIN LastDate ON Asset_History.Rep_Date = LastDate.CurrMonth) ON Assets_List.ID = Asset_History.Asset_ID) LEFT JOIN Asset_Repossession ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1))
GROUP BY Assets_List.ID, Switch(IIf(IsNull(book_value),IIf(IsNull(Asset_Repossession.Purchase_Price_Net_EUR),2000000,Asset_Repossession.Purchase_Price_Net_EUR),book_value)<1000000,36,IIf(IsNull(book_value),IIf(IsNull(Asset_Repossession.Purchase_Price_Net_EUR),2000000,Asset_Repossession.Purchase_Price_Net_EUR),book_value)<1500000,24,1,12);

-- 23.02.2018 12:04:45
CREATE VIEW vw_Asset_Appraisals AS
SELECT Asset_Appraisals.*
FROM Asset_Appraisals
WHERE (((IIf(IsNull(Appraisal_Market_Value_CCY),0,Appraisal_Market_Value_CCY)+IIf(IsNull(Appraisal_Market_Value_EUR),0,Appraisal_Market_Value_EUR)+IIf(IsNull(Appraisal_Firesale_Value_CCY),0,Appraisal_Firesale_Value_CCY)+IIf(IsNull(Appraisal_Firesale_Value_EUR),0,Appraisal_Firesale_Value_EUR))<>0) AND ((Asset_Appraisals.m_ID)=-1));

-- 23.02.2018 19:00:39
CREATE VIEW vw_CountryLE AS
SELECT Nom_Countries.MIS_Code, Tagetik_Code & "p_" & le_name AS Rep_LE
FROM Nom_Countries INNER JOIN Legal_Entities ON Nom_Countries.ID = Legal_Entities.LE_Country_ID
WHERE (((Legal_Entities.Active)=1));

-- 09.02.2018 15:58:36
CREATE VIEW vw_LE_Sender AS
SELECT Users.FullName, legal_entities.Tagetik_Code, Mail_Log.ID
FROM legal_entities INNER JOIN (Mail_Log INNER JOIN Users ON Mail_Log.Sender = Users.EMail) ON legal_entities.ID = Users.LE_ID;

-- 23.02.2018 18:13:34
CREATE VIEW vw_LEs AS
SELECT Legal_Entities.ID, "(" & country_code & ") " & tagetik_code & " - " & le_name AS Text
FROM Legal_Entities LEFT JOIN Nom_Countries ON Legal_Entities.LE_Country_ID = Nom_Countries.ID;

-- 19.02.2018 08:57:20
CREATE VIEW vw_Mail_auth_sender AS
SELECT vw_Mail_Objects.Object_Code
FROM vw_Mail_Objects
WHERE (((vw_Mail_Objects.m_ID)=p_m_ID) AND ((Not Exists (select country_code from vwUserCountry where country_code = object_country and email=p_mSender))=True))
GROUP BY vw_Mail_Objects.Object_Code;

-- 19.02.2018 08:52:55
CREATE VIEW vw_Mail_Countries AS
SELECT Users.EMail, Nom_Countries.MIS_Code
FROM Nom_Countries INNER JOIN (Legal_Entities INNER JOIN Users ON Legal_Entities.ID = Users.LE_ID) ON Nom_Countries.ID = Legal_Entities.LE_Country_ID
GROUP BY Users.EMail, Nom_Countries.MIS_Code;

-- 19.02.2018 08:57:20
CREATE VIEW vw_Mail_Objects AS
SELECT NPE_Code as Object_Code, Left(NPE_Code,2) as Object_Country, m_ID from NPE_List
UNION ALL SELECT Asset_Code as Object_Code, left(Asset_Code,2) as Object_Country, m_ID from Assets_List;

-- 23.02.2018 13:25:45
CREATE VIEW vw_Mail_Roles AS
SELECT vw_Mail_Objects.m_ID, vwUserCountry.EMail, vwUserCountry.Role
FROM vw_Mail_Objects INNER JOIN vwUserCountry ON vw_Mail_Objects.Object_Country = vwUserCountry.Country_Code
GROUP BY vw_Mail_Objects.m_ID, vwUserCountry.EMail, vwUserCountry.Role;

-- 21.02.2018 09:37:28
CREATE VIEW vw_NPE_Pipeline AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Max(Nom_NPE_Status.NPE_Status_Text) AS Status, Max(IIf(npe_history.npe_scenario_id=11,npe_history.npe_rep_date,Null)) AS FC_Rep_Date, NPE_History.NPE_Currency, Sum(IIf(npe_history.npe_scenario_id=11,npe_history.npe_amount_ccy,0)) AS FC_NPE_CCY, Sum(IIf(npe_history.npe_scenario_id=11,npe_history.npe_amount_eur,0)) AS FC_NPE_EUR, NPE_List.NPE_Scenario_ID, Sum(IIf(npe_history.npe_scenario_id=2,npe_history.npe_amount_eur,0)) AS MYP_Original, Sum(IIf(npe_history.npe_scenario_id=3,npe_history.npe_amount_eur,0)) AS MYP_Update, Sum(IIf(npe_history.npe_scenario_id=6,npe_history.npe_amount_eur,0)) AS Actual
FROM NPE_List INNER JOIN (Nom_NPE_Status RIGHT JOIN NPE_History ON Nom_NPE_Status.ID = NPE_History.NPE_Status_ID) ON NPE_List.ID = NPE_History.NPE_ID
WHERE (((NPE_History.Rep_Date) In (select prevmonth from lastDate)) AND ((NPE_History.m_ID)=-1) AND ((NPE_History.NPE_Scenario_ID) In (2,3,6,11)))
GROUP BY NPE_List.NPE_Code, NPE_List.NPE_Name, NPE_History.NPE_Currency, NPE_List.NPE_Scenario_ID
HAVING (((Max(Nom_NPE_Status.NPE_Status_Text)) In ("Approved","Pipeline")));

-- 05.02.2018 17:42:57
CREATE VIEW vw_NPE_Shifts AS
SELECT inn.rep_year, Sum(inn.baseNpe) AS Base_NPE, Sum(inn.compNpe) AS Comp_NPE, Sum(inn.ShiftNPE) AS Shift_NPE, Comp_NPE-Base_NPE-Shift_NPE AS New_NPE, Comp_NPE-Base_NPE AS Delta_NPE
FROM (SELECT iif(ver="Original",Year(NPE_Rep_Date),(select iif(ver="ShiftedTo",year(s.npe_rep_date),p_base_year) as shift_year from npe_history s where s.npe_scenario_id=p_comp_scenario and year(s.npe_rep_date)<>p_base_year and s.npe_id=npe_history.npe_id)) AS Rep_Year, (IIf(npe_scenario_id=p_base_scenario And ver="Original",npe_amount_eur,0)) AS BaseNPE, (IIf(npe_scenario_id=p_comp_scenario And ver="Original",npe_amount_eur,0)) AS CompNPE, (IIf(npe_scenario_id=p_base_scenario And ver<>"Original",npe_amount_eur*Sign,0)) AS ShiftNPE, ver, npe_id FROM NPE_History, Orig_Shifted WHERE (((NPE_History.NPE_Scenario_ID) In (p_base_scenario,p_comp_scenario)) And ((NPE_History.NPE_Amount_EUR)<>0)) And Not (npe_scenario_id=p_base_scenario And ver<>"Original" And year(npe_rep_date)<>p_base_year))  AS inn
WHERE (((inn.rep_year) Is Not Null))
GROUP BY inn.rep_year;

-- 19.02.2018 09:48:33
CREATE VIEW vw_old_Linked_Mails AS
SELECT vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID AS old_m_ID
FROM vw_Mail_Objects INNER JOIN vw_Mail_Objects AS vw_Mail_Objects_1 ON vw_Mail_Objects.Object_Code = vw_Mail_Objects_1.Object_Code
WHERE (((vw_Mail_Objects.m_ID)<>-1) And ((vw_Mail_Objects_1.m_ID)<>vw_Mail_Objects.m_ID And (vw_Mail_Objects_1.m_ID)<>-1) And ((vw_Mail_Objects.m_ID)=p_m_ID))
GROUP BY vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID;

-- 23.02.2018 12:04:45
CREATE VIEW vw_sh_Appraisals AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Switch(appraisal_asset_id Is Null,"No Appraisal",(select currMonth from lastdate) Not Between IIf(IsNull(appraisal_date),DateSerial(2000,1,1),Appraisal_Date) And DateAdd("m",appraisalPeriod,IIf(IsNull(appraisal_date),DateSerial(2000,1,1),Appraisal_Date)),"Appraisal expired or not yet valid",Appraisal_Market_Value_EUR=0,"Appraisal value is 0",1,"OK") AS Appraisal_Status, Counterparts.Counterpart_Common_Name AS Appraisal_Company, Asset_Appraisals.Appraisal_Date, Nom_Currencies.Currency_Code, Asset_Appraisals.Appraisal_Market_Value_CCY, Asset_Appraisals.Appraisal_Market_Value_EUR, Asset_Appraisals.Appraisal_Firesale_Value_CCY, Asset_Appraisals.Appraisal_Firesale_Value_EUR
FROM NPE_List INNER JOIN (((vw_Appr_Periods RIGHT JOIN Assets_List ON vw_Appr_Periods.ID = Assets_List.ID) LEFT JOIN (Counterparts RIGHT JOIN (vw_Asset_Appraisals AS Asset_Appraisals LEFT JOIN Nom_Currencies ON Asset_Appraisals.Appraisal_Currency_ID = Nom_Currencies.ID) ON Counterparts.ID = Asset_Appraisals.Appraisal_Company_ID) ON Assets_List.ID = Asset_Appraisals.Appraisal_Asset_ID) INNER JOIN (LastDate INNER JOIN Asset_History ON LastDate.PrevMonth = Asset_History.Rep_Date) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1) AND ((Asset_History.Book_Value)<>0));

-- 05.02.2018 17:58:26
CREATE VIEW vw_sh_Asset_Info AS
SELECT NPE_List.NPE_Code, Assets_List.Asset_Code, Assets_List.Asset_Name, Assets_List.Asset_Description, Nom_Asset_Owned.Asset_Owned, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Nom_Countries.Country_Name, Nom_Asset_Usage.Asset_Usage_Text, Nom_Asset_Type.Asset_Type_Text, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Comment
FROM NPE_List INNER JOIN (Nom_Countries RIGHT JOIN (Nom_Asset_Usage RIGHT JOIN (Nom_Asset_Type RIGHT JOIN (Assets_List LEFT JOIN Nom_Asset_Owned ON Assets_List.Asset_Owned = Nom_Asset_Owned.ID) ON Nom_Asset_Type.ID = Assets_List.Asset_Type_ID) ON Nom_Asset_Usage.ID = Assets_List.Asset_Usage_ID) ON Nom_Countries.ID = Assets_List.Asset_Country_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Assets_List.m_ID)=-1));

-- 09.02.2018 15:58:46
CREATE VIEW vw_sh_Asset_Status AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Asset_History.Status_Code, Asset_History.Book_Value
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (LastDate INNER JOIN Asset_History ON LastDate.PrevMonth = Asset_History.Rep_Date) ON Assets_List.ID = Asset_History.Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_History.m_ID)=-1));

-- 09.02.2018 15:30:32
CREATE VIEW vw_sh_Business_Cases AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Business_Cases.BC_Date, Business_Cases.BC_Comment, Business_Cases.BC_Purchase_Date, Business_Cases.BC_Purchase_Price_EUR, Business_Cases.Exp_CAPEX_EUR, Business_Cases.Exp_CAPEX_Time, Business_Cases.Exp_Sale_Date, Business_Cases.Exp_Sale_Price_EUR, Business_Cases.Exp_Interest_EUR, Business_Cases.Exp_OPEX_EUR, Business_Cases.Exp_Income_EUR
FROM NPE_List INNER JOIN Business_Cases ON NPE_List.ID = Business_Cases.NPE_ID
WHERE (((Business_Cases.m_ID)=-1));

-- 09.02.2018 15:58:51
CREATE VIEW vw_sh_Financing AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, vwCounterparts.Descr AS Lender, Asset_Financing.Financing_Contract_Code, Nom_Financing_Type.Financing_Type, Nom_Currencies.Currency_Code, Asset_Financing.Financing_Amount_CCY, Asset_Financing.Financing_Amount_EUR, Asset_Financing.Financing_Reference_Rate, Asset_Financing.Financing_Margin, Asset_Financing.Financing_Rate, Asset_Financing.Financing_Contract_Date, Asset_Financing.Financing_Start_Date, Asset_Financing.Financing_End_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (((Asset_Financing LEFT JOIN Nom_Currencies ON Asset_Financing.Financing_Currency_ID = Nom_Currencies.ID) LEFT JOIN Nom_Financing_Type ON Asset_Financing.Financing_Type_ID = Nom_Financing_Type.ID) LEFT JOIN vwCounterparts ON Asset_Financing.Financing_Counterpart_ID = vwCounterparts.ID) ON Assets_List.ID = Asset_Financing.Financing_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Financing.m_ID)=-1));

-- 01.02.2018 15:00:01
CREATE VIEW vw_sh_Insurances AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, IIf(Asset_Insurances.ID Is Null,"No Insurance",IIf(Date() Not Between IIf(IsNull(Insurance_Start_Date),DateSerial(2000,1,1),Insurance_Start_Date) And IIf(IsNull(Insurance_End_Date),DateSerial(2000,1,1),Insurance_End_Date),"Expired insurance",IIf(Insurance_Amount_EUR<=0,"Invalid insurance amount in EUR"))) AS Insurance_Status, Counterparts.counterpart_common_name AS Insurance_Company, Asset_Insurances.Insurance_Start_Date, Asset_Insurances.Insurance_End_Date, Nom_Currencies.Currency_Code, Asset_Insurances.Insurance_Amount_CCY, Asset_Insurances.Insurance_Amount_EUR, Asset_Insurances.Insurance_Premium_CCY, Asset_Insurances.Insurance_Premium_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Insurances LEFT JOIN Nom_Currencies ON Asset_Insurances.Insurance_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Insurances.Insurance_Company_ID = Counterparts.ID) ON Assets_List.ID = Asset_Insurances.Insurance_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Insurances.m_ID)=-1));

-- 19.02.2018 08:43:59
CREATE VIEW vw_sh_NPEs_Identified AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, NPE_List.NPE_Description, Nom_Countries.Country_Name, Lender.Descr AS Lender, Borrower.Descr AS Borrower, NPE_List.NPE_Amount_Date, Nom_Currencies.Currency_Code, NPE_List.NPE_Amount_CCY, NPE_List.NPE_Amount_EUR, NPE_List.LLP_Amount_CCY, NPE_List.LLP_Amount_EUR
FROM Nom_Countries RIGHT JOIN (Nom_Currencies RIGHT JOIN ((NPE_List LEFT JOIN vwCounterparts AS Lender ON NPE_List.NPE_Lender_ID = Lender.ID) LEFT JOIN vwCounterparts AS Borrower ON NPE_List.NPE_Borrower_ID = Borrower.ID) ON Nom_Currencies.ID = NPE_List.NPE_Currency_ID) ON Nom_Countries.ID = NPE_List.NPE_Country_ID
WHERE (((NPE_List.m_ID)=-1));

-- 01.02.2018 14:27:56
CREATE VIEW vw_sh_Rentals AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, IIf(Asset_Rentals.ID Is Null,"No Tenant",Counterpart_Common_Name) AS Tenant, Asset_Rentals.Rental_Contract_Date, Asset_Rentals.Rental_Start_Date, Asset_Rentals.Rental_End_Date, Asset_Rentals.Rental_Payment_Date, Nom_Currencies.Currency_Code, Asset_Rentals.Rental_Amount_CCY, Asset_Rentals.Rental_Amount_EUR
FROM NPE_List INNER JOIN (Assets_List LEFT JOIN ((Asset_Rentals LEFT JOIN Counterparts ON Asset_Rentals.Rental_Counterpart_ID = Counterparts.ID) LEFT JOIN Nom_Currencies ON Asset_Rentals.Rental_Currency_ID = Nom_Currencies.ID) ON Assets_List.ID = Asset_Rentals.Rental_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Rentals.m_ID)=-1));

-- 06.02.2018 18:51:51
CREATE VIEW vw_sh_Repossessions AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Asset_Repossession.Purchase_Auction_Date, Asset_Repossession.Purchase_Contract_Date, Asset_Repossession.Purchase_Handover_Date, Asset_Repossession.Purchase_Payment_Date, Purchase_Currency.Currency_Code, Asset_Repossession.Appr_Purchase_Price_Net_CCY, Asset_Repossession.Appr_Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Price_Net_CCY, Asset_Repossession.Purchase_Price_Net_EUR, Asset_Repossession.Purchase_Costs_CCY, Asset_Repossession.Purchase_Costs_EUR, Asset_Repossession.Planned_CAPEX_CCY, Asset_Repossession.Planned_CAPEX_EUR, Asset_Repossession.Planned_CAPEX_Comment, Asset_Repossession.Planned_OPEX_CCY, Asset_Repossession.Planned_OPEX_EUR, Asset_Repossession.Planned_OPEX_Comment, Asset_Repossession.Planned_SalesPrice_CCY, Asset_Repossession.Planned_SalesPrice_EUR
FROM NPE_List INNER JOIN (Assets_List INNER JOIN (Nom_Currencies AS Purchase_Currency RIGHT JOIN (Asset_Repossession LEFT JOIN Nom_Currencies AS NPE_Currency ON Asset_Repossession.NPE_Currency_ID = NPE_Currency.ID) ON Purchase_Currency.ID = Asset_Repossession.Purchase_Price_Currency_ID) ON Assets_List.ID = Asset_Repossession.Repossession_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Repossession.m_ID)=-1));

-- 01.02.2018 14:27:13
CREATE VIEW vw_sh_Sales AS
SELECT NPE_List.NPE_Code, NPE_List.NPE_Name, Assets_List.Asset_Code, Assets_List.Asset_Name, Counterparts.counterpart_common_name AS Buyer, Asset_Sales.Sale_Approval_Date, Asset_Sales.Sale_Contract_Date, Asset_Sales.Sale_Transfer_Date, Asset_Sales.Sale_Payment_Date, Nom_Currencies.Currency_Code, Asset_Sales.Sale_ApprovedAmt_CCY, Asset_Sales.Sale_ApprovedAmt_EUR, Asset_Sales.Sale_Amount_CCY, Asset_Sales.Sale_Amount_EUR, Asset_Sales.Sale_Book_Value_CCY, Asset_Sales.Sale_Book_Value_EUR, Asset_Sales.Sale_AML_Check_Date, Asset_Sales.Sale_AML_Pass_Date
FROM NPE_List INNER JOIN (Assets_List INNER JOIN ((Asset_Sales LEFT JOIN Nom_Currencies ON Asset_Sales.Sale_Currency_ID = Nom_Currencies.ID) LEFT JOIN Counterparts ON Asset_Sales.Sale_Counterpart_ID = Counterparts.ID) ON Assets_List.ID = Asset_Sales.Sale_Asset_ID) ON NPE_List.ID = Assets_List.Asset_NPE_ID
WHERE (((Asset_Sales.m_ID)=-1));

-- 29.12.2017 09:51:44
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

-- 29.12.2017 10:02:44
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

-- 23.02.2018 15:59:00
CREATE VIEW vwCounterparts AS
SELECT Counterparts.ID, Trim(Counterpart_Type & " " & Counterpart_First_Name & " " & counterpart_Last_Name & " " & Counterpart_Company_Name) AS Descr
FROM Counterparts;

-- 19.02.2018 08:41:44
CREATE VIEW vwFileRights AS
SELECT File_Log.m_ID, Mail_Log.Sender, File_Log.fileName, Legal_Entities.Tagetik_Code, Legal_Entities.LE_Name, File_Log.repLE
FROM File_Log INNER JOIN (Mail_Log LEFT JOIN (Users LEFT JOIN Legal_Entities ON Users.le_id = Legal_Entities.id) ON Mail_Log.Sender = Users.EMail) ON File_Log.m_ID = Mail_Log.ID
WHERE (((Legal_Entities.Tagetik_Code)=IIf(IsNull(RepLE),Tagetik_Code,RepLE)));

-- 23.02.2018 13:25:45
CREATE VIEW vwUserCountry AS
SELECT Users.EMail, Nom_Countries.MIS_Code AS Country_Code, Users.Role
FROM Nom_Countries RIGHT JOIN (Legal_Entities INNER JOIN Users ON Legal_Entities.ID = Users.LE_ID) ON Nom_Countries.ID = Legal_Entities.LE_Country_ID;

