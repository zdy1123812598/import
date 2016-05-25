create or replace view v_roomtran_yy as
select a."ROOMCODE",a."KEYCODE",a."ACC_DATE",a."SERCODE",a."SERCLASS",a."SERTYPE",b.showforkfs,b.roomstate,b.weight from v_room_operation_biz_yy a,tboldbiz_newroom_state_yy b  where a.sercode = b.sercode  order by acc_date;
