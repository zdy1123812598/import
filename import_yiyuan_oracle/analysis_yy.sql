--------------------------------------------------------
-- 沂源数据分析 dcx
--------------------------------------------------------
--tbrec
select * from eisdoc_yy.operation t;
select * from eistran_yy.operation t;
--tbbiz
select * from eistran_yy.Service  order by to_number(sercode);

select * from eistran_yy.Service  order by serclass;      

select * from eisdoc_yy.link_operation t;
select * from eistran_yy.link_operation t;
--根据房屋编号查案卷
select count(*) from eisdoc_yy.link_operation t;
select count(*) from eistran_yy.link_operation t;

--106827 套 链接信息
select count(distinct roomcode) from(
select t.roomcode from eisdoc_yy.link_operation t union
select t.roomcode from eistran_yy.link_operation t);

--128313 套
select count(distinct roomcode) from eisdoc_yy.Room t;
select count(*) from eisdoc_yy.Room t;

--63533 套
select count(distinct roomcode) from eistran_yy.Room t;
select count(*) from eistran_yy.Room t;

--所有房屋 131161 套
select count(distinct roomcode)
  from (select distinct roomcode
          from eisdoc_yy.Room
        union
        select distinct roomcode
          from eistran_yy.Room);
--视图 原系统房屋         
create view v_room_yy as
select roomcode from eisdoc_yy.Room union 
select roomcode from eistran_yy.Room;

select count( roomcode) from v_room_yy

select count(*) from v_room_yy where roomcode not in (select fwbh from tbroom where ssq='沂源县')

create view v_room_rest as
select roomcode from v_room_yy where roomcode not in (select fwbh from tbroom where ssq='沂源县')

create view v_fwbh_other as select fwbh from tbroom where ssq<>'沂源县'

select count(*) from v_room_rest a,v_fwbh_other b where a.roomcode = b.fwbh

select a.*,b.ssq from v_room_rest a left join tbroom b on a.roomcode = b.fwbh


select a.*,b.ssq from v_room_rest a left join tbroom b on a.roomcode = b.fwbh


select count(*) from tbroom where ssq is null

--淄博 869927 套
select count(distinct roomcode) from tbroom;

select * from tbroom;
select distinct ssq from tbroom;

--李杨 115520 套
select count(*) from tbroom where ssq = '沂源县';
select count(distinct fwbh) from tbroom where ssq = '沂源县';
-- 房屋案卷对应总表
select distinct roomcode,keycode from(
select s.roomcode,s.keycode from eisdoc_yy.link_operation s union
select t.roomcode,t.keycode from eistran_yy.link_operation t);

--237439  房屋案卷对应记录
select count(*) from (select distinct roomcode,keycode from(
select s.roomcode,s.keycode from eisdoc_yy.link_operation s union
select t.roomcode,t.keycode from eistran_yy.link_operation t));

select distinct keycode,acc_date from(
select s.keycode,s.acc_date from eisdoc_yy.operation s union
select t.keycode,t.acc_date from eistran_yy.operation t);

--122823 个案卷
select count(*) from (select distinct keycode,acc_date from(
select s.keycode,s.acc_date from eisdoc_yy.operation s union
select t.keycode,t.acc_date from eistran_yy.operation t));

--108522 个案卷
select count(*) from (select distinct keycode from(
select s.keycode from eisdoc_yy.operation s union
select t.keycode from eistran_yy.operation t));
--230669
select count(*) from (
select keycode,roomcode from eisdoc_yy.room union 
select keycode,roomcode from eistran_yy.room) 

--视图 所有房屋案卷对应关系
create view v_roomkeycode_yy as select distinct roomcode,keycode from(
select s.roomcode,s.keycode from eisdoc_yy.link_operation s union
select t.roomcode,t.keycode from eistran_yy.link_operation t);

select count(*) from v_roomkeycode_yy;--237439

select count(distinct roomcode ) from v_roomkeycode_yy;--106827

--没有参与流转的房屋
select count(*) from v_room_yy where roomcode not in (select roomcode from v_roomkeycode_yy)
create view v_room_notran_yy as 
select * from v_room_yy where roomcode not in (select roomcode from v_roomkeycode_yy);


