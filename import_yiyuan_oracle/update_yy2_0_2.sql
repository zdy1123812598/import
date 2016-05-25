------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy2_0_2.log

prompt
prompt --特殊处理
prompt

@\procedure\fnimptest_cqxx_doc_special_del.prc;
@\procedure\fnimptest_cqxx_doc_special_add.prc;

EXEC fnimptest_cqxx_doc_special_del;
EXEC fnimptest_cqxx_doc_special_add;

commit;

spool off