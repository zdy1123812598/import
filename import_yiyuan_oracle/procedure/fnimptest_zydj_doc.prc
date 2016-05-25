create or replace procedure fnimptest_zydj_doc(l_typeid integer,ibizid integer,l_ywmc varchar2) is
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
  iCount2 integer;
  iCount3 integer;
  iCount4 integer;
  iCount5 integer;
  iCount6 integer;
  iCount7 integer;
  l_stepno integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
  l_Cqzh   varchar2(200);
  iActdefid integer:=40;
  iROLEID   integer:=9632;
  l_ocertno VARCHAR2(80);  
begin
  for rs in(select a.keycode from t_keycode_yy a where a.t_user='eisdoc_yy' 
               and a.typeid=l_typeid order by a.keycode
             /*select s.keycode from t_keycode_yy s where s.keycode='201009250089'*/)loop
      l_Cqzh := null;
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '�ռ�ʧ�ܣ�ԭ��'||imsg;
        insert into ZYDJ_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
     else
       insert into ZYDJ_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
       --����cqxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       select count(1) into iCount2 from eisdoc_yy.person a where a.keycode=rs.keycode;
       select count(1) into iCount4 from eisdoc_yy.owner a where a.keycode=rs.keycode;
       if iCount2=0 and iCount4=0 then
         update ZYDJ_LOG set sjyy='������' where recid=iRecid;
         --exit;
       elsif iCount2>0 then
         if l_typeid<>115 then
           insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.name, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,
                      d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc 
                from eisdoc_yy.person a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
               where a.keycode = b.keycode(+)
                 and a.keycode = c.keycode(+)
                 and c.oldocertno=d.ocertno(+)
                 and a.keycode = rs.keycode
                 and rownum = 1;
         elsif l_typeid=115 then
            insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.name, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,
                    d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc
              from eisdoc_yy.person a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
             where a.keycode = b.keycode(+)
               and a.keycode = c.keycode(+)
               and c.oldocertno=d.ocertno(+)
               and a.keycode = rs.keycode
               and c.subkeycode=2
               and rownum = 1;
         end if;
       elsif iCount2=0 and iCount4>0 then
         if l_typeid<>115 then
           insert into cqxx (recid,cqr,zjhm,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.appman, a.appidcno, a.appcellphone,b.ocertno,b.osort,b.oshare,rs.keycode,
                      d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc 
                from eisdoc_yy.operation a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
               where a.keycode = b.keycode(+)
                 and a.keycode = c.keycode(+)
                 and c.oldocertno=d.ocertno(+)
                 and a.keycode = rs.keycode
                 and rownum = 1;
         elsif l_typeid=115 then
            insert into cqxx (recid,cqr,zjhm,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
              select  iRecid,a.appman, a.appidcno, a.appcellphone,b.ocertno,b.osort,b.oshare,rs.keycode,
                    d.name,c.oldocertno,d.address,d.cert_no,d.tel,l_ywmc
              from eisdoc_yy.operation a, eisdoc_yy.owner b,eisdoc_yy.history_room c,eisdoc_yy.person d
             where a.keycode = b.keycode(+)
               and a.keycode = c.keycode(+)
               and c.oldocertno=d.ocertno(+)
               and a.keycode = rs.keycode
               and c.subkeycode=2
               and rownum = 1;
         end if;
       end if;
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
            from eisdoc_yy.EAA_Table f
           where f.keycode = rs.keycode;
       --���뷿��״����FWZK��
       if l_typeid<>115 then
          --����Ȩ�˺�   ��eisdoc_yy.ownerȡ��oce no�ֶθ�ֵ������l_ocertno
	   select count(1) into iCount7  from eisdoc_yy.owner where keycode=rs.keycode and rownum=1;
	  if  iCount7>0 then
		select ocertno into l_ocertno from eisdoc_yy.owner where keycode=rs.keycode and rownum=1;
	  else
		l_ocertno := 'empty';
	  end if;
         --����eisdoc_yy.owner��roomcode ��eisdoc_yy.room ����ȡrownum=1
	 --fix by dcx
        for rn in (select h.roomcode from eisdoc_yy.owner h where keycode=rs.keycode)loop
              insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
               select
                  sys_guid(),
                  iRecid,
                  sysdate,
                  l_ocertno,
                  b.roomcode ���ݱ��,
                  b.land_no ���,
                  b.build_no ����,
                  b.room_no ����,
		  b.room_no ����,
                  b.b_area �������,
                  b.set_area �������,
	          b.s_area ��̯���,
                  b.curfloor ���ڲ�,
                  b.h_use ������;,
		  b.h_use ������;,
                  b.house_type ס������,
                  b.house_sit ��������,
                  '��Դ��',
                  '10',
                  '10'||'-'||b.land_no||'-'||b.build_no||'-'||b.room_no ������,
                  1
                 from eisdoc_yy.room b
                where b.roomcode=rn.roomcode and rownum=1;
            end loop;
        elsif l_typeid=115 then
          insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
           select
              sys_guid(),
              iRecid,
              sysdate,
              c.ocertno,
              b.roomcode ���ݱ��,
              b.land_no ���,
              b.build_no ����,
              b.room_no ����,
	      b.room_no ����,
              b.b_area �������,
              b.set_area �������,
	      b.s_area ��̯���,
              b.curfloor ���ڲ�,
              b.h_use ������;,
	      b.h_use ������;,
              b.house_type ס������,
              b.house_sit ��������,
              '��Դ��',
              '10',
              '10'||'-'||b.land_no||'-'||b.build_no||'-'||b.room_no ������,
              1
             from eisdoc_yy.history_room b,eisdoc_yy.person c
            where b.keycode=rs.keycode and c.keycode = rs.keycode
              and b.subkeycode=2;
        end if;
        --���빲����Ϣ
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
        --��������״��
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
           where a.keycode=rs.keycode and rownum=1;
        --�����շ���Ϣ���շѺϼ�
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eisdoc_yy.charge_item a where a.keycode=rs.keycode;
        select count(1) into iCount1 from eisdoc_yy.operation a where a.keycode=rs.keycode and a.accman like '%¼��%';
        select count(1) into iCount3 from eisdoc_yy.operation a where a.keycode=rs.keycode;
        if iCount3>0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);
        elsif iCount3=0 then
          select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eistran_yy.operation a where a.keycode=rs.keycode);
        end if;
        if l_stepno=11 or iCount1>0  then
          update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='����»',a.cantoncode=10 where a.recid=iRecid;
        elsif l_stepno in (7,8,9,10) then
          update tbactinst t set t.enddate=sysdate,t.completed=1 where t.recid=iRecid and t.actdefname='����';
          insert into tbactinst(recid,actid,partid,actdefid,actdefname,roleid,createdate,
                                read,assigned,cancelable,completed,sendback)
             values(iRecid,seqactid.nextval,-1,iActdefid,'�鵵',iROLEID,sysdate,0,0,1,0,0);
        end if;
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
                  decode(a.pages,'��',1,a.pages),
                  1,
                  1,
                  a.id
             from eisdoc_yy.IMPORTANT_DOC a
            where a.keycode = rs.keycode and a.id <>0;
        fnupdayj(iRecid,rs.keycode);        
        select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
        update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
        update cqxx c set c.dbr1=l_uname,c.dbsj1=l_date where c.recid=iRecid;
     end if;
  end loop;
  commit;
end;
/
