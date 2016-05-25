------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool update_yy2_0_3.log

create table tbroom_yy as select * from tbroom where ssq = '沂源县';
commit;

prompt
prompt Creating view 案卷对照表 T_KEYCODERECID_YY
prompt ============================
prompt
@\table\t_keycoderecid_yy.tab;
prompt
prompt Creating view 房屋流转综合表 T_ROOM_OPERATION_BIZ_RECID_YY
prompt ============================
prompt
@\table\t_room_operation_biz_recid_yy.tab;
prompt
prompt Creating function 判断是否归档案卷 FNISKEYCODEREGISTER_YY
prompt ============================
prompt
@\function\fniskeycoderegister_yy.fnc
prompt
prompt Creating view 房屋明细和房屋状况关联视图 V_FWMX_FWZK
prompt ===========================
prompt
@\view\v_fwmx_fwzk.vw
prompt
prompt Creating view 楼盘房屋明细和房屋关联视图 V_LPFWMX_TBROOM
prompt ===========================
prompt
@\view\v_lpfwmx_tbroom.vw
prompt
prompt Creating table 房屋案卷关联表 TBLOG_RELINST_YY
prompt ============================
prompt
@\table\tblog_relinst_yy.tab
prompt
prompt Creating table 房屋明细关联表 TBLOG_KEYREF_YY
prompt ============================
prompt
@\table\tblog_keyref_yy.tab
prompt
prompt Creating table 更新房屋状态日志表 TBLOG_UPDATEROOMSTATE_YY
prompt ===========================
prompt
@\table\tblog_updateroomstate_yy.tab
prompt
prompt Creating table 更新房屋状态进度表 TBPROGRESS_UPDATEROOMSTATE_YY
prompt ===========================
prompt
@\table\tbprogress_updateroomstate_yy.tab
prompt
prompt Creating procedure 更新现手房屋状态 FNUPDATEROOMSTATE_YY_CURHAND
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy_curhand.prc
prompt
prompt Creating procedure 更新上手房屋状态 FNUPDATEROOMSTATE_YY_PREHAND
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy_prehand.prc
prompt
prompt Creating procedure 更新房屋状态 FNUPDATEROOMSTATE_YY
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy.prc

spool off
