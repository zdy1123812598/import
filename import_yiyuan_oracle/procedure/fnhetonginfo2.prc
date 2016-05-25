create or replace procedure fnhetonginfo2(l_bargain_no varchar2,p_recid integer) is
  l_buyman VARCHAR2(100);
  v_count2 integer:=0;
  ssql  varchar(2000);
  l_tempcount integer:=0;
  -----买受人信息
  l_msrlx VARCHAR2(100);
  l_msrlxmc VARCHAR2(100);
  l_gj VARCHAR2(100);
  l_zjlx VARCHAR2(100);
  l_zjhm VARCHAR2(100);
  l_dz VARCHAR2(100);
  l_msryzbm VARCHAR2(100);
  l_lxdh VARCHAR2(100);
  -----共有人信息
  l_gyrxm VARCHAR2(100);
  l_gyrzjlx VARCHAR2(100);
  l_gyrzjhm VARCHAR2(100);
  iCount1 integer;
  --年月日分开的日期
  l_dbtrq VARCHAR2(100);
  ssql1 varchar2(2000);
  i3 varchar2(50);
  iCount integer;
  --2010年5月15日日期处理字段
   v_temp varchar2(100);
   v_length integer;
   v_index1 integer;
   v_index2 integer;
   v_year varchar2(50); 
   v_month varchar2(50); 
   v_day varchar2(50); 
