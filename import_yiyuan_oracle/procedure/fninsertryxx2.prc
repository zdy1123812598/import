create or replace procedure fninsertryxx2 is
 l_mid integer;
 y  integer;
begin
   for rt in (select a.accman  from eisdoc_yy.operation a where a.accman not in (select h.humanname from tbhuman h where 
               h.cantoncode=10) group by a.accman)loop
     select max(d.humanid) into l_mid from tbhuman d;
     select SEQHUMANCODE.Nextval into y from dual;
     insert into tbhuman(humanid,humanname,status,password,unitid,disporder,cantoncode,humancode)
       values (l_mid+1,rt.accman,1,'202cb962ac59075b964b07152d234b70',18,9999,10,10||y);
   end loop;
   commit;
end;/