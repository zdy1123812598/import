------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_2.log

prompt
prompt --2、合同
prompt

EXEC fnimptest_baht;

commit;

spool off