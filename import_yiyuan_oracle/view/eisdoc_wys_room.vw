create or replace force view eisdoc_wys_room as
select b."KEYCODE",
       b."ROOMCODE",
       b."SUBKEYCODE",
       b."LAND_NO",
       b."BUILD_NO",
       b."ROOM_NO",
       b."ROOM_ALIAS",
       b."B_AREA",
       b."U_AREA",
       b."SET_AREA",
       b."PERTAIN_AREA",
       decode(b."CURFLOOR", 'µ×²ã', '-1', 0, '-1',null,'-1',chr(10)||'µ×²ã','-1',' 1','1','µ×','-1','µ×²ã'||chr(10)||'µ×²ã','-1','¶¥²ã',-1,'¶«²à','-1','µ×²ã'||chr(10)||'µ×²ãµ×²ã','-1', b."CURFLOOR") CURFLOOR,
       b."H_USE",
       b."RTYPE",
       b."HOUSE_TYPE",
       b."ATTACHWAY",
       b."REAST",
       b."RSOUTH",
       b."RWEST",
       b."RNORTH",
       b."HOUSE_SIT",
       decode(b."CURCELL", null, b."ROOM_NO", b."CURCELL") CURCELL,
       b."S_AREA",
       b."HVALUE",
       b."LOGOUT_FLAG",
       b."SURVEY_FLAG",
       b."MARK",
       b."REGISTERNO",
       b."NUMBER1",
       b."BMFBUILDCODE",
       b."BMFROOMMID",
       b."FRAME",
       b."R_INDEX",
       b."IS_LOCK"
  from eisdoc_yy.PRESELL_BUILD a, eisdoc_yy.room b
 where a.land_no(+) = b.land_no
   and a.build_no(+) = b.build_no
   and a.keycode is null
   and b.curfloor not in ('1-2','1-3','1-4','1-5','0','01','15.20','1¡¢2','1¡¢2¡¢3','1£­2','1£­3','234','25.65','49.40','81.25','´¢²ØÊÒ01')
   and b.LAND_NO is not null and b.BUILD_NO is not null;

