------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------

----------------------------------------------------------------------------------------------------
---执行存储过程
----------------------------------------------------------------------------------------------------
set define off
spool update_yy1_1.log

prompt
prompt --1、楼盘库
prompt

EXEC fnimptest_lpk(2575);
EXEC fnimptest_lpk_wysxk(2575);
EXEC fnimptest_lpk_tb(2575);
commit;

spool off