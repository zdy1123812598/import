------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_9.log

prompt
prompt --9����ͬ����
prompt

EXEC fnimptest_htcx_bj_tran(102,2788,'Ԥ�۱���ע��');
commit;

spool off