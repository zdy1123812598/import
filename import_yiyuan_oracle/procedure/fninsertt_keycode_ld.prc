create or replace procedure fninsertt_keycode_ld is
begin
 insert into t_keycode_ld(keycode, t_user,TYPEID)
   select a.keycode,'eistran_yy',a.type_id from eistran_yy.operation a where a.accman like  '%Â¼µµ%'
   union all
   select a.keycode,'eisdoc_yy',a.type_id from eisdoc_yy.operation a where a.accman like  '%Â¼µµ%';
 delete from t_keycode_ld s where s.keycode in (select a.keycode from t_keycode_ld a group by a.keycode having count(1)>1) and s.t_user='eistran_yy';
 commit;
end;
/