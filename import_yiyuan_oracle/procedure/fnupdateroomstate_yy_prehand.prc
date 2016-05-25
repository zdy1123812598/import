create or replace procedure fnupdateroomstate_yy_prehand(p_roomcode varchar2,p_prekeycode varchar2,p_pre_recid varchar2,p_presercode integer,p_curkeycode varchar2,p_cur_recid varchar2,p_cursercode integer,p_cq_pre_recid varchar2) is
v_uuid char(32);
v_uuid_count int;
v_refuuid char(32);
v_refuuid_count int;
v_partzt varchar2(10);
v_stateflag int;
v_relinst_count int;
v_keyref_count int;
iCount integer;
iCount1 integer;
iCount2 integer;
iCount3 integer;
begin
  if fniskeycoderegister_yy(p_curkeycode)>0 then 
    v_partzt := '已';
    v_stateflag := 1;
  else
    v_partzt := '正';
    v_stateflag := 0;
  end if;

  ---------------------------------------------------------------------------------------
  --更新房屋各种状态
  ---------------------------------------------------------------------------------------
   --注销状态
   if  p_cursercode = 26  then
       if p_cq_pre_recid <> '-1' then

		update fwzk set zxzt = v_partzt||'注销',status = 2 where recid = p_cq_pre_recid and fwbh = p_roomcode;
		update tbroom set zxzt = v_partzt||'注销' where fwbh = p_roomcode;
		if v_partzt='已' then
		  update tbhousestatestack s set  s.stateflag = -1 where recid = p_cq_pre_recid and fwbh = p_roomcode;
		end if;
		select count(1) into iCount2 from fwzk a,cqxx b where a.recid = b.recid and b.recid = p_cq_pre_recid and a.zxzt<>'已注销';
		if iCount2 > 0 then
		  update cqxx set status= 1  where recid = p_cq_pre_recid;
		else
		  update cqxx set status= 2  where recid = p_cq_pre_recid;
		end if;
       end if;

   --预告状态
   elsif  p_cursercode = 101   then
        update fwzk set ygzt = v_partzt||'预告' where recid = p_pre_recid and fwbh = p_roomcode;
        update tbroom set ygzt = v_partzt||'预告' where fwbh = p_roomcode;
        if v_partzt='已' then
          update tbhousestatestack s set  s.stateflag = -1 where recid = p_pre_recid and fwbh = p_roomcode;
        end if;
   elsif  p_cursercode = 100   then
        update cqxx set status=decode(v_stateflag,1,2,1)  where recid = p_pre_recid;
        update fwzk set ygzt = null where recid = p_pre_recid and fwbh = p_roomcode;
        update tbroom set ygzt = null where fwbh = p_roomcode;
        if v_partzt='已' then
          update tbhousestatestack s set  s.stateflag = -1 where recid = p_pre_recid and fwbh = p_roomcode;
        end if;
   --转移预告状态
   elsif  p_cursercode = 49  then       
        update fwzk set ygzt = v_partzt||'预告' where recid = p_pre_recid and fwbh = p_roomcode;       
        update fwzk set zyygzt = v_partzt||'转移预告' where recid = p_pre_recid and fwbh = p_roomcode;
        
        update tbroom set ygzt = v_partzt||'预告' where fwbh = p_roomcode;
        update tbroom set zyygzt = v_partzt||'转移预告' where fwbh = p_roomcode;

   --抵押预告状态
   elsif  p_cursercode = 119 or p_cursercode = 120  then
        update fwzk set ygzt = v_partzt||'预告' where recid = p_pre_recid and fwbh = p_roomcode;
        update fwzk set dyygzt = v_partzt||'抵押预告' where recid = p_pre_recid and fwbh = p_roomcode;
        
        update tbroom set ygzt = v_partzt||'预告' where fwbh = p_roomcode;
        update tbroom set dyygzt = v_partzt||'抵押预告' where fwbh = p_roomcode;

   elsif  p_cursercode = 121  then
        update fwzk set ygzt = v_partzt||'预告' where recid = p_pre_recid and fwbh = p_roomcode;
        update fwzk set zjgcdyzt = v_partzt||'抵押预告' where recid = p_pre_recid and fwbh = p_roomcode;
        
        update tbroom set ygzt = v_partzt||'预告' where fwbh = p_roomcode;
        update tbroom set zjgcdyzt = v_partzt||'抵押预告' where fwbh = p_roomcode;
 
   --抵押状态
   elsif p_cursercode = 20 or p_cursercode = 84 or p_cursercode = 85 or p_cursercode = 128 then
	 if p_cq_pre_recid <> '-1' then
	         update fwzk set dyzt = v_partzt||'抵押' where recid = p_cq_pre_recid and fwbh = p_roomcode;		
	 end if;
         update tbroom set dyzt = v_partzt||'抵押' where fwbh = p_roomcode;
   elsif  p_cursercode = 86 then
	for rs in(select s.recid from eisdoc_yy.mortagage t,t_keycoderecid_yy s where t.keycode = s.keycode and t.logoutkeycode = p_curkeycode and t.logoutkeycode is not null)
        loop
	 update fwzk set dyzt = null where recid = rs.recid and fwbh = p_roomcode;
	end loop;	
        update tbroom set dyzt = null where fwbh = p_roomcode;
        if v_partzt='已' then
          update tbhousestatestack s set  s.stateflag = -1 where recid = p_pre_recid and fwbh = p_roomcode and housestateid = 11;
        end if;
   --最高额抵押状态
   elsif p_cursercode = 125 or p_cursercode = 126 or p_cursercode = 127  then
    if p_cq_pre_recid <> '-1' then

            update fwzk set dyzt = v_partzt||'抵押' where recid = p_cq_pre_recid and fwbh = p_roomcode;
        update fwzk set zgedyzt = v_partzt||'最高额抵押' where recid = p_cq_pre_recid and fwbh = p_roomcode;
        
        update tbroom set dyzt = v_partzt||'抵押' where fwbh = p_roomcode;
        update tbroom set zgedyzt = v_partzt||'最高额抵押' where fwbh = p_roomcode;
    end if;

   --转移状态
   elsif  p_cursercode = 7 or p_cursercode = 18 or p_cursercode = 104 or p_cursercode = 106 
     or p_cursercode = 107 or p_cursercode = 108 or p_cursercode = 109 or p_cursercode = 110 
     or p_cursercode = 111 or p_cursercode = 112 or p_cursercode = 113 or p_cursercode = 114 
     or p_cursercode = 115 or p_cursercode = 116 or p_cursercode = 117 or p_cursercode = 130 
     or p_cursercode = 131 or p_cursercode = 132 or p_cursercode = 133 or p_cursercode = 136 
     or p_cursercode = 138 or p_cursercode = 139 or p_cursercode = 142 or p_cursercode = 46 
     or p_cursercode = 135 or p_cursercode = 5 or p_cursercode = 6 or p_cursercode = 124 or p_cursercode = 137 or p_cursercode = 75 then        
        
	if p_cq_pre_recid <> '-1' then
		update fwzk set zyzt = v_partzt||'转移',status = decode(v_stateflag,1,2,1) where recid = p_cq_pre_recid and fwbh = p_roomcode;
		update tbroom set zyzt = decode(v_partzt,'已',null,v_partzt||'转移') where fwbh = p_roomcode;
		if v_partzt='已' then
		  update tbhousestatestack s set  s.stateflag = -1 where recid = p_cq_pre_recid and fwbh = p_roomcode and housestateid = 9;
		end if;
		select count(1) into iCount3 from fwzk a,cqxx b where a.recid = b.recid and b.recid = p_cq_pre_recid and a.zyzt<>'已转移';
		if iCount3 > 0 then
		  update cqxx set status= 1  where recid = p_cq_pre_recid;
		else
		  update cqxx set status= 2  where recid = p_cq_pre_recid;
		end if;
	end if;

   --租赁状态
   elsif  p_cursercode = 58  or p_cursercode = 33 then
        update fwzk set zlzt = v_partzt||'租赁' where recid = p_pre_recid and fwbh = p_roomcode;
        update tbroom set zlzt = v_partzt||'租赁' where fwbh = p_roomcode;

   --查封状态
   elsif  p_cursercode = 36  then
	if p_cq_pre_recid <> '-1' then
	        update fwzk set cfzt = v_partzt||'查封' where recid = p_cq_pre_recid and fwbh = p_roomcode;		
	end if;
	update tbroom set cfzt = v_partzt||'查封' where fwbh = p_roomcode;
   elsif  p_cursercode = 97  then   
	for rs in(select s.recid from eisdoc_yy.freeze t,t_keycoderecid_yy s where t.keycode = s.keycode and t.logoutkeycode = p_curkeycode and t.logoutkeycode is not null)
        loop
	  update fwzk set cfzt = decode(v_partzt,'已',null,v_partzt||'解封') where recid = rs.recid and fwbh = p_roomcode;  
	end loop;
	update tbroom set cfzt = decode(v_partzt,'已',null,v_partzt||'解封') where fwbh = p_roomcode;
   elsif  p_cursercode = 140  then
	if p_cq_pre_recid <> '-1' then
	   update fwzk set cfzt = v_partzt||'查封' where recid = p_cq_pre_recid and fwbh = p_roomcode;
	end if;
        update tbroom set cfzt = v_partzt||'查封' where fwbh = p_roomcode;

   elsif  p_cursercode = 141  then
   	for rs in(select s.recid from eisdoc_yy.freeze t,t_keycoderecid_yy s where t.keycode = s.keycode and t.logoutkeycode = p_curkeycode and t.logoutkeycode is not null)
        loop
	    update fwzk set cfzt = decode(v_partzt,'已',null,v_partzt||'解封') where recid = rs.recid and fwbh = p_roomcode;
	end loop;
	update tbroom set cfzt = decode(v_partzt,'已',null,v_partzt||'解封') where fwbh = p_roomcode;

   --异议状态
   elsif  p_cursercode = 47  then
      if p_cq_pre_recid <> '-1' then
              update fwzk set yyzt = v_partzt||'异议' where recid = p_cq_pre_recid and fwbh = p_roomcode;
      end if;
      update tbroom set yyzt = v_partzt||'异议' where fwbh = p_roomcode;
        
   elsif  p_cursercode = 99  then
     if p_cq_pre_recid <> '-1' then
              update fwzk set yyzt = null where recid = p_pre_recid and fwbh = p_roomcode;
     end if;
     update tbroom set yyzt = null where fwbh = p_roomcode;
        
   --备案状态
   elsif  p_cursercode = 32  then
        update tbroom set bazt = v_partzt||'备案' where fwbh = p_roomcode;

   elsif  p_cursercode = 102  then
        update tbroom set bazt =null where fwbh = p_roomcode;
	update ysht set htzt = 3 where recid = p_pre_recid;
        if v_partzt='已' then
          update tbhousestatestack s set  s.stateflag = -1 where recid = p_pre_recid and fwbh = p_roomcode and housestateid = 6;
        end if;
   --遗失状态
   elsif  p_cursercode = 44  then
        update fwzk set yszt = v_partzt||'遗失' where recid = p_pre_recid and fwbh = p_roomcode;
        update tbroom set yszt = v_partzt||'遗失' where fwbh = p_roomcode;

   elsif  p_cursercode = 95  then
        update fwzk set yszt = null where recid = p_pre_recid and fwbh = p_roomcode;
        update tbroom set yszt =null where fwbh = p_roomcode;

  end if;
  end;
/
