create or replace procedure fnimptest_cfxx_bj_doc  is
/****************************************************************************************
  36-----------2698  查封
  140----------2698  预查封
  97-----------2699  解封
  141----------2699  预解封
  select * from CFDJ a where a.recid=10957902;
  select * from fwmx a where a.recid=10957902;
  select * from tbhousestatestack a where a.fwbh='22245';
  select * from tbkeyref a where a.recid=10957902;
  select * from fwzk a where a.fwbh='22245';
  select * from tbroom a where a.fwbh='22245';
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
  l_stepno  integer;
  iActdefid  integer;
  iROLEID    integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
begin
  iActdefid := 638;
  iROLEID := 7808;
  for rs in(select a.keycode from t_keycode_yy a where a.t_user='eisdoc_yy' 
             and a.typeid=36 order by a.keycode)loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(2698,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
       v_msg := '收件失败，原因：'||imsg;
       insert into CFXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,LX,T_USER)values(iRecid,rs.keycode,v_msg,36,1,'查封','eisdoc_yy');
     else
       insert into CFXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,LX,T_USER)values(iRecid,rs.keycode,v_msg,36,1,'查封','eisdoc_yy');
       --插入CFDJ
       select count(1) into iCount1 from eisdoc_yy.Freeze a where a.keycode=rs.keycode;
       if iCount1=0 then
         update CFXX_LOG set sjyy='无数据' where recid=iRecid;
       else
         insert into CFDJ(RECID,SLBH,STATUS,CFBZ,CFBH,CFDW,CFDX,CHAFENLX,CFRQ,CQZH,YWMC)
            select iRecid,
                   rs.keycode,
                   0,
                   a.cause,
                   a.code,
                   a.unit,
                   '权利人',
                   '正式查封',
                   a.u_date,
                   a.certcode,
                   '查封'
              from eisdoc_yy.Freeze a
             where a.keycode = rs.keycode and rownum=1;
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
         select count(1) into iCount4 from eisdoc_yy.room s where s.keycode=rs.keycode;
         if iCount4=0 then
          insert into fwmx(uuid,recid,createdate,fwbh,syqzh,status,cqr,jfbh,jfrq,jfr)
               select sys_guid(),iRecid,sysdate,b.roomcode,b.certcode,decode(b.free_flag,0,1,2),b.owner,b.logoutkeycode,b.f_date,b.f_man
                 from eisdoc_yy.Freeze b
               where  b.keycode = rs.keycode;
         else
           insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,cqr,jfbh,jfrq,jfr)
               select sys_guid(),iRecid,sysdate,a.roomcode,a.b_area,b.certcode,decode(b.free_flag,0,1,2),b.owner,b.logoutkeycode,b.f_date,b.f_man
                 from eisdoc_yy.room a, eisdoc_yy.Freeze b
               where a.keycode = b.keycode
               and a.roomcode = b.roomcode
               and a.keycode = rs.keycode;
         end if;
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
          select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
          update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
       end if;
     end if;
  end loop;
  commit;
end;
/
