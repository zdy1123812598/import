------------------------------------------------------
-- 沂源数据导库清理脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool clear_yy2.log


prompt
prompt Drop function 判断是否归档案卷 FNISKEYCODEDOC_YY
prompt ============================
prompt
drop function fniskeycodedoc_yy;
prompt
prompt Drop table 旧系统业务和新系统房屋状态对照表 TBOLDBIZ_NEWROOM_STATE_YY
prompt ============================
prompt
drop table tboldbiz_newroom_state_yy;
prompt
prompt Drop view 案卷对照视图 V_KEYCODERECID_YY
prompt ============================
prompt
drop view v_keycoderecid_yy;
prompt
prompt Drop view 抵押视图 V_MORTAGAGE_YY
prompt ============================
prompt
drop view v_mortagage_yy;
prompt
prompt Drop view 所有案卷 V_OPERATION_YY
prompt ============================
prompt
drop view v_operation_yy;
prompt
prompt Drop view 所有房屋案卷号对应关系 V_ROOMKEYCODE_YY
prompt ==============================
prompt
drop view v_roomkeycode_yy;
prompt
prompt Drop view 所有房屋对应的案卷信息 V_ROOM_OPERATION_YY
prompt =================================
prompt
drop view v_room_operation_yy;
prompt
prompt Drop view 所有房屋对应的案卷信息和业务信息 V_ROOM_OPERATION_BIZ_YY
prompt =====================================
prompt
drop view v_room_operation_biz_yy;
prompt
prompt Drop view 房屋流转 V_ROOMTRAN_YY
prompt ===========================
prompt
drop view v_roomtran_yy;
prompt
prompt Drop view 房屋明细和房屋状况关联视图 V_FWMX_FWZK
prompt ===========================
prompt
drop view v_fwmx_fwzk;
prompt
prompt Drop view 楼盘房屋明细和房屋关联视图 V_LPFWMX_TBROOM
prompt ===========================
prompt
drop view v_lpfwmx_tbroom;
prompt
prompt Drop table 房屋案卷关联表 TBLOG_RELINST_YY
prompt ============================
prompt
drop table tblog_relinst_yy;
prompt
prompt Drop table 房屋明细关联表 TBLOG_KEYREF_YY
prompt ============================
prompt
drop table tblog_keyref_yy;
prompt
prompt Drop table 更新房屋状态日志表 TBLOG_UPDATEROOMSTATE_YY
prompt ===========================
prompt
drop table tblog_updateroomstate_yy;
prompt
prompt Drop table 更新房屋状态进度表 TBPROGRESS_UPDATEROOMSTATE_YY
prompt ===========================
prompt
drop table tbprogress_updateroomstate_yy;
prompt
prompt Drop procedure 更新现手房屋状态 FNUPDATEROOMSTATE_YY_CURHAND
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy_curhand;
prompt
prompt Drop procedure 更新上手房屋状态 FNUPDATEROOMSTATE_YY_PREHAND
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy_prehand;
prompt
prompt Drop procedure 更新房屋状态 FNUPDATEROOMSTATE_YY
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy;

spool off
