------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_10.log

prompt
prompt --10��Ԥ���Ԥ���Ѻ
prompt

EXEC fnimptest_ygspfygdj(100,2742,'Ԥ��ע��');
EXEC fnimptest_ygspfygdj_tran(100,2742,'Ԥ��ע��');
EXEC fnimptest_ygspfygdj_doc(100,2742,'Ԥ��ע��');
EXEC fnimptest_ygspfygdj(101,2739,'Ԥ����Ʒ��Ԥ��');
EXEC fnimptest_ygspfygdj_tran(101,2739,'Ԥ����Ʒ��Ԥ��');
EXEC fnimptest_ygspfygdj_doc(101,2739,'Ԥ����Ʒ��Ԥ��');
EXEC fnimptest_syqzyygdj(49,2731,'����Ȩת��Ԥ��');
EXEC fnimptest_syqzyygdj_tran(49,2731,'����Ȩת��Ԥ��');
EXEC fnimptest_syqzyygdj_doc(49,2731,'����Ȩת��Ԥ��');
EXEC fnimptest_ygspfdyygdj(120,2735,'Ԥ����Ʒ���趨��ѺȨԤ��');
EXEC fnimptest_ygspfdyygdj_tran(120,2735,'Ԥ����Ʒ���趨��ѺȨԤ��');
EXEC fnimptest_ygspfdyygdj_doc(120,2735,'Ԥ����Ʒ���趨��ѺȨԤ��');

commit;

spool off