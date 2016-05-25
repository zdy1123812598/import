create or replace procedure fnimptest_insertroom(p_recid integer,p_LANDNO varchar2,p_BUILDNO varchar2) is
/****************************************************************************************

*****************************************************************************************/
  img integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(300);
  v_msg varchar2(800);
  l_Lpbh varchar2(200);
  l_cjh  varchar2(400);
  l_zh  varchar2(400);
  l_qh  varchar2(400);
  l_th  varchar2(400);
  l_zcs  integer;
begin
  select a.lpbh,a.cjh,a.zh,a.qh,a.th,a.zcs into l_Lpbh,l_cjh,l_zh,l_qh,l_th,l_zcs from tbbuilding a where a.recid=p_recid;
  insert into tbroom(uuid,recid,createdate,roomnum,szcs,fwzt,unitnum,
                     floornum,yt,fjmc,szdy,cm,zl,zh,qh,lpbh,cjh,th,fwbh,issinglesale,fh,ssq,hx,
                     fwlx,changedate,ysfwzt,jzmj,glmj,zymj,status,yjzmj,yzymj,ycjh,yzh,yzl,fp,sfjg,zcs)
     select sys_guid(),p_recid,sysdate,row_number() over(partition by CURFLOOR, CURCELL order by ROOM_NO),a.curfloor curfloor1,3,regexp_replace(a.curcell,'[^0-9]'),
            a.curfloor curfloor2,a.h_use,lpad(regexp_replace(a.curcell,'[^0-9]'),2,0)||lpad(a.curfloor,2,0)||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0),
            regexp_replace(a.curcell,'[^0-9]'),a.curfloor curfloor3,a.house_sit/*lpad(regexp_replace(a.curcell,'[^0-9]'),2,0)||lpad(a.curfloor,2,0)||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0)||'∫≈'*/,l_zh,l_qh,
            l_Lpbh,l_cjh||'-'||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0)||lpad(a.curfloor,2,0)||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0),l_th,a.roomcode,0,a.room_no,'“ ‘¥œÿ',a.house_type,a.h_use,sysdate,3,a.b_area,a.b_area-a.set_area,a.set_area,1,a.b_area,a.set_area,
            l_cjh||'-'||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0)||lpad(a.curfloor,2,0)||lpad(regexp_replace(a.curcell,'[^0-9]'),2,0),
            l_zh,a.house_sit,0,1,l_zcs
       from /*eisdoc_yy.room*/eisdoc_room a where a.land_no=p_LANDNO and a.build_no=p_BUILDNO and a.curfloor>0;
  insert into tbroom(uuid,recid,createdate,roomnum,szcs,fwzt,
                     floornum,fjmc,cm,zl,zh,qh,lpbh,cjh,th,fwbh,issinglesale,fh,ssq,ffyt,
                     fwlx,changedate,ysfwzt,jzmj,glmj,status,yjzmj,yzymj,ycjh,yzh,yzl,fp,sfjg,zcs)
     select sys_guid(),p_recid,sysdate,row_number() over(partition by CURFLOOR, CURCELL order by ROOM_NO),a.curfloor curfloor1,3,
            a.curfloor curfloor2,'¥¢≤ÿ “'||regexp_replace(a.room_no,'[^0-9]'),a.curfloor curfloor3,a.house_sit,l_zh,l_qh,
            l_Lpbh,l_cjh||'-'||'¥¢≤ÿ “'||regexp_replace(a.room_no,'[^0-9]'),l_th,a.roomcode,0,a.room_no,'“ ‘¥œÿ',a.h_use,
            a.h_use,sysdate,3,a.b_area,a.b_area-a.set_area,1,a.b_area,a.set_area,
            l_cjh||'-'||'¥¢≤ÿ “'||regexp_replace(a.room_no,'[^0-9]'),
            l_zh,a.house_sit,0,1,l_zcs
       from /*eisdoc_yy.room*/eisdoc_room a where a.land_no=p_LANDNO and a.build_no=p_BUILDNO and a.curfloor<0;
  commit;
end;
/

