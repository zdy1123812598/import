create or replace procedure fnimptest_ink(l_typeid integer) is
/****************************************************************************************
  1-----------------转移登记
*****************************************************************************************/
  iCount integer;
begin
  if l_typeid=1 then
    for rs in(select a.recid,a.isgd from zydj_log a where a.sjyy is null)loop
      if rs.isgd =0 then
        update cqxx c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        update fwzk f set f.status=0,f.djzt='正登记' where f.recid=rs.recid;
        for rn in (select f.fwbh from fwzk f where f.recid=rs.recid)loop
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update zydj_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.djzt='正登记' where t.fwbh=rn.fwbh;
          end if;
        end loop;
      end if;
    end loop;
  end if;
  commit;
end;
/

