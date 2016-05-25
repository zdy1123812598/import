create or replace procedure fnimptest_syqzyygdj_doc(l_typeid integer,ibizid integer,l_ywmc varchar2) is
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
  iCount5 integer;
  iCount6 integer;
  iCount7 integer;
  l_Cqzh  varchar2(200);
  l_uname  varchar2(200);
  l_date   date;
  l_stepno  integer;
  iROLEID   integer;
  iActdefid integer;
  l_humancode integer;
begin
  iActdefid := 1048;
  iROLEID := 9611;
  for rs in(select a.keycode from t_keycode_yy a  where a.typeid=l_typeid and a.T_USER='eisdoc_yy'
               order by a.keycode)loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into SYQZYYG_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
     else
       insert into SYQZYYG_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
       --插入产权信息(CQXX)
       select count(1) into iCount1 from eisdoc_yy.PREDECLARE where keycode=rs.keycode;
       if iCount1=0 then
         update SYQZYYG_LOG set sjyy='无数据' where recid=iRecid;
       else
         insert into cqxx(recid,slbh,ywmc,ygzh,ssqdm,sscqr,sscqzh,ssrzjhm,ssrlxdh,cqr,zjmc,zjhm,lxdh,cb,status,sfdb)
           select iRecid,rs.keycode,l_ywmc,s.code, '10', d.name, d.ocertno, d.cert_no, d.tel,f.name,
                  f.certname,f.certno,f.tel, e.osort,0,0
            from eisdoc_yy.PREDECLARE s, eisdoc_yy.person d,eisdoc_yy.Owner e,eisdoc_yy.CU_PERSON f
           where s.keycode = d.keycode
             and s.keycode = e.keycode
             and s.keycode = f.keycode
             and s.keycode = rs.keycode;

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
         --插入房屋明细（FWMX）
         select count(1) into iCount7 from eisdoc_yy.room b where b.keycode=rs.keycode;
         
         if iCount7>0 then
           select d.ocertno into l_Cqzh from eisdoc_yy.person d where d.keycode=rs.keycode;
           insert into fwmx(uuid,recid,createdate,disporder,fwbh,dymj,syqzh,status)
              select sys_guid(), iRecid, sysdate, 0, a.roomcode, a.b_area, l_Cqzh, 0
                from eisdoc_yy.room a
               where a.keycode = rs.keycode;
         else
           select d.ocertno into l_Cqzh from eistran_yy.person d where d.keycode=rs.keycode;
           insert into fwmx(uuid,recid,createdate,disporder,fwbh,dymj,syqzh,status)
              select sys_guid(), iRecid, sysdate, 0, a.roomcode, a.b_area, l_Cqzh, 0
                from eistran_yy.room a
               where a.keycode = rs.keycode;
         end if;
        --插入共有信息
        insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,gyr,lxdh,lxdz)
          select sys_guid(),
                 iRecid,
                 sysdate,
                 a.certno,
                 a.certname,
                 a.name,
                 a.tel,
                 a.address
            from eisdoc_yy.CU_PERSON a
           where a.keycode = rs.keycode;
        --插入收费信息和收费合计
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        select count(1) into iCount6 from eisdoc_yy.operation a where a.keycode=rs.keycode and a.accman like '%录档%';
        select count(1) into iCount5 from eisdoc_yy.operation a where a.keycode=rs.keycode;
        if iCount5>0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
        elsif iCount5=0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
        end if;
        if l_stepno=11 or iCount6>0 then
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

