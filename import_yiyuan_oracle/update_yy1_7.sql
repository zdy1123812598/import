------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_7.log

prompt
prompt --7����Ѻ
prompt

EXEC fnimptest_dyxx(125,2646,'��߶��Ѻ');
EXEC fnimptest_dyxx(126,2647,'��߶��Ѻ���');
EXEC fnimptest_dyxx(127,2648,'��߶��Ѻת��');
EXEC fnimptest_dyxx(128,2509,'��Ѻת��');
EXEC fnimptest_dyxx(20,2505,'˽��');
EXEC fnimptest_dyxx(84,2505,'��λ��');
EXEC fnimptest_dyxx(85,2508,'��Ѻ���');
EXEC fnimptest_dyxx(86,2710,'ע����Ѻ');
EXEC fnimptest_dyxx_bj_tran(125,2646,'��߶��Ѻ');
EXEC fnimptest_dyxx_bj_tran(126,2647,'��߶��Ѻ���');
EXEC fnimptest_dyxx_bj_tran(127,2648,'��߶��Ѻת��');
EXEC fnimptest_dyxx_bj_tran(128,2509,'��Ѻת��');
EXEC fnimptest_dyxx_bj_tran(20,2505,'˽��');
EXEC fnimptest_dyxx_bj_tran(84,2505,'��λ��');
EXEC fnimptest_dyxx_bj_tran(85,2508,'��Ѻ���');
EXEC fnimptest_dyxx_bj_tran(86,2710,'ע����Ѻ'); 
EXEC fnimptest_dyxx_bj_doc(125,2646,'��߶��Ѻ');
EXEC fnimptest_dyxx_bj_doc(126,2647,'��߶��Ѻ���');
EXEC fnimptest_dyxx_bj_doc(127,2648,'��߶��Ѻת��');
EXEC fnimptest_dyxx_bj_doc(128,2509,'��Ѻת��');
EXEC fnimptest_dyxx_bj_doc(20,2505,'˽��');
EXEC fnimptest_dyxx_bj_doc(84,2505,'��λ��');
EXEC fnimptest_dyxx_bj_doc(85,2508,'��Ѻ���');
EXEC fnimptest_dyxx_bj_doc(86,2710,'ע����Ѻ');

commit;

spool off