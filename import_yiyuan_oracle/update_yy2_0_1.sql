------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool update_yy2_0_1.log


prompt
prompt Creating table 旧系统业务和新系统房屋状态对照表 TBOLDBIZ_NEWROOM_STATE_YY
prompt ============================
prompt
@\table\tboldbiz_newroom_state_yy.sql;
prompt
prompt Creating view 抵押视图 V_MORTAGAGE_YY
prompt ============================
prompt
@\view\v_mortagage_yy.vw;
@\table\t_mortagage_yy.tab;
prompt
prompt Creating view 所有案卷 V_OPERATION_YY
prompt ============================
prompt
@\view\v_operation_yy.vw;
prompt
prompt Creating view 所有房屋案卷号对应关系 V_ROOMKEYCODE_YY
prompt ==============================
prompt
@\view\v_roomkeycode_yy.vw;
prompt
prompt Creating view 所有房屋对应的案卷信息 V_ROOM_OPERATION_YY
prompt =================================
prompt
@\view\v_room_operation_yy.vw;
prompt
prompt Creating view 所有房屋对应的案卷信息和业务信息 V_ROOM_OPERATION_BIZ_YY
prompt =====================================
prompt
@\view\v_room_operation_biz_yy.vw;
@\table\t_room_operation_biz_yy.tab;
prompt
prompt Creating view 房屋流转 V_ROOMTRAN_YY
prompt ===========================
prompt
@\view\v_roomtran_yy.vw;
@\table\t_roomtran_yy.tab;
prompt
prompt Creating view 案卷对照视图 V_KEYCODERECID_YY
prompt ============================
prompt
@\view\v_keycoderecid_yy.vw;

spool off
