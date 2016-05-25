create or replace force view eisdoc_room as
select distinct b."KEYCODE",
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
       decode(b."CURFLOOR", '�ײ�', '-1', 0, '-1', b."CURFLOOR") CURFLOOR,
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
 where a.land_no = b.land_no
   and a.build_no = b.build_no;

