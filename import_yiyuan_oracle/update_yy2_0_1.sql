------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool update_yy2_0_1.log


prompt
prompt Creating table ��ϵͳҵ�����ϵͳ����״̬���ձ� TBOLDBIZ_NEWROOM_STATE_YY
prompt ============================
prompt
@\table\tboldbiz_newroom_state_yy.sql;
prompt
prompt Creating view ��Ѻ��ͼ V_MORTAGAGE_YY
prompt ============================
prompt
@\view\v_mortagage_yy.vw;
@\table\t_mortagage_yy.tab;
prompt
prompt Creating view ���а��� V_OPERATION_YY
prompt ============================
prompt
@\view\v_operation_yy.vw;
prompt
prompt Creating view ���з��ݰ���Ŷ�Ӧ��ϵ V_ROOMKEYCODE_YY
prompt ==============================
prompt
@\view\v_roomkeycode_yy.vw;
prompt
prompt Creating view ���з��ݶ�Ӧ�İ�����Ϣ V_ROOM_OPERATION_YY
prompt =================================
prompt
@\view\v_room_operation_yy.vw;
prompt
prompt Creating view ���з��ݶ�Ӧ�İ�����Ϣ��ҵ����Ϣ V_ROOM_OPERATION_BIZ_YY
prompt =====================================
prompt
@\view\v_room_operation_biz_yy.vw;
@\table\t_room_operation_biz_yy.tab;
prompt
prompt Creating view ������ת V_ROOMTRAN_YY
prompt ===========================
prompt
@\view\v_roomtran_yy.vw;
@\table\t_roomtran_yy.tab;
prompt
prompt Creating view ���������ͼ V_KEYCODERECID_YY
prompt ============================
prompt
@\view\v_keycoderecid_yy.vw;

spool off
