create or replace procedure fnimptest_link(l_typeid integer) is
/****************************************************************************************
  1-----------------转移登记
*****************************************************************************************/
  iCount integer;
  iCount1 integer;
  iCount2 integer;
  iCount3 integer;
  iCount4 integer;
  iCount5 integer;
  iCount6 integer;
  iCount7 integer;
  iSsrecid integer;
  iSsrecid1 integer;
  l_Htbh   integer;
  l_Uuid  varchar2(200);
begin
  if l_typeid=1 then
    for rs in(select a.recid,a.isgd from zydj_log a,cqxx c where a.recid=c.recid and a.sjyy is null and a.ISGX is null order by c.cqzh asc)loop
      update zydj_log set ISGX=1 where recid=rs.recid;
      select count(1) into iCount2 from cqxx c where c.cqzh=(select a.sscqzh from cqxx a where a.recid=rs.recid);
      if iCount2>1 then
        update zydj_log set CQZHSFDT=1 where recid=rs.recid;
      elsif iCount2=0 then
        update zydj_log set CQZHSFDT=2 where recid=rs.recid;
      else
        select c.recid into iSsrecid from cqxx c where c.cqzh = (select a.sscqzh from cqxx a where a.recid=rs.recid);
      end if;
      --登簿之前
      if rs.isgd =0 then
        update cqxx c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        update fwzk f set f.status=0,f.djzt='正登记' where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,9,0 from fwzk f where f.recid=rs.recid;
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        for rn in (select f.fwbh from fwzk f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.recid=iSsrecid;
          if iCount1=0 then
            update zydj_log set ssfw=1 where recid=rs.recid;
          else
            update fwzk f set f.zyzt='正转移' where f.recid=iSsrecid and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update zydj_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=9,t.djzt='正登记',t.zyzt='正转移' where t.fwbh=rn.fwbh;
          end if;
        end loop;
      --登簿之后
      elsif rs.isgd=1 then
        update cqxx c set c.status=1,c.sfdb=1 where c.recid=rs.recid;
        update fwzk f set f.status=1,f.djzt='已登记' where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,9,1 from fwzk f where f.recid=rs.recid;
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        select count(1) into iCount3 from fwzk f where f.fwbh not in (select fwbh from fwzk where recid=rs.recid) and f.recid=iSsrecid;
        if iCount3=0 then
          update cqxx c set c.status=2 where c.recid=iSsrecid;
        else
          update cqxx c set c.status=1 where c.recid=iSsrecid;
        end if;
        for rn in (select f.fwbh from fwzk f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where f.recid=iSsrecid;
          if iCount1=0 then
            update zydj_log set ssfw=1 where recid=rs.recid;
          else
            update fwzk f set f.zyzt='已转移',f.status=2,f.djzt='已登记' where f.recid=iSsrecid and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update zydj_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=9,t.djzt='已登记',t.zyzt=null where t.fwbh=rn.fwbh;
          end if;
          update tbhousestatestack h set h.stateflag=-1 where h.fwbh=rn.fwbh and h.recid<>rs.recid and h.housestateid=9;
        end loop;
      end if;
    end loop;
  elsif l_typeid=2 then
    for rs in(select a.recid,a.isgd from bgdj_log a,cqxx c where a.recid=c.recid and a.sjyy is null and a.ISGX is null order by c.cqzh asc)loop
      update bgdj_log set ISGX=1 where recid=rs.recid;
      select count(1) into iCount2 from cqxx c where c.cqzh=(select a.sscqzh from cqxx a where a.recid=rs.recid);
      if iCount2>1 then
        update bgdj_log set CQZHSFDT=1 where recid=rs.recid;
      elsif iCount2=0 then
        update bgdj_log set CQZHSFDT=2 where recid=rs.recid;
      else
        select c.recid into iSsrecid from cqxx c where c.cqzh = (select a.sscqzh from cqxx a where a.recid=rs.recid);
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
      end if;
      --登簿之前
      if rs.isgd =0 then
        update cqxx c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        update fwzk f set f.status=0,f.djzt='正登记' where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,9,0 from fwzk f where f.recid=rs.recid;
        
        for rn in (select f.fwbh from fwzk f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.recid=iSsrecid;
          if iCount1=0 then
            update bgdj_log set ssfw=1 where recid=rs.recid;
          else
            update fwzk f set f.zyzt='正转移' where f.recid=iSsrecid and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update bgdj_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=9,t.djzt='正登记',t.zyzt='正转移' where t.fwbh=rn.fwbh;
          end if;
        end loop;
      --登簿之后
      elsif rs.isgd=1 then
        update cqxx c set c.status=1,c.sfdb=1 where c.recid=rs.recid;
        update fwzk f set f.status=1,f.djzt='已登记' where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,9,1 from fwzk f where f.recid=rs.recid;
        select count(1) into iCount3 from fwzk f where f.fwbh not in (select fwbh from fwzk where recid=rs.recid) and f.recid=iSsrecid;
        if iCount3=0 then
          update cqxx c set c.status=2 where c.recid=iSsrecid;
        else
          update cqxx c set c.status=1 where c.recid=iSsrecid;
        end if;
        for rn in (select f.fwbh from fwzk f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where f.recid=iSsrecid;
          if iCount1=0 then
            update bgdj_log set ssfw=1 where recid=rs.recid;
          else
            update fwzk f set f.zyzt='已转移',f.status=2,f.djzt='已登记' where f.recid=iSsrecid and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update bgdj_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=9,t.djzt='已登记',t.zyzt=null where t.fwbh=rn.fwbh;
          end if;
          update tbhousestatestack h set h.stateflag=-1 where h.fwbh=rn.fwbh and h.recid<>rs.recid and h.housestateid=9;
        end loop;
      end if;
    end loop;
  elsif l_typeid=3 then
    for rs in(select a.recid,a.isgd from zxxx_log a,cqxx c where a.recid=c.recid and a.sjyy is null and a.ISGX is null)loop
      update zxxx_log set ISGX=1 where recid=rs.recid;
      select count(1) into iCount2 from cqxx c where c.cqzh=(select a.sscqzh from cqxx a where a.recid=rs.recid);
      if iCount2>1 then
        update zxxx_log set CQZHSFDT=1 where recid=rs.recid;
      elsif iCount2=0 then
        update zxxx_log set CQZHSFDT=2 where recid=rs.recid;
      else
        select c.recid into iSsrecid from cqxx c where c.cqzh = (select a.sscqzh from cqxx a where a.recid=rs.recid);
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
      end if;
      --登簿之前
      if rs.isgd =0 then
        update ZXDJB c set c.sfdb=0 where c.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,-1,0 from fwmx f where f.recid=rs.recid;
        
        for rn in (select f.fwbh,f.uuid from fwmx f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.status=1;
          if iCount1=0 then
            update zxxx_log set ssfw=1 where recid=rs.recid;
          elsif iCount1>1 then
            update zxxx_log set ssfw=2 where recid=rs.recid;
          else
            update fwzk f set f.zxzt='正注销' where f.status=1 and f.fwbh=rn.fwbh;
            update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.status=1) where s.recid=rs.recid and s.fwbh=rn.fwbh;
            insert into tbkeyref(uuid,recid,refuuid,refrecid)
              select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.status=1 and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update zxxx_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=-1,t.zxzt='正注销' where t.fwbh=rn.fwbh;
          end if;
        end loop;
      --登簿之后
      elsif rs.isgd=1 then
        update ZXDJB c set c.sfdb=1 where c.recid=rs.recid;
        for rn in (select f.fwbh,f.uuid from fwmx f where f.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.status=1;
          if iCount1=0 then
            update zxxx_log set ssfw=1 where recid=rs.recid;
          elsif iCount1>1 then
            update zxxx_log set ssfw=2 where recid=rs.recid;
          else
            update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.status=1) where s.recid=rs.recid and s.fwbh=rn.fwbh;
            insert into tbkeyref(uuid,recid,refuuid,refrecid)
              select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.status=1 and f.fwbh=rn.fwbh;
            update fwzk f set f.zxzt='已注销',f.status=2 where f.status=1 and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update zxxx_log set isfw=1 where recid=rs.recid;
          else
            update tbroom t set t.fwzt=6,t.zxzt='已注销' where t.fwbh=rn.fwbh;
          end if;
        end loop;
      end if;
    end loop;
  elsif l_typeid=4 then
    for rs in (select a.recid,a.isgd,a.type_id from dyxx_log a where a.sjyy is null and a.isgx is null)loop
      update dyxx_log set ISGX=1 where recid=rs.recid;
      if rs.type_id=86 then
        select count(1) into iCount4 from dyxx c where c.txqzh=(select a.txqzh from dyxx a where a.recid=rs.recid) and c.status=1;
        if iCount4>1 then
          update dyxx_log set txqzhsfdt=1 where recid=rs.recid;
        elsif iCount4=0 then
          update dyxx_log set txqzhsfdt=2 where recid=rs.recid;
        else
          select c.recid into iSsrecid from dyxx c where c.txqzh = (select a.txqzh from dyxx a where a.recid=rs.recid);
          insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        end if;
      else
        select count(1) into iCount2 from cqxx c where c.cqzh=(select a.sscqzh from cqxx a where a.recid=rs.recid);
        if iCount2>1 then
          update dyxx_log set CQZHSFDT=1 where recid=rs.recid;
        elsif iCount2=0 then
          update dyxx_log set CQZHSFDT=2 where recid=rs.recid;
        else
          select c.recid into iSsrecid from cqxx c where c.cqzh = (select a.sscqzh from cqxx a where a.recid=rs.recid);
          insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        end if;
      end if;
      --登簿之前
      if rs.isgd =0 then
        if rs.type_id=86 then
          update dyxx d set d.status=0,d.sfdb=0,d.foreshow=3 where d.recid=rs.recid;
          update ZXDJB c set c.sfdb=0 where c.recid=rs.recid;
        else
          update dyxx d set d.status=0,d.sfdb=0 where d.recid=rs.recid;
        end if;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
              select f.fwbh,rs.recid,11,0 from fwzk f where f.recid=rs.recid;
        for rn in (select s.uuid,s.fwbh from fwmx s where s.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.status=1;
          if iCount1=0 then
            update dyxx_log set ssfw=1 where recid=rs.recid;
          elsif iCount1>1 then
            update dyxx_log set ssfw=2 where recid=rs.recid;
          else
            if rs.type_id in (125,126,127)then
               update fwzk f set f.zgedyzt='正最高额抵押' where f.status=1 and f.fwbh=rn.fwbh;
            elsif rs.type_id not in (86,125,126,127) then
               update fwzk f set f.dyzt='正抵押' where f.status=1 and f.fwbh=rn.fwbh;
            end if;
              update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.status=1) where s.recid=rs.recid and s.fwbh=rn.fwbh;
              insert into tbkeyref(uuid,recid,refuuid,refrecid)
                select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.status=1 and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update dyxx_log set isfw=1 where recid=rs.recid;
          else
            if rs.type_id in (125,126,127)then
               update tbroom t set t.fwzt=11, t.zgedyzt='正最高额抵押' where t.fwbh=rn.fwbh;
            elsif rs.type_id not in (86,125,126,127) then
               update tbroom t set t.fwzt=11,t.dyzt='正抵押' where t.fwbh=rn.fwbh;
            end if;
          end if;
        end loop;
      --登簿之后
      elsif rs.isgd =1 then
        if rs.type_id=86 then
          update dyxx d set d.status=2,d.sfdb=1 where d.recid=iSsrecid;
        else
          update dyxx d set d.status=1,d.sfdb=1 where d.recid=rs.recid;
        end if;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select f.fwbh,rs.recid,11,1 from fwzk f where f.recid=rs.recid;
        for rn in (select s.uuid,s.fwbh from fwmx s where s.recid=rs.recid)loop
          select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.status=1;
          if iCount1=0 then
            update dyxx_log set ssfw=1 where recid=rs.recid;
          elsif iCount1>1 then
            update dyxx_log set ssfw=2 where recid=rs.recid;
          else
            if rs.type_id in (125,126,127)then
               update fwzk f set f.zgedyzt='已最高额抵押' where f.status=1 and f.fwbh=rn.fwbh;
            else
               update fwzk f set f.dyzt='已抵押' where f.status=1 and f.fwbh=rn.fwbh;
            end if;
              update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.status=1) where s.recid=rs.recid and s.fwbh=rn.fwbh;
              insert into tbkeyref(uuid,recid,refuuid,refrecid)
                select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.status=1 and f.fwbh=rn.fwbh;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update dyxx_log set isfw=1 where recid=rs.recid;
          else
            if rs.type_id in (125,126,127)then
               update tbroom t set t.fwzt=11, t.zgedyzt='已最高额抵押' where t.fwbh=rn.fwbh;
            else
               update tbroom t set t.fwzt=11,t.dyzt='已抵押' where t.fwbh=rn.fwbh;
            end if;
          end if;
        end loop;
      end if;
    end loop;
  elsif l_typeid=5 then
    for rs in (select a.recid,a.isgd from htcx_log a where a.ISGX is null )loop
      select h.htbh into l_Htbh from HTCX h where h.recid=rs.recid;
      select y.recid into iSsrecid from ysht y where y.recid=l_Htbh;
      if iSsrecid is null then
        update htcx_log a set a.issrecid='无上手信息' where a.recid=rs.recid;
      else
        insert into tbkeyref(uuid,recid,refuuid,refrecid)
          select a.uuid,rs.recid,b.uuid,b.recid from lpfwmx a,tbroom b where a.fwbh=b.fwbh and a.recid=rs.recid;
        insert into tbrelinst(reldefid,srcrecid,dstrecid)values(0,iSsrecid,rs.recid);
        update ysht y set y.htzt=3 where y.recid=iSsrecid;
        update tbroom t set t.bazt=null,t.bahtbh=null where t.fwbh in (select fwbh from lpfwmx where recid=rs.recid);
      end if;
    end loop;
  elsif l_typeid=6 then
    for rs in (select a.recid,a.type_id,a.isgd from cfxx_log a where a.isgx is null and a.sjyy is null and a.cqzhdg is null order by a.recid)loop
      update cfxx_log set ISGX=1 where recid=rs.recid;
      if rs.type_id=36 then
        select count(1) into iCount from cqxx c where c.cqzh=(select distinct f.syqzh from fwmx f where f.recid=rs.recid);
        select count(1) into iCount1 from cqxx c where c.cqzh=(select distinct f.syqzh from fwmx f where f.recid=rs.recid) and c.status=2;
        if iCount=1 and iCount1=1 then
          select c.recid into iSsrecid from cqxx c where c.cqzh=(select distinct f.syqzh from fwmx f where f.recid=rs.recid) and c.status=2;
          insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        else
          select count(1) into iCount6 from cqxx c where c.cqzh=(select distinct f.syqzh from fwmx f where f.recid=rs.recid) and c.status=1;
          if iCount6=0 then
            update cfxx_log set SSCQZH=1 where recid=rs.recid;
          elsif iCount6>1 then
            update cfxx_log set SSCQZH=2 where recid=rs.recid;
          else 
            select c.recid into iSsrecid from cqxx c,tbrec d 
             where c.recid=d.recid 
               and c.cqzh=(select distinct f.syqzh from fwmx f where f.recid=rs.recid) 
               and c.status=1
               and d.cantoncode=10; 
            insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
          end if;
        end if;
      else
        select count(1) into iCount7 from cfdj s where s.cfbh=(select c.cfbh from cfdj c where c.recid=rs.recid) and s.recid<>rs.recid;
        if iCount7=0 then
          update cfxx_log set SSCFSJ=1 where recid=rs.recid;
        else
         select s.recid into iSsrecid from cfdj s where s.cfbh=(select c.cfbh from cfdj c where c.recid=rs.recid) and s.recid<>rs.recid;  
         insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        end if;
      end if;
      --登簿之前
      if rs.isgd=0 then
        update CFDJ c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        update fwmx f set f.status=1 where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select fwbh,rs.recid,12,0 from fwmx where recid=rs.recid;
        for rn in (select f.fwbh,f.uuid from fwmx f where f.recid=rs.recid)loop
          if rs.type_id=36 and iCount6=1 then
            select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.recid=iSsrecid;
            if iCount1=0 then
              update cfxx_log set ssfw=1 where recid=rs.recid;
            elsif iCount1>1 then
              update cfxx_log set ssfw=2 where recid=rs.recid;
            else
              update fwzk f set f.cfzt='正查封' where f.fwbh=rn.fwbh and f.recid=iSsrecid;
              update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.recid=iSsrecid) where s.recid=rs.recid and s.fwbh=rn.fwbh;
              insert into tbkeyref(uuid,recid,refuuid,refrecid)
                select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.recid=iSsrecid and f.fwbh=rn.fwbh;
            end if;
          else
            select  count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh;
            select  count(1) into iCount5 from fwzk f where  f.fwbh=rn.fwbh and f.status=2;
            if iCount1=1 and iCount5=1 then
              update fwzk f set f.cfzt='正解封' where f.fwbh=rn.fwbh and f.status=2;
            else
              update fwzk f set f.cfzt='正解封' where f.fwbh=rn.fwbh and f.status=1;
            end if;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update cfxx_log set isfw=1 where recid=rs.recid;
          else
            if rs.type_id=36 then
              update tbroom t set t.fwzt=12,t.cfzt='正查封' where t.fwbh=rn.fwbh;
            else
              update tbroom t set t.fwzt=12,t.cfzt='正解封' where t.fwbh=rn.fwbh;
            end if;
          end if;
        end loop;
      --登簿之后  
      elsif rs.isgd=1 then
        update CFDJ c set c.status=1,c.sfdb=1 where c.recid=rs.recid;
        update fwmx f set f.status=1 where f.recid=rs.recid;
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select fwbh,rs.recid,12,1 from fwmx where recid=rs.recid;
        for rn in (select f.fwbh,f.uuid from fwmx f where f.recid=rs.recid)loop
          if rs.type_id=36 and iCount6=1  then
            select count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh and f.recid=iSsrecid;
            if iCount1=0 then
              update cfxx_log set ssfw=1 where recid=rs.recid;
            elsif iCount1>1 then
              update cfxx_log set ssfw=2 where recid=rs.recid;
            else
              update fwzk f set f.cfzt='已查封' where f.fwbh=rn.fwbh and f.recid=iSsrecid;
              update fwmx s set s.fwzk_uuid=(select f.uuid from fwzk f where  f.fwbh=rn.fwbh and f.recid=iSsrecid) where s.recid=rs.recid and s.fwbh=rn.fwbh;
              insert into tbkeyref(uuid,recid,refuuid,refrecid)
                select rn.uuid,rs.recid,f.uuid,f.recid from fwzk f where f.recid=iSsrecid and f.fwbh=rn.fwbh;
            end if;
          else
            select  count(1) into iCount1 from fwzk f where  f.fwbh=rn.fwbh;
            select  count(1) into iCount5 from fwzk f where  f.fwbh=rn.fwbh and f.status=2;
            if iCount1=1 and iCount5=1 then
              update fwzk f set f.cfzt='已解封' where f.fwbh=rn.fwbh and f.status=2;
            else
              update fwzk f set f.cfzt='已解封' where f.fwbh=rn.fwbh and f.status=1;
            end if;
          end if;
          select count(1) into iCount from tbroom t where t.fwbh=rn.fwbh;
          if iCount=0 then
            update cfxx_log set isfw=1 where recid=rs.recid;
          else
            if rs.type_id=36 then
              update tbroom t set t.fwzt=12,t.cfzt='已查封' where t.fwbh=rn.fwbh;
            else
              update tbroom t set t.fwzt=12,t.cfzt='已解封' where t.fwbh=rn.fwbh;
            end if;
          end if;
        end loop;
      end if;  
    end loop;
  elsif l_typeid=7 then
    for rs in (select a.recid,a.type_id,a.isgd from ycfxx_log a where a.sjyy is null and a.isgx is null order by a.keycode)loop
      update ycfxx_log a set a.isgx=1 where recid=rs.recid;
      delete from tbhousestatestack s where s.recid=rs.recid;
      delete from tbrelinst s where s.dstrecid=rs.recid;
      delete from tbkeyref s where s.recid=rs.recid;
      if rs.isgd=0 then
        --更新cfdj
        update cfdj c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        --更新lpfwmx
        update lpfwmx l set l.status=1 where l.recid=rs.recid;
        --更新tbroom
        update tbroom t set t.fwzt=12,t.cfzt='正查封' where t.fwbh in (select fwbh from lpfwmx where recid=rs.recid);
        --插入tbkeyref
        insert into tbkeyref(uuid,recid,refuuid,refrecid)
          select a.uuid,rs.recid,b.uuid,b.recid from lpfwmx a,tbroom b where a.fwbh=b.fwbh and a.recid=rs.recid;
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select l.fwbh,rs.recid,12,0 from lpfwmx l where l.recid=rs.recid;
        if rs.type_id=141 then
          select count(1) into iCount from cfdj s where s.cfbh =(select cfbh from cfdj where recid=rs.recid) and s.status=1;
          if iCount<>1 then
            update ycfxx_log set SFSSXX=1 where recid=rs.recid;
          elsif iCount=1 then
            select s.recid into iSsrecid from cfdj s where s.cfbh =(select cfbh from cfdj where recid=rs.recid) and s.status=1;
            insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
          end if;
        end if;  
      elsif rs.isgd=1 then
        --更新cfdj
        update cfdj c set c.status=1,c.sfdb=1 where c.recid=rs.recid;
        if rs.type_id=141 then
         --更新lpfwmx
         update lpfwmx l set l.status=2 where l.recid=rs.recid;
         --更新tbroom
         update tbroom t set t.fwzt=3,t.cfzt=null where t.fwbh in (select fwbh from lpfwmx where recid=rs.recid);
         select count(1) into iCount from cfdj s where s.cfbh =(select cfbh from cfdj where recid=rs.recid) and s.status=1;
         if iCount<>0 then
           update ycfxx_log set SFSSXX=1 where recid=rs.recid;
         elsif iCount=1 then
           select s.recid into iSsrecid from cfdj s where s.cfbh =(select cfbh from cfdj where recid=rs.recid) and s.status=1;
           update tbhousestatestack s set s.stateflag=-1 where s.recid=iSsrecid;
           insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
         end if;
        else
         --更新lpfwmx
         update lpfwmx l set l.status=1 where l.recid=rs.recid;
         --更新tbroom
         update tbroom t set t.fwzt=12,t.cfzt='已查封' where t.fwbh in (select fwbh from lpfwmx where recid=rs.recid); 
         --插入tbhousestatestack
         insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
            select l.fwbh,rs.recid,12,1 from lpfwmx l where l.recid=rs.recid;  
        end if;
        --插入tbkeyref
        insert into tbkeyref(uuid,recid,refuuid,refrecid)
          select a.uuid,rs.recid,b.uuid,b.recid from lpfwmx a,tbroom b where a.fwbh=b.fwbh and a.recid=rs.recid;
      end if;
    end loop;
  elsif l_typeid=8 then
    for rs in (select a.recid,a.isgd,a.type_id from SPFYG_LOG a where a.sjyy is null and a.isgx is null order by a.recid)loop
      --得到上手信息
      if rs.type_id=101 then
        select count(1) into iCount from ysht s where s.htbh=(select y.mmhth from ygxx y where y.recid=rs.recid);
        if iCount=0 then
          update SPFYG_LOG set SSHTXX=1 where recid=rs.recid;
        else
          select s.recid into iSsrecid from ysht s where s.htbh=(select y.mmhth from ygxx y where y.recid=rs.recid);
          insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        end if;
      else
        select count(1) into iCount from cqxx s where s.ygzh=(select y.ygzh from cqxx y where y.recid=rs.recid) and s.recid<>rs.recid;
        if iCount=0 then
          update SPFYG_LOG set ssygxx=1 where recid=rs.recid;
        else
          select s.recid into iSsrecid from cqxx s where s.ygzh=(select y.ygzh from cqxx y where y.recid=rs.recid) and s.recid<>rs.recid;
          insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
        end if;
      end if;
      --插入tbkeyref
      insert into tbkeyref(uuid,recid,refuuid,refrecid)
        select l.uuid,rs.recid,b.uuid,b.recid from lpfwmx l,tbroom b where l.fwbh=b.fwbh and l.recid=rs.recid;
      if rs.isgd=0 then
        update SPFYG_LOG set isgx=1 where recid=rs.recid;
        --更新lpfwmx
        update lpfwmx l set l.status=0 where l.recid=rs.recid;
        if rs.type_id=100 then
          --更新cqxx
          update cqxx c set c.status=0,c.sfdb=0,c.foreshow=0 where c.recid=rs.recid;
          --更新注销登记表
          update ZXDJB z set z.sfdb=0 where z.recid=rs.recid;
        else
          --更新cqxx
          update cqxx c set c.status=0,c.sfdb=0,c.foreshow=1 where c.recid=rs.recid;
        end if;
        if rs.type_id=101 then
          --更新tbroom
          update tbroom b set b.fwzt=7,b.ygzt='正预告' where b.fwbh in (select fwbh from lpfwmx where recid=rs.recid);
        end if;
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
          select l.fwbh,rs.recid,7,0 from lpfwmx l where l.recid=rs.recid;
      elsif rs.isgd=1 then
        if rs.type_id=101 then
          --更新cqxx
          update cqxx c set c.status=1,c.sfdb=1,c.foreshow=1 where c.recid=rs.recid;
          --更新lpfwmx
          update lpfwmx l set l.status=0 where l.recid=rs.recid;
          --插入tbhousestatestack
          insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
            select l.fwbh,rs.recid,7,1 from lpfwmx l where l.recid=rs.recid;
        else
          --更新cqxx
          update cqxx c set c.status=2,c.sfdb=1,c.foreshow=1 where c.ygzh = (select ygzh from cqxx where recid=rs.recid);
          --更新lpfwmx
          update lpfwmx l set l.status=2 where l.recid=rs.recid;
          update lpfwmx l set l.status=2 where l.recid=iSsrecid;
          update tbhousestatestack set stateflag=-1 where recid=iSsrecid;
        end if;
        --更新tbroom
        update tbroom b set b.fwzt=7,b.ygzt='已预告' where b.fwbh in (select fwbh from lpfwmx where recid=rs.recid);
      end if;
    end loop;
  elsif l_typeid=9 then
    for rs in (select s.isgd,s.recid from SPFDYYG_LOG s where s.sjyy is null and s.isgx is null order by s.recid)loop
      update SPFDYYG_LOG set isgx=1 where recid=rs.recid;
      --上手信息
      select count(1) into iCount from cqxx c where c.ygzh = (select syqzh from dyxx where recid=rs.recid) and c.status=1;
      if iCount=0 then
        update SPFDYYG_LOG set ssygxx=1 where recid=rs.recid;
      else
        select c.recid into iSsrecid from cqxx c where c.ygzh = (select syqzh from dyxx where recid=rs.recid) and c.status=1;      
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
      end if;
      --更新lpfwmx
      update lpfwmx l set l.status=0 where l.recid=rs.recid;
      --插入tbkeyref
      insert into tbkeyref(uuid,recid,refuuid,refrecid)
         select l.uuid,rs.recid,t.uuid,t.recid from lpfwmx l,tbroom t where l.fwbh=t.fwbh and l.recid=rs.recid;
      if rs.isgd=0 then
        --更新dyxx
        update dyxx d set d.status=0,d.sfdb=0,d.foreshow=1 where d.recid=rs.recid;
        --更新tbroom
        update tbroom t set t.fwzt=8,t.dyygzt='正抵押预告' where t.recid=rs.recid;
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select l.fwbh,rs.recid,8,0 from lpfwmx l where l.recid=rs.recid;
      else
        --更新dyxx
        update dyxx d set d.status=1,d.sfdb=1,d.foreshow=1 where d.recid=rs.recid;
        --更新tbroom
        update tbroom t set t.fwzt=8,t.dyygzt='已抵押预告' where t.recid=rs.recid;
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select l.fwbh,rs.recid,8,1 from lpfwmx l where l.recid=rs.recid;
      end if;
    end loop;
  elsif l_typeid=10 then
    for rs in (select a.isgd,a.recid from SYQZYYG_LOG a where a.sjyy is null and a.ISGX is null order by a.recid)loop
      --插入tbkeyref
      --select count(1) into iCount from fwzk f where f.fwbh in (select fwbh from fwmx where recid=rs.recid) and f.status=1;
      select count(1) into iCount from cqxx c where c.cqzh =(select s.sscqzh from cqxx s where s.recid=rs.recid) and c.status=1 and c.foreshow=0;
      if iCount=0 then
        update SYQZYYG_LOG a set a.SSFWXX=1 where a.recid=rs.recid;
      else
        select c.recid into iSsrecid from cqxx c where c.cqzh =(select s.sscqzh from cqxx s where s.recid=rs.recid) and c.status=1 and c.foreshow=0;
        for rn in (select f.uuid,f.fwbh from fwmx f where f.recid=rs.recid)loop
          update fwmx f set f.fwzk_uuid=(select d.uuid from fwzk d where d.recid=iSsrecid and d.fwbh=rn.fwbh) where f.recid=rs.recid and f.fwbh=rn.fwbh;
        end loop;
        insert into tbkeyref(uuid,recid,refuuid,refrecid)
          select f.uuid,rs.recid,f.fwzk_uuid,iSsrecid from fwmx f where recid=rs.recid;
        insert into tbrelinst(reldefid,srcrecid,dstrecid,lastmodified)values(0,iSsrecid,rs.recid,sysdate);
      end if;
      --更新fwmx
      update fwmx m set m.status=0 where m.recid=rs.recid;
      if rs.isgd=0 then
        --更新cqxx
        update cqxx c set c.status=0,c.sfdb=0 where c.recid=rs.recid;
        --更新上手fwzk
        update fwzk f set f.zyygzt='正转移预告' where f.fwbh in (select fwbh from  fwmx where recid=rs.recid) and f.status=1;
        --更新tbroom
        update tbroom t set t.fwzt=10,t.zyygzt='正转移预告' where t.fwbh in (select fwbh from fwmx where recid=rs.recid);
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select f.fwbh,rs.recid,10,0 from fwmx f where f.recid=rs.recid; 
      elsif rs.isgd=1 then
        --更新cqxx
        update cqxx c set c.status=1,c.sfdb=1,c.foreshow=1 where c.recid=rs.recid;
        --更新上手fwzk
        update fwzk f set f.zyygzt='已转移预告' where f.fwbh in (select fwbh from  fwmx where recid=rs.recid) and f.status=1;
        --更新tbroom
        update tbroom t set t.fwzt=10,t.zyygzt='已转移预告' where t.fwbh in (select fwbh from fwmx where recid=rs.recid);
        --插入tbhousestatestack
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)
           select f.fwbh,rs.recid,10,1 from fwmx f where f.recid=rs.recid; 
      end if;
    end loop;
  end if;
  commit;
end;
/

