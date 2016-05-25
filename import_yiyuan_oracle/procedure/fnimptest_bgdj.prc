create or replace procedure fnimptest_bgdj(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  l_Cqzh  varchar2(200);
  l_humancode integer;
begin
  for rs in(
    select a.keycode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=l_typeid and stepno in (0,1,2,3,4,5,6))
      and a.type_id = l_typeid  order by a.keycode
    )loop
    l_Cqzh := null;
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into BGDJ_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into BGDJ_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
       --插入cqxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
          select iRecid, a.name1, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,c.name,c.ocertno,c.address,c.cert_no,c.tel,l_ywmc
            from eistran_yy.person a, eistran_yy.owner b,eistran_yy.oldperson c
           where a.keycode = b.keycode(+)
             and a.keycode = c.keycode(+)
             and a.keycode = rs.keycode
             and rownum = 1;
       --插入审核单
       insert into SHD (recid,SLR,Slr_Rq,SLYJ,CSR,Csr_Rq,Csyj,Fsr,Fsr_Rq,FSYJ,DBR,DBYJ,DBR_RQ)
          select iRecid,
                 f.r_man,
                 f.r_date,
                 f.r_mark,
                 f.first_man,
                 f.first_date,
                 f.first_mark,
                 f.aud_man,
                 f.aud_date,
                 f.aud_mark,
		 f.eaa_man,
		 f.eaa_mark,
		 f.eaa_date
            from EISTRAN_YY.EAA_Table f
           where f.keycode = rs.keycode;
       --插入房屋状况（FWZK）
       select a.ocertno into l_Cqzh from eistran_yy.person a where a.keycode=rs.keycode and rownum=1;
       insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
         select
            sys_guid(),
            iRecid,
            sysdate,
            l_Cqzh,
            b.roomcode 房屋编号,
            b.land_no 丘号,
            b.build_no 幢号,
            b.room_no 房号,
	    b.room_no 房号,
            b.b_area 建筑面积,
            b.set_area 套内面积,
	    b.s_area 分摊面积,
            b.curfloor 所在层,
            b.h_use 房屋用途,
	    b.h_use 房屋用途,
            b.house_type 住房类型,
            b.house_sit 房屋坐落,
            '沂源县',
            '10',
            '10'||'-'||b.land_no||'-'||b.build_no||'-'||b.room_no 产籍号,
            1
            from eistran_yy.Room b
         where b.keycode=rs.keycode;
        --插入共有信息
        insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,ycqrgx,
                         zyfe,gyr,gyzh,lxdh,lxdz,bz)
          select sys_guid(),
                 iRecid,
                 sysdate,
                 a.certno,
                 a.certname,
                 a.conn,
                 a.share1,
                 a.name,
                 a.code,
                 a.tel,
                 a.address,
                 a.mark
            from eistran_yy.CU_Person a
           where a.keycode = rs.keycode;
        --插入土地状况
        insert into TDZK(UUID,RECID,TDMJ,TDQDFS,TDQSXZ,TDZH,TDYT,DH,TDSYQXZ,BZ,TDSYQX)
          select sys_guid(),
                 iRecid,
                 a.larea,
                 a.lfrom,
                 a.property,
                 a.cardnum,
                 a.landuse,
                 a.land_no,
                 a.enddate,
                 a.mark,
                 a.startdate
             from eistran_yy.land a
           where a.keycode=rs.keycode;
        --插入收费信息和收费合计
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
        
        select count(1) into iCount from eistran_yy.person a where a.keycode=rs.keycode;
        --要件
        delete from tbrecdoc where recid=iRecid;
        insert into tbrecdoc(docid,recid,docdefid,docname,doctype,disporder,copies,pages,checked,groupid,y_docid)
           select seqdocid.nextval,
                  iRecid,
                  0,
                  a.name,
                  decode(a.type, '复印件', 2, '原件', 1, 3),
                  0,
                  1,
                  a.pages,
                  1,
                  1,
                  a.id
             from eistran_yy.IMPORTANT_DOC a
            where a.keycode = rs.keycode and a.id <>0;
        fnupdayj(iRecid,rs.keycode);
        update tbrec set recnum=rs.keycode where recid=iRecid;
     end if;
  end loop;
  commit;
end;
/

