------------------------------------------------------
-- ��Դ���ݵ�������ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool clear_yy2.log


prompt
prompt Drop function �ж��Ƿ�鵵���� FNISKEYCODEDOC_YY
prompt ============================
prompt
drop function fniskeycodedoc_yy;
prompt
prompt Drop table ��ϵͳҵ�����ϵͳ����״̬���ձ� TBOLDBIZ_NEWROOM_STATE_YY
prompt ============================
prompt
drop table tboldbiz_newroom_state_yy;
prompt
prompt Drop view ���������ͼ V_KEYCODERECID_YY
prompt ============================
prompt
drop view v_keycoderecid_yy;
prompt
prompt Drop view ��Ѻ��ͼ V_MORTAGAGE_YY
prompt ============================
prompt
drop view v_mortagage_yy;
prompt
prompt Drop view ���а��� V_OPERATION_YY
prompt ============================
prompt
drop view v_operation_yy;
prompt
prompt Drop view ���з��ݰ���Ŷ�Ӧ��ϵ V_ROOMKEYCODE_YY
prompt ==============================
prompt
drop view v_roomkeycode_yy;
prompt
prompt Drop view ���з��ݶ�Ӧ�İ�����Ϣ V_ROOM_OPERATION_YY
prompt =================================
prompt
drop view v_room_operation_yy;
prompt
prompt Drop view ���з��ݶ�Ӧ�İ�����Ϣ��ҵ����Ϣ V_ROOM_OPERATION_BIZ_YY
prompt =====================================
prompt
drop view v_room_operation_biz_yy;
prompt
prompt Drop view ������ת V_ROOMTRAN_YY
prompt ===========================
prompt
drop view v_roomtran_yy;
prompt
prompt Drop view ������ϸ�ͷ���״��������ͼ V_FWMX_FWZK
prompt ===========================
prompt
drop view v_fwmx_fwzk;
prompt
prompt Drop view ¥�̷�����ϸ�ͷ��ݹ�����ͼ V_LPFWMX_TBROOM
prompt ===========================
prompt
drop view v_lpfwmx_tbroom;
prompt
prompt Drop table ���ݰ�������� TBLOG_RELINST_YY
prompt ============================
prompt
drop table tblog_relinst_yy;
prompt
prompt Drop table ������ϸ������ TBLOG_KEYREF_YY
prompt ============================
prompt
drop table tblog_keyref_yy;
prompt
prompt Drop table ���·���״̬��־�� TBLOG_UPDATEROOMSTATE_YY
prompt ===========================
prompt
drop table tblog_updateroomstate_yy;
prompt
prompt Drop table ���·���״̬���ȱ� TBPROGRESS_UPDATEROOMSTATE_YY
prompt ===========================
prompt
drop table tbprogress_updateroomstate_yy;
prompt
prompt Drop procedure �������ַ���״̬ FNUPDATEROOMSTATE_YY_CURHAND
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy_curhand;
prompt
prompt Drop procedure �������ַ���״̬ FNUPDATEROOMSTATE_YY_PREHAND
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy_prehand;
prompt
prompt Drop procedure ���·���״̬ FNUPDATEROOMSTATE_YY
prompt ===========================
prompt
drop procedure fnupdateroomstate_yy;

spool off