begin
  for ht in (select a.t_name, a.t_value, b.oldname, b.newname, b.type
                 from tbhetongcaoben a, tbhetongdzck b
              where a.t_name = b.oldname
              and nvl(type,0)<>1
              and b.newname is not null
              and a.t_no = l_bargain_no)loop
     if ht.oldname='fj2'then
       update ysht a set a.htzt=1 where a.recid=p_recid;
       else
        update ysht a set a.htzt=2 where a.recid=p_recid;
     end if;
      if ht.oldname='c1_landnumber'then
         if ht.t_value is not null then
           update ysht a set a.dytzlx='土地使用权划拨批准文件号' where a.recid=p_recid;
         end if ;
     end if; 
     
     if ht.type=2 then
       if ht.t_name='c8_paydate' then
         i3 := '%年%';
         ssql1 := 'select count(1) from tbhetongcaoben s where s.t_name='''||ht.t_name||''' and s.t_value like '''||i3||'''  and s.t_no='''||l_bargain_no||'''';
         execute immediate ssql1 into iCount;
         if iCount>0 then    
            v_length  :=length(ht.t_value);
            if v_length>1 then
              v_temp:=substr(ht.t_value,0,v_length-1);
              v_index1:=instr(v_temp,'年');
              v_index2:=instr(v_temp,'月');
              v_year:=substr(v_temp,0,v_index1-1);
              v_month:=lpad(substr(v_temp,v_index1+1,v_index2-1-v_index1),2,0) ;
              v_day:=lpad(substr(v_temp,v_index2+1,v_length-1),2,0) ;             
              v_temp:=v_year||'-'||v_month||'-'||v_day;
              ssql := 'update YSHT set '||ht.newname||'= to_date('''||v_temp||''',''yyyy-mm-dd'') where recid='||p_recid; 
              end if;
           --update baht_log b set b.bs=1 where b.recid=p_recid and b.keycode=l_bargain_no;
           
          else
            if LENGTH(ht.t_value)=10then 
               ssql := 'update YSHT set '||ht.newname||'= to_date('''||ht.t_value||''',''yyyy-mm-dd'') where recid='||p_recid; 
            elsif LENGTH(ht.t_value)=17 then
               ssql := 'update YSHT set '||ht.newname||'= to_date('''||ht.t_value||''',''yyyy-mm-dd hh24:mi:ss'') where recid='||p_recid; 
            end if;
         end if;
       else
         if LENGTH(ht.t_value)=10then 
             ssql := 'update YSHT set '||ht.newname||'= to_date('''||ht.t_value||''',''yyyy-mm-dd'') where recid='||p_recid; 
         elsif LENGTH(ht.t_value)=17 then
             ssql := 'update YSHT set '||ht.newname||'= to_date('''||ht.t_value||''',''yyyy-mm-dd hh24:mi:ss'') where recid='||p_recid; 
         end if;
      end if;
     else
         ssql := 'update YSHT set '||ht.newname||'= '''||ht.t_value||''' where recid='||p_recid;  
     end if;
                
     --dbms_output.put_line(ssql);
     execute immediate ssql;
  end loop;
   update ysht a set a.htlx=1 where a.recid=p_recid;
   update ysht a set a.htbh=l_bargain_no where a.recid=p_recid;
   if l_buyman is not null then
       for fs in (select * From table(fnsplit(l_buyman,'、')) )loop
         v_count2 :=v_count2+1;
         if v_count2=1 then
       --添加至买受人
           select nvl((select count(*) from eisdoc_yy.po_person where keycode=l_bargain_no and  signman=fs.column_value group by num1),0) into l_tempcount from dual;
            if l_tempcount >0 then
              select signtype1,signman,nationality,certtype,certno,address,postalcode,tel  into l_msrlx,l_msrlxmc,l_gj,l_zjlx, l_zjhm,l_dz，l_msryzbm，l_lxdh
                   from eisdoc_yy.po_person
                   where  rowid in(select min(rowid) from eisdoc_yy.po_person where keycode=l_bargain_no and  signman=fs.column_value group by num1); 
              update ysht  
                   set
                     msrlx=l_msrlx,
                     msrlxmc=l_msrlxmc,
                     gj=l_gj,
                     zjlx=l_zjlx, 
                     zjhm=l_zjhm,
                     dz=l_dz,
                     msryzbm=l_msryzbm,
                     lxdh=l_lxdh                
                   where htbh=l_bargain_no; 
              end if;
              else
          -- 添加多余的买受人至共有人
          select count(1) into iCount1 from eisdoc_yy.po_person
              where  rowid in(select min(rowid) from eisdoc_yy.po_person 
                 where keycode=l_bargain_no and  signman=fs.column_value group by num1);
          if iCount1=0 then
              update baht_log s set s.ISGYRSJ=1 where s.recid=p_recid;
          else
              select signman,certtype,certno  into l_gyrxm ,l_gyrzjlx, l_gyrzjhm
                from eisdoc_yy.po_person
                where  rowid in(select min(rowid) from eisdoc_yy.po_person where keycode=l_bargain_no and  signman=fs.column_value group by num1);

              insert into HTGYRXX (RECID,UUID,DISPORDER,GYRXM,GYRZJHM,GYRZJLX) values(p_recid,sys_guid(),0,l_gyrxm,l_gyrzjhm,l_gyrzjlx);       
          end if;   
            end if;
        end loop;
    end if;
    --添加共有人信息
 insert into HTGYRXX (RECID,UUID,DISPORDER,GYRXM,GYRZJHM,GYRZJLX)
         select p_recid,sys_guid(),0,name ,certno,certname from eisdoc_yy.PO_CU_Person a 
                where a. keycode=l_bargain_no  and name is not null; 

  select  trim((select t_value from tbhetongcaoben where t_name='c8_year'and  t_no=l_bargain_no))||'-'||
         trim((select t_value from tbhetongcaoben where t_name='c8_month'and  t_no=l_bargain_no))||'-'||
         trim((select t_value from tbhetongcaoben where t_name='c8_day'and  t_no=l_bargain_no)) strDate
         into l_dbtrq from dual;
  
  if length(l_dbtrq) = 9 then
    update ysht a set dbtrq=to_date(l_dbtrq,'yyyy-mm-dd') where a.recid=p_recid and htbh=l_bargain_no;
  end if;
  --更新tbroom 
  --update tbroom a set a.bazt='已备案',a.bahtbh=l_bargain_no where a.fwbh in (select d.roomcode from ysht c,eisdoc_yy.po_room d where c.htbh=d.bargainno and c.htzt=2 and c.htbh=l_bargain_no); 

  --插入数据到楼盘房屋明细表 lpfwmx 
  insert into lpfwmx (UUID,  RECID , CREATEDATE, FWBH,  DYMJ , TBROOM_UUID)
    select sys_guid(), p_recid, sysdate, a.roomcode, a.b_area, b.uuid
      from eisdoc_yy.po_room a, tbroom b
     where a.roomcode = b.fwbh
       and a.bargainno = l_bargain_no;
      
  COMMIT;
end fnhetonginfo2;
/

