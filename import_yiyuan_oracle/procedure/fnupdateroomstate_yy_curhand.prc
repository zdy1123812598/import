create or replace procedure fnupdateroomstate_yy_curhand(p_roomcode varchar2,p_keycode varchar2,p_sercode integer,p_recid integer) is
v_stateflag int;
v_count int;
begin
  if fniskeycoderegister_yy(p_keycode)>0 then 
    v_stateflag := 1;
  else
    v_stateflag := 0;
  end if;
  --³õÊ¼µÇ¼Ç
  if p_sercode = 3 or p_sercode = 79 or p_sercode = 80 or p_sercode = 129 or p_sercode = 134 then
    
        update cqxx set status = 1  where recid = p_recid;
        update fwzk s set  s.status=decode(v_stateflag,1,1,0),s.djzt=decode(v_stateflag,1,'ÒÑµÇ¼Ç','ÕýµÇ¼Ç') where recid = p_recid and fwbh = p_roomcode;
        update tbroom tb set tb.djzt=decode(v_stateflag,1,'ÒÑµÇ¼Ç','ÕýµÇ¼Ç') where tb.fwbh = p_roomcode;

        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 9;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,9,v_stateflag);
        end if;
   --×¢Ïú×´Ì¬
   elsif  p_sercode = 26  then
        update cqxx set status = 2  where recid = p_recid;
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = -1;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,-1,-1);
        end if;
   --Ô¤¸æ×´Ì¬
   elsif  p_sercode = 101   then
        update cqxx set status = 1  where recid = p_recid;        
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 7;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,7,v_stateflag);
        end if;
   --×ªÒÆÔ¤¸æ×´Ì¬
   elsif  p_sercode = 49  then       
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 10;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,10,v_stateflag);
        end if;
   --µÖÑºÔ¤¸æ×´Ì¬
   elsif  p_sercode = 119 or p_sercode = 120  then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 8;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,10,v_stateflag);
        end if;  
   elsif  p_sercode = 121  then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 13;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,13,v_stateflag);
        end if;
   --µÖÑº×´Ì¬
   elsif p_sercode = 20 or p_sercode = 84 or p_sercode = 85 or p_sercode = 128 then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 11;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,11,v_stateflag);
        end if;
   --×î¸ß¶îµÖÑº×´Ì¬
   elsif p_sercode = 125 or p_sercode = 126 or p_sercode = 127  then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 11;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,11,v_stateflag);
        end if;
   --×ªÒÆ×´Ì¬
   elsif  p_sercode = 7 or p_sercode = 18 or p_sercode = 104 or p_sercode = 106 
     or p_sercode = 107 or p_sercode = 108 or p_sercode = 109 or p_sercode = 110 
     or p_sercode = 111 or p_sercode = 112 or p_sercode = 113 or p_sercode = 114 
     or p_sercode = 115 or p_sercode = 116 or p_sercode = 117 or p_sercode = 130 
     or p_sercode = 131 or p_sercode = 132 or p_sercode = 133 or p_sercode = 136 
     or p_sercode = 138 or p_sercode = 139 or p_sercode = 142 or p_sercode = 46 
     or p_sercode = 135 or p_sercode = 5 or p_sercode = 6 or p_sercode = 124 or p_sercode = 137 or p_sercode = 75  then
        update fwzk s set  s.status=decode(v_stateflag,1,1,0),s.djzt=decode(v_stateflag,1,'ÒÑµÇ¼Ç','ÕýµÇ¼Ç') where recid = p_recid and fwbh = p_roomcode;
        update cqxx set status=decode(v_stateflag,1,1,1)  where recid = p_recid;
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 9;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,9,v_stateflag);
        end if;
        
        if v_stateflag = 1 then
           update fwzk set status=1 where recid = p_recid and fwbh = p_roomcode;
        else 
           update fwzk set status=0 where recid = p_recid and fwbh = p_roomcode;
        end if;
   --×âÁÞ×´Ì¬
   elsif  p_sercode = 58  or p_sercode = 33 then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 15;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,15,v_stateflag);
        end if;
   --²é·â×´Ì¬
   elsif  p_sercode = 36  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 12;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,12,v_stateflag);
        end if;
   elsif  p_sercode = 97  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 12;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,12,v_stateflag);
        end if;
   elsif  p_sercode = 140  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 12;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,12,v_stateflag);
        end if;
   elsif  p_sercode = 141  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 12;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,12,v_stateflag);
        end if;
   --ÒìÒé×´Ì¬
   elsif  p_sercode = 47  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 14;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,14,v_stateflag);
        end if;
   elsif  p_sercode = 99  then
       select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 14;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,14,v_stateflag);
        end if;
   --±¸°¸×´Ì¬
   elsif  p_sercode = 32  then
        select count(*) into v_count from tbhousestatestack where fwbh = p_roomcode and recid = p_recid and housestateid = 6;
        if  v_count = 0 then
        insert into tbhousestatestack(fwbh,recid,housestateid,stateflag)values(p_roomcode,p_recid,6,v_stateflag);
        end if;
  end if;
  end;
/
