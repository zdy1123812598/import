------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_10.log

prompt
prompt --10、预告和预告抵押
prompt

EXEC fnimptest_ygspfygdj(100,2742,'预告注销');
EXEC fnimptest_ygspfygdj_tran(100,2742,'预告注销');
EXEC fnimptest_ygspfygdj_doc(100,2742,'预告注销');
EXEC fnimptest_ygspfygdj(101,2739,'预购商品房预告');
EXEC fnimptest_ygspfygdj_tran(101,2739,'预购商品房预告');
EXEC fnimptest_ygspfygdj_doc(101,2739,'预购商品房预告');
EXEC fnimptest_syqzyygdj(49,2731,'所有权转让预告');
EXEC fnimptest_syqzyygdj_tran(49,2731,'所有权转让预告');
EXEC fnimptest_syqzyygdj_doc(49,2731,'所有权转让预告');
EXEC fnimptest_ygspfdyygdj(120,2735,'预购商品房设定抵押权预告');
EXEC fnimptest_ygspfdyygdj_tran(120,2735,'预购商品房设定抵押权预告');
EXEC fnimptest_ygspfdyygdj_doc(120,2735,'预购商品房设定抵押权预告');

commit;

spool off