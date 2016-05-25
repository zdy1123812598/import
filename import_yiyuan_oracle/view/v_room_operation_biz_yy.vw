create or replace force view v_room_operation_biz_yy as
select * from (select ro.roomcode,ro.keycode,ro.acc_date,to_number(s.sercode) sercode,s.serclass,s.sertype from v_room_operation_yy ro left join eistran_yy.Service s on ro.type_id = to_number(s.sercode)) where sercode <> '39' order by acc_date;

