create or replace procedure fnimptest_ygspfdyygdj(l_typeid integer,ibizid integer,l_ywmc varchar2) is
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
        v_msg := '�ռ�ʧ�ܣ�ԭ��'||imsg;
        insert into SPFDYYG_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into SPFDYYG_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
       --�����Ѻ��Ϣ(DYXX)
       insert into dyxx (recid,ywmc,slbh,dyqygdjzmh,TXQR,txqrzjmc,txqrzjhm,txqrlxdh,txqrlxr,txqrfrdb,syqr,syqrzjmc,
                         syqrzjhm,syqlxrdh,zwr,zwrdh,zwrzjmc,zwrzjhm,dyrqks,dyrqjs,ys,dyfcjz,qlfw,qlzl,dymjz,foreshow)
          select iRecid,l_ywmc,rs.keycode,c.code,a.m_name, a.m_type, a.m_code, a.m_tel, a.m_man, a.m_lawman,
                 b.o_name,b.o_type,b.o_code,b.o_tel,b.b_name,b.b_tel,b.b_type,b.b_code,
                 d.start_date,d.end_date,regexp_replace(d.limit_date,'[^0-9]'),d.right_value,d.kind,'��Ѻ',d.all_area,1
            from eistran_yy.PREMM_PERSON a, eistran_yy.PREMO_PERSON b,eistran_yy.predeclare c,
                 eistran_yy.PREMORTAGAGE d
           where a.keycode = b.keycode
             and a.keycode = c.keycode
             and a.keycode = d.keycode
             and a.keycode = rs.keycode
             and rownum=1;
       
       --������˵�
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
       --����¥�̷�����ϸ��LPFWMX��
       insert into lpfwmx(uuid,recid,createdate,disporder,fwbh,dymj,status)
          select sys_guid(), iRecid,sysdate, 0, a.roomcode, a.all_area, 1
            from eistran_yy.PREMORTAGAGE a
           where a.keycode = rs.keycode and rownum=1;
      --���빲����Ϣ
      /*insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,gyr,lxdh,lxdz)
        select  sys_guid(),iRecid,sysdate,a.certno,a.certname,a.name,a.tel,a.address
          from eisdoc_yy.po_cu_person a
         where a.keycode = rs.yshtno;*/
      --�����շ���Ϣ���շѺϼ�
      insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
        select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
      insert into SFHJ(RECID,SFHJ)
        select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
      select count(1) into iCount from eistran_yy.predeclare a where a.keycode=rs.keycode;
      --Ҫ��
      delete from tbrecdoc where recid=iRecid;
      insert into tbrecdoc(docid,recid,docdefid,docname,doctype,disporder,copies,pages,checked,groupid,y_docid)
         select seqdocid.nextval,
                iRecid,
                0,
                a.name,
                decode(a.type, '��ӡ��', 2, 'ԭ��', 1, 3),
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