--视图 所有案卷
create view v_operation_yy as select distinct keycode,acc_date,type_id from(
select s.keycode,s.acc_date,s.type_id from eisdoc_yy.operation s union
select t.keycode,t.acc_date,t.type_id from eistran_yy.operation t);
--视图 所有房屋对应的案卷信息
create view v_room_operation_yy as
select rk.roomcode,rk.keycode,op.acc_date,op.type_id from v_roomkeycode_yy rk left join v_operation_yy op on rk.keycode = op.keycode;
--视图 所有房屋对应的案卷信息和业务信息
create view v_room_operation_biz_yy as
select ro.roomcode,ro.keycode,ro.acc_date,to_number(s.sercode) sercode,s.serclass from v_room_operation_yy ro left join eistran_yy.Service s on ro.type_id = to_number(s.sercode);

--查询一个房屋涉及所有案卷按时间排序
select * from v_room_operation_biz_yy where roomcode='12398537171013' order by acc_date


select * from tbhousestate order by stateid;
select * from eistran_yy.workflow w where w.workcode = '50417EB7-6A28-4811-8825-83B8D38CE49C'


--视图 所有房屋对应的案卷信息和业务信息和流程所在阶段
create view v_room_operation_biz_act as
select ro.roomcode,ro.keycode,ro.acc_date,ro.type_id,s.serclass from v_room_operation_biz rob left join eistran_yy.workflow wf on rob.w = to_number(s.sercode);

--视图 案卷所处流程和环节 是否正常
create view keyworkcode as
select a.keycode,a.workcode,b.stepname,b.stepno,b.sercode,b.isvalid from eistran_yy.work_link a,eistran_yy.workflow b where a.workcode = b.workcode
select * from eistran_yy.operation t;

-----------------------------------------------------------------------------------------------
---1、初始登记 是否有效
-----------------------------------------------------------------------------------------------

select * from  keyworkcode where

select a.ysfwzt,a.fwzt,a. from tbroom a

select * from eistran_yy.Mortagage

select distinct fwzt from tbroom where ssq = '沂源县';
---创建关系表
create table tboldbiz_newroom_state_yy as select * from eistran_yy.Service  order by to_number(sercode);


select * from tboldbiz_newroom_state_yy order by serclass for update;
select * from tbhousestate order by stateid;
--视图 房屋流转
create view v_roomtran_yy as
select a.*,b.showforkfs,b.roomstate,b.weight from v_room_operation_biz_yy a,tboldbiz_newroom_state_yy b  where a.sercode = b.sercode  order by acc_date;

--视图 抵押表
create view v_mortagage_yy as
select distinct * from  (select * from eistran_yy.mortagage union
select * from eisdoc_yy.mortagage);

select distinct roomstate from v_roomtran where roomcode='12398537171013' and weight=(select max(weight) from  v_roomtran where roomcode='12398537171013');

select ysfwzt from tbroom;

select a.*,b.showforkfs,b.roomstate,b.weight from v_room_operation_biz a,tboldbiz_newroom_state_yy b  where a.sercode = b.sercode and roomcode='12398537171013' order by acc_date;

select * from v_mortagage_yy;

select * from v_roomtran_yy  where  roomcode = 12398537171013;

create table  tboldbiz_newroom_state_yy2 as select * from tboldbiz_newroom_state_yy;

create table tblog_updateroomstate_yy
(
  roomcode INTEGER,
  msg     VARCHAR2(1000)
)
;

create table tbprogress_updateroomstate_yy
(  
  msg     VARCHAR2(2000)
)
;

select * from tblog_updateroomstate_yy;
select distinct roomcode from tblog_updateroomstate_yy;
select * from tbprogress_updateroomstate_yy;

select * from fwzk where fwbh = '13407862836335';
select * from fwmx where fwbh = '13407862836335';
select * from t_keycode_ld;

create view v_keycoderecid_yy as
select distinct keycode,recid from(
select recid,keycode from ZXXX_LOG
union select recid,keycode from YSXX_LOG
union select recid,keycode from BGDJ_LOG
union select recid,keycode from ZYDJ_LOG
union select recid,keycode from DYXX_LOG
union select recid,keycode from CFXX_LOG
union select recid,keycode from YCFXX_LOG
union select recid,keycode from SPFYG_LOG
union select recid,keycode from SYQZYYG_LOG
union select recid,keycode from SPFDYYG_LOG
union select recid,keycode from CL_LOG
union select recid,keycode from CQXX_LOG
union select recid,keycode from BAHT_LOG
union select recid,keycode from HTCX_LOG)


