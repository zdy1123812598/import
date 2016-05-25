create or replace force view v_room_operation_yy as
select rk.roomcode,rk.keycode,op.acc_date,op.type_id from v_roomkeycode_yy rk left join v_operation_yy op on rk.keycode = op.keycode;

