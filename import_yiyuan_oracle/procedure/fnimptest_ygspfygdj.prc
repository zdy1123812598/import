create or replace procedure fnimptest_ygspfygdj(l_typeid integer,ibizid integer,l_ywmc varchar2) is
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
  iCount2  integer;
  iCount3  integer;
  l_humancode integer;
begin
  for rs in(
    select a.keycode,a.appman,a.appsex,a.appnation,a.appbirth,a.appaddress,a.appidcno,a.appcellphone,trim(a.yshtno) yshtno 
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=l_typeid and stepno in (0,1,2,3,4,5,6))
      and a.type_id = l_typeid  order by a.keycode
    /* select a.keycode,a.appman,a.appsex,a.appnation,a.appbirth,a.appaddress,a.appidcno,a.appcellphone,trim(a.yshtno) yshtno from t_test s,eistran_yy.operation a where a.keycode=s.keycode order by s.keycode*/
    )loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into SPFYG_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into SPFYG_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
       insert into cqxx (recid,slbh,ywmc,ygzh,cqr,zjhm,lxdh,foreshow,sfdb,status)
          select iRecid,
                 rs.keycode,
                 l_ywmc,
                 a.code,
                 rs.appman,
                 rs.appidcno,
                 rs.appcellphone,1,0,0
            from eistran_yy.predeclare a
           where a.keycode = rs.keycode
             and rownum=1;
       if l_typeid=100 then
         insert into ZXDJB(recid,sqr,slbh,sqrzjhm,djlx,sfdb)
           values(iRecid,rs.appman,rs.keycode,rs.appidcno,l_ywmc,0);
       end if;
       if l_typeid<>100 then
         --插入ygxx
         select count(1) into iCount1 from eisdoc_yy.po_records a,eistran_yy.developer b where a.ssperson=b.code(+) and a.keycode=rs.yshtno;
         if iCount1>0 then
           insert into ygxx(recid,kfgs,gsdz,yyzz,mmhth,dlr,xsje)
              select iRecid,
                     b.developer_name,
                     b.developer_add,
                     b.developer_register,
                     rs.yshtno,
                     b.developer_man,
                     a.hvalue
                from eisdoc_yy.po_records a, eistran_yy.developer b
               where a.ssperson = b.code(+)
                 and a.keycode = rs.yshtno
                 and rownum=1;
         else 
           update SPFYG_LOG set sjyy='无合同数据' where recid=iRecid;
           /*insert into ygxx(recid,kfgs,gsdz,yyzz,mmhth,dlr,xsje)
              select iRecid,
                     b.developer_name,
                     b.developer_add,
                     b.developer_register,
                     rs.yshtno,
                     b.developer_man,
                     a.hvalue
                from eistran_yy.po_records a, eistran_yy.developer b
               where a.ssperson = b.code(+)
                 and a.keycode = rs.yshtno
                 and rownum=1;*/
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
            from EISTRAN_YY.EAA_Table f
           where f.keycode = rs.keycode;
       if l_typeid<>100 then
         --插入楼盘房屋明细（LPFWMX）
         select count(1) into iCount2 from eisdoc_yy.po_room a where a.keycode=rs.yshtno;
         if iCount2>0 then
           insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
              select sys_guid(), iRecid,sysdate, 0, a.roomcode, a.b_area, 0
                from eisdoc_yy.po_room a
               where a.keycode = rs.yshtno;
         else
           insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
              select sys_guid(), iRecid,sysdate, 0, a.roomcode, a.b_area, 0
                from eistran_yy.po_room a
               where a.keycode = rs.yshtno;
         end if;
       elsif l_typeid=100 then
         insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
           select sys_guid(),iRecid,sysdate,0,a.roomcode,a.b_area,0 from eistran_yy.room a where a.keycode=rs.keycode;
       end if;
       if l_typeid<>100 then
          --插入共有信息
          select count(1) into iCount3 from eisdoc_yy.po_cu_person a where a.keycode = rs.yshtno;
          if iCount3>0 then
            insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,gyr,lxdh,lxdz)
              select  sys_guid(),iRecid,sysdate,a.certno,a.certname,a.name,a.tel,a.address
                from eisdoc_yy.po_cu_person a
               where a.keycode = rs.yshtno;
          else
            insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,gyr,lxdh,lxdz)
              select  sys_guid(),iRecid,sysdate,a.certno,a.certname,a.name,a.tel,a.address
                from eistran_yy.po_cu_person a
               where a.keycode = rs.yshtno;
          end if;
        end if;
        --插入收费信息和收费合计
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
        select count(1) into iCount from eistran_yy.predeclare a where a.keycode=rs.keycode;
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

