--��Դ�����
create table tbrec_yy as select * from tbrec where recid in (select recid from v_keycoderecid_yy);
select count(*) from tbrec_yy;
--���ݱ�
create table tbroom_yy as select * from tbroom where ssq='��Դ��';
create index TBROOM_RECIDs on TBROOM_YY (RECID);
select count(*) from tbroom_yy;
select * from tbroom_yy;

--¥�̿�
create table tbbuilding_yy as select * from tbbuilding where ssq='��Դ��';
select count(*) from tbbuilding_yy;
select * from tbbuilding_yy;
--Ԥ�ۺ�ͬ
create table ysht_yy as
select * from YSHT where recid in (select recid from v_keycoderecid_yy);
select count(*) from ysht_yy;
select * from ysht_yy;
--��Ȩ��Ϣ
create table cqxx_yy as
select * from cqxx where recid in (select recid from v_keycoderecid_yy);
select count(*) from cqxx_yy;
select * from cqxx_yy;

--��˵�
create table shd_yy as
select * from SHD where recid in (select recid from v_keycoderecid_yy);
select count(*) from shd_yy;
select * from shd_yy;


--��ͬ����
create table HTCX_yy as select * from HTCX where recid in (select recid from v_keycoderecid_yy);
select count(1) from HTCX_yy;
select * from HTCX_yy;


--¥�̷�����ϸ
create table LPFWMX_yy as select * from LPFWMX where recid in (select recid from v_keycoderecid_yy);
select count(1) from LPFWMX_yy ;
select * from LPFWMX_yy ;


--��ͬ��������Ϣ
create table HTGYRXX_yy as select * from HTGYRXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from HTGYRXX_yy ;
select * from HTGYRXX_yy ;


--����״��
create table fwzk_yy as select * from fwzk where recid in (select recid from v_keycoderecid_yy);
select count(1) from fwzk_yy ;
select * from fwzk_yy ;


--������Ϣ
create table gyxx_yy as select * from gyxx where recid in (select recid from v_keycoderecid_yy);
select count(1) from gyxx_yy ;
select * from gyxx_yy ;


--����״��
create table TDZK_yy as select * from TDZK where recid in (select recid from v_keycoderecid_yy);
select count(1) from TDZK_yy ;
select * from TDZK_yy ;


--�շ���Ϣ
create table SFXX_yy as select * from SFXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from SFXX_yy ;
select * from SFXX_yy ;


--�շѺϼ�
create table SFHJ_yy as select * from SFHJ where recid in (select recid from v_keycoderecid_yy);
select count(1) from SFHJ_yy ;
select * from SFHJ_yy ;


--������ϸ
create table fwmx_yy as select * from fwmx where recid in (select recid from v_keycoderecid_yy);
select count(1) from fwmx_yy ;
select * from fwmx_yy ;


--���Ǽ�
create table CFDJ_yy as select * from CFDJ where recid in (select recid from v_keycoderecid_yy);
select count(1) from CFDJ_yy ;
select * from CFDJ_yy ;


--������
create table cl_������_yy as select * from cl_������ where ����id in (select recid from v_keycoderecid_yy);
select count(1) from cl_������_yy;
select * from cl_������_yy;


--��Ѻ��Ϣ
create table dyxx_yy as select * from dyxx where recid in (select recid from v_keycoderecid_yy);
select count(1) from dyxx_yy ;
select * from dyxx_yy ;


--ע���ǼǱ�
create table ZXDJB_yy as select * from ZXDJB where recid in (select recid from v_keycoderecid_yy);
select count(1) from ZXDJB_yy ;
select * from ZXDJB_yy ;


--Ԥ����Ϣ
create table YSXX_yy as select * from YSXX where recid in (select recid from v_keycoderecid_yy);
select count(1) from YSXX_yy ;
select * from YSXX_yy ;


--�ʵ����
create table tbactinst_yy as select * from tbactinst where recid in (select recid from v_keycoderecid_yy);
select count(1) from tbactinst_yy ;
select * from tbactinst_yy ;



--Ҫ��
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