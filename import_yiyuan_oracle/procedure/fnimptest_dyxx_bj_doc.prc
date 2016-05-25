create or replace procedure fnimptest_dyxx_bj_doc(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1   integer;
  iCount2   integer;
  iCount3   integer;
  iCount4   integer;
  iCount5   integer;
  iCount6   integer;
  iCount7   integer;
  l_stepno  integer;
  iROLEID   integer;
  iActdefid integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
  l_Cqzh   varchar2(200);
begin
  if l_typeid in (128,20,84,85,86) then
    iActdefid := 42;
    iROLEID := 7704;
  elsif l_typeid in (125,126,127) then
    iActdefid := 772;
    iROLEID := 9679;
  end if;
  for rs in(select a.keycode from t_keycode_yy a where a.t_user='eisdoc_yy' 
              and a.typeid=l_typeid order by a.keycode)loop
	l_Cqzh := null;
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select nvl(a.accman,'王东禄') from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into dyXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
     else
       insert into dyXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,T_USER)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
       --插入dyxx
       select count(1) into iCount1 from eisdoc_yy.MM_Person a where a.keycode=rs.keycode;
       select count(1) into iCount4 from eistran_yy.MM_Person a where a.keycode=rs.keycode;
       select count(1) into iCount5 from eistran_yy.Mortagage a where a.logoutkeycode=rs.keycode;
       select count(1) into iCount6 from eisdoc_yy.Mortagage a where a.logoutkeycode=rs.keycode;
       if l_typeid=86 then
         if iCount1=0 and iCount4=0 and iCount5=0 and iCount6=0 then
           update dyXX_LOG set sjyy='无数据' where recid=iRecid;
         elsif iCount6>0 then
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
                  from eisdoc_yy.MM_Person a,eisdoc_yy.MO_Person b,eisdoc_yy.Mortagage c
              where a.keycode = b.keycode(+)
                and a.keycode = c.keycode(+)
                and c.logoutkeycode=rs.keycode and rownum=1;
           insert into ZXDJB(RECID,SQR,ZXBH,SLBH,SQRZJMC,SQRZJHM,ZXYY,DJLX,SFDB)
               select iRecid,b.b_name,c.logoutkeycode,rs.keycode,b.b_type,b.b_code,c.lo_cause,l_ywmc,decode(c.logoutkeycode,null,0,1)
                  from eisdoc_yy.MM_Person a,eisdoc_yy.MO_Person b,eisdoc_yy.Mortagage c
               where a.keycode = b.keycode(+)
                and a.keycode = c.keycode(+)
                and c.logoutkeycode = rs.keycode and rownum=1;
	select count(1) into iCount7 from eisdoc_yy.MO_Person b, eisdoc_yy.Mortagage c where  b.keycode= c.keycode and c.logoutkeycode=rs.keycode and rownum=1;
	if iCount7 > 0 then 
	select b.ocertno into l_Cqzh from eisdoc_yy.MO_Person b, eisdoc_yy.Mortagage c where  b.keycode= c.keycode and c.logoutkeycode=rs.keycode and rownum=1;
	end if;
           insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
             select sys_guid(),
                    iRecid,sysdate,
                    a.roomcode   房屋编号,
                    a.all_area   房屋面积_抵押面积,
                    l_Cqzh   产权证号,
                    decode(a.lo_flag,0,1,2),
                    null
               from eisdoc_yy.Mortagage a
             where rowid in (select min(rowid)
                       from eisdoc_yy.Mortagage a
                      where a.logoutkeycode = rs.keycode
                      group by roomcode);
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
                from eisdoc_yy.CU_Person a
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
                 from eisdoc_yy.land a
               where a.keycode=rs.keycode;
         elsif iCount6=0 and iCount5>0 then
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
           select b.ocertno into l_Cqzh from eistran_yy.MO_Person b where b.keycode=rs.keycode and rownum=1;
           --插入房屋明细（FWMX）,查找上手fwbh待定
           insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
             select sys_guid(),
                    iRecid,sysdate,
                    a.roomcode   房屋编号,
                    a.all_area   房屋面积_抵押面积,
                    l_Cqzh   产权证号,
                    decode(a.lo_flag,0,1,2),
                    null
               from eistran_yy.Mortagage a
             where rowid in (select min(rowid)
                       from eistran_yy.Mortagage a
                      where a.logoutkeycode = rs.keycode
                      group by roomcode);
          --插入共有信息
          insert into gyxx(uuid,recid,createdate,gyrzjhm, gyrzjlx,ycqrgx,zyfe,gyr,gyzh,lxdh,lxdz,bz)
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
         end if;
----不是抵押注销
       else
         if iCount1=0 and iCount4=0 then
           update dyXX_LOG set sjyy='无数据' where recid=iRecid;
         elsif iCount1>0 then
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
                  from eisdoc_yy.MM_Person a,eisdoc_yy.MO_Person b,eisdoc_yy.Mortagage c
              where a.keycode = b.keycode(+)
                and a.keycode = c.keycode(+)
                and a.keycode = rs.keycode and rownum=1;
           select b.ocertno into l_Cqzh from eisdoc_yy.MO_Person b where b.keycode=rs.keycode and rownum=1;
           --插入房屋明细（FWMX）,查找上手fwbh待定
           insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
             select sys_guid(),
                    iRecid,sysdate,
                    a.roomcode   房屋编号,
                    a.all_area   房屋面积_抵押面积,
                    l_Cqzh   产权证号,
                    decode(a.lo_flag,0,1,2),
                    null
               from eisdoc_yy.Mortagage a
             where rowid in (select min(rowid)
                       from eisdoc_yy.Mortagage a
                      where a.keycode = rs.keycode
                      group by roomcode);
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
                from eisdoc_yy.CU_Person a
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
                 from eisdoc_yy.land a
               where a.keycode=rs.keycode;
         elsif iCount1=0 and iCount4>0 then
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
           select b.ocertno into l_Cqzh from eistran_yy.MO_Person b where b.keycode=rs.keycode and rownum=1;
           --插入房屋明细（FWMX）,查找上手fwbh待定
           insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
             select sys_guid(),
                    iRecid,sysdate,
                    a.roomcode   房屋编号,
                    a.all_area   房屋面积_抵押面积,
                    l_Cqzh   产权证号,
                    decode(a.lo_flag,0,1,2),
                    null
               from eistran_yy.Mortagage a
             where rowid in (select min(rowid)
                       from eistran_yy.Mortagage a
                      where a.keycode = rs.keycode
                      group by roomcode);
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
                 where a.keycode=rs.keycode;
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
            from EISDOC_YY.EAA_Table f
           where f.keycode = rs.keycode;
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
                    decode(a.pages,'２',2,a.pages),
                    1,
                    1,
                    a.id
               from eisdoc_yy.IMPORTANT_DOC a
              where a.keycode = rs.keycode and a.id <>0;
          fnupdayj(iRecid,rs.keycode);          
          select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
          update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
     end if;
  end loop;
  commit;
end;
/

