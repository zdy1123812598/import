create or replace function fniskeycoderegister_yy(p_keycode varchar2)
return Integer AS
  iCount integer;
begin
  select count(*) into iCount from t_keycode_yy where keycode = p_keycode;
  return iCount;
end fniskeycoderegister_yy;
/
