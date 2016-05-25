------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_5.log

prompt
prompt --5、变更
prompt

EXEC fnimptest_bgdj(124,2595,'门牌号');
EXEC fnimptest_bgdj(6,2595,'自然状况');
EXEC fnimptest_bgdj(75,2600,'分割');
EXEC fnimptest_bgdj_next(137,2600,'合并');
EXEC fnimptest_bgdj_next(5,2595,'更名');
EXEC fnimptest_bgdj(135,2631,'自然状况更正');
EXEC fnimptest_bgdj(46,2631,'所有权更正');
EXEC fnimptest_bgdj(30,2595,'单位产');
EXEC fnimptest_bgdj(96,2596,'私产');
EXEC fnimptest_bgdj(27,2798,'私产');
EXEC fnimptest_bgdj(76,2798,'单位产');
EXEC fnimptest_bgdj(77,2798,'产权证补打');
EXEC fnimptest_bgxx_bj_tran(124,2595,'门牌号');
EXEC fnimptest_bgxx_bj_tran(6,2595,'自然状况');
EXEC fnimptest_bgxx_bj_tran(75,2600,'分割');
EXEC fnimptest_bgxx_bj_tran_next(137,2600,'合并');
EXEC fnimptest_bgxx_bj_tran_next(5,2595,'更名');
EXEC fnimptest_bgxx_bj_tran(135,2631,'自然状况更正');
EXEC fnimptest_bgxx_bj_tran(46,2631,'所有权更正');
EXEC fnimptest_bgxx_bj_tran(30,2595,'单位产');
EXEC fnimptest_bgxx_bj_tran(96,2596,'私产');
EXEC fnimptest_bgxx_bj_tran(27,2798,'私产');
EXEC fnimptest_bgxx_bj_tran(76,2798,'单位产');
EXEC fnimptest_bgxx_bj_tran(77,2798,'产权证补打');
EXEC fnimptest_bgxx_bj_doc(124,2595,'门牌号');
EXEC fnimptest_bgxx_bj_doc(6,2595,'自然状况');
EXEC fnimptest_bgxx_bj_doc(75,2600,'分割');
EXEC fnimptest_bgxx_bj_doc_next(137,2600,'合并');
EXEC fnimptest_bgxx_bj_doc_next(5,2595,'更名');
EXEC fnimptest_bgxx_bj_doc(135,2631,'自然状况更正');
EXEC fnimptest_bgxx_bj_doc(46,2631,'所有权更正');
EXEC fnimptest_bgxx_bj_doc(30,2595,'单位产');
EXEC fnimptest_bgxx_bj_doc(96,2596,'私产');
EXEC fnimptest_bgxx_bj_doc(27,2798,'私产');
EXEC fnimptest_bgxx_bj_doc(76,2798,'单位产');
EXEC fnimptest_bgxx_bj_doc(77,2798,'产权证补打');

commit;

spool off