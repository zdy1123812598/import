create or replace procedure fnimptest_zxxx_doc is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1 integer;
  iCount2 integer;
  iCount3 integer;
  iCount4 integer;
  l_Cqzh  varchar2(200);
  l_humancode integer;
  l_stepno  integer;
  iActdefid integer;
  iRoles integer;
  l_uname  varchar2(200);
  l_date   date;
begin
  iActdefid := 216;
  iRoles := 9715;
  for rs in(select a.keycode from t_keycode_yy a where a.typeid = 26
              and a.t_user='eisdoc_yy'  order by a.keycode)loop
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(2490,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into zxxx_log(RECID, KEYCODE, MSG, Type_Id,Isgd,t_user)values(iRecid,rs.keycode,v_msg,26,1,'eisdoc_yy');
     else
       insert into zxxx_log(RECID, KEYCODE,  MSG, Type_Id,Isgd,t_user)values(iRecid,rs.keycode,v_msg,26,1,'eisdoc_yy');
       select count(1) into iCount1 from eisdoc_yy.person a where a.keycode=rs.keycode;
       select count(1) into iCount4 from eisdoc_yy.owner s where s.logoutkeycode=rs.keycode;
       if iCount1=0 and iCount4=0 then
         update zxxx_log set sjyy='无数据' where recid=iRecid;
       elsif iCount1>0 then
         --插入cqxx
         --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
         insert into cqxx (recid,cqr,zjhm,cqzh)
            select iRecid, a.name, a.cert_no,a.ocertno
              from eisdoc_yy.person a
             where a.keycode = rs.keycode
               and rownum = 1;
         --插入ZXDJB
         insert into ZXDJB(recid,Djlx,Slbh,Zxbh,Sqr,lxdz,Sqrzjhm,Lxdh,Sfdb)
            select iRecid,
                   '注销登记',
                   rs.keycode,
                   b.logoutkeycode,
                   a.appman,
                   a.appaddress,
                   a.appidcno,
                   a.appcellphone,
                   0
              from eisdoc_yy.operation a, eisdoc_yy.owner b
             where a.keycode = b.keycode
               and a.keycode = rs.keycode
               and rownum = 1;
       elsif iCount1=0 and iCount4>0 then
         insert into cqxx (recid,cqr,zjhm,cqzh)
            select iRecid, b.name, b.cert_no,a.ocertno
              from eisdoc_yy.owner a,eisdoc_yy.person b
             where a.keycode=b.keycode
               and a.logoutkeycode = rs.keycode
               and rownum = 1;
         --插入ZXDJB
         insert into ZXDJB(recid,Djlx,Slbh,Zxbh,Sqr,lxdz,Sqrzjhm,Lxdh,Sfdb)
            select iRecid,
                   '注销登记',
                   rs.keycode,
                   b.logoutkeycode,
                   a.appman,
                   a.appaddress,
                   a.appidcno,
                   a.appcellphone,
                   0
              from eisdoc_yy.operation a, eisdoc_yy.owner b
             where a.keycode = b.keycode
               and b.logoutkeycode = rs.keycode
               and rownum = 1;
       end if;
       if iCount1=0 and iCount4=0 then
         null;
       else
         --插入房屋明细（FWMX）
         select a.ocertno into l_Cqzh from eisdoc_yy.owner a where a.logoutkeycode=rs.keycode and rownum=1;
         for rn in (select a.roomcode from eisdoc_yy.owner a where a.logoutkeycode=rs.keycode)loop
           INSERT INTO FWMX(UUID,RECID,CREATEDATE,FWBH,DYMJ,SYQZH,STATUS)
              select sys_guid(), iRecid, sysdate, s.roomcode, s.b_area, l_Cqzh, 0
                from eisdoc_yy.room s
               where s.roomcode = rn.roomcode and rownum=1;
         end loop;
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
              from EISDOC_YY.EAA_Table f
             where f.keycode = rs.keycode; 
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
          select count(1) into iCount2 from eisdoc_yy.operation a where a.keycode=rs.keycode and a.accman like '%录档%';
          select count(1) into iCount3 from eisdoc_yy.operation a where a.keycode=rs.keycode;
          if iCount3>0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
          elsif iCount3=0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
          end if;
          --update tbrec set recnum=rs.keycode where recid=iRecid;
          if l_stepno=9 or iCount2>0 then
            update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='王东禄',a.cantoncode=10 where a.recid=iRecid;
          elsif l_stepno in (6,7,8) then
            update tbactinst t set t.enddate=sysdate,t.completed=1 where t.recid=iRecid and t.actdefname='受理';
            insert into tbactinst(recid,actid,partid,actdefid,actdefname,roleid,createdate,
                                  read,assigned,cancelable,completed,sendback)
               values(iRecid,seqactid.nextval,-1,iActdefid,'归档',iRoles,sysdate,0,0,1,0,0);
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
               from eisdoc_yy.IMPORTANT_DOC a
              where a.keycode = rs.keycode and a.id <>0;
          fnupdayj(iRecid,rs.keycode);          
          select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
          update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
       end if;
     end if;
  end loop;
  commit;
end;
/

