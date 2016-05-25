create or replace procedure fnimptest_dyxx(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************
  20------------401   私产
  84------------401   单位产
  86------------2710  注销抵押
  125-----------2645  最高额抵押
  
  收件之后 dyxx(status=0，sfdb=0)，fwmx(status=0),tbkeyref,tbhousestatestack(fwbh,recid,11,0), 
           SHD,GYXX,SFXX,上手fwzk（dyzt='正抵押'）,tbrelinst(0,上手recid,现手recid，sysdate)
  --------------------------------------------------------------------------------------------
  登簿后： dyxx(status=1，sfdb=1)，fwmx(status=0),tbkeyref,tbhousestatestack(fwbh,recid,11,1),
           上手fwbh状态不变，上手fwzk（dyzt='已抵押'）,tbrelinst(0,上手recid,现手recid，sysdate)
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1   integer;
  l_humancode integer;
begin
  for rs in(
    select a.keycode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=l_typeid and stepno in (0,1,2,3,4,5,6))
      and a.type_id = l_typeid  order by a.keycode
    )loop
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
  /*if iRet=0 then
    dbms_output.put_line(iRecid);
  end if;*/
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into dyXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into dyXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD)values(iRecid,rs.keycode,v_msg,l_typeid,0);

       if l_typeid=86 then
        --插入dyxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       --select count(1) into iCount from eisdoc_yy.operation a where a.keycode='201101120062';
       insert into dyxx (recid,slbh,txqzh,syqr,syqrzjmc,syqrzjhm,
                         SYQLXRDH,SYQRFRDB,ywmc,sfdb,syqzh,dymjz,dylx,txqr,
                         txqrzjmc,txqrzjhm,txqrlxdh,TXQRFRDB,DYRQKS,DYRQJS,Ys,Qlfw,QLZL,DYFCJZ,bdbzqse,zxrq,status)

          select iRecid,rs.keycode,
                 a.ocertnum,b.b_name,b.b_type,b.b_code,b.b_tel,b.b_lawman,
                 l_ywmc,decode(a.ocertnum /*iCount*/,/*0*/null,0,1),
                 b.ocertno,c.all_area,1,a.m_name,a.m_type,a.m_code,
                 a.m_tel,a.m_lawman,c.start_date,c.end_date,
                 /*to_number(trim(regexp_replace(c.limit_date,'[^0-9]')))*/
                 round(months_between(c.end_date,c.start_date),0),
                 c.part,c.kind,c.eval_value,c.right_value,c.lo_date,decode(c.lo_flag,0,1,2)
              from eistran_yy.MM_Person a,eistran_yy.MO_Person b,eistran_yy.Mortagage c
          where a.keycode = b.keycode(+)
            and a.keycode = c.keycode(+)
            and c.logoutkeycode = rs.keycode and rownum=1;

         insert into ZXDJB(RECID,SQR,ZXBH,SLBH,SQRZJMC,SQRZJHM,ZXYY,DJLX,SFDB)
           select iRecid,b.b_name,c.logoutkeycode,rs.keycode,b.b_type,b.b_code,c.lo_cause,l_ywmc,decode(c.logoutkeycode,null,0,1)
              from eistran_yy.MM_Person a,eistran_yy.MO_Person b,eistran_yy.Mortagage c
           where a.keycode = b.keycode(+)
            and a.keycode = c.keycode(+)
            and c.logoutkeycode = rs.keycode and rownum=1;
else
  insert into dyxx (recid,slbh,txqzh,syqr,syqrzjmc,syqrzjhm,
                         SYQLXRDH,SYQRFRDB,ywmc,sfdb,syqzh,dymjz,dylx,txqr,
                         txqrzjmc,txqrzjhm,txqrlxdh,TXQRFRDB,DYRQKS,DYRQJS,Ys,Qlfw,QLZL,DYFCJZ,bdbzqse,zxrq,zxyy,status)

          select iRecid,rs.keycode,
                 a.ocertnum,b.b_name,b.b_type,b.b_code,b.b_tel,b.b_lawman,
                 l_ywmc,decode(a.ocertnum /*iCount*/,/*0*/null,0,1),
                 b.ocertno,c.all_area,1,a.m_name,a.m_type,a.m_code,
                 a.m_tel,a.m_lawman,c.start_date,c.end_date,
                 /*to_number(trim(regexp_replace(c.limit_date,'[^0-9]')))*/
                 round(months_between(c.end_date,c.start_date),0),
                 c.part,c.kind,c.eval_value,c.right_value,c.lo_date,c.logoutkeycode,decode(c.lo_flag,0,1,2)
              from eistran_yy.MM_Person a,eistran_yy.MO_Person b,eistran_yy.Mortagage c
          where a.keycode = b.keycode(+)
            and a.keycode = c.keycode(+)
            and a.keycode = rs.keycode and rownum=1;
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
       --插入房屋明细（FWMX）,查找上手fwbh待定
       insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
         select sys_guid(),iRecid,sysdate,
                a.roomcode   房屋编号,
                a.all_area   房屋面积_抵押面积,
                a.o_certno   产权证号,
                decode(a.lo_flag,0,1,2),
                null
           from eistran_yy.Mortagage a
          where a.keycode = rs.keycode;

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
        
        select count(1) into iCount1 from eistran_yy.person a where a.keycode=rs.keycode;
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

