create or replace procedure fnimptest_cqxx_bj_tran(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************
  3-----------2700  商品房
  79----------2483  个人建房
  80----------2484  单位建房
  129---------2700  经济适用房
  134---------2700  集体土地建房
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  l_stepno integer;
  l_uname  varchar2(200);
  l_date   date;
  l_cqzh   varchar2(500);
  l_humancode integer;
  iCount integer;
  iCount2 integer;
  iCount3 integer;
  iROLEID   integer:=7329;
  iActdefid integer:=2338;
begin
  for rs in(select a.keycode from t_keycode_yy a where a.t_user='eistran_yy' 
              and a.typeid=l_typeid  order by a.keycode
            /*select a.keycode from t_keycode_yy a where a.keycode='201307260111'*/)loop
    l_cqzh := null;
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
    img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into CQXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eistran_yy');
     else
       insert into CQXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eistran_yy');
       --插入cqxx
       select count(1) into iCount from eisdoc_yy.person a where a.keycode=rs.keycode;
       if iCount=0 then
         update CQXX_LOG set sjyy='无数据' where recid=iRecid;
       else
         insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,ywmc)
            select iRecid, a.name1, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,l_ywmc
              from eistran_yy.person a, eistran_yy.owner b
             where a.keycode = b.keycode(+)
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
         select a.ocertno into l_cqzh from eistran_yy.person a where a.keycode=rs.keycode and rownum=1;
         insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
           select
              sys_guid(),
              iRecid,
              sysdate,
              l_cqzh,
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
          select count(1) into iCount2 from eistran_yy.operation a where a.keycode=rs.keycode and a.accman like '%录档%';
          select count(1) into iCount3 from eistran_yy.operation a where a.keycode=rs.keycode;
          if iCount3=0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
          elsif iCount3>0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
          end if;
          if l_stepno=11 or iCount2>0 then
            update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='王东禄',a.cantoncode=10 where a.recid=iRecid;
          elsif l_stepno in (7,8,9,10) then
            update tbactinst t set t.enddate=sysdate,t.completed=1 where t.recid=iRecid and t.actdefname='受理';
            insert into tbactinst(recid,actid,partid,actdefid,actdefname,roleid,createdate,
                                  read,assigned,cancelable,completed,sendback)
               values(iRecid,seqactid.nextval,-1,iActdefid,'归档',iROLEID,sysdate,0,0,1,0,0);
          end if;
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
          select a.regeditman,a.regeditdate into l_uname,l_date from eistran_yy.operation a where a.keycode=rs.keycode;
          update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
          update cqxx s set s.dbr1=l_uname,s.dbsj1=l_date  where s.recid=iRecid;
       end if;
     end if;
  end loop;
  commit;
end;
/

