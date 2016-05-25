------------------------------------------------------
-- 沂源数据导库脚本删除20150705                      --
-- Created by zdy on 2015-07-05, 10:36:34 --
------------------------------------------------------

----------------------------------------------------------------------------------------------------
---删除数据导入使用的存储过程  zdy
----------------------------------------------------------------------------------------------------
--1、楼盘库

drop procedure fnimptest_insertroom;
drop procedure fnimptest_insertroom_wysxk;
drop procedure fnimptest_lpk;
drop procedure fnimptest_lpk_wysxk;
drop procedure fnimptest_lpk_tb;
drop table lpk_log;
drop view eisdoc_room;
drop view eisdoc_wys_room;



--2、合同

drop procedure fnhetonginfo;
drop procedure fnhetonginfosp;
drop procedure fnhetonginfo2;
drop procedure fnimptest_baht;
drop procedure fnimptest_baht2;
drop view V_合同;
drop table baht_log;
drop table tbhetongcaoben;
drop table tbhetongdzck;




--3、初始

drop procedure fnupdayj;
drop procedure fnimptest_cqxx;
drop procedure fnimptest_cqxx_80;
drop procedure fnimptest_cqxx_bj_doc;
drop procedure fnimptest_cqxx_bj_doc_80;
drop procedure fnimptest_cqxx_bj_tran;
drop procedure fnimptest_cqxx_bj_tran_80;
drop table resxx_log;
drop table cfxx_log;
drop table t_recid;




--4、转移

drop procedure fnimptest_zydj;
drop procedure fnimptest_zydj_next;
drop procedure fnimptest_zydj_doc;
drop procedure fnimptest_zydj_doc_next;
drop procedure fnimptest_zydj_tran;
drop procedure fnimptest_zydj_tran_next;
drop table zydj_log;


--5、变更

drop procedure fnimptest_bgdj;
drop procedure fnimptest_bgdj_next;
drop procedure fnimptest_bgxx_bj_tran;
drop procedure fnimptest_bgxx_bj_tran_next;
drop procedure fnimptest_bgxx_bj_doc;
drop procedure fnimptest_bgxx_bj_doc_next;

--6、注销

drop procedure fnimptest_zxxx;
drop procedure fnimptest_zxxx_tran;
drop procedure fnimptest_zxxx_doc;
drop table zxxx_log;



--7、抵押

drop procedure fnimptest_dyxx;
drop procedure fnimptest_dyxx_bj_tran;
drop procedure fnimptest_dyxx_bj_doc;

--8、查封、预查封、解封、预解封

drop procedure fnimptest_cfxx;
drop procedure fnimptest_cfxx_bj_tran;
drop procedure fnimptest_cfxx_bj_doc;
drop procedure fnimptest_ycfxx;
drop procedure fnimptest_ycfxx_bj_tran;
drop procedure fnimptest_ycfxx_bj_doc;
drop procedure fnimptest_jfxx;
drop procedure fnimptest_jfxx_tran;
drop procedure fnimptest_jfxx_doc;
drop procedure fnimptest_yjfxx;
drop procedure fnimptest_yjfxx_bj_tran;
drop procedure fnimptest_yjfxx_bj_doc;
drop table ycfxx_log;



--9、合同撤销

drop procedure fnimptest_htcx_bj_tran;
drop table htcx_log;


--10、预告和预告抵押

drop procedure fnimptest_ygspfygdj;
drop procedure fnimptest_ygspfygdj_tran;
drop procedure fnimptest_ygspfygdj_doc;
drop procedure fnimptest_syqzyygdj;
drop procedure fnimptest_syqzyygdj_tran;
drop procedure fnimptest_syqzyygdj_doc;
drop procedure fnimptest_ygspfdyygdj;
drop procedure fnimptest_ygspfdyygdj_tran;
drop procedure fnimptest_ygspfdyygdj_doc;
drop table t_test;
drop table spfyg_log;
drop table syqzyyg_log;
drop table spfdyyg_log;


--11、预售

drop procedure fnimptest_ysxx;
drop procedure fnimptest_ysxx_bj_doc;
drop procedure fnimptest_ysxx_bj_tran;
drop table ysxx_log;


--删除表字段
alter table YSLPXX drop column y_qh;
alter table YSLPXX drop column y_zh;
alter table tbrecdoc drop column y_docid;
alter table TBFILE drop column y_docid;
alter table TBFILE drop column t_recid;



--删除表,序列
drop table bgdj_log;
drop table cqxx_log;
drop table dyxx_log;
drop table lpk_wys_log;
drop table cl_log;
drop table t_keycode;
drop table t_keycode_ld;
drop table tbvices;

drop sequence seqhumancode;
drop sequence seqhuman;

commit;