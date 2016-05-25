create or replace procedure fnimptest_zydj_next(l_typeid integer,ibizid integer,l_ywmc varchar2) is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  l_Cqzh  varchar2(200);
  l_humancode integer;
begin
  for rs in(
    select a.keycode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=l_typeid and stepno in (0,1,2,3,4,5))
      and a.type_id = l_typeid order by a.keycode
    )loop
      l_Cqzh := null;
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
     if img < 0 then
        v_msg := '�ռ�ʧ�ܣ�ԭ��'||imsg;
        insert into ZYDJ_LOG(RECID, KEYCODE, MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
     else
       insert into ZYDJ_LOG(RECID, KEYCODE,  MSG, Type_Id,Isgd)values(iRecid,rs.keycode,v_msg,l_typeid,0);
       --����cqxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,sscqr,sscqzh,ssrlxdz,ssrzjhm,ssrlxdh,ywmc)
          select iRecid, a.name1, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,c.name,c.ocertno,c.address,c.cert_no,c.tel,l_ywmc
            from eistran_yy.person a, eistran_yy.owner b,eistran_yy.oldperson c
           where a.keycode = b.keycode(+)
             and a.keycode = c.keycode(+)
             and a.keycode = rs.keycode
             and rownum = 1;
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

	  --�����Ѻ��Ϣ
	   insert into dyxx (recid,slbh,status,txqzh,syqr,syqrzjmc,syqrzjhm,
			     SYQLXRDH,SYQRFRDB,ywmc,sfdb,syqzh,dymjz,dylx,txqr,
			     txqrzjmc,txqrzjhm,txqrlxdh,TXQRFRDB,DYRQKS,DYRQJS,Ys,Qlfw,QLZL,DYFCJZ)
	      select iRecid,rs.keycode,decode(a.ocertnum ,null,0,1),
		     a.ocertnum,b.b_name,b.b_type,b.b_code,b.b_tel,b.b_lawman,
		     l_ywmc,decode(a.ocertnum ,null,0,1),
		     b.ocertno,c.all_area,1,a.m_name,a.m_type,a.m_code,
		     a.m_tel,a.m_lawman,c.start_date,c.end_date,                    
		     round(months_between(c.end_date,c.start_date),0),
		     c.part,c.kind,c.p_money
		  from eistran_yy.MM_Person a,eistran_yy.MO_Person b,eistran_yy.Mortagage c
	      where a.keycode = b.keycode(+)
		and a.keycode = c.keycode(+)
		and c.keycode=rs.keycode and rownum=1;

	select s.ocertno into l_Cqzh from eistran_yy.person s where s.keycode=rs.keycode;

	--���뷿����ϸ��FWMX��
       insert into fwmx(uuid,recid,createdate,fwbh,dymj,syqzh,status,fwzk_uuid)
         select sys_guid(),iRecid,sysdate,
                a.roomcode   ���ݱ��,
                a.all_area   �������_��Ѻ���,
                l_Cqzh   ��Ȩ֤��,
                decode(a.lo_flag,0,1,2),
                null
           from eistran_yy.Mortagage a
          where a.keycode = rs.keycode;
       --���뷿��״����FWZK�� 
       insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,FH,JZMJ,TNMJ,GTMJ,SZCS,YTDL,FWYT,FWLX,FWZL,SSQ,th,cjh,status)
         select
            sys_guid(),
            iRecid,
            sysdate,
            l_Cqzh,
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
          from eistran_yy.Room b
         where b.keycode=rs.keycode;
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
            from eistran_yy.CU_Person a
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
             from eistran_yy.land a
           where a.keycode=rs.keycode and rownum=1;
        --�����շ���Ϣ���շѺϼ�
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
        select count(1) into iCount from eistran_yy.person a where a.keycode=rs.keycode;
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

