create or replace procedure fnimptest_lpk_wysxk(ibizid integer) is
/****************************************************************************************

*****************************************************************************************/
  img integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(300);
  v_msg varchar2(800);
  l_recnum varchar2(200);
  iCount integer;
begin
  for rs in(select a.LAND_NO,a.BUILD_NO from eisdoc_wys_room a group by a.LAND_NO,a.BUILD_NO)loop
     img := pkworkflow.startWorkflow(ibizid,488,'王东禄',iRecid,iActid,imsg);
     if img < 0 then
       v_msg := '收件失败，原因：'||imsg;
       insert into LPK_wys_LOG(RECID,  MSG, LANDNO,BUILDNO)values(iRecid,v_msg,rs.land_no,rs.build_no);
     else
       select RECNUM into l_recnum from tbrec where recid=iRecid;
       select count(1) into iCount from eisdoc_yy.build e where e.land_no=rs.land_no and e.build_no=rs.build_no;
       insert into LPK_wys_LOG(RECID,  MSG, LANDNO,BUILDNO)values(iRecid,v_msg,rs.land_no,rs.build_no);
       insert into tbbuilding(lpbh,lpmc,zl,jg,qh,zh,recid,cllx,ssq,cjh,th,lpzt,mj,jgxg,salestatus,sfjg,dys,zcs,dscs,dxcs,ts)
          select 10 || l_recnum,
                 a.sit sitname,
                 a.sit,
                 a.frame,
                 a.land_no,
                 a.build_no,
                 iRecid,
                 '实测',
                 '沂源县',
                 '10' || '-' || a.land_no || '-' || a.build_no,
                 '10',
                 0,
                 a.build_unit,
                 2,
                 0,
                 1,
                 a.cellnum,
                 a.floorall,
                 a.floorall - a.floor_under,
                 a.floor_under,
                 a.setnum
            from eisdoc_yy.build a
           where a.land_no = rs.land_no
             and a.build_no =rs.build_no
             and rownum = 1;
       if iCount>0 then
          fnimptest_insertroom_wysxk(iRecid,rs.land_no,rs.build_no);
       end if;
     end if;
  end loop;
  commit;
end;
/

