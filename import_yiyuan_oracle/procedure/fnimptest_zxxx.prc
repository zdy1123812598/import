create or replace procedure fnimptest_zxxx is
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
  l_Cqzh  varchar2(200);
  l_humancode integer;
begin
  for rs in(
    select a.keycode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=26 and stepno in (0,1,2,3,4,5))
      and a.type_id = 26  order by a.keycode
    )loop
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(2490,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into zxxx_log(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,26,0);
     else
       insert into zxxx_log(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,26,0);
       --插入cqxx
       select count(1) into iCount1 from eistran_yy.operation s,eistran_yy.person a where a.keycode=s.keycode and s.workcode='1ADC4253-C6E1-4422-9A4D-755B3B461A0D';
       if iCount1=0 then
         update zxxx_log set sjyy='无数据' where recid=iRecid;
       else
         insert into cqxx (recid,cqr,zjhm,cqzh)
            select iRecid, a.name1, a.cert_no,a.ocertno
              from eistran_yy.person a
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
              from eistran_yy.operation a, eistran_yy.owner b
             where a.keycode = b.keycode
               and a.keycode = rs.keycode
               and rownum = 1;
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
         select a.ocertno into l_Cqzh from eistran_yy.person a where a.keycode=rs.keycode and rownum=1;
         INSERT INTO FWMX(UUID,RECID,CREATEDATE,FWBH,DYMJ,SYQZH,STATUS)
              select sys_guid(), iRecid, sysdate, s.roomcode, s.b_area, l_Cqzh, 0
                from eistran_yy.room s
               where s.keycode = rs.keycode;
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
              from eistran_yy.CU_Person a
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
               from eistran_yy.land a
             where a.keycode=rs.keycode and rownum=1;
          --插入收费信息和收费合计
          insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
            select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
          insert into SFHJ(RECID,SFHJ)
            select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
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
     end if;
  end loop;
  commit;
end;
/

