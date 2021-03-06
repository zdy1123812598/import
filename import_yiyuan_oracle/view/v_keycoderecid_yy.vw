create or replace force view v_keycoderecid_yy as
select distinct keycode,recid from(
select recid,keycode from ZXXX_LOG
union select recid,keycode from YSXX_LOG
union select recid,keycode from BGDJ_LOG
union select recid,keycode from ZYDJ_LOG
union select recid,keycode from DYXX_LOG
union select recid,keycode from CFXX_LOG
union select recid,keycode from YCFXX_LOG
union select recid,keycode from SPFYG_LOG
union select recid,keycode from SYQZYYG_LOG
union select recid,keycode from SPFDYYG_LOG
union select recid,keycode from CL_LOG
union select recid,keycode from CQXX_LOG
union select recid,keycode from BAHT_LOG
union select recid,keycode from HTCX_LOG);

