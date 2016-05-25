create or replace procedure fnimptest_ygspfdyygdj_tran(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount3 integer;
  l_stepno  integer;
  iROLEID   integer;
  iActdefid integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
begin
  iActdefid := 935;
  iROLEID := 9669;
  for rs in(
     select a.keycode,a.appman,a.appsex,a.appnation,a.appbirth,a.appaddress,a.appidcno,a.appcellphone,a.yshtno
      from t_keycode_yy s ,eistran_yy.operation a where s.keycode=a.keycode and s.typeid=l_typeid and s.t_user='eistran_yy' 
       order by s.keycode
    )loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into SPFDYYG_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd,t_User)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eistran_yy');
     else
       insert into SPFDYYG_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd,t_User)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eistran_yy');
       --插入抵押信息(DYXX)
       select count(1) into iCount from eistran_yy.predeclare a where a.keycode=rs.keycode;
       if iCount=0 then
         update SPFDYYG_LOG set sjyy='无数据' where recid=iRecid;
       else
           insert into dyxx (recid,ywmc,slbh,dyqygdjzmh,TXQR,txqrzjmc,txqrzjhm,txqrlxdh,txqrlxr,txqrfrdb,syqr,syqrzjmc,
                             syqrzjhm,syqlxrdh,zwr,zwrdh,zwrzjmc,zwrzjhm,dyrqks,dyrqjs,ys,dyfcjz,qlfw,qlzl,dymjz,foreshow)
              select iRecid,l_ywmc,rs.keycode,c.code,a.m_name, a.m_type, a.m_code, a.m_tel, a.m_man, a.m_lawman,
                     b.o_name,b.o_type,b.o_code,b.o_tel,b.b_name,b.b_tel,b.b_type,b.b_code,
                     d.start_date,d.end_date,regexp_replace(d.limit_date,'[^0-9]'),d.right_value,d.kind,'抵押',d.all_area,1
                from eistran_yy.PREMM_PERSON a, eistran_yy.PREMO_PERSON b,eistran_yy.predeclare c,
                     eistran_yy.PREMORTAGAGE d
               where a.keycode = b.keycode
                 and a.keycode = c.keycode
                 and a.keycode = d.keycode
                 and a.keycode = rs.keycode
                 and rownum=1;

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
           --插入楼盘房屋明细（LPFWMX）
           insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
              select sys_guid(), iRecid,sysdate, 0, a.roomcode, a.all_area, 1
                from eistran_yy.PREMORTAGAGE a
               where a.keycode = rs.keycode  and rownum=1;
          --插入共有信息
          /*insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,gyr,lxdh,lxdz)
            select  sys_guid(),iRecid,sysdate,a.certno,a.certname,a.name,a.tel,a.address
              from eisdoc_yy.po_cu_person a
             where a.keycode = rs.yshtno;*/
          --插入收费信息和收费合计
          insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
            select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
          insert into SFHJ(RECID,SFHJ)
            select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
          select count(1) into iCount3 from eistran_yy.operation a where a.keycode=rs.keycode;
          if iCount3=0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
          elsif iCount3>0 then
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
          end if;
          if l_stepno=11 then
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
       end if;
     end if;
  end loop;
  commit;
end;
/

