create or replace procedure fninsertryxx is
  l_mid integer;
  y  integer;
begin
   for rt in (select s.username,s.sex from eistran_yy.userpower s where s.username <> 'Íõ¶«Â»')loop
     select max(d.humanid) into l_mid from tbhuman d;
     select SEQHUMANCODE.Nextval into y from dual;
     insert into tbhuman(humanid,humanname,gender,status,password,unitid,disporder,cantoncode,humancode)
       values (l_mid+1,rt.username,decode(rt.sex,'ÄÐ',1,'Å®',0),1,'202cb962ac59075b964b07152d234b70',18,9999,10,10||y);
   end loop;
   commit;
end;/