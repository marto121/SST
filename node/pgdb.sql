--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = public, pg_catalog;

--
-- Name: del_asset_financials(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION del_asset_financials(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Financials
WHERE m_id=-1
 and Asset_ID in (select old_parent.id from (Asset_Financials as new_tab0 inner join Assets_List new_parent on new_parent.id=new_tab0.Asset_ID) inner join Assets_List old_parent on new_parent.Asset_Code=old_parent.Asset_Code where new_tab0.m_ID=p_m_ID)
 and Rep_Date in (select new_tab1.Rep_Date from Asset_Financials as new_tab1 where new_tab1.m_id=p_m_ID);

$$;


ALTER FUNCTION public.del_asset_financials(p_m_id integer) OWNER TO postgres;

--
-- Name: delassetappraisals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delassetappraisals() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Appraisals;

$$;


ALTER FUNCTION public.delassetappraisals() OWNER TO postgres;

--
-- Name: delassetfinancing(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delassetfinancing() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Financing;

$$;


ALTER FUNCTION public.delassetfinancing() OWNER TO postgres;

--
-- Name: delassetinsurances(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delassetinsurances() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Insurances;

$$;


ALTER FUNCTION public.delassetinsurances() OWNER TO postgres;

--
-- Name: delemptyappraisals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delemptyappraisals() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Appraisals
WHERE (((Asset_Appraisals.Appraisal_Date) Is Null) AND ((Asset_Appraisals.Appraisal_Market_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Market_Value_EUR)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_CCY)=0) AND ((Asset_Appraisals.Appraisal_Firesale_Value_EUR)=0));

$$;


ALTER FUNCTION public.delemptyappraisals() OWNER TO postgres;

--
-- Name: delemptyfinancing(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delemptyfinancing() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Financing
WHERE (((Asset_Financing.Financing_Amount_CCY)=0) AND ((Asset_Financing.Financing_Amount_EUR)=0) AND ((Asset_Financing.Financing_Start_Date) Is Null) AND ((Asset_Financing.Financing_End_Date) Is Null));

$$;


ALTER FUNCTION public.delemptyfinancing() OWNER TO postgres;

--
-- Name: delemptyinsurances(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delemptyinsurances() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Insurances
WHERE (((Asset_Insurances.Insurance_Amount_CCY)=0) AND ((Asset_Insurances.Insurance_Amount_EUR)=0) AND ((Asset_Insurances.Insurance_Premium_CCY)=0) AND ((Asset_Insurances.Insurance_Premium_EUR)=0) AND ((Asset_Insurances.Insurance_Start_Date)='2000-1-1') AND ((Asset_Insurances.Insurance_End_Date) Is Null));

$$;


ALTER FUNCTION public.delemptyinsurances() OWNER TO postgres;

--
-- Name: delemptyrentals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delemptyrentals() RETURNS void
    LANGUAGE sql
    AS $$
DELETE FROM Asset_Rentals
WHERE (((Asset_Rentals.Rental_Amount_CCY)=0) AND ((Asset_Rentals.Rental_Amount_EUR)=0) AND ((Asset_Rentals.Rental_Contract_Date)='2000-1-1') AND ((Asset_Rentals.Rental_Start_Date) Is Null) AND ((Asset_Rentals.Rental_End_Date) Is Null));

$$;


ALTER FUNCTION public.delemptyrentals() OWNER TO postgres;

--
-- Name: fn_confirmmessage(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_confirmmessage(confirm_m_id integer, log_m_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	rMsg RECORD;
	lMUT RECORD;
	rc integer;
	msg sst_log.log_text%type;
	mSender mail_log.sender%type;
	authObjects cursor for select object_code from vw_mail_auth_sender(mSender, confirm_m_ID);
	objCode character varying;
	tLog constant integer:=1;
	tErr constant integer:=3;
begin
	select Sender into mSender from Mail_Log where ID = log_m_id;
	select mailStatus, Sender, ID into rMsg from Mail_Log where ID = confirm_m_ID;
	IF NOT FOUND THEN
		perform logMessage(text'confirmMessage', 'Message with ID ' || confirm_m_ID || ' does not exist!', tErr, log_m_ID);
		RETURN 0;
	END IF;
	IF rMsg.mailStatus <> (select id from vw_nom_mail_status where name='[processed]') THEN
		perform logMessage(text'confirmMessage', 'Message with ID ' || confirm_m_ID || ' has status ' || (select name from vw_nom_mail_status where id = rMsg.mailStatus) || ' and cannot be confirmed anymore.', tErr, log_m_ID);
		raise notice 'Executing 1Check Name %s %s', rMsg.Sender, mSender;
		RETURN 0;
	END IF;
	IF rMsg.Sender = mSender and lower(rMsg.sender)<>'mkrastev.external@unicredit.eu' THEN
		perform logMessage(text'confirmMessage', mSender || ' cannot confirm message with ID ' || confirm_m_ID || ' because it was received from the same address.', tErr, log_m_ID);
		raise notice 'Executing 1Check Name %s %s', rMsg.Sender, mSender;
		RETURN 0;
	END IF;

	msg='';
	open authObjects;
	fetch authObjects into objCode;
	while FOUND loop
		msg = msg || objCode || ', ';
		fetch authObjects into objCode;
	end loop;
	if msg<>'' then
		perform logMessage(text'confirmMessage','Message confirmation failed. ' || mSender || ' is not allowed to confirm the data for the following Objects: ' || left(msg, length(msg)-2) || '.', tErr, log_m_ID);
		RETURN 0;
	end if;
	FOR lMUT in select * from Meta_Updatable_Tables order by ID loop
		perform logMessage(text'confirmMessage','Executing confirm action for ' || lMUT.table_name, tLog, log_m_ID);
		IF lMUT.del_key = 'yes' THEN
			execute format ('select del_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
			perform logMessage(text'confirmMessage', rc || ' row(s) deleted.', tLog, log_m_ID);
		ELSE
			execute format ('select upd_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
			perform logMessage(text'confirmMessage', rc || ' row(s) updated.', tLog, log_m_ID); 
		END IF;
		execute format ('select ins_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
		perform logMessage(text'confirmMessage', rc || ' row(s) inserted.', tLog, log_m_ID); 
	END LOOP;
	return 1;
end;
$_$;


ALTER FUNCTION public.fn_confirmmessage(confirm_m_id integer, log_m_id integer) OWNER TO postgres;

--
-- Name: fn_confirmmessage(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_confirmmessage(confirm_m_id integer, log_m_id integer, msender character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	rMsg RECORD;
	lMUT RECORD;
	rc integer;
	msg sst_log.log_text%type;
	authObjects cursor for select object_code from vw_mail_auth_sender(mSender, confirm_m_ID);
	objCode character varying;
	tLog constant integer:=1;
	tErr constant integer:=3;
begin
	select mailStatus, Sender, ID into rMsg from Mail_Log where ID = confirm_m_ID;
	IF NOT FOUND THEN
		perform logMessage(text'confirmMessage', 'Message with ID ' || confirm_m_ID || ' does not exist!', cast(tErr as character varying), log_m_ID);
		RETURN 0;
	END IF;
	IF rMsg.mailStatus <> (select id from vw_nom_mail_status where name='[processed]') THEN
		perform logMessage(text'confirmMessage', 'Message with ID ' || confirm_m_ID || ' has status ' || (select name from vw_nom_mail_status where id = rMsg.mailStatus) || ' and cannot be confirmed anymore.', cast(tErr as character varying), log_m_ID);
		raise notice 'Executing 1Check Name %s %s', rMsg.Sender, mSender;
		RETURN 0;
	END IF;
	IF rMsg.Sender = mSender and lower(rMsg.sender)<>'mkrastev.external@unicredit.eu' THEN
		perform logMessage(text'confirmMessage', mSender || ' cannot confirm message with ID ' || confirm_m_ID || ' because it was received from the same address.', cast(tErr as character varying), log_m_ID);
		raise notice 'Executing 1Check Name %s %s', rMsg.Sender, mSender;
		RETURN 0;
	END IF;

	msg='';
	open authObjects;
	fetch authObjects into objCode;
	while FOUND loop
		msg = msg || objCode || ', ';
		fetch authObjects into objCode;
	end loop;
	if msg<>'' then
		perform logMessage(text'confirmMessage','Message confirmation failed. ' || mSender || ' is not allowed to confirm the data for the following Objects: ' || left(msg, length(msg)-2) || '.', cast(tErr as character varying), log_m_ID);
		RETURN 0;
	end if;
	FOR lMUT in select * from Meta_Updatable_Tables order by ID loop
		perform logMessage(text'confirmMessage','Executing confirm action for ' || lMUT.table_name, cast(tLog as character varying), log_m_ID);
		IF lMUT.del_key = 'yes' THEN
			execute format ('select del_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
			perform logMessage(text'confirmMessage', rc || ' row(s) deleted.', cast(tLog as character varying), log_m_ID);
		ELSE
			execute format ('select upd_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
			perform logMessage(text'confirmMessage', rc || ' row(s) updated.', cast(tLog as character varying), log_m_ID); 
		END IF;
		execute format ('select ins_%s($1)', lMUT.table_name) using confirm_m_ID;
			GET DIAGNOSTICS rc = ROW_COUNT;
		perform logMessage(text'confirmMessage', rc || ' row(s) inserted.', cast(tLog as character varying), log_m_ID); 
	END LOOP;
	return 1;
end;
$_$;


ALTER FUNCTION public.fn_confirmmessage(confirm_m_id integer, log_m_id integer, msender character varying) OWNER TO postgres;

--
-- Name: fn_perform_checks(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_perform_checks(m_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	lChecks RECORD;
begin
	for lChecks in select Check_Name, Check_Query from lst_Checks where is_Active = 1 loop
		raise notice 'Executing Check Name %s', lChecks.Check_Name;
	end loop;
	return 1;
end;
$$;


ALTER FUNCTION public.fn_perform_checks(m_id integer) OWNER TO postgres;

--
-- Name: fn_performchecks(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_performchecks(m_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	lChecks RECORD;
	tLog constant integer:=1;
begin
	for lChecks in select Check_Name, Check_Query from lst_Checks where is_Active = 1 loop
		perform logMessage(text'performChecks', 'Performing ' || lChecks.check_name, tLog, m_ID);
		execute lChecks.check_query||'($1)' using m_ID;
	END LOOP;
	return 1;
end;
$_$;


ALTER FUNCTION public.fn_performchecks(m_id integer) OWNER TO postgres;

--
-- Name: fn_performfx(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_performfx(m_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	lFXMeta RECORD;
	updCCY_ID integer;
	updCCY_Amt integer;
	updEUR_Amt integer;
	noDate integer;
	tLog constant integer:=1;
	updSQL text;
	ccy_id_view text;
	msg text;
	nomCCY_col text;
begin
	--update asset_sales a set sale_currency_id = null, sale_approvedamt_eur = null, sale_amount_ccy = null where a.m_id = fn_performFX.m_ID;
--		GET DIAGNOSTICS updCCY_ID = ROW_COUNT;
	FOR lFXMeta in select ref_date_col, coalesce(ref_date_add_col, ref_date_col) ref_date_add_col, ccy_id_col, ccy_amount_col, eur_amount_col, table_name, asset_id_col from meta_ccy_conversion LOOP
		raise notice 'Updating table %', lFXMeta.table_name;
	-- CASE 1 Missing Currency Code
		ccy_id_view = 'vw_'|| case when left(lower(lFXMeta.table_name),3)='npe' then 'npe' else 'asset' end ||'_ccy_id';
		updSQL = 'insert into update_log (table_name, r_id, column_name, old_value, new_value, upd_time)';
		updSQL = updSQL || ' select $1, t.id, $2, t.'|| lFXMeta.ccy_id_col ||', currency_id, now() from ' || lFXMeta.table_name || ' t join ' || ccy_id_view || ' cc on cc.id=t.' || lFXMeta.asset_id_col || ' and t.' || lFXMeta.ccy_id_col || ' is null and t.m_id = $3';
		execute updSQL using lFXMeta.table_name, lFXMeta.ccy_id_col, m_ID;
		updSQL = 'update ' || lFXMeta.table_name || ' t set ' || lFXMeta.ccy_id_col || '= currency_id from ' || ccy_id_view || ' cc where cc.id=t.'|| lFXMeta.asset_id_col ||' and ' || lFXMeta.ccy_id_col || ' is null and m_id = $1';
		execute updSQL using m_ID;
		GET DIAGNOSTICS updCCY_ID = ROW_COUNT;
	-- CASE 2 CCY Column not filled-in
		-- first update the ccy_amount_col
		If lFXMeta.CCY_ID_Col <> 'NPE_Currency' Then
		    nomCCY_col = 'ID';
		Else
		    nomCCY_col = 'Currency_Code';
		End If;
		updSQL = 'insert into update_log (table_name, r_id, column_name, old_value, new_value, upd_time) '||
		' select $1, t.id, $2, t.'|| lFXMeta.ccy_amount_col ||', t.'|| lFXMeta.eur_amount_col ||'*fx_rate_eop, now()'||
		' from ' || lFXMeta.table_name || ' t join nom_currencies c on t.' || lFXMeta.ccy_id_col || ' = c.'||nomCCY_col||' '||
		' join fx_rates fx on c.currency_code=fx.ccy_code and scenario=''Act'' and repdate = last_day(coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ')) '
		'where coalesce(t.'|| lFXMeta.ccy_amount_col ||',0)=0 and coalesce(t.'|| lFXMeta.eur_amount_col ||',0)<>0 '||
		' and coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ', date ''2000-1-1'')>date ''2010-1-1'' and t.m_id = $3';
		execute updSQL using lFXMeta.table_name, lFXMeta.ccy_amount_col, m_ID;

		updSQL = 'update ' || lFXMeta.table_name || ' t set ' || lFXMeta.ccy_amount_col || '= ' || lFXMeta.eur_amount_col || '*fx_rate_eop '||
		'from nom_currencies c ' ||
		' join fx_rates fx on c.currency_code=fx.ccy_code '||
		' where t.' || lFXMeta.ccy_id_col || ' = c.'||nomCCY_col||' and fx.scenario=''Act'' and fx.repdate = last_day(coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ')) '||
		' and m_id=$1 and coalesce(t.'|| lFXMeta.ccy_amount_col ||',0)=0 and coalesce(t.'|| lFXMeta.eur_amount_col ||',0)<>0';
		execute updSQL using m_ID;
		GET DIAGNOSTICS updCCY_Amt = ROW_COUNT;
		--raise notice '%', updSQL;

		-- and then the eur_amount_col
		updSQL = 'insert into update_log (table_name, r_id, column_name, old_value, new_value, upd_time) '||
		' select $1, t.id, $2, t.'|| lFXMeta.eur_amount_col ||', t.'|| lFXMeta.ccy_amount_col ||'/fx_rate_eop, now()'||
		' from ' || lFXMeta.table_name || ' t join nom_currencies c on t.' || lFXMeta.ccy_id_col || ' = c.'||nomCCY_col||' '||
		' join fx_rates fx on c.currency_code=fx.ccy_code and scenario=''Act'' and repdate = last_day(coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ')) '
		'where coalesce(t.'|| lFXMeta.ccy_amount_col ||',0)<>0 and coalesce(t.'|| lFXMeta.eur_amount_col ||',0)=0 '||
		' and coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ', date ''2000-1-1'')>date ''2010-1-1'' and t.m_id = $3';
		execute updSQL using lFXMeta.table_name, lFXMeta.ccy_amount_col, m_ID;

		updSQL = 'update ' || lFXMeta.table_name || ' t set ' || lFXMeta.eur_amount_col || '= ' || lFXMeta.ccy_amount_col || '/fx_rate_eop '||
		'from nom_currencies c '||
		' join fx_rates fx on c.currency_code=fx.ccy_code '||
		' where t.' || lFXMeta.ccy_id_col || ' = c.'||nomCCY_col||' and fx.scenario=''Act'' and fx.repdate = last_day(coalesce(t.'|| lFXMeta.ref_date_col ||', '|| lFXMeta.ref_date_add_col || ')) '||
		' and m_id=$1 and coalesce(t.'|| lFXMeta.ccy_amount_col ||',0)<>0 and coalesce(t.'|| lFXMeta.eur_amount_col ||',0)=0';
		execute updSQL using m_ID;
		GET DIAGNOSTICS updEUR_Amt = ROW_COUNT;
		If updCCY_ID>0 or noDate>0 or updCCY_Amt>0 or updEUR_Amt>0 Then
		    msg = 'FX updates results for table ' || lFXMeta.table_name || ':';
		    If updCCY_ID>0 Then
			msg = msg || ' column ' || lFXMeta.CCY_ID_Col || ' updated ' || updCCY_ID || ' times;';
		    End If;
		    If noDate>0 Then
			msg = msg || ' conversion impossible for ' || noDate || ' row(s) due to missing '  || lFXMeta.Ref_Date_Col ||  ';';
		    End If;
		    If updCCY_Amt>0 Then
			msg = msg || ' ' || lFXMeta.CCY_Amount_Col || ' updated ' || updCCY_Amt || ' times;';
		    End If; 
		    If updEUR_Amt>0 Then
			msg = msg || ' ' || EUR_Amount_Col || ' updated ' || updEUR_Amt || ' times;';
		    End If;
			perform logMessage(text'convertFX', msg, tLog, m_ID);
			RAISE NOTICE '%', msg;
		End If;
	END LOOP;
	--RAISE EXCEPTION 'Error';
	return 1;
end;
$_$;


ALTER FUNCTION public.fn_performfx(m_id integer) OWNER TO postgres;

--
-- Name: fn_performupdates(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_performupdates(confirm_m_id integer, log_m_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	lUpdates RECORD;
	rc integer;
	tLog constant integer:=1;
begin
	FOR lUpdates in select Update_Name, Update_Query from lst_Updates where is_Active = 1 LOOP
		execute lUpdates.update_query||'($1)' using confirm_m_ID;
		GET DIAGNOSTICS rc = ROW_COUNT;
		perform logMessage(text'performUpdates', lUpdates.update_name || rc || ' row(s) affected', tLog, log_m_ID);
	END LOOP;
	return 1;
end;
$_$;


ALTER FUNCTION public.fn_performupdates(confirm_m_id integer, log_m_id integer) OWNER TO postgres;

--
-- Name: iif(boolean, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION iif(condition1 boolean, true_part character varying, false_part character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	strresult character varying;
BEGIN
IF condition1=true then
return true_part;
else 
return false_part;
END IF;
END
$$;


ALTER FUNCTION public.iif(condition1 boolean, true_part character varying, false_part character varying) OWNER TO postgres;

--
-- Name: ins_asset(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
	V_NPE_ID NPE_LIST.ID%TYPE;
    BEGIN
	IF NOT EXISTS (SELECT 1 FROM NPE_LIST WHERE m_ID=NEW.m_ID and NPE_Code=LEFT(NEW.Asset_Code,8)) THEN
		WITH NPE_INSERT AS (
			INSERT INTO NPE_LIST (m_ID, NPE_Code) VALUES (NEW.m_ID, LEFT(NEW.Asset_Code,8)) RETURNING *
		)
		SELECT ID into V_NPE_ID FROM NPE_INSERT;

		NEW.Asset_NPE_ID := V_NPE_ID;
	END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.ins_asset() OWNER TO postgres;

--
-- Name: ins_asset_appraisals(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_appraisals(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Appraisals
( Appraisal_Asset_ID, Appraisal_Company_ID, Appraisal_Date, Appraisal_Currency_ID, Appraisal_Market_Value_CCY, Appraisal_Market_Value_EUR, Appraisal_Firesale_Value_CCY, Appraisal_Firesale_Value_EUR, Appraisal_Order, m_ID
) SELECT new_parent.ID AS Appraisal_Asset_ID, new_tab.Appraisal_Company_ID AS Appraisal_Company_ID, new_tab.Appraisal_Date AS Appraisal_Date, new_tab.Appraisal_Currency_ID AS Appraisal_Currency_ID, new_tab.Appraisal_Market_Value_CCY AS Appraisal_Market_Value_CCY, new_tab.Appraisal_Market_Value_EUR AS Appraisal_Market_Value_EUR, new_tab.Appraisal_Firesale_Value_CCY AS Appraisal_Firesale_Value_CCY, new_tab.Appraisal_Firesale_Value_EUR AS Appraisal_Firesale_Value_EUR, new_tab.Appraisal_Order AS Appraisal_Order, -1 AS m_ID
FROM (Asset_Appraisals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Appraisal_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Appraisals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Appraisal_Asset_ID=new_parent.id
   and dw_tab.Appraisal_Date=new_tab.Appraisal_Date
);

$$;


ALTER FUNCTION public.ins_asset_appraisals(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_financials(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_financials(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Financials
( Asset_ID, Acc_Date, Account_No, Account_Name, Amount, Trans_Type_ID, Rep_Date, m_ID
) SELECT new_parent.ID AS Asset_ID, new_tab.Acc_Date AS Acc_Date, new_tab.Account_No AS Account_No, new_tab.Account_Name AS Account_Name, new_tab.Amount AS Amount, new_tab.Trans_Type_ID AS Trans_Type_ID, new_tab.Rep_Date AS Rep_Date, -1 AS m_ID
FROM (Asset_Financials AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financials as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;


ALTER FUNCTION public.ins_asset_financials(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_financing(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_financing(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Financing
( Financing_Contract_Code, Financing_Counterpart_ID, Financing_Asset_ID, Financing_Type_ID, Financing_Currency_ID, Financing_Amount_CCY, Financing_Amount_EUR, Financing_Reference_Rate, Financing_Margin, Financing_Rate, Financing_Start_Date, Financing_End_Date, Financing_Contract_Date, m_ID
) SELECT new_tab.Financing_Contract_Code AS Financing_Contract_Code, new_tab.Financing_Counterpart_ID AS Financing_Counterpart_ID, new_parent.ID AS Financing_Asset_ID, new_tab.Financing_Type_ID AS Financing_Type_ID, new_tab.Financing_Currency_ID AS Financing_Currency_ID, new_tab.Financing_Amount_CCY AS Financing_Amount_CCY, new_tab.Financing_Amount_EUR AS Financing_Amount_EUR, new_tab.Financing_Reference_Rate AS Financing_Reference_Rate, new_tab.Financing_Margin AS Financing_Margin, new_tab.Financing_Rate AS Financing_Rate, new_tab.Financing_Start_Date AS Financing_Start_Date, new_tab.Financing_End_Date AS Financing_End_Date, new_tab.Financing_Contract_Date AS Financing_Contract_Date, -1 AS m_ID
FROM (Asset_Financing AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Financing_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Financing as dw_tab where dw_tab.m_id = -1
   and dw_tab.Financing_Asset_ID=new_parent.id
   and dw_tab.Financing_Type_ID=new_tab.Financing_Type_ID
   and dw_tab.Financing_Start_Date=new_tab.Financing_Start_Date
);

$$;


ALTER FUNCTION public.ins_asset_financing(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_history(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_history(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_History
( Asset_ID, Rep_Date, Status_Code, Inflows, CAPEX, Depreciation, Sales, Imp_WB, Book_Value, Costs, Income, Expected_Exit, m_ID
) SELECT new_parent.ID AS Asset_ID, new_tab.Rep_Date AS Rep_Date, new_tab.Status_Code AS Status_Code, new_tab.Inflows AS Inflows, new_tab.CAPEX AS CAPEX, new_tab.Depreciation AS Depreciation, new_tab.Sales AS Sales, new_tab.Imp_WB AS Imp_WB, new_tab.Book_Value AS Book_Value, new_tab.Costs AS Costs, new_tab.Income AS Income, new_tab.Expected_Exit AS Expected_Exit, -1 AS m_ID
FROM (Asset_History AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_History as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_ID=new_parent.id
   and dw_tab.Rep_Date=new_tab.Rep_Date
);

$$;


ALTER FUNCTION public.ins_asset_history(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_insurances(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_insurances(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Insurances
( Insurance_Asset_ID, Insurance_Company_ID, Insurance_Start_Date, Insurance_End_Date, Insurance_Currency_ID, Insurance_Amount_CCY, Insurance_Amount_EUR, Insurance_Premium_CCY, Insurance_Premium_EUR, m_ID
) SELECT new_parent.ID AS Insurance_Asset_ID, new_tab.Insurance_Company_ID AS Insurance_Company_ID, new_tab.Insurance_Start_Date AS Insurance_Start_Date, new_tab.Insurance_End_Date AS Insurance_End_Date, new_tab.Insurance_Currency_ID AS Insurance_Currency_ID, new_tab.Insurance_Amount_CCY AS Insurance_Amount_CCY, new_tab.Insurance_Amount_EUR AS Insurance_Amount_EUR, new_tab.Insurance_Premium_CCY AS Insurance_Premium_CCY, new_tab.Insurance_Premium_EUR AS Insurance_Premium_EUR, -1 AS m_ID
FROM (Asset_Insurances AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Insurance_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Insurances as dw_tab where dw_tab.m_id = -1
   and dw_tab.Insurance_Asset_ID=new_parent.id
   and dw_tab.Insurance_Start_Date=new_tab.Insurance_Start_Date
);

$$;


ALTER FUNCTION public.ins_asset_insurances(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_rentals(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_rentals(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Rentals
( Rental_Asset_ID, Rental_Counterpart_ID, Rental_Contract_Date, Rental_Start_Date, Rental_End_Date, Rental_Payment_Date, Rental_Currency_ID, Rental_Amount_CCY, Rental_Amount_EUR, m_ID
) SELECT new_parent.ID AS Rental_Asset_ID, new_tab.Rental_Counterpart_ID AS Rental_Counterpart_ID, new_tab.Rental_Contract_Date AS Rental_Contract_Date, new_tab.Rental_Start_Date AS Rental_Start_Date, new_tab.Rental_End_Date AS Rental_End_Date, new_tab.Rental_Payment_Date AS Rental_Payment_Date, new_tab.Rental_Currency_ID AS Rental_Currency_ID, new_tab.Rental_Amount_CCY AS Rental_Amount_CCY, new_tab.Rental_Amount_EUR AS Rental_Amount_EUR, -1 AS m_ID
FROM (Asset_Rentals AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Rental_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Rentals as dw_tab where dw_tab.m_id = -1
   and dw_tab.Rental_Asset_ID=new_parent.id
   and dw_tab.Rental_Contract_Date=new_tab.Rental_Contract_Date
);

$$;


ALTER FUNCTION public.ins_asset_rentals(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_repossession(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_repossession(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Repossession
( Repossession_Asset_ID, NPE_Currency_ID, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_Currency_ID, Appr_Purchase_Price_Net_CCY, Appr_Purchase_Price_Net_EUR, Purchase_Price_Net_CCY, Purchase_Price_Net_EUR, Purchase_Costs_CCY, Purchase_Costs_EUR, Planned_CAPEX_Currency_ID, Planned_CAPEX_CCY, Planned_CAPEX_EUR, Planned_CAPEX_Comment, Purchase_Auction_Date, Purchase_Contract_Date, Purchase_Repossession_Date, Purchase_Payment_Date, Purchase_Handover_Date, Purchase_Registration_Date, Purchase_Local_Approval_Date, Purchase_Central_Approval_Date, Purchase_Prolongation_Date, Purchase_Expected_Exit_Date, Planned_OPEX_CCY, Planned_OPEX_EUR, Planned_OPEX_Comment, Planned_SalesPrice_CCY, Planned_SalesPrice_EUR, m_ID
) SELECT new_parent.ID AS Repossession_Asset_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.Purchase_Price_Currency_ID AS Purchase_Price_Currency_ID, new_tab.Appr_Purchase_Price_Net_CCY AS Appr_Purchase_Price_Net_CCY, new_tab.Appr_Purchase_Price_Net_EUR AS Appr_Purchase_Price_Net_EUR, new_tab.Purchase_Price_Net_CCY AS Purchase_Price_Net_CCY, new_tab.Purchase_Price_Net_EUR AS Purchase_Price_Net_EUR, new_tab.Purchase_Costs_CCY AS Purchase_Costs_CCY, new_tab.Purchase_Costs_EUR AS Purchase_Costs_EUR, new_tab.Planned_CAPEX_Currency_ID AS Planned_CAPEX_Currency_ID, new_tab.Planned_CAPEX_CCY AS Planned_CAPEX_CCY, new_tab.Planned_CAPEX_EUR AS Planned_CAPEX_EUR, new_tab.Planned_CAPEX_Comment AS Planned_CAPEX_Comment, new_tab.Purchase_Auction_Date AS Purchase_Auction_Date, new_tab.Purchase_Contract_Date AS Purchase_Contract_Date, new_tab.Purchase_Repossession_Date AS Purchase_Repossession_Date, new_tab.Purchase_Payment_Date AS Purchase_Payment_Date, new_tab.Purchase_Handover_Date AS Purchase_Handover_Date, new_tab.Purchase_Registration_Date AS Purchase_Registration_Date, new_tab.Purchase_Local_Approval_Date AS Purchase_Local_Approval_Date, new_tab.Purchase_Central_Approval_Date AS Purchase_Central_Approval_Date, new_tab.Purchase_Prolongation_Date AS Purchase_Prolongation_Date, new_tab.Purchase_Expected_Exit_Date AS Purchase_Expected_Exit_Date, new_tab.Planned_OPEX_CCY AS Planned_OPEX_CCY, new_tab.Planned_OPEX_EUR AS Planned_OPEX_EUR, new_tab.Planned_OPEX_Comment AS Planned_OPEX_Comment, new_tab.Planned_SalesPrice_CCY AS Planned_SalesPrice_CCY, new_tab.Planned_SalesPrice_EUR AS Planned_SalesPrice_EUR, -1 AS m_ID
FROM (Asset_Repossession AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Repossession_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Repossession as dw_tab where dw_tab.m_id = -1
   and dw_tab.Repossession_Asset_ID=new_parent.id
   and dw_tab.Purchase_Auction_Date=new_tab.Purchase_Auction_Date
);

$$;


ALTER FUNCTION public.ins_asset_repossession(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_asset_sales(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_asset_sales(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Asset_Sales
( Sale_Asset_ID, Sale_Counterpart_ID, Sale_Approval_Date, Sale_Contract_Date, Sale_Transfer_Date, Sale_Payment_Date, Sale_AML_Check_Date, Sale_AML_Pass_Date, Sale_Currency_ID, Sale_ApprovedAmt_CCY, Sale_ApprovedAmt_EUR, Sale_Amount_CCY, Sale_Amount_EUR, Sale_Book_Value_CCY, Sale_Book_Value_EUR, m_ID
) SELECT new_parent.ID AS Sale_Asset_ID, new_tab.Sale_Counterpart_ID AS Sale_Counterpart_ID, new_tab.Sale_Approval_Date AS Sale_Approval_Date, new_tab.Sale_Contract_Date AS Sale_Contract_Date, new_tab.Sale_Transfer_Date AS Sale_Transfer_Date, new_tab.Sale_Payment_Date AS Sale_Payment_Date, new_tab.Sale_AML_Check_Date AS Sale_AML_Check_Date, new_tab.Sale_AML_Pass_Date AS Sale_AML_Pass_Date, new_tab.Sale_Currency_ID AS Sale_Currency_ID, new_tab.Sale_ApprovedAmt_CCY AS Sale_ApprovedAmt_CCY, new_tab.Sale_ApprovedAmt_EUR AS Sale_ApprovedAmt_EUR, new_tab.Sale_Amount_CCY AS Sale_Amount_CCY, new_tab.Sale_Amount_EUR AS Sale_Amount_EUR, new_tab.Sale_Book_Value_CCY AS Sale_Book_Value_CCY, new_tab.Sale_Book_Value_EUR AS Sale_Book_Value_EUR, -1 AS m_ID
FROM (Asset_Sales AS new_tab INNER JOIN Assets_List AS old_parent ON old_parent.id=new_tab.Sale_Asset_ID) INNER JOIN Assets_List AS new_parent ON new_parent.Asset_Code=old_parent.Asset_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Asset_Sales as dw_tab where dw_tab.m_id = -1
   and dw_tab.Sale_Asset_ID=new_parent.id
   and dw_tab.Sale_Approval_Date=new_tab.Sale_Approval_Date
);

$$;


ALTER FUNCTION public.ins_asset_sales(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_assets_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_assets_list(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Assets_List
( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID
) SELECT new_tab.Asset_Code AS Asset_Code, new_parent.ID AS Asset_NPE_ID, new_tab.Asset_Name AS Asset_Name, new_tab.Asset_Description AS Asset_Description, new_tab.Asset_Address AS Asset_Address, new_tab.Asset_ZIP AS Asset_ZIP, new_tab.Asset_Region AS Asset_Region, new_tab.Asset_Country_ID AS Asset_Country_ID, new_tab.Asset_Usage_ID AS Asset_Usage_ID, new_tab.Asset_Type_ID AS Asset_Type_ID, new_tab.Asset_Usable_Area AS Asset_Usable_Area, new_tab.Asset_Common_Area AS Asset_Common_Area, new_tab.Asset_Owned AS Asset_Owned, new_tab.Comment AS Comment, -1 AS m_ID
FROM (Assets_List AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.Asset_NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Assets_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.Asset_Code=new_tab.Asset_Code
);

$$;


ALTER FUNCTION public.ins_assets_list(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_assets_list2(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_assets_list2(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Assets_List ( Asset_Code, Asset_NPE_ID, Asset_Name, Asset_Description, Asset_Address, Asset_ZIP, Asset_Region, Asset_Country_ID, Asset_Usage_ID, Asset_Type_ID, Asset_Usable_Area, Asset_Common_Area, Asset_Owned, Comment, m_ID )
SELECT Assets_List.Asset_Code, NPE_List_DW.ID, Assets_List.Asset_Name, Assets_List.Asset_Description, Assets_List.Asset_Address, Assets_List.Asset_ZIP, Assets_List.Asset_Region, Assets_List.Asset_Country_ID, Assets_List.Asset_Usage_ID, Assets_List.Asset_Type_ID, Assets_List.Asset_Usable_Area, Assets_List.Asset_Common_Area, Assets_List.Asset_Owned, Assets_List.Comment, -1 AS DW_m_ID
FROM (NPE_List INNER JOIN Assets_List ON NPE_List.ID = Assets_List.Asset_NPE_ID) INNER JOIN NPE_List AS NPE_List_DW ON NPE_List.NPE_Code = NPE_List_DW.NPE_Code
WHERE (((Assets_List.m_ID)=p_m_ID) AND ((Exists (select 1 from Assets_list al_dwh where al_dwh.asset_code=assets_list.Asset_Code))=False));

$$;


ALTER FUNCTION public.ins_assets_list2(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_business_cases(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_business_cases(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO Business_Cases
( NPE_ID, BC_Date, BC_Comment, BC_Purchase_Date, BC_Purchase_Price_EUR, Exp_CAPEX_EUR, Exp_CAPEX_Time, Exp_Sale_Date, Exp_Sale_Price_EUR, Exp_Interest_EUR, Exp_OPEX_EUR, Exp_Income_EUR, m_ID
) SELECT new_parent.ID AS NPE_ID, new_tab.BC_Date AS BC_Date, new_tab.BC_Comment AS BC_Comment, new_tab.BC_Purchase_Date AS BC_Purchase_Date, new_tab.BC_Purchase_Price_EUR AS BC_Purchase_Price_EUR, new_tab.Exp_CAPEX_EUR AS Exp_CAPEX_EUR, new_tab.Exp_CAPEX_Time AS Exp_CAPEX_Time, new_tab.Exp_Sale_Date AS Exp_Sale_Date, new_tab.Exp_Sale_Price_EUR AS Exp_Sale_Price_EUR, new_tab.Exp_Interest_EUR AS Exp_Interest_EUR, new_tab.Exp_OPEX_EUR AS Exp_OPEX_EUR, new_tab.Exp_Income_EUR AS Exp_Income_EUR, -1 AS m_ID
FROM (Business_Cases AS new_tab INNER JOIN NPE_List AS old_parent ON old_parent.id=new_tab.NPE_ID) INNER JOIN NPE_List AS new_parent ON new_parent.NPE_Code=old_parent.NPE_Code
WHERE new_tab.m_id = p_m_ID
 and new_parent.m_id=-1
   and not exists (select 1 from Business_Cases as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_ID=new_parent.id
   and dw_tab.BC_Date=new_tab.BC_Date
);

$$;


ALTER FUNCTION public.ins_business_cases(p_m_id integer) OWNER TO postgres;

--
-- Name: ins_copyactuals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_copyactuals() RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO NPE_History ( NPE_ID, Rep_Date, NPE_Status_ID, NPE_Scenario_ID, NPE_Rep_Date, NPE_Currency, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, Purchase_Price_CCY, Purchase_Price_EUR, m_ID )
SELECT NPE_History.NPE_ID, LastDate.CurrMonth AS RepDate, Max(NPE_History.NPE_Status_ID) AS MaxOfNPE_Status_ID, 6 AS NPE_Scenario_ID_, Max( case when npe_history.npe_scenario_id=11 then npe_history.npe_rep_date else Null end ) AS FC_Rep_Date, 'EUR' AS NPE_Currency, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_CCY, Sum( case when npe_history.npe_scenario_id=11 then npe_history.npe_amount_eur else 0 end ) AS FC_NPE_EUR, Sum(NPE_History.LLP_Amount_CCY) AS SumOfLLP_Amount_CCY, Sum(NPE_History.LLP_Amount_EUR) AS SumOfLLP_Amount_EUR, Sum(NPE_History.Purchase_Price_CCY) AS SumOfPurchase_Price_CCY, Sum(NPE_History.Purchase_Price_EUR) AS SumOfPurchase_Price_EUR, NPE_History.m_ID
FROM NPE_History INNER JOIN LastDate ON NPE_History.Rep_Date = LastDate.PrevMonth
WHERE (((NPE_History.NPE_Scenario_ID) In (6,11)))
GROUP BY NPE_History.NPE_ID, LastDate.CurrMonth, 6, NPE_History.m_ID
HAVING (((NPE_History.m_ID)=-1));

$$;


ALTER FUNCTION public.ins_copyactuals() OWNER TO postgres;

--
-- Name: ins_npe_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_npe_list(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO NPE_List
( NPE_Code, NPE_Scenario_ID, NPE_Country_ID, NPE_Name, NPE_Description, NPE_Lender_ID, NPE_Borrower_ID, NPE_Currency_ID, NPE_Amount_Date, NPE_Amount_CCY, NPE_Amount_EUR, LLP_Amount_CCY, LLP_Amount_EUR, NPE_Owned, m_ID, LE_ID) SELECT new_tab.NPE_Code AS NPE_Code, new_tab.NPE_Scenario_ID AS NPE_Scenario_ID, new_tab.NPE_Country_ID AS NPE_Country_ID, new_tab.NPE_Name AS NPE_Name, new_tab.NPE_Description AS NPE_Description, new_tab.NPE_Lender_ID AS NPE_Lender_ID, new_tab.NPE_Borrower_ID AS NPE_Borrower_ID, new_tab.NPE_Currency_ID AS NPE_Currency_ID, new_tab.NPE_Amount_Date AS NPE_Amount_Date, new_tab.NPE_Amount_CCY AS NPE_Amount_CCY, new_tab.NPE_Amount_EUR AS NPE_Amount_EUR, new_tab.LLP_Amount_CCY AS LLP_Amount_CCY, new_tab.LLP_Amount_EUR AS LLP_Amount_EUR, new_tab.NPE_Owned AS NPE_Owned, -1 AS m_ID, new_tab.LE_ID AS LE_ID
FROM NPE_List AS new_tab
WHERE new_tab.m_id = p_m_ID
   and not exists (select 1 from NPE_List as dw_tab where dw_tab.m_id = -1
   and dw_tab.NPE_Code=new_tab.NPE_Code
);
$$;


ALTER FUNCTION public.ins_npe_list(p_m_id integer) OWNER TO postgres;

--
-- Name: last_day(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_day(date) RETURNS date
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select (date_trunc('month', $1) + interval '1 month' - interval '1 day')::date;
$_$;


ALTER FUNCTION public.last_day(date) OWNER TO postgres;

--
-- Name: logmessage(character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION logmessage(log_source character varying, log_text character varying, log_type integer, mail_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into sst_log (log_date, log_source, log_text, log_type, mail_id) values (now(), log_source, log_text, log_type, mail_id);
	return 1;
end;
$$;


ALTER FUNCTION public.logmessage(log_source character varying, log_text character varying, log_type integer, mail_id integer) OWNER TO postgres;

--
-- Name: logmessage(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION logmessage(log_source character varying, log_text character varying, log_type character varying, mail_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into sst_log (log_date, log_source, log_text, log_type, mail_id) values (now(), log_source, log_text, log_type, mail_id);
	return 1;
end;
$$;


ALTER FUNCTION public.logmessage(log_source character varying, log_text character varying, log_type character varying, mail_id integer) OWNER TO postgres;

--
-- Name: make_into_serial(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_into_serial(table_name text, column_name text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    start_with INTEGER;
    sequence_name TEXT;
BEGIN
    sequence_name := table_name || '_' || column_name || '_seq';
    EXECUTE 'SELECT coalesce(max(' || column_name || '), 0) + 1 FROM ' || table_name
            INTO start_with;
    EXECUTE 'CREATE SEQUENCE ' || sequence_name ||
            ' START WITH ' || start_with ||
            ' OWNED BY ' || table_name || '.' || column_name;
    EXECUTE 'ALTER TABLE ' || table_name || ' ALTER COLUMN ' || column_name ||
            ' SET DEFAULT nextVal(''' || sequence_name || ''')';
    RETURN start_with;
END;
$$;


ALTER FUNCTION public.make_into_serial(table_name text, column_name text) OWNER TO postgres;

--
-- Name: sel_asset_appraisals(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_appraisals(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_appraisal_company_id character varying, new_appraisal_company_id character varying, appraisal_date date, old_appraisal_currency_id character varying, new_appraisal_currency_id character varying, old_appraisal_market_value_ccy double precision, new_appraisal_market_value_ccy double precision, old_appraisal_market_value_eur double precision, new_appraisal_market_value_eur double precision, old_appraisal_firesale_value_ccy double precision, new_appraisal_firesale_value_ccy double precision, old_appraisal_firesale_value_eur double precision, new_appraisal_firesale_value_eur double precision, old_appraisal_order integer, new_appraisal_order integer, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Appraisal_Company_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Appraisal_Company_ID, tab.Appraisal_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Appraisal_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Appraisal_Currency_ID, max( case when tab.m_id=-1 then  tab.Appraisal_Market_Value_CCY else null end ) AS old_Appraisal_Market_Value_CCY, max( case when tab.m_id<>-1 then  tab.Appraisal_Market_Value_CCY else null end ) AS new_Appraisal_Market_Value_CCY, max( case when tab.m_id=-1 then  tab.Appraisal_Market_Value_EUR else null end ) AS old_Appraisal_Market_Value_EUR, max( case when tab.m_id<>-1 then  tab.Appraisal_Market_Value_EUR else null end ) AS new_Appraisal_Market_Value_EUR, max( case when tab.m_id=-1 then  tab.Appraisal_Firesale_Value_CCY else null end ) AS old_Appraisal_Firesale_Value_CCY, max( case when tab.m_id<>-1 then  tab.Appraisal_Firesale_Value_CCY else null end ) AS new_Appraisal_Firesale_Value_CCY, max( case when tab.m_id=-1 then  tab.Appraisal_Firesale_Value_EUR else null end ) AS old_Appraisal_Firesale_Value_EUR, max( case when tab.m_id<>-1 then  tab.Appraisal_Firesale_Value_EUR else null end ) AS new_Appraisal_Firesale_Value_EUR, max( case when tab.m_id=-1 then  tab.Appraisal_Order else null end ) AS old_Appraisal_Order, max( case when tab.m_id<>-1 then  tab.Appraisal_Order else null end ) AS new_Appraisal_Order,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Appraisals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Appraisal_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Appraisal_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Appraisal_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Appraisal_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_appraisals(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_financials(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_financials(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_acc_date date, new_acc_date date, old_account_no character varying, new_account_no character varying, old_account_name character varying, new_account_name character varying, old_amount integer, new_amount integer, old_trans_type_id integer, new_trans_type_id integer, rep_date date, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  tab.Acc_Date else null end ) AS old_Acc_Date, max( case when tab.m_id<>-1 then  tab.Acc_Date else null end ) AS new_Acc_Date, max( case when tab.m_id=-1 then  tab.Account_No else null end ) AS old_Account_No, max( case when tab.m_id<>-1 then  tab.Account_No else null end ) AS new_Account_No, max( case when tab.m_id=-1 then  tab.Account_Name else null end ) AS old_Account_Name, max( case when tab.m_id<>-1 then  tab.Account_Name else null end ) AS new_Account_Name, max( case when tab.m_id=-1 then  tab.Amount else null end ) AS old_Amount, max( case when tab.m_id<>-1 then  tab.Amount else null end ) AS new_Amount, max( case when tab.m_id=-1 then  tab.Trans_Type_ID else null end ) AS old_Trans_Type_ID, max( case when tab.m_id<>-1 then  tab.Trans_Type_ID else null end ) AS new_Trans_Type_ID, tab.Rep_Date,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM Asset_Financials AS tab INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_financials(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_financing(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_financing(p_m_id integer) RETURNS TABLE(old_financing_contract_code character varying, new_financing_contract_code character varying, old_financing_counterpart_id character varying, new_financing_counterpart_id character varying, asset_code character varying, asset_name character varying, financing_type_id character varying, old_financing_currency_id character varying, new_financing_currency_id character varying, old_financing_amount_ccy double precision, new_financing_amount_ccy double precision, old_financing_amount_eur double precision, new_financing_amount_eur double precision, old_financing_reference_rate character varying, new_financing_reference_rate character varying, old_financing_margin double precision, new_financing_margin double precision, old_financing_rate double precision, new_financing_rate double precision, financing_start_date date, old_financing_end_date date, new_financing_end_date date, old_financing_contract_date date, new_financing_contract_date date, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT max( case when tab.m_id=-1 then  tab.Financing_Contract_Code else null end ) AS old_Financing_Contract_Code, max( case when tab.m_id<>-1 then  tab.Financing_Contract_Code else null end ) AS new_Financing_Contract_Code, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Financing_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Financing_Counterpart_ID, parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, Nom_Financing_Type1.Financing_Type AS Financing_Type_ID, max( case when tab.m_id=-1 then  Nom_Currencies2.Currency_Code else null end ) AS old_Financing_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies2.Currency_Code else null end ) AS new_Financing_Currency_ID, max( case when tab.m_id=-1 then  tab.Financing_Amount_CCY else null end ) AS old_Financing_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Financing_Amount_CCY else null end ) AS new_Financing_Amount_CCY, max( case when tab.m_id=-1 then  tab.Financing_Amount_EUR else null end ) AS old_Financing_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Financing_Amount_EUR else null end ) AS new_Financing_Amount_EUR, max( case when tab.m_id=-1 then  tab.Financing_Reference_Rate else null end ) AS old_Financing_Reference_Rate, max( case when tab.m_id<>-1 then  tab.Financing_Reference_Rate else null end ) AS new_Financing_Reference_Rate, max( case when tab.m_id=-1 then  tab.Financing_Margin else null end ) AS old_Financing_Margin, max( case when tab.m_id<>-1 then  tab.Financing_Margin else null end ) AS new_Financing_Margin, max( case when tab.m_id=-1 then  tab.Financing_Rate else null end ) AS old_Financing_Rate, max( case when tab.m_id<>-1 then  tab.Financing_Rate else null end ) AS new_Financing_Rate, tab.Financing_Start_Date, max( case when tab.m_id=-1 then  tab.Financing_End_Date else null end ) AS old_Financing_End_Date, max( case when tab.m_id<>-1 then  tab.Financing_End_Date else null end ) AS new_Financing_End_Date, max( case when tab.m_id=-1 then  tab.Financing_Contract_Date else null end ) AS old_Financing_Contract_Date, max( case when tab.m_id<>-1 then  tab.Financing_Contract_Date else null end ) AS new_Financing_Contract_Date,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM (((Asset_Financing AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Financing_Counterpart_ID) LEFT JOIN Nom_Financing_Type AS Nom_Financing_Type1 ON Nom_Financing_Type1.id=tab.Financing_Type_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies2 ON Nom_Currencies2.id=tab.Financing_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Financing_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, Nom_Financing_Type1.Financing_Type, tab.Financing_Start_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_financing(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_history(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_history(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, rep_date date, old_status_code character varying, new_status_code character varying, old_currency_id character varying, new_currency_id character varying, old_book_value_pm double precision, new_book_value_pm double precision, old_inflows double precision, new_inflows double precision, old_capex double precision, new_capex double precision, old_depreciation double precision, new_depreciation double precision, old_sales double precision, new_sales double precision, old_imp_wb double precision, new_imp_wb double precision, old_book_value double precision, new_book_value double precision, old_costs double precision, new_costs double precision, old_income double precision, new_income double precision, old_expected_exit date, new_expected_exit date, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, tab.Rep_Date, max( case when tab.m_id=-1 then  Nom_Asset_Status0.Asset_Status_Code else null end ) AS old_Status_Code, max( case when tab.m_id<>-1 then  Nom_Asset_Status0.Asset_Status_Code else null end ) AS new_Status_Code, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Currency_ID, max( case when tab.m_id=-1 then  tab.Book_Value_PM else null end ) AS old_Book_Value_PM, max( case when tab.m_id<>-1 then  tab.Book_Value_PM else null end ) AS new_Book_Value_PM, max( case when tab.m_id=-1 then  tab.Inflows else null end ) AS old_Inflows, max( case when tab.m_id<>-1 then  tab.Inflows else null end ) AS new_Inflows, max( case when tab.m_id=-1 then  tab.CAPEX else null end ) AS old_CAPEX, max( case when tab.m_id<>-1 then  tab.CAPEX else null end ) AS new_CAPEX, max( case when tab.m_id=-1 then  tab.Depreciation else null end ) AS old_Depreciation, max( case when tab.m_id<>-1 then  tab.Depreciation else null end ) AS new_Depreciation, max( case when tab.m_id=-1 then  tab.Sales else null end ) AS old_Sales, max( case when tab.m_id<>-1 then  tab.Sales else null end ) AS new_Sales, max( case when tab.m_id=-1 then  tab.Imp_WB else null end ) AS old_Imp_WB, max( case when tab.m_id<>-1 then  tab.Imp_WB else null end ) AS new_Imp_WB, max( case when tab.m_id=-1 then  tab.Book_Value else null end ) AS old_Book_Value, max( case when tab.m_id<>-1 then  tab.Book_Value else null end ) AS new_Book_Value, max( case when tab.m_id=-1 then  tab.Costs else null end ) AS old_Costs, max( case when tab.m_id<>-1 then  tab.Costs else null end ) AS new_Costs, max( case when tab.m_id=-1 then  tab.Income else null end ) AS old_Income, max( case when tab.m_id<>-1 then  tab.Income else null end ) AS new_Income, max( case when tab.m_id=-1 then  tab.Expected_Exit else null end ) AS old_Expected_Exit, max( case when tab.m_id<>-1 then  tab.Expected_Exit else null end ) AS new_Expected_Exit,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_History AS tab LEFT JOIN Nom_Asset_Status AS Nom_Asset_Status0 ON Nom_Asset_Status0.id=tab.Status_Code) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rep_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_history(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_insurances(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_insurances(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_insurance_company_id character varying, new_insurance_company_id character varying, insurance_start_date date, old_insurance_end_date date, new_insurance_end_date date, old_insurance_currency_id character varying, new_insurance_currency_id character varying, old_insurance_amount_ccy double precision, new_insurance_amount_ccy double precision, old_insurance_amount_eur double precision, new_insurance_amount_eur double precision, old_insurance_premium_ccy double precision, new_insurance_premium_ccy double precision, old_insurance_premium_eur double precision, new_insurance_premium_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Insurance_Company_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Insurance_Company_ID, tab.Insurance_Start_Date, max( case when tab.m_id=-1 then  tab.Insurance_End_Date else null end ) AS old_Insurance_End_Date, max( case when tab.m_id<>-1 then  tab.Insurance_End_Date else null end ) AS new_Insurance_End_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Insurance_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Insurance_Currency_ID, max( case when tab.m_id=-1 then  tab.Insurance_Amount_CCY else null end ) AS old_Insurance_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Insurance_Amount_CCY else null end ) AS new_Insurance_Amount_CCY, max( case when tab.m_id=-1 then  tab.Insurance_Amount_EUR else null end ) AS old_Insurance_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Insurance_Amount_EUR else null end ) AS new_Insurance_Amount_EUR, max( case when tab.m_id=-1 then  tab.Insurance_Premium_CCY else null end ) AS old_Insurance_Premium_CCY, max( case when tab.m_id<>-1 then  tab.Insurance_Premium_CCY else null end ) AS new_Insurance_Premium_CCY, max( case when tab.m_id=-1 then  tab.Insurance_Premium_EUR else null end ) AS old_Insurance_Premium_EUR, max( case when tab.m_id<>-1 then  tab.Insurance_Premium_EUR else null end ) AS new_Insurance_Premium_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Insurances AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Insurance_Company_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Insurance_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Insurance_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Insurance_Start_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_insurances(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_rentals(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_rentals(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_rental_counterpart_id character varying, new_rental_counterpart_id character varying, rental_contract_date date, old_rental_start_date date, new_rental_start_date date, old_rental_end_date date, new_rental_end_date date, old_rental_payment_date date, new_rental_payment_date date, old_rental_currency_id character varying, new_rental_currency_id character varying, old_rental_amount_ccy double precision, new_rental_amount_ccy double precision, old_rental_amount_eur double precision, new_rental_amount_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Rental_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Rental_Counterpart_ID, tab.Rental_Contract_Date, max( case when tab.m_id=-1 then  tab.Rental_Start_Date else null end ) AS old_Rental_Start_Date, max( case when tab.m_id<>-1 then  tab.Rental_Start_Date else null end ) AS new_Rental_Start_Date, max( case when tab.m_id=-1 then  tab.Rental_End_Date else null end ) AS old_Rental_End_Date, max( case when tab.m_id<>-1 then  tab.Rental_End_Date else null end ) AS new_Rental_End_Date, max( case when tab.m_id=-1 then  tab.Rental_Payment_Date else null end ) AS old_Rental_Payment_Date, max( case when tab.m_id<>-1 then  tab.Rental_Payment_Date else null end ) AS new_Rental_Payment_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Rental_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Rental_Currency_ID, max( case when tab.m_id=-1 then  tab.Rental_Amount_CCY else null end ) AS old_Rental_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Rental_Amount_CCY else null end ) AS new_Rental_Amount_CCY, max( case when tab.m_id=-1 then  tab.Rental_Amount_EUR else null end ) AS old_Rental_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Rental_Amount_EUR else null end ) AS new_Rental_Amount_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Rentals AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Rental_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Rental_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Rental_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Rental_Contract_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_rentals(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_repossession(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_repossession(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_npe_currency_id character varying, new_npe_currency_id character varying, old_npe_amount_ccy double precision, new_npe_amount_ccy double precision, old_npe_amount_eur double precision, new_npe_amount_eur double precision, old_llp_amount_ccy double precision, new_llp_amount_ccy double precision, old_llp_amount_eur double precision, new_llp_amount_eur double precision, old_purchase_price_currency_id character varying, new_purchase_price_currency_id character varying, old_appr_purchase_price_net_ccy double precision, new_appr_purchase_price_net_ccy double precision, old_appr_purchase_price_net_eur double precision, new_appr_purchase_price_net_eur double precision, old_purchase_price_net_ccy double precision, new_purchase_price_net_ccy double precision, old_purchase_price_net_eur double precision, new_purchase_price_net_eur double precision, old_purchase_costs_ccy double precision, new_purchase_costs_ccy double precision, old_purchase_costs_eur double precision, new_purchase_costs_eur double precision, old_planned_capex_currency_id integer, new_planned_capex_currency_id integer, old_planned_capex_ccy double precision, new_planned_capex_ccy double precision, old_planned_capex_eur double precision, new_planned_capex_eur double precision, old_planned_capex_comment character varying, new_planned_capex_comment character varying, purchase_auction_date date, old_purchase_contract_date date, new_purchase_contract_date date, old_purchase_repossession_date date, new_purchase_repossession_date date, old_purchase_payment_date date, new_purchase_payment_date date, old_purchase_handover_date date, new_purchase_handover_date date, old_purchase_registration_date date, new_purchase_registration_date date, old_purchase_local_approval_date date, new_purchase_local_approval_date date, old_purchase_central_approval_date date, new_purchase_central_approval_date date, old_purchase_prolongation_date date, new_purchase_prolongation_date date, old_purchase_expected_exit_date date, new_purchase_expected_exit_date date, old_planned_opex_ccy double precision, new_planned_opex_ccy double precision, old_planned_opex_eur double precision, new_planned_opex_eur double precision, old_planned_opex_comment character varying, new_planned_opex_comment character varying, old_planned_salesprice_ccy double precision, new_planned_salesprice_ccy double precision, old_planned_salesprice_eur double precision, new_planned_salesprice_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  Nom_Currencies0.Currency_Code else null end ) AS old_NPE_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies0.Currency_Code else null end ) AS new_NPE_Currency_ID, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Purchase_Price_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Purchase_Price_Currency_ID, max( case when tab.m_id=-1 then  tab.Appr_Purchase_Price_Net_CCY else null end ) AS old_Appr_Purchase_Price_Net_CCY, max( case when tab.m_id<>-1 then  tab.Appr_Purchase_Price_Net_CCY else null end ) AS new_Appr_Purchase_Price_Net_CCY, max( case when tab.m_id=-1 then  tab.Appr_Purchase_Price_Net_EUR else null end ) AS old_Appr_Purchase_Price_Net_EUR, max( case when tab.m_id<>-1 then  tab.Appr_Purchase_Price_Net_EUR else null end ) AS new_Appr_Purchase_Price_Net_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Price_Net_CCY else null end ) AS old_Purchase_Price_Net_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Price_Net_CCY else null end ) AS new_Purchase_Price_Net_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Price_Net_EUR else null end ) AS old_Purchase_Price_Net_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Price_Net_EUR else null end ) AS new_Purchase_Price_Net_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Costs_CCY else null end ) AS old_Purchase_Costs_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Costs_CCY else null end ) AS new_Purchase_Costs_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Costs_EUR else null end ) AS old_Purchase_Costs_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Costs_EUR else null end ) AS new_Purchase_Costs_EUR, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_Currency_ID else null end ) AS old_Planned_CAPEX_Currency_ID, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_Currency_ID else null end ) AS new_Planned_CAPEX_Currency_ID, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_CCY else null end ) AS old_Planned_CAPEX_CCY, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_CCY else null end ) AS new_Planned_CAPEX_CCY, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_EUR else null end ) AS old_Planned_CAPEX_EUR, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_EUR else null end ) AS new_Planned_CAPEX_EUR, max( case when tab.m_id=-1 then  tab.Planned_CAPEX_Comment else null end ) AS old_Planned_CAPEX_Comment, max( case when tab.m_id<>-1 then  tab.Planned_CAPEX_Comment else null end ) AS new_Planned_CAPEX_Comment, tab.Purchase_Auction_Date, max( case when tab.m_id=-1 then  tab.Purchase_Contract_Date else null end ) AS old_Purchase_Contract_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Contract_Date else null end ) AS new_Purchase_Contract_Date, max( case when tab.m_id=-1 then  tab.Purchase_Repossession_Date else null end ) AS old_Purchase_Repossession_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Repossession_Date else null end ) AS new_Purchase_Repossession_Date, max( case when tab.m_id=-1 then  tab.Purchase_Payment_Date else null end ) AS old_Purchase_Payment_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Payment_Date else null end ) AS new_Purchase_Payment_Date, max( case when tab.m_id=-1 then  tab.Purchase_Handover_Date else null end ) AS old_Purchase_Handover_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Handover_Date else null end ) AS new_Purchase_Handover_Date, max( case when tab.m_id=-1 then  tab.Purchase_Registration_Date else null end ) AS old_Purchase_Registration_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Registration_Date else null end ) AS new_Purchase_Registration_Date, max( case when tab.m_id=-1 then  tab.Purchase_Local_Approval_Date else null end ) AS old_Purchase_Local_Approval_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Local_Approval_Date else null end ) AS new_Purchase_Local_Approval_Date, max( case when tab.m_id=-1 then  tab.Purchase_Central_Approval_Date else null end ) AS old_Purchase_Central_Approval_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Central_Approval_Date else null end ) AS new_Purchase_Central_Approval_Date, max( case when tab.m_id=-1 then  tab.Purchase_Prolongation_Date else null end ) AS old_Purchase_Prolongation_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Prolongation_Date else null end ) AS new_Purchase_Prolongation_Date, max( case when tab.m_id=-1 then  tab.Purchase_Expected_Exit_Date else null end ) AS old_Purchase_Expected_Exit_Date, max( case when tab.m_id<>-1 then  tab.Purchase_Expected_Exit_Date else null end ) AS new_Purchase_Expected_Exit_Date, max( case when tab.m_id=-1 then  tab.Planned_OPEX_CCY else null end ) AS old_Planned_OPEX_CCY, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_CCY else null end ) AS new_Planned_OPEX_CCY, max( case when tab.m_id=-1 then  tab.Planned_OPEX_EUR else null end ) AS old_Planned_OPEX_EUR, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_EUR else null end ) AS new_Planned_OPEX_EUR, max( case when tab.m_id=-1 then  tab.Planned_OPEX_Comment else null end ) AS old_Planned_OPEX_Comment, max( case when tab.m_id<>-1 then  tab.Planned_OPEX_Comment else null end ) AS new_Planned_OPEX_Comment, max( case when tab.m_id=-1 then  tab.Planned_SalesPrice_CCY else null end ) AS old_Planned_SalesPrice_CCY, max( case when tab.m_id<>-1 then  tab.Planned_SalesPrice_CCY else null end ) AS new_Planned_SalesPrice_CCY, max( case when tab.m_id=-1 then  tab.Planned_SalesPrice_EUR else null end ) AS old_Planned_SalesPrice_EUR, max( case when tab.m_id<>-1 then  tab.Planned_SalesPrice_EUR else null end ) AS new_Planned_SalesPrice_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Repossession AS tab LEFT JOIN Nom_Currencies AS Nom_Currencies0 ON Nom_Currencies0.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Purchase_Price_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Repossession_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Purchase_Auction_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_repossession(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_asset_sales(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_asset_sales(p_m_id integer) RETURNS TABLE(asset_code character varying, asset_name character varying, old_sale_counterpart_id character varying, new_sale_counterpart_id character varying, sale_approval_date date, old_sale_contract_date date, new_sale_contract_date date, old_sale_transfer_date date, new_sale_transfer_date date, old_sale_payment_date date, new_sale_payment_date date, old_sale_aml_check_date date, new_sale_aml_check_date date, old_sale_aml_pass_date date, new_sale_aml_pass_date date, old_sale_currency_id character varying, new_sale_currency_id character varying, old_sale_approvedamt_ccy double precision, new_sale_approvedamt_ccy double precision, old_sale_approvedamt_eur double precision, new_sale_approvedamt_eur double precision, old_sale_amount_ccy double precision, new_sale_amount_ccy double precision, old_sale_amount_eur double precision, new_sale_amount_eur double precision, old_sale_book_value_ccy double precision, new_sale_book_value_ccy double precision, old_sale_book_value_eur double precision, new_sale_book_value_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.Asset_Code,  case when Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) Is Null then Max(parent.Asset_Name) else Max( case when tab.m_id<>-1 then parent.Asset_Name else Null end ) end  AS Asset_Name, max( case when tab.m_id=-1 then  vwCounterparts0.Descr else null end ) AS old_Sale_Counterpart_ID, max( case when tab.m_id<>-1 then  vwCounterparts0.Descr else null end ) AS new_Sale_Counterpart_ID, tab.Sale_Approval_Date, max( case when tab.m_id=-1 then  tab.Sale_Contract_Date else null end ) AS old_Sale_Contract_Date, max( case when tab.m_id<>-1 then  tab.Sale_Contract_Date else null end ) AS new_Sale_Contract_Date, max( case when tab.m_id=-1 then  tab.Sale_Transfer_Date else null end ) AS old_Sale_Transfer_Date, max( case when tab.m_id<>-1 then  tab.Sale_Transfer_Date else null end ) AS new_Sale_Transfer_Date, max( case when tab.m_id=-1 then  tab.Sale_Payment_Date else null end ) AS old_Sale_Payment_Date, max( case when tab.m_id<>-1 then  tab.Sale_Payment_Date else null end ) AS new_Sale_Payment_Date, max( case when tab.m_id=-1 then  tab.Sale_AML_Check_Date else null end ) AS old_Sale_AML_Check_Date, max( case when tab.m_id<>-1 then  tab.Sale_AML_Check_Date else null end ) AS new_Sale_AML_Check_Date, max( case when tab.m_id=-1 then  tab.Sale_AML_Pass_Date else null end ) AS old_Sale_AML_Pass_Date, max( case when tab.m_id<>-1 then  tab.Sale_AML_Pass_Date else null end ) AS new_Sale_AML_Pass_Date, max( case when tab.m_id=-1 then  Nom_Currencies1.Currency_Code else null end ) AS old_Sale_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies1.Currency_Code else null end ) AS new_Sale_Currency_ID, max( case when tab.m_id=-1 then  tab.Sale_ApprovedAmt_CCY else null end ) AS old_Sale_ApprovedAmt_CCY, max( case when tab.m_id<>-1 then  tab.Sale_ApprovedAmt_CCY else null end ) AS new_Sale_ApprovedAmt_CCY, max( case when tab.m_id=-1 then  tab.Sale_ApprovedAmt_EUR else null end ) AS old_Sale_ApprovedAmt_EUR, max( case when tab.m_id<>-1 then  tab.Sale_ApprovedAmt_EUR else null end ) AS new_Sale_ApprovedAmt_EUR, max( case when tab.m_id=-1 then  tab.Sale_Amount_CCY else null end ) AS old_Sale_Amount_CCY, max( case when tab.m_id<>-1 then  tab.Sale_Amount_CCY else null end ) AS new_Sale_Amount_CCY, max( case when tab.m_id=-1 then  tab.Sale_Amount_EUR else null end ) AS old_Sale_Amount_EUR, max( case when tab.m_id<>-1 then  tab.Sale_Amount_EUR else null end ) AS new_Sale_Amount_EUR, max( case when tab.m_id=-1 then  tab.Sale_Book_Value_CCY else null end ) AS old_Sale_Book_Value_CCY, max( case when tab.m_id<>-1 then  tab.Sale_Book_Value_CCY else null end ) AS new_Sale_Book_Value_CCY, max( case when tab.m_id=-1 then  tab.Sale_Book_Value_EUR else null end ) AS old_Sale_Book_Value_EUR, max( case when tab.m_id<>-1 then  tab.Sale_Book_Value_EUR else null end ) AS new_Sale_Book_Value_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((Asset_Sales AS tab LEFT JOIN vwCounterparts AS vwCounterparts0 ON vwCounterparts0.id=tab.Sale_Counterpart_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies1 ON Nom_Currencies1.id=tab.Sale_Currency_ID) INNER JOIN Assets_List AS parent ON parent.id=tab.Sale_Asset_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.Asset_Code, tab.Sale_Approval_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_asset_sales(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_assets_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_assets_list(p_m_id integer) RETURNS TABLE(asset_code character varying, old_npe_code character varying, new_npe_code character varying, old_asset_name character varying, new_asset_name character varying, old_asset_description character varying, new_asset_description character varying, old_asset_address character varying, new_asset_address character varying, old_asset_zip character varying, new_asset_zip character varying, old_asset_region character varying, new_asset_region character varying, old_asset_country_id character varying, new_asset_country_id character varying, old_asset_usage_id character varying, new_asset_usage_id character varying, old_asset_type_id character varying, new_asset_type_id character varying, old_asset_usable_area double precision, new_asset_usable_area double precision, old_asset_common_area double precision, new_asset_common_area double precision, old_asset_owned character varying, new_asset_owned character varying, old_comment character varying, new_comment character varying, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT tab.Asset_Code, max( case when tab.m_id=-1 then  parent.NPE_Code else null end ) AS old_NPE_Code, max( case when tab.m_id<>-1 then  parent.NPE_Code else null end ) AS new_NPE_Code, max( case when tab.m_id=-1 then  tab.Asset_Name else null end ) AS old_Asset_Name, max( case when tab.m_id<>-1 then  tab.Asset_Name else null end ) AS new_Asset_Name, max( case when tab.m_id=-1 then  tab.Asset_Description else null end ) AS old_Asset_Description, max( case when tab.m_id<>-1 then  tab.Asset_Description else null end ) AS new_Asset_Description, max( case when tab.m_id=-1 then  tab.Asset_Address else null end ) AS old_Asset_Address, max( case when tab.m_id<>-1 then  tab.Asset_Address else null end ) AS new_Asset_Address, max( case when tab.m_id=-1 then  tab.Asset_ZIP else null end ) AS old_Asset_ZIP, max( case when tab.m_id<>-1 then  tab.Asset_ZIP else null end ) AS new_Asset_ZIP, max( case when tab.m_id=-1 then  tab.Asset_Region else null end ) AS old_Asset_Region, max( case when tab.m_id<>-1 then  tab.Asset_Region else null end ) AS new_Asset_Region, max( case when tab.m_id=-1 then  Nom_Countries0.Country_Name else null end ) AS old_Asset_Country_ID, max( case when tab.m_id<>-1 then  Nom_Countries0.Country_Name else null end ) AS new_Asset_Country_ID, max( case when tab.m_id=-1 then  Nom_Asset_Usage1.Asset_Usage_Text else null end ) AS old_Asset_Usage_ID, max( case when tab.m_id<>-1 then  Nom_Asset_Usage1.Asset_Usage_Text else null end ) AS new_Asset_Usage_ID, max( case when tab.m_id=-1 then  Nom_Asset_Type2.Asset_Type_Text else null end ) AS old_Asset_Type_ID, max( case when tab.m_id<>-1 then  Nom_Asset_Type2.Asset_Type_Text else null end ) AS new_Asset_Type_ID, max( case when tab.m_id=-1 then  tab.Asset_Usable_Area else null end ) AS old_Asset_Usable_Area, max( case when tab.m_id<>-1 then  tab.Asset_Usable_Area else null end ) AS new_Asset_Usable_Area, max( case when tab.m_id=-1 then  tab.Asset_Common_Area else null end ) AS old_Asset_Common_Area, max( case when tab.m_id<>-1 then  tab.Asset_Common_Area else null end ) AS new_Asset_Common_Area, max( case when tab.m_id=-1 then  Nom_Asset_Owned3.Asset_Owned else null end ) AS old_Asset_Owned, max( case when tab.m_id<>-1 then  Nom_Asset_Owned3.Asset_Owned else null end ) AS new_Asset_Owned, max( case when tab.m_id=-1 then  tab.Comment else null end ) AS old_Comment, max( case when tab.m_id<>-1 then  tab.Comment else null end ) AS new_Comment,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((((Assets_List AS tab LEFT JOIN Nom_Countries AS Nom_Countries0 ON Nom_Countries0.id=tab.Asset_Country_ID) LEFT JOIN Nom_Asset_Usage AS Nom_Asset_Usage1 ON Nom_Asset_Usage1.id=tab.Asset_Usage_ID) LEFT JOIN Nom_Asset_Type AS Nom_Asset_Type2 ON Nom_Asset_Type2.id=tab.Asset_Type_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned3 ON Nom_Asset_Owned3.id=tab.Asset_Owned) INNER JOIN NPE_List AS parent ON parent.id=tab.Asset_NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.Asset_Code
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_assets_list(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_business_cases(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_business_cases(p_m_id integer) RETURNS TABLE(npe_code character varying, npe_name character varying, bc_date date, old_bc_comment character varying, new_bc_comment character varying, old_bc_purchase_date date, new_bc_purchase_date date, old_bc_purchase_price_eur double precision, new_bc_purchase_price_eur double precision, old_exp_capex_eur double precision, new_exp_capex_eur double precision, old_exp_capex_time date, new_exp_capex_time date, old_exp_sale_date date, new_exp_sale_date date, old_exp_sale_price_eur double precision, new_exp_sale_price_eur double precision, old_exp_interest_eur double precision, new_exp_interest_eur double precision, old_exp_opex_eur double precision, new_exp_opex_eur double precision, old_exp_income_eur double precision, new_exp_income_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.NPE_Code,  case when Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) Is Null then Max(parent.NPE_Name) else Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) end  AS NPE_Name, tab.BC_Date, max( case when tab.m_id=-1 then  tab.BC_Comment else null end ) AS old_BC_Comment, max( case when tab.m_id<>-1 then  tab.BC_Comment else null end ) AS new_BC_Comment, max( case when tab.m_id=-1 then  tab.BC_Purchase_Date else null end ) AS old_BC_Purchase_Date, max( case when tab.m_id<>-1 then  tab.BC_Purchase_Date else null end ) AS new_BC_Purchase_Date, max( case when tab.m_id=-1 then  tab.BC_Purchase_Price_EUR else null end ) AS old_BC_Purchase_Price_EUR, max( case when tab.m_id<>-1 then  tab.BC_Purchase_Price_EUR else null end ) AS new_BC_Purchase_Price_EUR, max( case when tab.m_id=-1 then  tab.Exp_CAPEX_EUR else null end ) AS old_Exp_CAPEX_EUR, max( case when tab.m_id<>-1 then  tab.Exp_CAPEX_EUR else null end ) AS new_Exp_CAPEX_EUR, max( case when tab.m_id=-1 then  tab.Exp_CAPEX_Time else null end ) AS old_Exp_CAPEX_Time, max( case when tab.m_id<>-1 then  tab.Exp_CAPEX_Time else null end ) AS new_Exp_CAPEX_Time, max( case when tab.m_id=-1 then  tab.Exp_Sale_Date else null end ) AS old_Exp_Sale_Date, max( case when tab.m_id<>-1 then  tab.Exp_Sale_Date else null end ) AS new_Exp_Sale_Date, max( case when tab.m_id=-1 then  tab.Exp_Sale_Price_EUR else null end ) AS old_Exp_Sale_Price_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Sale_Price_EUR else null end ) AS new_Exp_Sale_Price_EUR, max( case when tab.m_id=-1 then  tab.Exp_Interest_EUR else null end ) AS old_Exp_Interest_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Interest_EUR else null end ) AS new_Exp_Interest_EUR, max( case when tab.m_id=-1 then  tab.Exp_OPEX_EUR else null end ) AS old_Exp_OPEX_EUR, max( case when tab.m_id<>-1 then  tab.Exp_OPEX_EUR else null end ) AS new_Exp_OPEX_EUR, max( case when tab.m_id=-1 then  tab.Exp_Income_EUR else null end ) AS old_Exp_Income_EUR, max( case when tab.m_id<>-1 then  tab.Exp_Income_EUR else null end ) AS new_Exp_Income_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM Business_Cases AS tab INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.BC_Date
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_business_cases(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_npe_history(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_npe_history(p_m_id integer) RETURNS TABLE(npe_code character varying, npe_name character varying, rep_date date, old_npe_status_id character varying, new_npe_status_id character varying, npe_scenario_id character varying, old_npe_rep_date date, new_npe_rep_date date, old_npe_currency character varying, new_npe_currency character varying, old_npe_amount_ccy double precision, new_npe_amount_ccy double precision, old_npe_amount_eur double precision, new_npe_amount_eur double precision, old_llp_amount_ccy double precision, new_llp_amount_ccy double precision, old_llp_amount_eur double precision, new_llp_amount_eur double precision, old_purchase_price_ccy double precision, new_purchase_price_ccy double precision, old_purchase_price_eur double precision, new_purchase_price_eur double precision, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT parent.NPE_Code,  case when Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) Is Null then Max(parent.NPE_Name) else Max( case when tab.m_id<>-1 then parent.NPE_Name else Null end ) end  AS NPE_Name, tab.Rep_Date, max( case when tab.m_id=-1 then  Nom_NPE_Status0.NPE_Status_Code else null end ) AS old_NPE_Status_ID, max( case when tab.m_id<>-1 then  Nom_NPE_Status0.NPE_Status_Code else null end ) AS new_NPE_Status_ID, Nom_Scenarios1.Scenario_Name AS NPE_Scenario_ID, max( case when tab.m_id=-1 then  tab.NPE_Rep_Date else null end ) AS old_NPE_Rep_Date, max( case when tab.m_id<>-1 then  tab.NPE_Rep_Date else null end ) AS new_NPE_Rep_Date, max( case when tab.m_id=-1 then  tab.NPE_Currency else null end ) AS old_NPE_Currency, max( case when tab.m_id<>-1 then  tab.NPE_Currency else null end ) AS new_NPE_Currency, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  tab.Purchase_Price_CCY else null end ) AS old_Purchase_Price_CCY, max( case when tab.m_id<>-1 then  tab.Purchase_Price_CCY else null end ) AS new_Purchase_Price_CCY, max( case when tab.m_id=-1 then  tab.Purchase_Price_EUR else null end ) AS old_Purchase_Price_EUR, max( case when tab.m_id<>-1 then  tab.Purchase_Price_EUR else null end ) AS new_Purchase_Price_EUR,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM ((NPE_History AS tab LEFT JOIN Nom_NPE_Status AS Nom_NPE_Status0 ON Nom_NPE_Status0.id=tab.NPE_Status_ID) LEFT JOIN Nom_Scenarios AS Nom_Scenarios1 ON Nom_Scenarios1.id=tab.NPE_Scenario_ID) INNER JOIN NPE_List AS parent ON parent.id=tab.NPE_ID
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY parent.NPE_Code, tab.Rep_Date, Nom_Scenarios1.Scenario_Name
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_npe_history(p_m_id integer) OWNER TO postgres;

--
-- Name: sel_npe_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sel_npe_list(p_m_id integer) RETURNS TABLE(npe_code character varying, old_npe_scenario_id character varying, new_npe_scenario_id character varying, old_npe_country_id character varying, new_npe_country_id character varying, old_npe_name character varying, new_npe_name character varying, old_npe_description character varying, new_npe_description character varying, old_npe_lender_id character varying, new_npe_lender_id character varying, old_npe_borrower_id character varying, new_npe_borrower_id character varying, old_npe_currency_id character varying, new_npe_currency_id character varying, old_npe_amount_date date, new_npe_amount_date date, old_npe_amount_ccy double precision, new_npe_amount_ccy double precision, old_npe_amount_eur double precision, new_npe_amount_eur double precision, old_llp_amount_ccy double precision, new_llp_amount_ccy double precision, old_llp_amount_eur double precision, new_llp_amount_eur double precision, old_npe_owned character varying, new_npe_owned character varying, record_status character varying)
    LANGUAGE sql
    AS $$
SELECT tab.NPE_Code, max( case when tab.m_id=-1 then  Nom_Scenarios0.Scenario_Name else null end ) AS old_NPE_Scenario_ID, max( case when tab.m_id<>-1 then  Nom_Scenarios0.Scenario_Name else null end ) AS new_NPE_Scenario_ID, max( case when tab.m_id=-1 then  Nom_Countries1.Country_Name else null end ) AS old_NPE_Country_ID, max( case when tab.m_id<>-1 then  Nom_Countries1.Country_Name else null end ) AS new_NPE_Country_ID, max( case when tab.m_id=-1 then  tab.NPE_Name else null end ) AS old_NPE_Name, max( case when tab.m_id<>-1 then  tab.NPE_Name else null end ) AS new_NPE_Name, max( case when tab.m_id=-1 then  tab.NPE_Description else null end ) AS old_NPE_Description, max( case when tab.m_id<>-1 then  tab.NPE_Description else null end ) AS new_NPE_Description, max( case when tab.m_id=-1 then  vwCounterparts2.Descr else null end ) AS old_NPE_Lender_ID, max( case when tab.m_id<>-1 then  vwCounterparts2.Descr else null end ) AS new_NPE_Lender_ID, max( case when tab.m_id=-1 then  vwCounterparts3.Descr else null end ) AS old_NPE_Borrower_ID, max( case when tab.m_id<>-1 then  vwCounterparts3.Descr else null end ) AS new_NPE_Borrower_ID, max( case when tab.m_id=-1 then  Nom_Currencies4.Currency_Code else null end ) AS old_NPE_Currency_ID, max( case when tab.m_id<>-1 then  Nom_Currencies4.Currency_Code else null end ) AS new_NPE_Currency_ID, max( case when tab.m_id=-1 then  tab.NPE_Amount_Date else null end ) AS old_NPE_Amount_Date, max( case when tab.m_id<>-1 then  tab.NPE_Amount_Date else null end ) AS new_NPE_Amount_Date, max( case when tab.m_id=-1 then  tab.NPE_Amount_CCY else null end ) AS old_NPE_Amount_CCY, max( case when tab.m_id<>-1 then  tab.NPE_Amount_CCY else null end ) AS new_NPE_Amount_CCY, max( case when tab.m_id=-1 then  tab.NPE_Amount_EUR else null end ) AS old_NPE_Amount_EUR, max( case when tab.m_id<>-1 then  tab.NPE_Amount_EUR else null end ) AS new_NPE_Amount_EUR, max( case when tab.m_id=-1 then  tab.LLP_Amount_CCY else null end ) AS old_LLP_Amount_CCY, max( case when tab.m_id<>-1 then  tab.LLP_Amount_CCY else null end ) AS new_LLP_Amount_CCY, max( case when tab.m_id=-1 then  tab.LLP_Amount_EUR else null end ) AS old_LLP_Amount_EUR, max( case when tab.m_id<>-1 then  tab.LLP_Amount_EUR else null end ) AS new_LLP_Amount_EUR, max( case when tab.m_id=-1 then  Nom_Asset_Owned5.Asset_Owned else null end ) AS old_NPE_Owned, max( case when tab.m_id<>-1 then  Nom_Asset_Owned5.Asset_Owned else null end ) AS new_NPE_Owned,  case when min(tab.m_ID)>-1 then 'New' else '' end  AS Record_Status
FROM (((((NPE_List AS tab LEFT JOIN Nom_Scenarios AS Nom_Scenarios0 ON Nom_Scenarios0.id=tab.NPE_Scenario_ID) LEFT JOIN Nom_Countries AS Nom_Countries1 ON Nom_Countries1.id=tab.NPE_Country_ID) LEFT JOIN vwCounterparts AS vwCounterparts2 ON vwCounterparts2.id=tab.NPE_Lender_ID) LEFT JOIN vwCounterparts AS vwCounterparts3 ON vwCounterparts3.id=tab.NPE_Borrower_ID) LEFT JOIN Nom_Currencies AS Nom_Currencies4 ON Nom_Currencies4.id=tab.NPE_Currency_ID) LEFT JOIN Nom_Asset_Owned AS Nom_Asset_Owned5 ON Nom_Asset_Owned5.id=tab.NPE_Owned
WHERE tab.m_id in (p_m_ID,-1)
GROUP BY tab.NPE_Code
HAVING max(tab.m_id)>-1;

$$;


ALTER FUNCTION public.sel_npe_list(p_m_id integer) OWNER TO postgres;

--
-- Name: upd_npe_list(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_npe_list(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
UPDATE NPE_List AS dw_tab
SET NPE_Scenario_ID =  case when new_tab.NPE_Scenario_ID is null then dw_tab.NPE_Scenario_ID else new_tab.NPE_Scenario_ID end , NPE_Country_ID =  case when new_tab.NPE_Country_ID is null then dw_tab.NPE_Country_ID else new_tab.NPE_Country_ID end , NPE_Name =  case when new_tab.NPE_Name is null then dw_tab.NPE_Name else new_tab.NPE_Name end , NPE_Description =  case when new_tab.NPE_Description is null then dw_tab.NPE_Description else new_tab.NPE_Description end , NPE_Lender_ID =  case when new_tab.NPE_Lender_ID is null then dw_tab.NPE_Lender_ID else new_tab.NPE_Lender_ID end , NPE_Borrower_ID =  case when new_tab.NPE_Borrower_ID is null then dw_tab.NPE_Borrower_ID else new_tab.NPE_Borrower_ID end , NPE_Currency_ID =  case when new_tab.NPE_Currency_ID is null then dw_tab.NPE_Currency_ID else new_tab.NPE_Currency_ID end , NPE_Amount_Date =  case when new_tab.NPE_Amount_Date is null then dw_tab.NPE_Amount_Date else new_tab.NPE_Amount_Date end , NPE_Amount_CCY =  case when new_tab.NPE_Amount_CCY is null then dw_tab.NPE_Amount_CCY else new_tab.NPE_Amount_CCY end , NPE_Amount_EUR =  case when new_tab.NPE_Amount_EUR is null then dw_tab.NPE_Amount_EUR else new_tab.NPE_Amount_EUR end , LLP_Amount_CCY =  case when new_tab.LLP_Amount_CCY is null then dw_tab.LLP_Amount_CCY else new_tab.LLP_Amount_CCY end , LLP_Amount_EUR =  case when new_tab.LLP_Amount_EUR is null then dw_tab.LLP_Amount_EUR else new_tab.LLP_Amount_EUR end , NPE_Owned =  case when new_tab.NPE_Owned is null then dw_tab.NPE_Owned else new_tab.NPE_Owned end 
FROM NPE_List AS new_tab 
WHERE dw_tab.NPE_Code=new_tab.NPE_Code
AND new_tab.m_id = p_m_ID and dw_tab.m_id=-1;

$$;


ALTER FUNCTION public.upd_npe_list(p_m_id integer) OWNER TO postgres;

--
-- Name: upd_old_linked_mails_reject(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_old_linked_mails_reject(p_m_id integer) RETURNS void
    LANGUAGE sql
    AS $$
UPDATE Mail_Log SET mailStatus = 3
WHERE (((Mail_Log.ID) In (select old_m_id from vw_old_linked_mails(p_m_ID))));

$$;


ALTER FUNCTION public.upd_old_linked_mails_reject(p_m_id integer) OWNER TO postgres;

--
-- Name: vw_mail_auth_sender(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vw_mail_auth_sender(p_msender character varying, p_m_id integer) RETURNS TABLE(object_code character varying)
    LANGUAGE sql
    AS $$
SELECT vw_Mail_Objects.Object_Code
FROM vw_Mail_Objects
WHERE (((vw_Mail_Objects.m_ID)=p_m_ID) AND ((Not Exists (select country_code from vwUserCountry where country_code = object_country and email=p_mSender))=True))
GROUP BY vw_Mail_Objects.Object_Code;

$$;


ALTER FUNCTION public.vw_mail_auth_sender(p_msender character varying, p_m_id integer) OWNER TO postgres;

--
-- Name: vw_npe_shifts(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vw_npe_shifts(p_base_year integer, p_comp_scenario integer, p_base_scenario integer) RETURNS TABLE(rep_year double precision, base_npe double precision, comp_npe double precision, shift_npe double precision, new_npe double precision, delta_npe double precision)
    LANGUAGE sql
    AS $$
SELECT inn.rep_year
	, Sum(inn.baseNpe) AS Base_NPE
	, Sum(inn.compNpe) AS Comp_NPE
	, Sum(inn.ShiftNPE) AS Shift_NPE
	, Sum(inn.compNpe)-Sum(inn.baseNpe)-Sum(inn.ShiftNPE) AS New_NPE, Sum(inn.compNpe)-Sum(inn.baseNpe) AS Delta_NPE
FROM (SELECT  case when ver='Original' then extract(year from NPE_Rep_Date) else (select  case when ver='ShiftedTo' then extract(year from s.npe_rep_date) else p_base_year end  as shift_year from npe_history s where s.npe_scenario_id=p_comp_scenario and extract(year from s.npe_rep_date)<>p_base_year and s.npe_id=npe_history.npe_id) end  AS Rep_Year, ( case when npe_scenario_id=p_base_scenario And ver='Original' then npe_amount_eur else 0 end ) AS BaseNPE, ( case when npe_scenario_id=p_comp_scenario And ver='Original' then npe_amount_eur else 0 end ) AS CompNPE, ( case when npe_scenario_id=p_base_scenario And ver<>'Original' then npe_amount_eur*Sign else 0 end ) AS ShiftNPE, ver, npe_id FROM NPE_History, Orig_Shifted WHERE (((NPE_History.NPE_Scenario_ID) In (p_base_scenario,p_comp_scenario)) And ((NPE_History.NPE_Amount_EUR)<>0)) And Not (npe_scenario_id=p_base_scenario And ver<>'Original' And extract(year from npe_rep_date)<>p_base_year))  AS inn
WHERE (((inn.rep_year) Is Not Null))
GROUP BY inn.rep_year;

$$;


ALTER FUNCTION public.vw_npe_shifts(p_base_year integer, p_comp_scenario integer, p_base_scenario integer) OWNER TO postgres;

--
-- Name: vw_old_linked_mails(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vw_old_linked_mails(p_m_id integer) RETURNS TABLE(m_id integer, old_m_id integer)
    LANGUAGE sql
    AS $$
SELECT vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID AS old_m_ID
FROM vw_Mail_Objects INNER JOIN vw_Mail_Objects AS vw_Mail_Objects_1 ON vw_Mail_Objects.Object_Code = vw_Mail_Objects_1.Object_Code
WHERE (((vw_Mail_Objects.m_ID)<>-1) And ((vw_Mail_Objects_1.m_ID)<>vw_Mail_Objects.m_ID And (vw_Mail_Objects_1.m_ID)<>-1) And ((vw_Mail_Objects.m_ID)=p_m_ID))
GROUP BY vw_Mail_Objects.m_ID, vw_Mail_Objects_1.m_ID;

$$;


ALTER FUNCTION public.vw_old_linked_mails(p_m_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Gift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Gift" (
    "Item" character varying,
    "givingDate" date,
    id numeric,
    "createTime" timestamp with time zone,
    "modifyTime" time with time zone
);


ALTER TABLE "Gift" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "User" (
    "Name" character varying,
    "modifyTime" timestamp with time zone,
    "createTime" timestamp with time zone,
    "passwordHash" character varying,
    role_admin character varying,
    username character varying,
    id numeric
);


ALTER TABLE "User" OWNER TO postgres;

--
-- Name: asset_appraisals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_appraisals (
    id integer NOT NULL,
    appraisal_asset_id integer,
    appraisal_company_id integer,
    appraisal_date date,
    appraisal_currency_id integer,
    appraisal_market_value_ccy double precision,
    appraisal_market_value_eur double precision,
    appraisal_firesale_value_ccy double precision,
    appraisal_firesale_value_eur double precision,
    appraisal_order integer,
    m_id integer
);


ALTER TABLE asset_appraisals OWNER TO postgres;

--
-- Name: asset_appraisals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_appraisals_id_seq
    START WITH 17699
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_appraisals_id_seq OWNER TO postgres;

--
-- Name: asset_appraisals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_appraisals_id_seq OWNED BY asset_appraisals.id;


--
-- Name: asset_financials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_financials (
    id integer NOT NULL,
    asset_id integer,
    acc_date date,
    account_no character varying(255),
    account_name character varying(255),
    amount integer,
    trans_type_id integer,
    rep_date date,
    m_id integer
);


ALTER TABLE asset_financials OWNER TO postgres;

--
-- Name: asset_financing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_financing (
    id integer NOT NULL,
    financing_contract_code character varying(20),
    financing_counterpart_id integer,
    financing_asset_id integer,
    financing_type_id integer,
    financing_currency_id integer,
    financing_amount_ccy double precision,
    financing_amount_eur double precision,
    financing_reference_rate character varying(20),
    financing_margin double precision,
    financing_rate double precision,
    financing_start_date date,
    financing_end_date date,
    financing_contract_date date,
    m_id integer
);


ALTER TABLE asset_financing OWNER TO postgres;

--
-- Name: asset_financing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_financing_id_seq
    START WITH 42037
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_financing_id_seq OWNER TO postgres;

--
-- Name: asset_financing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_financing_id_seq OWNED BY asset_financing.id;


--
-- Name: asset_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_history (
    id integer NOT NULL,
    asset_id integer,
    rep_date date,
    status_code integer,
    currency_id integer,
    book_value_pm double precision,
    inflows double precision,
    capex double precision,
    depreciation double precision,
    sales double precision,
    imp_wb double precision,
    book_value double precision,
    costs double precision,
    income double precision,
    expected_exit date,
    m_id integer
);


ALTER TABLE asset_history OWNER TO postgres;

--
-- Name: asset_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_history_id_seq
    START WITH 3678
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_history_id_seq OWNER TO postgres;

--
-- Name: asset_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_history_id_seq OWNED BY asset_history.id;


--
-- Name: asset_insurances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_insurances (
    id integer NOT NULL,
    insurance_asset_id integer,
    insurance_company_id integer,
    insurance_start_date date,
    insurance_end_date date,
    insurance_currency_id integer,
    insurance_amount_ccy double precision,
    insurance_amount_eur double precision,
    insurance_premium_ccy double precision,
    insurance_premium_eur double precision,
    m_id integer
);


ALTER TABLE asset_insurances OWNER TO postgres;

--
-- Name: asset_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_insurances_id_seq
    START WITH 13629
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_insurances_id_seq OWNER TO postgres;

--
-- Name: asset_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_insurances_id_seq OWNED BY asset_insurances.id;


--
-- Name: asset_rentals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_rentals (
    id integer NOT NULL,
    rental_asset_id integer,
    rental_counterpart_id integer,
    rental_contract_date date,
    rental_start_date date,
    rental_end_date date,
    rental_payment_date date,
    rental_currency_id integer,
    rental_amount_ccy double precision,
    rental_amount_eur double precision,
    m_id integer
);


ALTER TABLE asset_rentals OWNER TO postgres;

--
-- Name: asset_rentals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_rentals_id_seq
    START WITH 8916
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_rentals_id_seq OWNER TO postgres;

--
-- Name: asset_rentals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_rentals_id_seq OWNED BY asset_rentals.id;


--
-- Name: asset_repossession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_repossession (
    id integer NOT NULL,
    repossession_asset_id integer,
    npe_currency_id integer,
    npe_amount_ccy double precision,
    npe_amount_eur double precision,
    llp_amount_ccy double precision,
    llp_amount_eur double precision,
    purchase_price_currency_id integer,
    appr_purchase_price_net_ccy double precision,
    appr_purchase_price_net_eur double precision,
    purchase_price_net_ccy double precision,
    purchase_price_net_eur double precision,
    purchase_costs_ccy double precision,
    purchase_costs_eur double precision,
    planned_capex_currency_id integer,
    planned_capex_ccy double precision,
    planned_capex_eur double precision,
    planned_capex_comment character varying(255),
    purchase_auction_date date,
    purchase_contract_date date,
    purchase_repossession_date date,
    purchase_payment_date date,
    purchase_handover_date date,
    purchase_registration_date date,
    purchase_local_approval_date date,
    purchase_central_approval_date date,
    purchase_prolongation_date date,
    purchase_expected_exit_date date,
    planned_opex_ccy double precision,
    planned_opex_eur double precision,
    planned_opex_comment character varying(255),
    planned_salesprice_ccy double precision,
    planned_salesprice_eur double precision,
    m_id integer
);


ALTER TABLE asset_repossession OWNER TO postgres;

--
-- Name: asset_repossession_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_repossession_id_seq
    START WITH 19917
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_repossession_id_seq OWNER TO postgres;

--
-- Name: asset_repossession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_repossession_id_seq OWNED BY asset_repossession.id;


--
-- Name: asset_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asset_sales (
    id integer NOT NULL,
    sale_asset_id integer,
    sale_counterpart_id integer,
    sale_approval_date date,
    sale_contract_date date,
    sale_transfer_date date,
    sale_payment_date date,
    sale_aml_check_date date,
    sale_aml_pass_date date,
    sale_currency_id integer,
    sale_approvedamt_ccy double precision,
    sale_approvedamt_eur double precision,
    sale_amount_ccy double precision,
    sale_amount_eur double precision,
    sale_book_value_ccy double precision,
    sale_book_value_eur double precision,
    m_id integer
);


ALTER TABLE asset_sales OWNER TO postgres;

--
-- Name: asset_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE asset_sales_id_seq
    START WITH 14916
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset_sales_id_seq OWNER TO postgres;

--
-- Name: asset_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE asset_sales_id_seq OWNED BY asset_sales.id;


--
-- Name: assets_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE assets_list (
    id integer NOT NULL,
    asset_code character varying(12),
    asset_npe_id integer,
    asset_name character varying(255),
    asset_description character varying(255),
    asset_address character varying(255),
    asset_zip character varying(255),
    asset_region character varying(255),
    asset_country_id integer,
    asset_usage_id integer,
    asset_type_id integer,
    asset_usable_area double precision,
    asset_common_area double precision,
    asset_owned integer,
    comment character varying(255),
    m_id integer
);


ALTER TABLE assets_list OWNER TO postgres;

--
-- Name: assets_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE assets_list_id_seq
    START WITH 21264
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE assets_list_id_seq OWNER TO postgres;

--
-- Name: assets_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE assets_list_id_seq OWNED BY assets_list.id;


--
-- Name: business_cases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE business_cases (
    id integer NOT NULL,
    npe_id integer,
    bc_date date,
    bc_comment character varying(2000),
    bc_purchase_date date,
    bc_purchase_price_eur double precision,
    exp_capex_eur double precision,
    exp_capex_time date,
    exp_sale_date date,
    exp_sale_price_eur double precision,
    exp_interest_eur double precision,
    exp_opex_eur double precision,
    exp_income_eur double precision,
    m_id integer
);


ALTER TABLE business_cases OWNER TO postgres;

--
-- Name: calendar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE calendar (
    id integer NOT NULL,
    rep_date date,
    prev_date date,
    send_date date,
    confirm_date date
);


ALTER TABLE calendar OWNER TO postgres;

--
-- Name: counterparts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE counterparts (
    id integer NOT NULL,
    counterpart_common_name character varying(255),
    counterpart_first_name character varying(255),
    counterpart_last_name character varying(255),
    counterpart_company_name character varying(255),
    counterpart_type character varying(255)
);


ALTER TABLE counterparts OWNER TO postgres;

--
-- Name: counterparts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE counterparts_id_seq
    START WITH 1349
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE counterparts_id_seq OWNER TO postgres;

--
-- Name: counterparts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE counterparts_id_seq OWNED BY counterparts.id;


--
-- Name: drop_dup_repos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE drop_dup_repos (
    repossession_asset_id integer,
    m_id integer,
    "count��id" integer
);


ALTER TABLE drop_dup_repos OWNER TO postgres;

--
-- Name: file_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE file_log (
    id integer NOT NULL,
    m_id integer,
    filename character varying(255),
    filestatus smallint,
    reple character varying(255),
    repdate date
);


ALTER TABLE file_log OWNER TO postgres;

--
-- Name: file_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE file_log_id_seq
    START WITH 149
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE file_log_id_seq OWNER TO postgres;

--
-- Name: file_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE file_log_id_seq OWNED BY file_log.id;


--
-- Name: fx_rates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE fx_rates (
    id integer,
    ccy_code character varying(255) NOT NULL,
    scenario character varying(255) NOT NULL,
    repdate date NOT NULL,
    fx_rate_avg double precision,
    fx_rate_eop double precision
);


ALTER TABLE fx_rates OWNER TO postgres;

--
-- Name: import_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE import_mapping (
    id integer NOT NULL,
    sheet_name character varying(255),
    column_no integer,
    column_name character varying(255),
    target_table character varying(255),
    target_field character varying(255),
    lookup_table character varying(255),
    lookup_field character varying(255),
    condition character varying(255),
    key character varying(255),
    updatemode character varying(255)
);


ALTER TABLE import_mapping OWNER TO postgres;

--
-- Name: lastdate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE lastdate (
    prevmonth date NOT NULL,
    currmonth date,
    begyear date
);


ALTER TABLE lastdate OWNER TO postgres;

--
-- Name: legal_entities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE legal_entities (
    id integer NOT NULL,
    tagetik_code character varying(255),
    le_name character varying(255),
    le_country_id integer,
    active integer
);


ALTER TABLE legal_entities OWNER TO postgres;

--
-- Name: lst_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE lst_reports (
    id integer NOT NULL,
    report_code character varying(255),
    report_name character varying(255),
    template_filename character varying(255)
);


ALTER TABLE lst_reports OWNER TO postgres;

--
-- Name: lst_sheets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE lst_sheets (
    id integer NOT NULL,
    report_id integer,
    sheet_name character varying(255),
    sheet_title character varying(255),
    sheet_query character varying(255),
    sheet_columns character varying(2000)
);


ALTER TABLE lst_sheets OWNER TO postgres;

--
-- Name: mail_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mail_log (
    id integer NOT NULL,
    sender character varying(255),
    receiver character varying(255),
    subject character varying(255),
    mailstatus smallint,
    authstatus smallint,
    answertext character varying(2000),
    answerrecipients character varying(255),
    body text
);


ALTER TABLE mail_log OWNER TO postgres;

--
-- Name: mail_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mail_log_id_seq
    START WITH 387
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mail_log_id_seq OWNER TO postgres;

--
-- Name: mail_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mail_log_id_seq OWNED BY mail_log.id;


--
-- Name: mail_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mail_queue (
    id integer NOT NULL,
    mrecipients character varying(255),
    mcc character varying(255),
    msubject character varying(255),
    mbody text,
    mattachments character varying(255),
    mstatus smallint,
    mdate date
);


ALTER TABLE mail_queue OWNER TO postgres;

--
-- Name: mail_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mail_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mail_queue_id_seq OWNER TO postgres;

--
-- Name: mail_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mail_queue_id_seq OWNED BY mail_queue.id;


--
-- Name: meta_ccy_conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE meta_ccy_conversion (
    id integer NOT NULL,
    ref_date_col character varying(255),
    ref_date_add_col character varying(255),
    ccy_id_col character varying(255),
    ccy_amount_col character varying(255),
    eur_amount_col character varying(255),
    table_name character varying(255),
    asset_id_col character varying(255)
);


ALTER TABLE meta_ccy_conversion OWNER TO postgres;

--
-- Name: meta_updatable_tables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE meta_updatable_tables (
    id integer NOT NULL,
    table_name character varying(255),
    parent_table character varying(255),
    parent_id character varying(255),
    parent_code character varying(255),
    key character varying(255),
    del_key character varying(255),
    add_fields character varying(255),
    sheet_name character varying(255),
    fields_list character varying(2000)
);


ALTER TABLE meta_updatable_tables OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE migrations (
    name character varying,
    "modifyTime" timestamp with time zone
);


ALTER TABLE migrations OWNER TO postgres;

--
-- Name: nom_asset_owned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_asset_owned (
    id integer NOT NULL,
    asset_owned character varying(255)
);


ALTER TABLE nom_asset_owned OWNER TO postgres;

--
-- Name: nom_asset_owned_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_asset_owned_id_seq
    START WITH 93
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_asset_owned_id_seq OWNER TO postgres;

--
-- Name: nom_asset_owned_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_asset_owned_id_seq OWNED BY nom_asset_owned.id;


--
-- Name: nom_asset_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_asset_status (
    id integer NOT NULL,
    asset_status_code character varying(20),
    asset_status_text character varying(50)
);


ALTER TABLE nom_asset_status OWNER TO postgres;

--
-- Name: nom_asset_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_asset_status_id_seq
    START WITH 13
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_asset_status_id_seq OWNER TO postgres;

--
-- Name: nom_asset_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_asset_status_id_seq OWNED BY nom_asset_status.id;


--
-- Name: nom_asset_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_asset_type (
    id integer NOT NULL,
    asset_type_text character varying(255)
);


ALTER TABLE nom_asset_type OWNER TO postgres;

--
-- Name: nom_asset_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_asset_type_id_seq
    START WITH 134
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_asset_type_id_seq OWNER TO postgres;

--
-- Name: nom_asset_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_asset_type_id_seq OWNED BY nom_asset_type.id;


--
-- Name: nom_asset_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_asset_usage (
    id integer NOT NULL,
    asset_usage_text character varying(255)
);


ALTER TABLE nom_asset_usage OWNER TO postgres;

--
-- Name: nom_asset_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_asset_usage_id_seq
    START WITH 16
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_asset_usage_id_seq OWNER TO postgres;

--
-- Name: nom_asset_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_asset_usage_id_seq OWNED BY nom_asset_usage.id;


--
-- Name: nom_countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_countries (
    id integer NOT NULL,
    country_name character varying(20),
    country_full_name character varying(50),
    country_local_name character varying(50),
    country_code character varying(2),
    currency_id integer,
    country_code3 character varying(3),
    mis_code character varying(2)
);


ALTER TABLE nom_countries OWNER TO postgres;

--
-- Name: nom_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_countries_id_seq
    START WITH 75
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_countries_id_seq OWNER TO postgres;

--
-- Name: nom_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_countries_id_seq OWNED BY nom_countries.id;


--
-- Name: nom_currencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_currencies (
    id integer NOT NULL,
    currency_code character varying(255),
    currency_name character varying(255),
    currency_symbol character varying(3),
    fixed_rate double precision
);


ALTER TABLE nom_currencies OWNER TO postgres;

--
-- Name: nom_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_currencies_id_seq
    START WITH 17
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_currencies_id_seq OWNER TO postgres;

--
-- Name: nom_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_currencies_id_seq OWNED BY nom_currencies.id;


--
-- Name: nom_financing_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_financing_type (
    id integer NOT NULL,
    financing_type character varying(10)
);


ALTER TABLE nom_financing_type OWNER TO postgres;

--
-- Name: nom_financing_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_financing_type_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_financing_type_id_seq OWNER TO postgres;

--
-- Name: nom_financing_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_financing_type_id_seq OWNED BY nom_financing_type.id;


--
-- Name: nom_log_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_log_types (
    id integer NOT NULL,
    descr character varying(255),
    color character varying(255)
);


ALTER TABLE nom_log_types OWNER TO postgres;

--
-- Name: nom_npe_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_npe_status (
    id integer NOT NULL,
    npe_status_code character varying(10),
    npe_status_text character varying(50),
    npe_parent_status character varying(255)
);


ALTER TABLE nom_npe_status OWNER TO postgres;

--
-- Name: nom_npe_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nom_npe_status_id_seq
    START WITH 22
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nom_npe_status_id_seq OWNER TO postgres;

--
-- Name: nom_npe_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nom_npe_status_id_seq OWNED BY nom_npe_status.id;


--
-- Name: nom_scenarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_scenarios (
    id integer NOT NULL,
    scenario_name character varying(50)
);


ALTER TABLE nom_scenarios OWNER TO postgres;

--
-- Name: nom_transaction_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nom_transaction_types (
    id integer NOT NULL,
    transaction_code character varying(255)
);


ALTER TABLE nom_transaction_types OWNER TO postgres;

--
-- Name: npe_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE npe_history (
    id integer NOT NULL,
    npe_id integer,
    rep_date date,
    npe_status_id integer,
    npe_scenario_id integer,
    npe_rep_date date,
    npe_currency character varying(255),
    npe_amount_ccy double precision,
    npe_amount_eur double precision,
    llp_amount_ccy double precision,
    llp_amount_eur double precision,
    purchase_price_ccy double precision,
    purchase_price_eur double precision,
    m_id integer
);


ALTER TABLE npe_history OWNER TO postgres;

--
-- Name: npe_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE npe_history_id_seq
    START WITH 13081
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE npe_history_id_seq OWNER TO postgres;

--
-- Name: npe_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE npe_history_id_seq OWNED BY npe_history.id;


--
-- Name: npe_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE npe_list (
    id integer NOT NULL,
    npe_code character varying(255),
    npe_scenario_id integer,
    npe_country_id integer,
    npe_name character varying(255),
    npe_description character varying(255),
    npe_lender_id integer,
    npe_borrower_id integer,
    npe_currency_id integer,
    npe_amount_date date,
    npe_amount_ccy double precision,
    npe_amount_eur double precision,
    llp_amount_ccy double precision,
    llp_amount_eur double precision,
    npe_owned integer,
    m_id integer,
    le_id integer
);


ALTER TABLE npe_list OWNER TO postgres;

--
-- Name: npe_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE npe_list_id_seq
    START WITH 5619
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE npe_list_id_seq OWNER TO postgres;

--
-- Name: npe_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE npe_list_id_seq OWNED BY npe_list.id;


--
-- Name: orig_shifted; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE orig_shifted (
    ver character varying(255),
    sign integer
);


ALTER TABLE orig_shifted OWNER TO postgres;

--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE reports (
    id integer NOT NULL,
    report_name character varying(255),
    report_query character varying(255)
);


ALTER TABLE reports OWNER TO postgres;

--
-- Name: sheet1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sheet1 (
    f1 character varying(255),
    f2 character varying(255),
    f3 character varying(255),
    f4 character varying(255),
    f5 character varying(255),
    f6 character varying(255)
);


ALTER TABLE sheet1 OWNER TO postgres;

--
-- Name: sst_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sst_log (
    id integer NOT NULL,
    log_date timestamp without time zone,
    log_source character varying(255),
    log_text text,
    log_type integer,
    mail_id integer
);


ALTER TABLE sst_log OWNER TO postgres;

--
-- Name: sst_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sst_log_id_seq
    START WITH 50493
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sst_log_id_seq OWNER TO postgres;

--
-- Name: sst_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sst_log_id_seq OWNED BY sst_log.id;


--
-- Name: update_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE update_log (
    id integer NOT NULL,
    table_name character varying(255),
    r_id integer,
    column_name character varying(255),
    old_value character varying(255),
    new_value character varying(255),
    upd_time date
);


ALTER TABLE update_log OWNER TO postgres;

--
-- Name: update_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE update_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE update_log_id_seq OWNER TO postgres;

--
-- Name: update_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE update_log_id_seq OWNED BY update_log.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id integer,
    email character varying(255) NOT NULL,
    fullname character varying(255),
    le_id integer NOT NULL,
    role smallint,
    firstname character varying(255),
    lastname character varying(255),
    username character varying(255)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: vw_appr_periods; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_appr_periods AS
 SELECT assets_list.id,
        CASE
            WHEN (
            CASE
                WHEN (asset_history.book_value IS NULL) THEN
                CASE
                    WHEN (asset_repossession.purchase_price_net_eur IS NULL) THEN (2000000)::double precision
                    ELSE asset_repossession.purchase_price_net_eur
                END
                ELSE asset_history.book_value
            END < (1000000)::double precision) THEN 36
            WHEN (
            CASE
                WHEN (asset_history.book_value IS NULL) THEN
                CASE
                    WHEN (asset_repossession.purchase_price_net_eur IS NULL) THEN (2000000)::double precision
                    ELSE asset_repossession.purchase_price_net_eur
                END
                ELSE asset_history.book_value
            END < (1500000)::double precision) THEN 24
            ELSE 12
        END AS appraisalperiod
   FROM (npe_list
     JOIN ((assets_list
     JOIN (asset_history
     JOIN lastdate ON ((asset_history.rep_date = lastdate.currmonth))) ON ((assets_list.id = asset_history.asset_id)))
     LEFT JOIN asset_repossession ON ((assets_list.id = asset_repossession.repossession_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (assets_list.m_id = '-1'::integer)
  GROUP BY assets_list.id,
        CASE
            WHEN (
            CASE
                WHEN (asset_history.book_value IS NULL) THEN
                CASE
                    WHEN (asset_repossession.purchase_price_net_eur IS NULL) THEN (2000000)::double precision
                    ELSE asset_repossession.purchase_price_net_eur
                END
                ELSE asset_history.book_value
            END < (1000000)::double precision) THEN 36
            WHEN (
            CASE
                WHEN (asset_history.book_value IS NULL) THEN
                CASE
                    WHEN (asset_repossession.purchase_price_net_eur IS NULL) THEN (2000000)::double precision
                    ELSE asset_repossession.purchase_price_net_eur
                END
                ELSE asset_history.book_value
            END < (1500000)::double precision) THEN 24
            ELSE 12
        END;


ALTER TABLE vw_appr_periods OWNER TO postgres;

--
-- Name: vw_last_appraisals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_last_appraisals AS
 SELECT asset_appraisals.appraisal_asset_id,
    max(asset_appraisals.appraisal_date) AS lastdate
   FROM asset_appraisals
  WHERE (asset_appraisals.m_id = '-1'::integer)
  GROUP BY asset_appraisals.appraisal_asset_id;


ALTER TABLE vw_last_appraisals OWNER TO postgres;

--
-- Name: vw_appraisals_exp; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_appraisals_exp AS
 SELECT asset_appraisals.appraisal_asset_id,
    counterparts.counterpart_common_name AS appraisal_company,
    asset_appraisals.appraisal_date,
    nom_currencies.currency_code,
    asset_appraisals.appraisal_market_value_ccy,
    asset_appraisals.appraisal_market_value_eur,
    asset_appraisals.appraisal_firesale_value_ccy,
    asset_appraisals.appraisal_firesale_value_eur,
        CASE
            WHEN (vw_appr_periods.appraisalperiod IS NULL) THEN NULL::timestamp without time zone
            ELSE (asset_appraisals.appraisal_date + '2 years'::interval)
        END AS appraisal_expiration
   FROM (vw_appr_periods
     JOIN ((nom_currencies
     RIGHT JOIN (vw_last_appraisals
     JOIN asset_appraisals ON (((vw_last_appraisals.lastdate = asset_appraisals.appraisal_date) AND (vw_last_appraisals.appraisal_asset_id = asset_appraisals.appraisal_asset_id)))) ON ((nom_currencies.id = asset_appraisals.appraisal_currency_id)))
     LEFT JOIN counterparts ON ((asset_appraisals.appraisal_company_id = counterparts.id))) ON ((vw_appr_periods.id = asset_appraisals.appraisal_asset_id)))
  WHERE (asset_appraisals.m_id = '-1'::integer);


ALTER TABLE vw_appraisals_exp OWNER TO postgres;

--
-- Name: vw_asset_appraisals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_asset_appraisals AS
 SELECT asset_appraisals.id,
    asset_appraisals.appraisal_asset_id,
    asset_appraisals.appraisal_company_id,
    asset_appraisals.appraisal_date,
    asset_appraisals.appraisal_currency_id,
    asset_appraisals.appraisal_market_value_ccy,
    asset_appraisals.appraisal_market_value_eur,
    asset_appraisals.appraisal_firesale_value_ccy,
    asset_appraisals.appraisal_firesale_value_eur,
    asset_appraisals.appraisal_order,
    asset_appraisals.m_id
   FROM asset_appraisals
  WHERE (((((
        CASE
            WHEN (asset_appraisals.appraisal_market_value_ccy IS NULL) THEN (0)::double precision
            ELSE asset_appraisals.appraisal_market_value_ccy
        END +
        CASE
            WHEN (asset_appraisals.appraisal_market_value_eur IS NULL) THEN (0)::double precision
            ELSE asset_appraisals.appraisal_market_value_eur
        END) +
        CASE
            WHEN (asset_appraisals.appraisal_firesale_value_ccy IS NULL) THEN (0)::double precision
            ELSE asset_appraisals.appraisal_firesale_value_ccy
        END) +
        CASE
            WHEN (asset_appraisals.appraisal_firesale_value_eur IS NULL) THEN (0)::double precision
            ELSE asset_appraisals.appraisal_firesale_value_eur
        END) <> (0)::double precision) AND (asset_appraisals.m_id = '-1'::integer));


ALTER TABLE vw_asset_appraisals OWNER TO postgres;

--
-- Name: vw_asset_ccy_id; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_asset_ccy_id AS
 SELECT assets_list.id,
    assets_list.asset_code,
    nom_countries.currency_id
   FROM assets_list,
    nom_countries
  WHERE ("left"((assets_list.asset_code)::text, 2) = (nom_countries.mis_code)::text);


ALTER TABLE vw_asset_ccy_id OWNER TO postgres;

--
-- Name: vw_last_insurances; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_last_insurances AS
 SELECT asset_insurances.insurance_asset_id,
    max(asset_insurances.insurance_end_date) AS lastdate
   FROM asset_insurances
  WHERE (asset_insurances.m_id = '-1'::integer)
  GROUP BY asset_insurances.insurance_asset_id;


ALTER TABLE vw_last_insurances OWNER TO postgres;

--
-- Name: vw_insurances_exp; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_insurances_exp AS
 SELECT asset_insurances.insurance_asset_id,
    counterparts.counterpart_common_name AS insurance_company,
    asset_insurances.insurance_start_date,
    asset_insurances.insurance_end_date,
    nom_currencies.currency_code,
    asset_insurances.insurance_amount_ccy,
    asset_insurances.insurance_amount_eur,
    asset_insurances.insurance_premium_ccy,
    asset_insurances.insurance_premium_eur
   FROM (npe_list
     JOIN (assets_list
     JOIN (vw_last_insurances
     JOIN (nom_currencies
     RIGHT JOIN (counterparts
     RIGHT JOIN asset_insurances ON ((counterparts.id = asset_insurances.insurance_company_id))) ON ((nom_currencies.id = asset_insurances.insurance_currency_id))) ON (((vw_last_insurances.lastdate = asset_insurances.insurance_end_date) AND (vw_last_insurances.insurance_asset_id = asset_insurances.insurance_asset_id)))) ON ((assets_list.id = asset_insurances.insurance_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (asset_insurances.m_id = '-1'::integer);


ALTER TABLE vw_insurances_exp OWNER TO postgres;

--
-- Name: vw_last_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_last_rentals AS
 SELECT asset_rentals.rental_asset_id,
    max(asset_rentals.rental_end_date) AS lastdate
   FROM asset_rentals
  WHERE (asset_rentals.m_id = '-1'::integer)
  GROUP BY asset_rentals.rental_asset_id;


ALTER TABLE vw_last_rentals OWNER TO postgres;

--
-- Name: vw_le_sender; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_le_sender AS
 SELECT users.fullname,
    legal_entities.tagetik_code,
    mail_log.id
   FROM (legal_entities
     JOIN (mail_log
     JOIN users ON (((mail_log.sender)::text = (users.email)::text))) ON ((legal_entities.id = users.le_id)));


ALTER TABLE vw_le_sender OWNER TO postgres;

--
-- Name: vw_mail_countries; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_mail_countries AS
 SELECT users.email,
    nom_countries.mis_code
   FROM (nom_countries
     JOIN (legal_entities
     JOIN users ON ((legal_entities.id = users.le_id))) ON ((nom_countries.id = legal_entities.le_country_id)))
  GROUP BY users.email, nom_countries.mis_code;


ALTER TABLE vw_mail_countries OWNER TO postgres;

--
-- Name: vw_mail_objects; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_mail_objects AS
 SELECT npe_list.npe_code AS object_code,
    "left"((npe_list.npe_code)::text, 2) AS object_country,
    npe_list.m_id
   FROM npe_list
UNION ALL
 SELECT assets_list.asset_code AS object_code,
    "left"((assets_list.asset_code)::text, 2) AS object_country,
    assets_list.m_id
   FROM assets_list;


ALTER TABLE vw_mail_objects OWNER TO postgres;

--
-- Name: vwusercountry; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vwusercountry AS
 SELECT users.email,
    nom_countries.mis_code AS country_code,
    users.role
   FROM (nom_countries
     RIGHT JOIN (legal_entities
     JOIN users ON ((legal_entities.id = users.le_id))) ON ((nom_countries.id = legal_entities.le_country_id)));


ALTER TABLE vwusercountry OWNER TO postgres;

--
-- Name: vw_mail_roles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_mail_roles AS
 SELECT vw_mail_objects.m_id,
    vwusercountry.email,
    vwusercountry.role
   FROM (vw_mail_objects
     JOIN vwusercountry ON ((vw_mail_objects.object_country = (vwusercountry.country_code)::text)))
  GROUP BY vw_mail_objects.m_id, vwusercountry.email, vwusercountry.role;


ALTER TABLE vw_mail_roles OWNER TO postgres;

--
-- Name: vw_nom_mail_status; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_nom_mail_status AS
 SELECT 0 AS id,
    '[received]'::text AS name
UNION
 SELECT 1 AS id,
    '[processed]'::text AS name
UNION
 SELECT 2 AS id,
    '[confirmed]'::text AS name
UNION
 SELECT 3 AS id,
    '[rejected]'::text AS name;


ALTER TABLE vw_nom_mail_status OWNER TO postgres;

--
-- Name: vw_npe_ccy_id; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_npe_ccy_id AS
 SELECT npe_list.id,
    npe_list.npe_code,
    nom_countries.currency_id
   FROM npe_list,
    nom_countries
  WHERE ("left"((npe_list.npe_code)::text, 2) = (nom_countries.mis_code)::text);


ALTER TABLE vw_npe_ccy_id OWNER TO postgres;

--
-- Name: vw_npe_pipeline; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_npe_pipeline AS
 SELECT npe_history.id,
    npe_list.npe_code,
    npe_list.npe_name,
    max((nom_npe_status.npe_status_code)::text) AS status,
    max(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.npe_rep_date
            ELSE NULL::date
        END) AS fc_rep_date,
    npe_history.npe_currency,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 11) THEN npe_history.npe_amount_ccy
            ELSE (0)::double precision
        END) AS fc_npe_ccy,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 11) THEN npe_history.npe_amount_eur
            ELSE (0)::double precision
        END) AS fc_npe_eur,
    npe_list.npe_scenario_id,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 2) THEN npe_history.npe_amount_eur
            ELSE (0)::double precision
        END) AS myp_original,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 3) THEN npe_history.npe_amount_eur
            ELSE (0)::double precision
        END) AS myp_update,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.npe_amount_ccy
            ELSE (0)::double precision
        END) AS actual_ccy,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.npe_amount_eur
            ELSE (0)::double precision
        END) AS actual_eur,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.llp_amount_ccy
            ELSE (0)::double precision
        END) AS actual_llp_ccy,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.llp_amount_eur
            ELSE (0)::double precision
        END) AS actual_llp_eur,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.purchase_price_ccy
            ELSE (0)::double precision
        END) AS purchase_price_ccy,
    sum(
        CASE
            WHEN (npe_history.npe_scenario_id = 6) THEN npe_history.purchase_price_eur
            ELSE (0)::double precision
        END) AS purchase_price_eur
   FROM (npe_list
     JOIN (nom_npe_status
     RIGHT JOIN npe_history ON ((nom_npe_status.id = npe_history.npe_status_id))) ON ((npe_list.id = npe_history.npe_id)))
  WHERE ((npe_history.rep_date IN ( SELECT lastdate.currmonth
           FROM lastdate)) AND (npe_history.m_id = '-1'::integer) AND (npe_history.npe_scenario_id = ANY (ARRAY[2, 3, 6, 11])))
  GROUP BY npe_history.id, npe_list.npe_code, npe_list.npe_name, npe_history.npe_currency, npe_list.npe_scenario_id
 HAVING (max((nom_npe_status.npe_status_code)::text) = ANY (ARRAY['Approved'::text, 'Pipeline'::text]));


ALTER TABLE vw_npe_pipeline OWNER TO postgres;

--
-- Name: vw_rentals_exp; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_rentals_exp AS
 SELECT asset_rentals.rental_asset_id,
    counterparts.counterpart_common_name AS tenant,
    asset_rentals.rental_contract_date,
    asset_rentals.rental_start_date,
    asset_rentals.rental_end_date,
    asset_rentals.rental_payment_date,
    nom_currencies.currency_code,
    asset_rentals.rental_amount_ccy,
    asset_rentals.rental_amount_eur
   FROM ((((asset_rentals
     JOIN vw_last_rentals ON (((vw_last_rentals.lastdate = asset_rentals.rental_end_date) AND (asset_rentals.rental_asset_id = vw_last_rentals.rental_asset_id))))
     LEFT JOIN nom_currencies ON ((asset_rentals.rental_currency_id = nom_currencies.id)))
     LEFT JOIN counterparts ON ((asset_rentals.rental_counterpart_id = counterparts.id)))
     LEFT JOIN asset_sales ON ((asset_rentals.rental_asset_id = asset_sales.sale_asset_id)))
  WHERE ((asset_rentals.m_id = '-1'::integer) AND (asset_sales.sale_contract_date IS NULL));


ALTER TABLE vw_rentals_exp OWNER TO postgres;

--
-- Name: vw_sh_appraisals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_appraisals AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    vw_appraisals_exp.appraisal_company,
    vw_appraisals_exp.appraisal_date,
    vw_appraisals_exp.currency_code,
    vw_appraisals_exp.appraisal_market_value_ccy,
    vw_appraisals_exp.appraisal_market_value_eur,
    vw_appraisals_exp.appraisal_firesale_value_ccy,
    vw_appraisals_exp.appraisal_firesale_value_eur,
        CASE
            WHEN (vw_appraisals_exp.appraisal_date IS NULL) THEN 'No Appraisal'::text
            WHEN (lastdate.currmonth > vw_appraisals_exp.appraisal_expiration) THEN 'Expired Appraisal'::text
            WHEN (vw_appraisals_exp.appraisal_expiration < (lastdate.currmonth + '2 mons'::interval)) THEN 'Appraisal Expiring Soon'::text
            ELSE 'Appraisal OK'::text
        END AS appraisal_status
   FROM (npe_list
     JOIN ((vw_appraisals_exp
     RIGHT JOIN assets_list ON ((vw_appraisals_exp.appraisal_asset_id = assets_list.id)))
     JOIN (lastdate
     JOIN asset_history ON ((lastdate.currmonth = asset_history.rep_date))) ON ((assets_list.id = asset_history.asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (assets_list.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_appraisals OWNER TO postgres;

--
-- Name: vw_sh_asset_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_asset_info AS
 SELECT npe_list.npe_code,
    assets_list.asset_code,
    assets_list.asset_name,
    assets_list.asset_description,
    nom_asset_owned.asset_owned,
    assets_list.asset_address,
    assets_list.asset_zip,
    assets_list.asset_region,
    nom_countries.country_name,
    nom_asset_usage.asset_usage_text,
    nom_asset_type.asset_type_text,
    assets_list.asset_usable_area,
    assets_list.asset_common_area,
    assets_list.comment
   FROM (npe_list
     JOIN (nom_countries
     RIGHT JOIN (nom_asset_usage
     RIGHT JOIN (nom_asset_type
     RIGHT JOIN (assets_list
     LEFT JOIN nom_asset_owned ON ((assets_list.asset_owned = nom_asset_owned.id))) ON ((nom_asset_type.id = assets_list.asset_type_id))) ON ((nom_asset_usage.id = assets_list.asset_usage_id))) ON ((nom_countries.id = assets_list.asset_country_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (assets_list.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_asset_info OWNER TO postgres;

--
-- Name: vw_sh_asset_status; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_asset_status AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    nom_asset_status.asset_status_code,
    asset_history.book_value_pm,
    asset_history.inflows,
    asset_history.capex,
    asset_history.depreciation,
    asset_history.sales,
    asset_history.imp_wb,
    asset_history.book_value,
    asset_history.costs,
    asset_history.income,
    asset_history.expected_exit
   FROM (npe_list
     JOIN (assets_list
     JOIN ((asset_history
     JOIN lastdate ON ((asset_history.rep_date = lastdate.currmonth)))
     JOIN nom_asset_status ON ((asset_history.status_code = nom_asset_status.id))) ON ((assets_list.id = asset_history.asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE ((asset_history.m_id = '-1'::integer) AND ((((nom_asset_status.asset_status_code)::text = 'Sold'::text) AND (round(asset_history.book_value_pm) = (0)::double precision)) = false))
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_asset_status OWNER TO postgres;

--
-- Name: vw_sh_business_cases; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_business_cases AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    business_cases.bc_date,
    business_cases.bc_comment,
    business_cases.bc_purchase_date,
    business_cases.bc_purchase_price_eur,
    business_cases.exp_capex_eur,
    business_cases.exp_capex_time,
    business_cases.exp_sale_date,
    business_cases.exp_sale_price_eur,
    business_cases.exp_interest_eur,
    business_cases.exp_opex_eur,
    business_cases.exp_income_eur
   FROM (npe_list
     JOIN business_cases ON ((npe_list.id = business_cases.npe_id)))
  WHERE (business_cases.m_id = '-1'::integer)
  ORDER BY npe_list.npe_code;


ALTER TABLE vw_sh_business_cases OWNER TO postgres;

--
-- Name: vwcounterparts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vwcounterparts AS
 SELECT counterparts.id,
    counterparts.counterpart_common_name AS descr,
    btrim((((((((counterparts.counterpart_type)::text || ' '::text) || (counterparts.counterpart_first_name)::text) || ' '::text) || (counterparts.counterpart_last_name)::text) || ' '::text) || (counterparts.counterpart_company_name)::text)) AS descr2
   FROM counterparts;


ALTER TABLE vwcounterparts OWNER TO postgres;

--
-- Name: vw_sh_financing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_financing AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    vwcounterparts.descr AS lender,
    asset_financing.financing_contract_code,
    nom_financing_type.financing_type,
    nom_currencies.currency_code,
    asset_financing.financing_amount_ccy,
    asset_financing.financing_amount_eur,
    asset_financing.financing_reference_rate,
    asset_financing.financing_margin,
    asset_financing.financing_rate,
    asset_financing.financing_contract_date,
    asset_financing.financing_start_date,
    asset_financing.financing_end_date
   FROM (npe_list
     JOIN (assets_list
     JOIN (((asset_financing
     LEFT JOIN nom_currencies ON ((asset_financing.financing_currency_id = nom_currencies.id)))
     LEFT JOIN nom_financing_type ON ((asset_financing.financing_type_id = nom_financing_type.id)))
     LEFT JOIN vwcounterparts ON ((asset_financing.financing_counterpart_id = vwcounterparts.id))) ON ((assets_list.id = asset_financing.financing_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (asset_financing.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_financing OWNER TO postgres;

--
-- Name: vw_sh_insurances; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_insurances AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    vw_insurances_exp.insurance_company,
    vw_insurances_exp.insurance_start_date,
    vw_insurances_exp.insurance_end_date,
    vw_insurances_exp.currency_code,
    vw_insurances_exp.insurance_amount_ccy,
    vw_insurances_exp.insurance_amount_eur,
    vw_insurances_exp.insurance_premium_ccy,
    vw_insurances_exp.insurance_premium_eur,
        CASE
            WHEN (vw_insurances_exp.insurance_end_date IS NULL) THEN 'No Insurance'::text
            WHEN (lastdate.currmonth > vw_insurances_exp.insurance_end_date) THEN 'Expired Insurance'::text
            WHEN (vw_insurances_exp.insurance_end_date < (lastdate.currmonth + '2 mons'::interval)) THEN 'Insurance Expiring Soon'::text
            ELSE 'Insurance OK'::text
        END AS insurance_status
   FROM (npe_list
     JOIN ((assets_list
     LEFT JOIN vw_insurances_exp ON ((assets_list.id = vw_insurances_exp.insurance_asset_id)))
     JOIN (lastdate
     JOIN asset_history ON ((lastdate.currmonth = asset_history.rep_date))) ON ((assets_list.id = asset_history.asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (assets_list.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_insurances OWNER TO postgres;

--
-- Name: vw_sh_npes_identified; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_npes_identified AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    npe_list.npe_description,
    nom_countries.country_name,
    lender.descr AS lender,
    borrower.descr AS borrower,
    npe_list.npe_amount_date,
    nom_currencies.currency_code,
    npe_list.npe_amount_ccy,
    npe_list.npe_amount_eur,
    npe_list.llp_amount_ccy,
    npe_list.llp_amount_eur
   FROM (nom_countries
     RIGHT JOIN (nom_currencies
     RIGHT JOIN ((npe_list
     LEFT JOIN vwcounterparts lender ON ((npe_list.npe_lender_id = lender.id)))
     LEFT JOIN vwcounterparts borrower ON ((npe_list.npe_borrower_id = borrower.id))) ON ((nom_currencies.id = npe_list.npe_currency_id))) ON ((nom_countries.id = npe_list.npe_country_id)))
  WHERE (npe_list.m_id = '-1'::integer)
  ORDER BY npe_list.npe_code;


ALTER TABLE vw_sh_npes_identified OWNER TO postgres;

--
-- Name: vw_sh_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_rentals AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    vw_rentals_exp.tenant,
    vw_rentals_exp.rental_contract_date,
    vw_rentals_exp.rental_start_date,
    vw_rentals_exp.rental_end_date,
    vw_rentals_exp.rental_payment_date,
    vw_rentals_exp.currency_code,
    vw_rentals_exp.rental_amount_ccy,
    vw_rentals_exp.rental_amount_eur,
        CASE
            WHEN (vw_rentals_exp.rental_end_date IS NULL) THEN 'Not Rented'::text
            WHEN (lastdate.currmonth > vw_rentals_exp.rental_end_date) THEN 'Expired Rental Contract'::text
            WHEN (vw_rentals_exp.rental_end_date < (lastdate.currmonth + '2 mons'::interval)) THEN 'Rental Contract Expiring Soon'::text
            ELSE 'Rental Contract OK'::text
        END AS rental_status
   FROM lastdate,
    (npe_list
     JOIN (assets_list
     JOIN vw_rentals_exp ON ((assets_list.id = vw_rentals_exp.rental_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (assets_list.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_rentals OWNER TO postgres;

--
-- Name: vw_sh_repossessions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_repossessions AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    asset_repossession.purchase_auction_date,
    asset_repossession.purchase_contract_date,
    asset_repossession.purchase_handover_date,
    asset_repossession.purchase_payment_date,
    purchase_currency.currency_code,
    asset_repossession.appr_purchase_price_net_ccy,
    asset_repossession.appr_purchase_price_net_eur,
    asset_repossession.purchase_price_net_ccy,
    asset_repossession.purchase_price_net_eur,
    asset_repossession.purchase_costs_ccy,
    asset_repossession.purchase_costs_eur,
    asset_repossession.planned_capex_ccy,
    asset_repossession.planned_capex_eur,
    asset_repossession.planned_capex_comment,
    asset_repossession.planned_opex_ccy,
    asset_repossession.planned_opex_eur,
    asset_repossession.planned_opex_comment,
    asset_repossession.planned_salesprice_ccy,
    asset_repossession.planned_salesprice_eur
   FROM (npe_list
     JOIN (assets_list
     JOIN (nom_currencies purchase_currency
     RIGHT JOIN (asset_repossession
     LEFT JOIN nom_currencies npe_currency ON ((asset_repossession.npe_currency_id = npe_currency.id))) ON ((purchase_currency.id = asset_repossession.purchase_price_currency_id))) ON ((assets_list.id = asset_repossession.repossession_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (asset_repossession.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_repossessions OWNER TO postgres;

--
-- Name: vw_sh_sales; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_sh_sales AS
 SELECT npe_list.npe_code,
    npe_list.npe_name,
    assets_list.asset_code,
    assets_list.asset_name,
    counterparts.counterpart_common_name AS buyer,
    asset_sales.sale_approval_date,
    asset_sales.sale_contract_date,
    asset_sales.sale_transfer_date,
    asset_sales.sale_payment_date,
    nom_currencies.currency_code,
    asset_sales.sale_approvedamt_ccy,
    asset_sales.sale_approvedamt_eur,
    asset_sales.sale_amount_ccy,
    asset_sales.sale_amount_eur,
    asset_sales.sale_book_value_ccy,
    asset_sales.sale_book_value_eur,
    asset_sales.sale_aml_check_date,
    asset_sales.sale_aml_pass_date
   FROM (npe_list
     JOIN (assets_list
     JOIN ((asset_sales
     LEFT JOIN nom_currencies ON ((asset_sales.sale_currency_id = nom_currencies.id)))
     LEFT JOIN counterparts ON ((asset_sales.sale_counterpart_id = counterparts.id))) ON ((assets_list.id = asset_sales.sale_asset_id))) ON ((npe_list.id = assets_list.asset_npe_id)))
  WHERE (asset_sales.m_id = '-1'::integer)
  ORDER BY assets_list.asset_code;


ALTER TABLE vw_sh_sales OWNER TO postgres;

--
-- Name: asset_appraisals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_appraisals ALTER COLUMN id SET DEFAULT nextval('asset_appraisals_id_seq'::regclass);


--
-- Name: asset_financing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financing ALTER COLUMN id SET DEFAULT nextval('asset_financing_id_seq'::regclass);


--
-- Name: asset_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_history ALTER COLUMN id SET DEFAULT nextval('asset_history_id_seq'::regclass);


--
-- Name: asset_insurances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_insurances ALTER COLUMN id SET DEFAULT nextval('asset_insurances_id_seq'::regclass);


--
-- Name: asset_rentals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_rentals ALTER COLUMN id SET DEFAULT nextval('asset_rentals_id_seq'::regclass);


--
-- Name: asset_repossession id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_repossession ALTER COLUMN id SET DEFAULT nextval('asset_repossession_id_seq'::regclass);


--
-- Name: asset_sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_sales ALTER COLUMN id SET DEFAULT nextval('asset_sales_id_seq'::regclass);


--
-- Name: assets_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list ALTER COLUMN id SET DEFAULT nextval('assets_list_id_seq'::regclass);


--
-- Name: counterparts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counterparts ALTER COLUMN id SET DEFAULT nextval('counterparts_id_seq'::regclass);


--
-- Name: file_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY file_log ALTER COLUMN id SET DEFAULT nextval('file_log_id_seq'::regclass);


--
-- Name: mail_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mail_log ALTER COLUMN id SET DEFAULT nextval('mail_log_id_seq'::regclass);


--
-- Name: mail_queue id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mail_queue ALTER COLUMN id SET DEFAULT nextval('mail_queue_id_seq'::regclass);


--
-- Name: nom_asset_owned id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_owned ALTER COLUMN id SET DEFAULT nextval('nom_asset_owned_id_seq'::regclass);


--
-- Name: nom_asset_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_status ALTER COLUMN id SET DEFAULT nextval('nom_asset_status_id_seq'::regclass);


--
-- Name: nom_asset_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_type ALTER COLUMN id SET DEFAULT nextval('nom_asset_type_id_seq'::regclass);


--
-- Name: nom_asset_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_usage ALTER COLUMN id SET DEFAULT nextval('nom_asset_usage_id_seq'::regclass);


--
-- Name: nom_countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_countries ALTER COLUMN id SET DEFAULT nextval('nom_countries_id_seq'::regclass);


--
-- Name: nom_currencies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_currencies ALTER COLUMN id SET DEFAULT nextval('nom_currencies_id_seq'::regclass);


--
-- Name: nom_financing_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_financing_type ALTER COLUMN id SET DEFAULT nextval('nom_financing_type_id_seq'::regclass);


--
-- Name: nom_npe_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_npe_status ALTER COLUMN id SET DEFAULT nextval('nom_npe_status_id_seq'::regclass);


--
-- Name: npe_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_history ALTER COLUMN id SET DEFAULT nextval('npe_history_id_seq'::regclass);


--
-- Name: npe_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list ALTER COLUMN id SET DEFAULT nextval('npe_list_id_seq'::regclass);


--
-- Name: sst_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sst_log ALTER COLUMN id SET DEFAULT nextval('sst_log_id_seq'::regclass);


--
-- Name: update_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY update_log ALTER COLUMN id SET DEFAULT nextval('update_log_id_seq'::regclass);


--
-- Name: asset_appraisals asset_appraisals_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_appraisals
    ADD CONSTRAINT asset_appraisals_primarykey PRIMARY KEY (id);


--
-- Name: asset_appraisals asset_appraisals_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_appraisals
    ADD CONSTRAINT asset_appraisals_uniquekey UNIQUE (appraisal_asset_id, appraisal_date, appraisal_order, m_id);


--
-- Name: asset_financials asset_financials_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financials
    ADD CONSTRAINT asset_financials_primarykey PRIMARY KEY (id);


--
-- Name: asset_financing asset_financing_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financing
    ADD CONSTRAINT asset_financing_primarykey PRIMARY KEY (id);


--
-- Name: asset_financing asset_financing_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financing
    ADD CONSTRAINT asset_financing_uniquekey UNIQUE (financing_asset_id, financing_contract_date, financing_type_id, m_id);


--
-- Name: asset_history asset_history_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_history
    ADD CONSTRAINT asset_history_primarykey PRIMARY KEY (id);


--
-- Name: asset_history asset_history_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_history
    ADD CONSTRAINT asset_history_uniquekey UNIQUE (asset_id, rep_date, m_id);


--
-- Name: asset_insurances asset_insurances_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_insurances
    ADD CONSTRAINT asset_insurances_primarykey PRIMARY KEY (id);


--
-- Name: asset_insurances asset_insurances_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_insurances
    ADD CONSTRAINT asset_insurances_uniquekey UNIQUE (insurance_asset_id, insurance_start_date, m_id);


--
-- Name: asset_rentals asset_rentals_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_rentals
    ADD CONSTRAINT asset_rentals_primarykey PRIMARY KEY (id);


--
-- Name: asset_rentals asset_rentals_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_rentals
    ADD CONSTRAINT asset_rentals_uniquekey UNIQUE (rental_asset_id, rental_contract_date, m_id);


--
-- Name: asset_repossession asset_repossession_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_repossession
    ADD CONSTRAINT asset_repossession_primarykey PRIMARY KEY (id);


--
-- Name: asset_repossession asset_repossession_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_repossession
    ADD CONSTRAINT asset_repossession_uniquekey UNIQUE (repossession_asset_id, purchase_auction_date, m_id);


--
-- Name: asset_sales asset_sales_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_sales
    ADD CONSTRAINT asset_sales_primarykey PRIMARY KEY (id);


--
-- Name: asset_sales asset_sales_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_sales
    ADD CONSTRAINT asset_sales_uniquekey UNIQUE (sale_asset_id, sale_approval_date, m_id);


--
-- Name: assets_list assets_list_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT assets_list_primarykey PRIMARY KEY (id);


--
-- Name: business_cases business_cases_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY business_cases
    ADD CONSTRAINT business_cases_primarykey PRIMARY KEY (id);


--
-- Name: business_cases business_cases_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY business_cases
    ADD CONSTRAINT business_cases_uniquekey UNIQUE (npe_id, bc_date, m_id);


--
-- Name: calendar calendar_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_primarykey PRIMARY KEY (id);


--
-- Name: counterparts counterparts_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counterparts
    ADD CONSTRAINT counterparts_primarykey PRIMARY KEY (id);


--
-- Name: file_log file_log_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY file_log
    ADD CONSTRAINT file_log_primarykey PRIMARY KEY (id);


--
-- Name: fx_rates fx_rates_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fx_rates
    ADD CONSTRAINT fx_rates_primarykey PRIMARY KEY (ccy_code, scenario, repdate);


--
-- Name: import_mapping import_mapping_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY import_mapping
    ADD CONSTRAINT import_mapping_primarykey PRIMARY KEY (id);


--
-- Name: lastdate lastdate_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lastdate
    ADD CONSTRAINT lastdate_primarykey PRIMARY KEY (prevmonth);


--
-- Name: legal_entities legal_entities_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY legal_entities
    ADD CONSTRAINT legal_entities_primarykey PRIMARY KEY (id);


--
-- Name: lst_reports lst_reports_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lst_reports
    ADD CONSTRAINT lst_reports_primarykey PRIMARY KEY (id);


--
-- Name: lst_sheets lst_sheets_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lst_sheets
    ADD CONSTRAINT lst_sheets_primarykey PRIMARY KEY (id);


--
-- Name: mail_log mail_log_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mail_log
    ADD CONSTRAINT mail_log_primarykey PRIMARY KEY (id);


--
-- Name: mail_queue mail_queue_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mail_queue
    ADD CONSTRAINT mail_queue_primarykey PRIMARY KEY (id);


--
-- Name: meta_ccy_conversion meta_ccy_conversion_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meta_ccy_conversion
    ADD CONSTRAINT meta_ccy_conversion_primarykey PRIMARY KEY (id);


--
-- Name: meta_updatable_tables meta_updatable_tables_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meta_updatable_tables
    ADD CONSTRAINT meta_updatable_tables_primarykey PRIMARY KEY (id);


--
-- Name: nom_asset_owned nom_asset_owned_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_owned
    ADD CONSTRAINT nom_asset_owned_primarykey PRIMARY KEY (id);


--
-- Name: nom_asset_status nom_asset_status_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_status
    ADD CONSTRAINT nom_asset_status_primarykey PRIMARY KEY (id);


--
-- Name: nom_asset_type nom_asset_type_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_type
    ADD CONSTRAINT nom_asset_type_primarykey PRIMARY KEY (id);


--
-- Name: nom_asset_usage nom_asset_usage_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_asset_usage
    ADD CONSTRAINT nom_asset_usage_primarykey PRIMARY KEY (id);


--
-- Name: nom_countries nom_countries_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_countries
    ADD CONSTRAINT nom_countries_primarykey PRIMARY KEY (id);


--
-- Name: nom_currencies nom_currencies_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_currencies
    ADD CONSTRAINT nom_currencies_primarykey PRIMARY KEY (id);


--
-- Name: nom_financing_type nom_financing_type_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_financing_type
    ADD CONSTRAINT nom_financing_type_primarykey PRIMARY KEY (id);


--
-- Name: nom_log_types nom_log_types_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_log_types
    ADD CONSTRAINT nom_log_types_primarykey PRIMARY KEY (id);


--
-- Name: nom_npe_status nom_npe_status_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_npe_status
    ADD CONSTRAINT nom_npe_status_primarykey PRIMARY KEY (id);


--
-- Name: nom_scenarios nom_scenarios_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_scenarios
    ADD CONSTRAINT nom_scenarios_primarykey PRIMARY KEY (id);


--
-- Name: nom_transaction_types nom_transaction_types_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nom_transaction_types
    ADD CONSTRAINT nom_transaction_types_primarykey PRIMARY KEY (id);


--
-- Name: npe_history npe_history_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_history
    ADD CONSTRAINT npe_history_primarykey PRIMARY KEY (id);


--
-- Name: npe_history npe_history_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_history
    ADD CONSTRAINT npe_history_uniquekey UNIQUE (npe_id, rep_date, m_id, npe_scenario_id);


--
-- Name: npe_list npe_list_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list
    ADD CONSTRAINT npe_list_primarykey PRIMARY KEY (id);


--
-- Name: npe_list npe_list_uniquekey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list
    ADD CONSTRAINT npe_list_uniquekey UNIQUE (npe_code, m_id);


--
-- Name: reports reports_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_primarykey PRIMARY KEY (id);


--
-- Name: sst_log sst_log_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sst_log
    ADD CONSTRAINT sst_log_primarykey PRIMARY KEY (id);


--
-- Name: update_log update_log_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY update_log
    ADD CONSTRAINT update_log_primarykey PRIMARY KEY (id);


--
-- Name: users users_primarykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_primarykey PRIMARY KEY (email, le_id);


--
-- Name: asset_appraisals_apprassetdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX asset_appraisals_apprassetdate ON asset_appraisals USING btree (appraisal_asset_id, appraisal_date, m_id);


--
-- Name: asset_appraisals_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_appraisals_m_id ON asset_appraisals USING btree (m_id);


--
-- Name: asset_financials_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_financials_asset_id ON asset_financials USING btree (asset_id);


--
-- Name: asset_financials_mis_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_financials_mis_code ON asset_financials USING btree (trans_type_id);


--
-- Name: asset_financing_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_financing_m_id ON asset_financing USING btree (m_id);


--
-- Name: asset_history_currency_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_history_currency_id ON asset_history USING btree (currency_id);


--
-- Name: asset_history_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_history_m_id ON asset_history USING btree (m_id);


--
-- Name: asset_insurances_insassetdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX asset_insurances_insassetdate ON asset_insurances USING btree (insurance_asset_id, insurance_start_date, m_id);


--
-- Name: asset_insurances_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_insurances_m_id ON asset_insurances USING btree (m_id);


--
-- Name: asset_rentals_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_rentals_m_id ON asset_rentals USING btree (m_id);


--
-- Name: asset_rentals_rentassetdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX asset_rentals_rentassetdate ON asset_rentals USING btree (rental_asset_id, rental_contract_date, m_id);


--
-- Name: asset_repossession_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_repossession_m_id ON asset_repossession USING btree (m_id);


--
-- Name: asset_repossession_repasset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX asset_repossession_repasset ON asset_repossession USING btree (repossession_asset_id, m_id);


--
-- Name: asset_sales_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asset_sales_m_id ON asset_sales USING btree (m_id);


--
-- Name: assets_list_assetcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX assets_list_assetcode ON assets_list USING btree (asset_code, m_id);


--
-- Name: assets_list_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assets_list_m_id ON assets_list USING btree (m_id);


--
-- Name: business_cases_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX business_cases_m_id ON business_cases USING btree (m_id);


--
-- Name: business_cases_npe_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX business_cases_npe_id ON business_cases USING btree (npe_id);


--
-- Name: file_log_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX file_log_m_id ON file_log USING btree (m_id);


--
-- Name: fx_rates_ccy_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fx_rates_ccy_code ON fx_rates USING btree (ccy_code);


--
-- Name: fx_rates_scenario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fx_rates_scenario_id ON fx_rates USING btree (scenario);


--
-- Name: legal_entities_tagetik_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX legal_entities_tagetik_code ON legal_entities USING btree (tagetik_code);


--
-- Name: nom_asset_owned_asset_type_text; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nom_asset_owned_asset_type_text ON nom_asset_owned USING btree (asset_owned);


--
-- Name: nom_asset_type_asset_type_text; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nom_asset_type_asset_type_text ON nom_asset_type USING btree (asset_type_text);


--
-- Name: nom_asset_usage_asset_usage_text; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nom_asset_usage_asset_usage_text ON nom_asset_usage USING btree (asset_usage_text);


--
-- Name: nom_countries_country_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nom_countries_country_name ON nom_countries USING btree (country_name);


--
-- Name: nom_currencies_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nom_currencies_currency_code ON nom_currencies USING btree (currency_code);


--
-- Name: nom_transaction_types_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nom_transaction_types_code ON nom_transaction_types USING btree (transaction_code);


--
-- Name: npe_history_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX npe_history_m_id ON npe_history USING btree (m_id);


--
-- Name: npe_list_m_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX npe_list_m_id ON npe_list USING btree (m_id);


--
-- Name: sst_log_mail_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sst_log_mail_id ON sst_log USING btree (mail_id);


--
-- Name: update_log_r_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX update_log_r_id ON update_log USING btree (r_id);


--
-- Name: assets_list assets_list_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER assets_list_insert BEFORE INSERT ON assets_list FOR EACH ROW EXECUTE PROCEDURE ins_asset();


--
-- Name: assets_list asset_typeassets_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT asset_typeassets_list FOREIGN KEY (asset_type_id) REFERENCES nom_asset_type(id);


--
-- Name: assets_list asset_usageassets_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT asset_usageassets_list FOREIGN KEY (asset_usage_id) REFERENCES nom_asset_usage(id);


--
-- Name: asset_appraisals assets_listasset_appraisals; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_appraisals
    ADD CONSTRAINT assets_listasset_appraisals FOREIGN KEY (appraisal_asset_id) REFERENCES assets_list(id);


--
-- Name: asset_financing assets_listasset_financing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financing
    ADD CONSTRAINT assets_listasset_financing FOREIGN KEY (financing_asset_id) REFERENCES assets_list(id);


--
-- Name: asset_history assets_listasset_history; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_history
    ADD CONSTRAINT assets_listasset_history FOREIGN KEY (asset_id) REFERENCES assets_list(id);


--
-- Name: asset_insurances assets_listasset_insurances; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_insurances
    ADD CONSTRAINT assets_listasset_insurances FOREIGN KEY (insurance_asset_id) REFERENCES assets_list(id);


--
-- Name: asset_rentals assets_listasset_rentals; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_rentals
    ADD CONSTRAINT assets_listasset_rentals FOREIGN KEY (rental_asset_id) REFERENCES assets_list(id);


--
-- Name: asset_repossession assets_listasset_repossession; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_repossession
    ADD CONSTRAINT assets_listasset_repossession FOREIGN KEY (repossession_asset_id) REFERENCES assets_list(id);


--
-- Name: asset_sales assets_listasset_sales; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_sales
    ADD CONSTRAINT assets_listasset_sales FOREIGN KEY (sale_asset_id) REFERENCES assets_list(id);


--
-- Name: assets_list countriesassets_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT countriesassets_list FOREIGN KEY (asset_country_id) REFERENCES nom_countries(id);


--
-- Name: users legal_entitiesusers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT legal_entitiesusers FOREIGN KEY (le_id) REFERENCES legal_entities(id);


--
-- Name: assets_list nom_asset_ownedassets_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT nom_asset_ownedassets_list FOREIGN KEY (asset_owned) REFERENCES nom_asset_owned(id);


--
-- Name: legal_entities nom_countrieslegal_entities; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY legal_entities
    ADD CONSTRAINT nom_countrieslegal_entities FOREIGN KEY (le_country_id) REFERENCES nom_countries(id);


--
-- Name: npe_list nom_countriesnpe_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list
    ADD CONSTRAINT nom_countriesnpe_list FOREIGN KEY (npe_country_id) REFERENCES nom_countries(id);


--
-- Name: asset_financing nom_financing_typeasset_financing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY asset_financing
    ADD CONSTRAINT nom_financing_typeasset_financing FOREIGN KEY (financing_type_id) REFERENCES nom_financing_type(id);


--
-- Name: npe_history nom_npe_statusnpe_history; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_history
    ADD CONSTRAINT nom_npe_statusnpe_history FOREIGN KEY (npe_status_id) REFERENCES nom_npe_status(id);


--
-- Name: npe_list nom_scenariosnpe_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list
    ADD CONSTRAINT nom_scenariosnpe_list FOREIGN KEY (npe_scenario_id) REFERENCES nom_scenarios(id);


--
-- Name: npe_list nom_scenariosnpe_list1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_list
    ADD CONSTRAINT nom_scenariosnpe_list1 FOREIGN KEY (npe_scenario_id) REFERENCES nom_scenarios(id);


--
-- Name: assets_list npe_listassets_list; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assets_list
    ADD CONSTRAINT npe_listassets_list FOREIGN KEY (asset_npe_id) REFERENCES npe_list(id);


--
-- Name: npe_history npe_listnpe_history; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY npe_history
    ADD CONSTRAINT npe_listnpe_history FOREIGN KEY (npe_id) REFERENCES npe_list(id);


--
-- PostgreSQL database dump complete
--

