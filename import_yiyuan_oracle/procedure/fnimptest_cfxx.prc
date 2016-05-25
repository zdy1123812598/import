create or replace procedure fnimptest_cfxx is
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
  l_humancode integer;
begin
  for rs in(
    select a.keycode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=36 and stepno in (0,1,2,3,4,5,6))
      and a.type_id = 36 order by a.keycode
    )loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(2698,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into CFXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,LX)values(iRecid,rs.keycode,v_msg,36,0,'查封');
     else
       insert into CFXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,LX)values(iRecid,rs.keycode,v_msg,36,0,'查封');
       --插入CFDJ
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
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
            from eistran_yy.Freeze a
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
            from EISTRAN_YY.EAA_Table f
           where f.keycode = rs.keycode;
       --插入房屋明细（FWMX）
       insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,cqr,jfbh,jfrq,jfr)
           select sys_guid(),iRecid,sysdate,a.roomcode,a.b_area,b.certcode,decode(b.free_flag,0,1,2),b.owner,b.logoutkeycode,b.f_date,b.f_man
             from eistran_yy.room a, eistran_yy.Freeze b
           where a.keycode = b.keycode
           and a.roomcode = b.roomcode
           and a.keycode = rs.keycode;
       --插入收费信息和收费合计
       insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
         select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
       insert into SFHJ(RECID,SFHJ)
         select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
       --
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

