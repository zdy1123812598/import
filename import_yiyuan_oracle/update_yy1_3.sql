------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_3.log

prompt
prompt --3����ʼ
prompt

EXEC fnimptest_cqxx(3,2700,'��Ʒ��');
EXEC fnimptest_cqxx(79,2483,'���˽���');
EXEC fnimptest_cqxx_80(80,2484,'��λ����');
EXEC fnimptest_cqxx(129,2700,'�������÷�');
EXEC fnimptest_cqxx(134,2795,'�������ؽ���');
EXEC fnimptest_cqxx_bj_doc(3,2700,'��Ʒ��');
EXEC fnimptest_cqxx_bj_doc(79,2483,'���˽���');
EXEC fnimptest_cqxx_bj_doc_80(80,2484,'��λ����');
EXEC fnimptest_cqxx_bj_doc(129,2700,'�������÷�');
EXEC fnimptest_cqxx_bj_doc(134,2795,'�������ؽ���');
EXEC fnimptest_cqxx_bj_tran(3,2700,'��Ʒ��');
EXEC fnimptest_cqxx_bj_tran(79,2483,'���˽���');
EXEC fnimptest_cqxx_bj_tran_80(80,2484,'��λ����');
EXEC fnimptest_cqxx_bj_tran(129,2700,'�������÷�');
EXEC fnimptest_cqxx_bj_tran(134,2795,'�������ؽ���');
commit;

spool off