--沂源案卷表
create table tbrec_yy as select * from tbrec where recid in (select recid from v_keycoderecid_yy);
select count(*) from tbrec_yy;
--房屋表
create table tbroom_yy as select * from tbroom where ssq='沂源县';
create index TBROOM_RECIDs on TBROOM_YY (RECID);
select count(*) from tbroom_yy;
select * from tbroom_yy;

--楼盘库
create table tbbuilding_yy as select * from tbbuilding where ssq='沂源县';
select count(*) from tbbuilding_yy;
select * from tbbuilding_yy;
--预售合同
create table ysht_yy as
select * from YSHT where recid in (select recid from v_keycoderecid_yy);
select count(*) from ysht_yy;
select * from ysht_yy;
--产权信息
create table cqxx_yy as
select * from cqxx where recid in (select recid from v_keycoderecid_yy);
select count(*) from cqxx_yy;
select * from cqxx_yy;

--审核单
create table shd_yy as
select * from SHD where recid in (select recid from v_keycoderecid_yy);
select count(*) from shd_yy;
select * from shd_yy;


--合同撤销
create table HTCX_yy as select * from HTCX where recid in (select recid from v_keycoderecid_yy);
select count(1) from HTCX_yy;
select * from HTCX_yy;


--楼盘房屋明细
create table LPFWMX_yy as select * from LPFWMX where recid in (select recid from v_keycoderecid_yy);
select count(1) from LPFWMX_yy ;
select * from LPFWMX_yy ;


--合同共有人信息
create table HTGYRXX_yy as select * from HTGYRXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from HTGYRXX_yy ;
select * from HTGYRXX_yy ;


--房屋状况
create table fwzk_yy as select * from fwzk where recid in (select recid from v_keycoderecid_yy);
select count(1) from fwzk_yy ;
select * from fwzk_yy ;


--共有信息
create table gyxx_yy as select * from gyxx where recid in (select recid from v_keycoderecid_yy);
select count(1) from gyxx_yy ;
select * from gyxx_yy ;


--土地状况
create table TDZK_yy as select * from TDZK where recid in (select recid from v_keycoderecid_yy);
select count(1) from TDZK_yy ;
select * from TDZK_yy ;


--收费信息
create table SFXX_yy as select * from SFXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from SFXX_yy ;
select * from SFXX_yy ;


--收费合计
create table SFHJ_yy as select * from SFHJ where recid in (select recid from v_keycoderecid_yy);
select count(1) from SFHJ_yy ;
select * from SFHJ_yy ;


--房屋明细
create table fwmx_yy as select * from fwmx where recid in (select recid from v_keycoderecid_yy);
select count(1) from fwmx_yy ;
select * from fwmx_yy ;


--查封登记
create table CFDJ_yy as select * from CFDJ where recid in (select recid from v_keycoderecid_yy);
select count(1) from CFDJ_yy ;
select * from CFDJ_yy ;


--存量房
create table cl_备案表_yy as select * from cl_备案表 where 备案id in (select recid from v_keycoderecid_yy);
select count(1) from cl_备案表_yy;
select * from cl_备案表_yy;


--抵押信息
create table dyxx_yy as select * from dyxx where recid in (select recid from v_keycoderecid_yy);
select count(1) from dyxx_yy ;
select * from dyxx_yy ;


--注销登记表
create table ZXDJB_yy as select * from ZXDJB where recid in (select recid from v_keycoderecid_yy);
select count(1) from ZXDJB_yy ;
select * from ZXDJB_yy ;


--预售信息
create table YSXX_yy as select * from YSXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from YSXX_yy ;
select * from YSXX_yy ;


--活动实例表
create table tbactinst_yy as select * from tbactinst where recid in (select recid from v_keycoderecid_yy);
select count(1) from tbactinst_yy ;
select * from tbactinst_yy ;



--要件
create table tbrecdoc_yy as select * from tbrecdoc where recid in (select recid from v_keycoderecid_yy);
select count(1) from tbrecdoc_yy ;
select * from tbrecdoc_yy ;
--
create table tbrecdocfile_yy as select * from tbrecdocfile b where b.docid in (select a.docid from tbrecdoc a  where a.recid in (select recid from v_keycoderecid_yy));
select count(1) from tbrecdocfile_yy ;
select * from tbrecdocfile_yy ;
--
/*
alter table TBFILE add T_RECID integer;
declare
begin
  for rs in (select a.recid,a.docid from tbrecdoc a where a.recid in (select recid from v_keycoderecid_yy))loop
    for rn in (select b.docid,b.fileid from tbrecdocfile b where b.docid=rs.docid)loop
      update TBFILE c set c.t_recid=rs.recid where c.fileid=rn.fileid;
    end loop;
  end loop;
  commit;
end;


declare
begin
  for rs in (select a.recid,a.docid,b.keycode from tbrecdoc a,v_keycoderecid_yy b where a.recid=b.recid)loop
    for rn in (select b.docid,b.fileid from tbrecdocfile b where b.docid=rs.docid)loop
      for rw in (select a.disporder,a.id,a.filename from tbvices a where a.keycode=rs.keycode and a.docid=rn.docid)loop
        update TBFILE c
           set c.t_recid       = rs.recid,
               c.filepath      = '/ImpDoc/yyyj/DocFiles_' ||
                                 substr(rs.keycode, 1, 6),
               c.STOREFILENAME = rw.disporder || '_' || rw.id || '_' ||
                                 rw.filename
         where c.fileid = rn.fileid;
      end loop; 
    end loop;
  end loop;
  commit;
end;
*/

create table TBFILE_yy as select * from TBFILE where t_recid in (select recid from v_keycoderecid_yy);
select count(1) from TBFILE_yy ;
select * from TBFILE_yy ;

create index tbroom_recids on tbroom_yy(recid);
create unique index tbrecdoc_pks on tbrecdoc_yy(docid);
create index tbrecdoc_recididxs on tbrecdoc_yy(recid);