------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34        --
------------------------------------------------------

set define off
spool update_yy2_0_3.log

create table tbroom_yy as select * from tbroom where ssq = '��Դ��';
commit;

prompt
prompt Creating view ������ձ� T_KEYCODERECID_YY
prompt ============================
prompt
@\table\t_keycoderecid_yy.tab;
prompt
prompt Creating view ������ת�ۺϱ� T_ROOM_OPERATION_BIZ_RECID_YY
prompt ============================
prompt
@\table\t_room_operation_biz_recid_yy.tab;
prompt
prompt Creating function �ж��Ƿ�鵵���� FNISKEYCODEREGISTER_YY
prompt ============================
prompt
@\function\fniskeycoderegister_yy.fnc
prompt
prompt Creating view ������ϸ�ͷ���״��������ͼ V_FWMX_FWZK
prompt ===========================
prompt
@\view\v_fwmx_fwzk.vw
prompt
prompt Creating view ¥�̷�����ϸ�ͷ��ݹ�����ͼ V_LPFWMX_TBROOM
prompt ===========================
prompt
@\view\v_lpfwmx_tbroom.vw
prompt
prompt Creating table ���ݰ�������� TBLOG_RELINST_YY
prompt ============================
prompt
@\table\tblog_relinst_yy.tab
prompt
prompt Creating table ������ϸ������ TBLOG_KEYREF_YY
prompt ============================
prompt
@\table\tblog_keyref_yy.tab
prompt
prompt Creating table ���·���״̬��־�� TBLOG_UPDATEROOMSTATE_YY
prompt ===========================
prompt
@\table\tblog_updateroomstate_yy.tab
prompt
prompt Creating table ���·���״̬���ȱ� TBPROGRESS_UPDATEROOMSTATE_YY
prompt ===========================
prompt
@\table\tbprogress_updateroomstate_yy.tab
prompt
prompt Creating procedure �������ַ���״̬ FNUPDATEROOMSTATE_YY_CURHAND
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy_curhand.prc
prompt
prompt Creating procedure �������ַ���״̬ FNUPDATEROOMSTATE_YY_PREHAND
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy_prehand.prc
prompt
prompt Creating procedure ���·���״̬ FNUPDATEROOMSTATE_YY
prompt ===========================
prompt
@\procedure\fnupdateroomstate_yy.prc

spool off
