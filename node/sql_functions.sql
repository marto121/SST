create or replace function last_day(date)
returns date as
$$
select (date_trunc('month', $1) + interval '1 month' - interval '1 day')::date;
$$ language 'sql'
immutable strict;

create or replace function fn_performFX(m_ID mail_log.id%type) returns integer as $$
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
			perform logMessage(text'convertFX', msg, cast(tLog as character varying), m_ID);
			RAISE NOTICE '%', msg;
		End If;
	END LOOP;
	--RAISE EXCEPTION 'Error';
	return 1;
end;
$$ language plpgsql;
select fn_performFX(360);


create or replace function fn_performUpdates(confirm_m_ID mail_log.id%type, log_m_ID mail_log.id%type) returns integer as $$
declare
	lUpdates RECORD;
	rc integer;
	tLog constant integer:=1;
begin
	FOR lUpdates in select Update_Name, Update_Query from lst_Updates where is_Active = 1 LOOP
		execute lUpdates.update_query||'($1)' using confirm_m_ID;
		GET DIAGNOSTICS rc = ROW_COUNT;
		perform logMessage(text'performUpdates', lUpdates.update_name || rc || ' row(s) affected', cast(tLog as character varying), log_m_ID);
	END LOOP;
	return 1;
end;
$$ language plpgsql;

create or replace function fn_performChecks(m_ID mail_log.id%type) returns integer as $$
declare
	lChecks RECORD;
	tLog constant integer:=1;
begin
	for lChecks in select Check_Name, Check_Query from lst_Checks where is_Active = 1 loop
		perform logMessage(text'performChecks', 'Performing ' || lChecks.check_name, cast(tLog as character varying), m_ID);
		execute lChecks.check_query||'($1)' using m_ID;
	END LOOP;
	return 1;
end;
$$ language plpgsql;

create or replace function fn_confirmMessage(confirm_m_ID mail_log.id%type, log_m_ID mail_log.id%type, mSender mail_log.Sender%type) returns integer as $$
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
$$ language plpgsql;

--select fn_confirmMessage(360,0,'mkrastev.external@unicredit.eu');
/*
create view vw_nom_mail_status as
select 0 as id, '[received]' as name
union select 1, '[processed]'
union select 2, '[confirmed]'
union select 3, '[rejected]'
create view vw_nom_log_type*/