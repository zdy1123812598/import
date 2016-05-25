create or replace procedure fnimptest_cqxx_doc_special_add is
/****************************************************************************************
  3-----------2700  ��Ʒ��
  80----------2484  ��λ����
   115,2605,'����');
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  iCount   integer;
  iCount1  integer;
  iCount2  integer;
  iCount3  integer;
  iCount4  integer;
  l_recnum varchar2(500);
  l_stepno integer;
  l_uname  varchar2(200);
  l_date   date;
  l_humancode integer;
  l_Cqzh   varchar2(200);
  l_Cqzh1  varchar2(200);
  iROLEID   integer:=7329;
  iActdefid integer:=2338;
  ibizid integer;
  l_ywmc varchar2(200);
  l_typeid integer;
begin
    for rs in(
    select  distinct a.*, t.keycode ,c.ocertno from EISdoc_YY.Operation t,eistran_yy.service a ,EISDOC_YY.OWNER c  where
     t.type_id=a.sercode and t.keycode=c.keycode and t.keycode in (SELECT AA1.KEYCODE FROM  (
SELECT  DISTINCT A.KEYCODE,A.OCERTNO  FROM EISDOC_YY.OWNER A WHERE A.OCERTNO IS NOT NULL ) AA1 GROUP BY AA1.KEYCODE HAVING COUNT(10)>1)   )loop

  l_Cqzh := null;
  l_Cqzh1 := null;
      select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eisdoc_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
       if rs.sercode=3 then ibizid:=2700;
         elsif rs.sercode=115 then ibizid:=2605;
         elsif  rs.sercode=80 then ibizid:=2484; end if;
         l_ywmc:=rs.sertype;
         l_typeid:=rs.sercode;
      img := pkworkflow.startWorkflow(ibizid,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '�ռ�ʧ�ܣ�ԭ��'||imsg;
        insert into CQXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
     else
       insert into CQXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD,t_user)values(iRecid,rs.keycode,v_msg,l_typeid,1,'eisdoc_yy');
       --����cqxx
       --select a.recnum into l_recnum from tbrec a where a.recid=iRecid;
       select count(1) into iCount from eisdoc_yy.person a where a.keycode=rs.keycode and a.ocertno = rs.ocertno;
       select count(1) into iCount2 from eisdoc_yy.owner a where a.keycode=rs.keycode and a.ocertno = rs.ocertno;
       if iCount=0 and iCount2=0 then
         update CQXX_LOG set sjyy='������' where recid=iRecid;
       elsif iCount>0 then
         insert into cqxx (recid,cqr,zjhm,zjmc,lxdh,cqzh,cb,GYQK,slbh,ywmc,status)
            select iRecid, a.name, a.cert_no, a.cert_type, a.tel,a.ocertno,b.osort,b.oshare,rs.keycode,l_ywmc, case when b.state =0 then 1 else 2 end as status
              from eisdoc_yy.person a, eisdoc_yy.owner b
             where a.keycode = b.keycode
               and a.keycode = rs.keycode and  a.ocertno=b.ocertno and a.ocertno=rs.ocertno 
               and rownum = 1;
               l_cqzh:=rs.ocertno;
       elsif iCount=0 and iCount2>0 then
         insert into cqxx (recid,cqr,zjhm,lxdh,cqzh,cb,GYQK,slbh,ywmc)
            select iRecid, a.appman, a.appidcno, a.appcellphone,b.ocertno,b.osort,b.oshare,rs.keycode,l_ywmc
              from eisdoc_yy.operation a, eisdoc_yy.owner b
             where a.keycode = b.keycode(+)
               and a.keycode = rs.keycode
               and rownum = 1;
              l_cqzh:=rs.ocertno;
       end if;
       if iCount=0 and iCount2=0 then
         null;
       else
         --������˵�
         insert into SHD (recid,SLR,Slr_Rq,SLYJ,CSR,Csr_Rq,Csyj,Fsr,Fsr_Rq,FSYJ,dbr,DBYJ,Dbr_Rq)
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
                   f.aud_man,f.aud_mark,f.aud_date
              from EISDOC_YY.EAA_Table f
             where f.keycode = rs.keycode;
           --���뷿��״����FWZK��
           select count(1) into iCount3 from eisdoc_yy.room s where s.keycode=rs.keycode;
           select count(1) into iCount4 from eisdoc_yy.owner a where a.keycode=rs.keycode;

             for rn in (select a.roomcode,a.state from eisdoc_yy.owner a where a.keycode=rs.keycode and a.ocertno=rs.ocertno)loop
               insert into fwzk (uuid,recid,createdate,syqzh,FWBH,QH,ZH,FWMC,fh,JZMJ,TNMJ,gtmj,SZCS,YTDL,FWLX,FWZL,SSQ,th,cjh,status)
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
                    b.house_type ס������,
                    b.house_sit ��������,
                    '��Դ��',
                    '10',
                    '10'||'-'||b.land_no||'-'||b.build_no||'-'||b.room_no ������,
                    case when rn.state =0 then 1 else 2 end as status
                    from eisdoc_yy.Room b
                  where b.roomcode=rn.roomcode and rownum=1;
             end loop;

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
             where a.keycode = rs.keycode and a.ocertno=rs.ocertno;
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
            select w.stepno into l_stepno  from eistran_yy.workflow w where w.workcode=(select a.workcode from eisdoc_yy.operation a where a.keycode=rs.keycode);

            update tbrec a set a.recstateid=102,a.finishhumanid=488,a.finishhumanname='����»',a.cantoncode=10 where a.recid=iRecid;

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
                 from eisdoc_yy.IMPORTANT_DOC a
                where a.keycode = rs.keycode and a.id <>0;
            fnupdayj(iRecid,rs.keycode);
            select a.regeditman,a.regeditdate into l_uname,l_date from eisdoc_yy.operation a where a.keycode=rs.keycode;
            update tbrec t set t.dbr=l_uname,t.dbsj=l_date,t.recnum=rs.keycode  where t.recid=iRecid;
            update cqxx c set c.dbr1=l_uname,c.dbsj1=l_date where c.recid=iRecid;
        end if;
    end if;
  end loop;
  commit;
end;
/

