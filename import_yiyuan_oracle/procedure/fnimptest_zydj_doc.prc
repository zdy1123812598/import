create or replace procedure fnimptest_zydj_doc(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1  integer;
  iCount2 integer;
  iCount3 integer;
  iCount4 integer;
  iCount5 integer;
  iCount6 integer;
  iCount7 integer;
  l_stepno integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
  l_Cqzh   varchar2(200);
  iActdefid integer:=40;
  iROLEID   integer:=9632;
  l_ocertno VARCHAR2(80);  
begin
  for rs in(select a.keycode from t_keycode_yy a where a.t_user='eisdoc_yy' 
               and a.typeid=l_typeid order by a.keycode
             /*select s.keycode from t_keycode_yy s where s.keycode='201009250089'*/)loop
      l_Cqzh := null;
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into ZYDJ_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
     else
       insert into ZYDJ_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
       --插入cqxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       select count(1) into iCount2 from eisdoc_yy.person a where a.keycode=rs.keycode;
       select count(1) into iCount4 from eisdoc_yy.owner a where a.keycode=rs.keycode;
       if iCount2=0 and iCount4=0 then
         update ZYDJ_LOG set sjyy='无数据' where recid=iRecid;
         --exit;
       elsif iCount2>0 then
         if l_typeid<>115 then
           insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.name, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,
                      d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc 
                from eisdoc_yy.person a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
               where a.keycode = b.keycode(+)
                 and a.keycode = c.keycode(+)
                 and c.oldocertno=d.ocertno(+)
                 and a.keycode = rs.keycode
                 and rownum = 1;
         elsif l_typeid=115 then
            insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.name, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,
                    d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc
              from eisdoc_yy.person a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
             where a.keycode = b.keycode(+)
               and a.keycode = c.keycode(+)
               and c.oldocertno=d.ocertno(+)
               and a.keycode = rs.keycode
               and c.subkeycode=2
               and rownum = 1;
         end if;
       elsif iCount2=0 and iCount4>0 then
         if l_typeid<>115 then
           insert into cqxx (recid,cqr,zjhm,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.appman, a.appidcno, a.appcellphone,b.ocertno,b.osort,b.oshare,rs.keycode,
                      d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc 
                from eisdoc_yy.operation a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
               where a.keycode = b.keycode(+)
                 and a.keycode = c.keycode(+)
                 and c.oldocertno=d.ocertno(+)
                 and a.keycode = rs.keycode
                 and rownum = 1;
         elsif l_typeid=115 then
            insert into cqxx (recid,cqr,zjhm,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.appman, a.appidcno, a.appcellphone,b.ocertno,b.osort,b.oshare,rs.keycode,
                    d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc
              from eisdoc_yy.operation a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
             where a.keycode = b.keycode(+)
               and a.keycode = c.keycode(+)
               and c.oldocertno=d.ocertno(+)
               and a.keycode = rs.keycode
               and c.subkeycode=2
               and rownum = 1;
         end if;
       end if;
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
            from eisdoc_yy.EAA_Table f
           where f.keycode = rs.keycode;
       --插入房屋状况（FWZK）
       if l_typeid<>115 then
          --所有权账号   从eisdoc_yy.owner取出oce no字段赋值给变量l_ocertno
	   select count(1) into iCount7  from eisdoc_yy.owner where keycode=rs.keycode and rownum=1;
	  if  iCount7>0 then
		select ocertno into l_ocertno from eisdoc_yy.owner where keycode=rs.keycode and rownum=1;
	  else
		l_ocertno := 'empty';
	  end if;
         --遍历eisdoc_yy.owner的roomcode 与eisdoc_yy.room 关联取rownum=1
	 --fix by dcx
        for rn in (select h.roomcode from eisdoc_yy.owner h where keycode=rs.keycode)loop
              insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
               select
                  sys_guid(),
                  iRecid,
                  sysdate,
                  l_ocertno,
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
                 from eisdoc_yy.room b
                where b.roomcode=rn.roomcode and rownum=1;
            end loop;
        elsif l_typeid=115 then
          insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
           select
              sys_guid(),
              iRecid,
              sysdate,
              c.ocertno,
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
             from eisdoc_yy.history_room b,eisdoc_yy.person c
            where b.keycode=rs.keycode and c.keycode = rs.keycode
              and b.subkeycode=2;
        end if;
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
            from eisdoc_yy.CU_Person a
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
             from eisdoc_yy.land a
           where a.keycode=rs.keycode and rownum=1;
        --插入收费信息和收费合计
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        select count(1) into iCount1 from eisdoc_yy.operation a where a.keycode=rs.keycode and a.accman like '%录档%';
        select count(1) into iCount3 from eisdoc_yy.operation a where a.keycode=rs.keycode;
        if iCount3>0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
        elsif iCount3=0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
        end if;
        if l_stepno=11 or iCount1>0  then
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
                  decode(a.pages,'１',1,a.pages),
                  1,
                  1,
                  a.id
             from eisdoc_yy.IMPORTANT_DOC a
            where a.keycode = rs.keycode and a.id <>0;
        fnupdayj(iRecid,rs.keycode);        
        select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
        update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
        update cqxx c set c.dbr1=l_uname,c.dbsj1=l_date where c.recid=iRecid;
     end if;
  end loop;
  commit;
end;
/
