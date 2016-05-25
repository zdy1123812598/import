------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_6.log

prompt
prompt --6、注销
prompt

EXEC fnimptest_zxxx;
EXEC fnimptest_zxxx_tran;
EXEC fnimptest_zxxx_doc;

commit;

spool off