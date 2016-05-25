create or replace procedure fnimptest_htcx_bj_tran(l_typeid integer,ibizid integer,l_bizname varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  l_stepno  integer;
  iROLEID   integer;
  iActdefid integer;
  iCount1 integer;
  iCount2 integer;
  iCount3 integer;
  iCount4 integer;
  iCount5 integer;
  iCount6 integer;
  l_uname  varchar2(200);--4
  l_date   date;--4
  l_humancode  integer;
begin
  iActdefid := 3388;
  iROLEID := 10224;
  for rs in(select a.keycode,a.T_USER from t_keycode_yy a where a.typeid=l_typeid
                 order by a.keycode
             /*select a.keycode, a.t_user from t_keycode_yy a where a.keycode='200910150015'*/)loop--1
      if rs.t_user='eistran_yy' then
        select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      else
        select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      end if;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
       v_msg := '收件失败，原因：'||imsg;
       insert into HTCX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,LX,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'合同撤销',rs.t_user);
     else
       insert into HTCX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,LX,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'合同撤销',rs.t_user);--2
       --插入HTCX
       select count(1) into iCount from eistran_yy.po_records a, eistran_yy.operation c where a.keycode = c.keycode and a.keycode = rs.keycode;
       if iCount>0 then
         select w.stepno
           into l_stepno
           from eistran_yy.workflow w
          where w.workcode = (select a.workcode
                                from eistran_yy.operation a
                               where a.keycode = rs.keycode);
         insert into HTCX(recid,cxzt,blr,htbh,msr,status,zjhm,slbh,ywmc,BLRY_RQ,Cxbh)
            select iRecid,
                   0,
                   c.accman,
                   a.bargainno,
                   c.appman,
                   0,
                   c.appidcno,
                   rs.keycode,
                   l_bizname,
                   c.acc_date,
                   a.logoutkeycode
              from eistran_yy.po_records a, eistran_yy.operation c
             where a.keycode = c.keycode
               and a.keycode = rs.keycode and rownum=1;
       else
         select w.stepno
           into l_stepno
           from eistran_yy.workflow w
          where w.workcode = (select a.workcode
                                from eisdoc_yy.operation a
                               where a.keycode = rs.keycode);
         insert into HTCX(recid,cxzt,blr,htbh,msr,status,zjhm,slbh,ywmc,BLRY_RQ,Cxbh)
            select iRecid,
                   0,
                   c.accman,
                   a.bargainno,
                   c.appman,
                   0,
                   c.appidcno,
                   rs.keycode,
                   l_bizname,
                   c.acc_date,
                   a.logoutkeycode
              from eisdoc_yy.po_records a, eisdoc_yy.operation c
             where a.keycode = c.keycode
               and a.keycode = rs.keycode and rownum=1;
       end if;
       --插入审核单
       select count(1) into iCount1 from  EISTRAN_YY.EAA_Table f where f.keycode=rs.keycode;
       if iCount1>0 then
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
        else
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
        end if;
       --插入楼盘房屋明细（LPFWMX）
       select count(1) into iCount2 from eistran_yy.po_room a where a.keycode=rs.keycode;
       if iCount2>0 then
         insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
             select sys_guid(), iRecid, sysdate, 0, a.roomcode, a.b_area, 0
               from eistran_yy.po_room a
              where a.keycode=rs.keycode;
       else
         insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
             select sys_guid(), iRecid, sysdate, 0, a.roomcode, a.b_area, 0
               from eisdoc_yy.po_room a
              where a.keycode=rs.keycode;
       end if;
       --插入HTGYRXX
       select count(1) into iCount3 from eistran_yy.po_cu_person a where a.keycode=rs.keycode;
       if iCount3>0 then
         insert into HTGYRXX(RECID,UUID,GYRXM,GYRZJHM,GYRZJLX)
           select iRecid,sys_guid(),a.name,a.certno,a.certname from eistran_yy.po_cu_person a where a.keycode=rs.keycode;
       else
         insert into HTGYRXX(RECID,UUID,GYRXM,GYRZJHM,GYRZJLX)
           select iRecid,sys_guid(),a.name,a.certno,a.certname from eisdoc_yy.po_cu_person a where a.keycode=rs.keycode;
       end if;
       --插入收费信息和收费合计
       select count(1) into iCount4 from eistran_yy.charge_item where keycode = rs.keycode;
       if iCount4>0 then
         insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
           select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
         insert into SFHJ(RECID,SFHJ)
           select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
       else
         insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
           select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
         insert into SFHJ(RECID,SFHJ)
           select iRecid,sum(a.should) from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
       end if;
       select count(1) into iCount6 from eisdoc_yy.operation a where a.keycode=rs.keycode;
       if iCount6>0 then
         select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
        elsif iCount6=0 then
         select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
       end if;
       --update tbrec set recnum=rs.keycode where recid=iRecid;
       if l_stepno=7 then
          update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='王东禄',a.cantoncode=10 where a.recid=iRecid;
       elsif l_stepno in (5,6) then
          update tbactinst t set t.enddate=sysdate,t.completed=1 where t.recid=iRecid and t.actdefname='受理';
          insert into tbactinst(recid,actid,partid,actdefid,actdefname,roleid,createdate,
                                read,assigned,cancelable,completed,sendback)
             values(iRecid,seqactid.nextval,-1,iActdefid,'归档',iROLEID,sysdate,0,0,1,0,0);
        end if;
        --要件
       delete from tbrecdoc where recid=iRecid;
       select count(1) into iCount5 from eistran_yy.IMPORTANT_DOC a where a.keycode = rs.keycode ;
       if iCount5>0 then
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
        else
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
        end if;
        fnupdayj(iRecid,rs.keycode);        
        if rs.t_user='eistran_yy' then
          select a.regeditman,a.regeditdate into l_uname,l_date from eistran_yy.operation a where a.keycode=rs.keycode;
        else
          select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
        end if;
        update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
     end if;
  end loop;
  commit;
end;
/