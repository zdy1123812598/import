------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_11.log

prompt
prompt --11��Ԥ��
prompt

EXEC fnimptest_ysxx;
EXEC fnimptest_ysxx_bj_doc;
EXEC fnimptest_ysxx_bj_tran;
commit;

spool off