------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_4.log

prompt
prompt --4、转移
prompt

EXEC fnimptest_zydj(7,2493,'二手房');
EXEC fnimptest_zydj(18,2494,'拆迁');
EXEC fnimptest_zydj(104,2494,'划拨');
EXEC fnimptest_zydj(106,2499,'分割');
EXEC fnimptest_zydj(107,2499,'合并');
EXEC fnimptest_zydj(108,2502,'司法裁决');
EXEC fnimptest_zydj(109,2757,'房产入股');
EXEC fnimptest_zydj(110,2494,'房改房');
EXEC fnimptest_zydj(111,2495,'继承');
EXEC fnimptest_zydj(112,2495,'赠与');
EXEC fnimptest_zydj(113,2701,'新建商品房');
EXEC fnimptest_zydj(114,2494,'单位产');
EXEC fnimptest_zydj(115,2605,'交换');
EXEC fnimptest_zydj(116,2494,'房改房上市');
EXEC fnimptest_zydj(117,2494,'经济适用房上市');
EXEC fnimptest_zydj(130,2494,'二手房无原产权');
EXEC fnimptest_zydj(131,2701,'经济适用房');
EXEC fnimptest_zydj(132,2759,'离婚');
EXEC fnimptest_zydj(133,2494,'经济适用房无原产权');
EXEC fnimptest_zydj(136,2494,'无原房拆迁');
EXEC fnimptest_zydj(138,2494,'有原产权房改房');
EXEC fnimptest_zydj_next(139,2494,'房改房过渡');
EXEC fnimptest_zydj_next(142,2494,'按揭转现');
EXEC fnimptest_zydj_doc(7,2493,'二手房');
EXEC fnimptest_zydj_doc(18,2494,'拆迁');
EXEC fnimptest_zydj_doc(104,2494,'划拨');
EXEC fnimptest_zydj_doc(106,2499,'分割');
EXEC fnimptest_zydj_doc(107,2499,'合并');
EXEC fnimptest_zydj_doc(108,2502,'司法裁决');
EXEC fnimptest_zydj_doc(109,2757,'房产入股');
EXEC fnimptest_zydj_doc(110,2494,'房改房');
EXEC fnimptest_zydj_doc(111,2495,'继承');
EXEC fnimptest_zydj_doc(112,2495,'赠与');
EXEC fnimptest_zydj_doc(113,2701,'新建商品房');
EXEC fnimptest_zydj_doc(114,2494,'单位产');
EXEC fnimptest_zydj_doc(115,2605,'交换');
EXEC fnimptest_zydj_doc(116,2494,'房改房上市');
EXEC fnimptest_zydj_doc(117,2494,'经济适用房上市');
EXEC fnimptest_zydj_doc(130,2494,'二手房无原产权');
EXEC fnimptest_zydj_doc(131,2701,'经济适用房');
EXEC fnimptest_zydj_doc(132,2759,'离婚');
EXEC fnimptest_zydj_doc(133,2494,'经济适用房无原产权');
EXEC fnimptest_zydj_doc(136,2494,'无原房拆迁');
EXEC fnimptest_zydj_doc(138,2494,'有原产权房改房');
EXEC fnimptest_zydj_doc_next(139,2494,'房改房过渡');
EXEC fnimptest_zydj_doc_next(142,2494,'按揭转现');
EXEC fnimptest_zydj_tran(7,2493,'二手房');
EXEC fnimptest_zydj_tran(18,2494,'拆迁');
EXEC fnimptest_zydj_tran(104,2494,'划拨');
EXEC fnimptest_zydj_tran(106,2499,'分割');
EXEC fnimptest_zydj_tran(107,2499,'合并');
EXEC fnimptest_zydj_tran(108,2502,'司法裁决');
EXEC fnimptest_zydj_tran(109,2757,'房产入股');
EXEC fnimptest_zydj_tran(110,2494,'房改房');
EXEC fnimptest_zydj_tran(111,2495,'继承');
EXEC fnimptest_zydj_tran(112,2495,'赠与');
EXEC fnimptest_zydj_tran(113,2701,'新建商品房');
EXEC fnimptest_zydj_tran(114,2494,'单位产');
EXEC fnimptest_zydj_tran(115,2605,'交换');
EXEC fnimptest_zydj_tran(116,2494,'房改房上市');
EXEC fnimptest_zydj_tran(117,2494,'经济适用房上市');
EXEC fnimptest_zydj_tran(130,2494,'二手房无原产权');
EXEC fnimptest_zydj_tran(131,2701,'经济适用房');
EXEC fnimptest_zydj_tran(132,2759,'离婚');
EXEC fnimptest_zydj_tran(133,2494,'经济适用房无原产权');
EXEC fnimptest_zydj_tran(136,2494,'无原房拆迁');
EXEC fnimptest_zydj_tran(138,2494,'有原产权房改房');
EXEC fnimptest_zydj_tran_next(139,2494,'房改房过渡');
EXEC fnimptest_zydj_tran_next(142,2494,'按揭转现');

commit;

spool off