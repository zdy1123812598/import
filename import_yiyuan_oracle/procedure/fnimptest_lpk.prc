create or replace procedure fnimptest_lpk(ibizid integer) is
/****************************************************************************************

*****************************************************************************************/
  img integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(300);
  v_msg varchar2(800);
  l_recnum varchar2(200);
begin
  for rs in(select b.keycode, a.ITEMNAME ITEMNAME,b.buildcode buildcode,decode(b.buildname, NUll, a.itemname, b.buildname) buildname,c.DEVELOPER_NAME DEVELOPER_NAME,
                   decode(b.address, NUll, a.address, b.address) ADDRESS,b.FRAME FRAME,a.HOUSEUSE HOUSEUSE,b.LAND_NO LAND_NO,
                   b.BUILD_NO BUILD_NO,a.CERTCODE CERTCODE,a.ALLAREA ALLAREA,b.cellnum CELLNUM,
		   b.floorall FLOORALL,b.FLOOR_UNDER FLOOR_UNDER,b.floorall - b.FLOOR_UNDER FLOOR_UP,b.setnum SETNUM
               from eistran_yy.Presell a, eisdoc_yy.PRESELL_BUILD b,eistran_yy.Developer c
             where a.keycode=b.keycode and a.declareco=c.code )loop
    img := pkworkflow.startWorkflow(ibizid,488,'王东禄',iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into LPK_LOG(RECID, pre_buildcode, MSG, LANDNO,BUILDNO,TBBS)values(iRecid,rs.buildcode,v_msg,rs.land_no,rs.build_no,1);
     else
       insert into LPK_LOG(RECID, pre_buildcode,  MSG, LANDNO,BUILDNO,TBBS)values(iRecid,rs.buildcode,v_msg,rs.land_no,rs.build_no,1);
       insert into tbbuilding(lpbh,lpmc,xmmc,qymc,zl,yt,jg,qh,zh,recid,cllx,ssq,cjh,th,lpzt,ysxkzh,mj,jgxg,salestatus,sfjg,dys,zcs,dscs,dxcs,ts)
          values(rs.buildcode,rs.buildname,rs.ITEMNAME,rs.developer_name,rs.address,rs.frame,rs.houseuse,rs.land_no,rs.build_no,iRecid,
                 '预测','沂源县','10'||'-'||rs.land_no||'-'||rs.build_no,'10',0,rs.certcode,rs.allarea,2,0,1,rs.cellnum,rs.floorall, rs.floor_up,rs.floor_under,rs.setnum);
       fnimptest_insertroom(iRecid,rs.land_no,rs.build_no);
     end if;
  end loop;
  commit;
end;
/