select count(*) from YSXX_LOG where recid is null;
select count(*) from BGDJ_LOG where recid is null;
select count(*) from ZYDJ_LOG where recid is null;
select count(*) from DYXX_LOG where recid is null;
select count(*) from CFXX_LOG where recid is null;
select count(*) from YCFXX_LOG where recid is null;
select count(*) from SPFYG_LOG where recid is null;
select count(*) from SYQZYYG_LOG where recid is null;
select count(*) from SPFDYYG_LOG where recid is null;
select count(*) from CL_LOG where recid is null;
select count(*) from CQXX_LOG where recid is null;
select count(*) from BAHT_LOG where recid is null;--有问题
select count(*) from HTCX_LOG where recid is null;

select distinct(zyygzt) from fwzk where zyygzt is not null;
select * from fwzk where zgedyzt is not null;
select * from fwmx where fwmx
select * from tbrelinst;

select * from tbkeyref;

select count(*) from v_operation_yy where type_id in(31); --预售676
select count(*) from v_operation_yy where type_id in(32); --合同29456
select count(*) from v_operation_yy where type_id in(49,100,101,119,120,121);--预告5845
select count(*) from v_operation_yy where type_id in(20,82,83,84,85,86,125,126,127,128);--抵押16003
select count(*) from v_operation_yy where type_id in(3,79,80,129,134, 7,18,104,106,107,108,109,110,111,112,113,114,115,116,117,130,131,132,133,136,138,139,142, 5,6,75,124,137, 27,76,77);--产权50191（初始，转移，变更，补证）
create table tbrelinst as select * from tbrelinst_yy;
-------------------------------------------------------------------------------------------
select count(*) from v_operation_yy where type_id in(62,88,89,90); --预售676
---楼盘房屋明细
select count(*) from lpfwmx where recid in(select b.recid from v_operation_yy a,v_keycoderecid_yy b where a.keycode = b.keycode and type_id in(32));
--合同
select * from lpfwmx where recid in(select b.recid from v_operation_yy a,v_keycoderecid_yy b where a.keycode = b.keycode and type_id in(32))
--抵押
select * from fwmx where recid in(select b.recid from v_operation_yy a,v_keycoderecid_yy b where a.keycode = b.keycode and type_id in(20,82,83,84,85,86,125,126,127,128))


select * from lpfwmx where syqzh is not null and recid in(select b.recid from v_operation_yy a,v_keycoderecid_yy b where a.keycode = b.keycode and type_id in(32))

----------------------------关系日志表-----------------------------------------------------
create table tbrelinst_yy as select * from tbrelinst;
delete from tblog_relinst_yy;
create table tblog_keyref_yy as select * from tbkeyref;
delete from tbkeyref_yy;
-------------------------------------------------------------------------------------------
select * from tblog_updateroomstate_yy;
select * from tbprogress_updateroomstate_yy;
select * from tblog_relinst_yy;
select * from tblog_keyref_yy;

fnreclistcqxx;

delete from tblog_updateroomstate_yy;
delete from tblog_relinst_yy;
delete from tblog_keyref_yy;
delete from tbrelinst where srcrecid in (select recid from v_keycoderecid_yy );
delete from tbkeyref where recid in (select recid from v_keycoderecid_yy )


select * from tbrec where recid = 11129881;

select distinct(zyzt) from tbroom;

select count(*) from tbroom a,fwmx b where ssq = '沂源县' and a.fwbh = b.fwbh;


select * from tbroom a,tbrec b where a.recid=b.recid;

select distinct(procname) from tbroom a,tbrec b where a.recid=b.recid;


select a.* from tbroom a,fwmx b where ssq = '沂源县' and a.fwbh = b.fwbh;


select * from tblog_keyref_yy a,tbrec b where a.recid = b.recid and a.recid=11100997;


select * from fwmx where recid = 11119883;
select * from dyxx where recid = 11119883
select * from tbKeyref where recid = 11119883;

  select count(1) from tbKeyref a, dyxx b, tbRec c
    where a.refrecid = 11071978 and a.recid = b.RecID and b.recid = c.recid and nvl(b.foreshow,0)=0;
    
    
    select * from DACXTXQXX where recid = 11132994;
    select * from tbDocInfoTemp where recid = 11132994;
    
    fnupdateroomdata
