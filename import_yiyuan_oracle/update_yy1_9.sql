------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_9.log

prompt
prompt --9、合同撤销
prompt

EXEC fnimptest_htcx_bj_tran(102,2788,'预售备案注销');
commit;

spool off