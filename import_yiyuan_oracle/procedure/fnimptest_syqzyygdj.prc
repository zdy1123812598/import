create or replace procedure fnimptest_syqzyygdj(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

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
    select a.keycode,a.appman,a.appsex,a.appnation,a.appbirth,a.appaddress,a.appidcno,a.appcellphone,a.yshtno
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=l_typeid and stepno in (0,1,2,3,4,5,6))
      and a.type_id = l_typeid
    )loop
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into SYQZYYG_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into SYQZYYG_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
       --插入产权信息(CQXX)
       insert into cqxx(recid,slbh,ywmc,ygzh,ssqdm,sscqr,sscqzh,ssrzjhm,ssrlxdh,cqr,zjmc,zjhm,lxdh,cb,status,sfdb)
         select iRecid,rs.keycode,l_ywmc,s.code, '10', d.name1, d.ocertno, d.cert_no, d.tel,f.name,
                f.certname,f.certno,f.tel, e.osort,0,0
          from eistran_yy.PREDECLARE s, eistran_yy.person d,eistran_yy.Owner e,eistran_yy.CU_PERSON f
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
            from EISTRAN_YY.EAA_Table f
           where f.keycode = rs.keycode;
       --插入房屋明细（FWMX）
       insert into fwmx(uuid,recid,createdate,disporder,fwbh,dymj,syqzh,status)
          select sys_guid(), iRecid, sysdate, 0, a.roomcode, a.b_area, d.ocertno, 0
            from eistran_yy.room a, eistran_yy.person d
           where a.keycode = d.keycode
             and a.keycode = rs.keycode;
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
          from eistran_yy.CU_PERSON a
         where a.keycode = rs.keycode;
      --插入收费信息和收费合计
      insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
        select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
      insert into SFHJ(RECID,SFHJ)
        select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
      
      update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='王东禄',a.cantoncode=10 where a.recid=iRecid;
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

