create or replace procedure fnimptest_yjfxx  is
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
  l_humancode integer;
begin
  for rs in(
    select a.keycode,a.acc_date
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=141 and stepno in (0,1))
      and a.type_id = 141 order by a.keycode
    )loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(2699,l_humancode,null,iRecid,iActid,imsg);
  /*if iRet=0 then
    dbms_output.put_line(iRecid);
  end if;*/
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into YCFXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,lx)values(iRecid,rs.keycode,v_msg,141,1,'预解封');
     else
       insert into YCFXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,lx)values(iRecid,rs.keycode,v_msg,141,1,'预解封');
       --插入CFDJ
        insert into CFDJ(RECID,SLBH,STATUS,CFBZ,CFBH,CFDW,CFDX,CHAFENLX,CFRQ,CQZH,YWMC,Jfbh)
        select iRecid,
               rs.keycode,
               0,
               a.cause,
               a.code,
               a.unit,
               '开发商',
               '预解封',
               a.u_date,
               a.certcode,
               '预查封',
               a.logoutkeycode
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
       --插入房屋状况（LPFWMX）
        for rn in (select s.* from eistran_yy.freeze s where s.keycode=rs.keycode)loop
             insert into lpfwmx(uuid,recid,createdate,fwbh,dymj,status)
               select sys_guid(),iRecid,sysdate,a.roomcode,a.b_area,decode(rn.free_flag,0,1,2)
                 from eistran_yy.room a
               where a.roomcode=rn.roomcode and rownum=1;
        end loop;
       /*--插入收费信息和收费合计
       insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
         select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
       insert into SFHJ(RECID,SFHJ)
         select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;*/      
     end if;
  end loop;
  commit;
end;
/

