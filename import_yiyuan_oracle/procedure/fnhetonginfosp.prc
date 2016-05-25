create or replace procedure fnhetonginfosp(l_bargain_no varchar2,p_recid integer) is
  l_buyman VARCHAR2(100);
  v_count2 integer:=0;
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
begin
   update ysht a set a.htlx=1, a.htzt=2 where a.recid=p_recid;
   update ysht a set a.htbh=l_bargain_no where a.recid=p_recid;
   select buyperson into l_buyman from eisdoc_yy.po_person where keycode=l_bargain_no and rownum=1;
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

  --更新tbroom 
  --update tbroom a set a.bazt='已备案',a.bahtbh=l_bargain_no,a.fwzt=6 where a.fwbh in (select d.roomcode from ysht c,eisdoc_yy.po_room d where c.htbh=d.bargainno and c.htzt=2 and c.htbh=l_bargain_no); 

  --插入数据到楼盘房屋明细表 lpfwmx 
  insert into lpfwmx (UUID,  RECID , CREATEDATE, FWBH,  DYMJ , TBROOM_UUID)
    select sys_guid(), p_recid, sysdate, a.roomcode, a.b_area, b.uuid
      from eisdoc_yy.po_room a, tbroom b
     where a.roomcode = b.fwbh
       and a.bargainno = l_bargain_no;      

  COMMIT;  
end fnhetonginfosp;
/

