------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_8.log

prompt
prompt --8、查封、预查封、解封、预解封
prompt

EXEC fnimptest_cfxx;
EXEC fnimptest_cfxx_bj_tran;
EXEC fnimptest_cfxx_bj_doc;
EXEC fnimptest_ycfxx;
EXEC fnimptest_ycfxx_bj_tran;
EXEC fnimptest_ycfxx_bj_doc;
EXEC fnimptest_jfxx;
EXEC fnimptest_jfxx_tran;
EXEC fnimptest_jfxx_doc;
EXEC fnimptest_yjfxx;
EXEC fnimptest_yjfxx_bj_tran;
EXEC fnimptest_yjfxx_bj_doc;

commit;

spool off