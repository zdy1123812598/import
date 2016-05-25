create or replace procedure fnimptest_cl is
/****************************************************************************************
  36-----------2698  查封
  140----------2698  预查封
  97-----------2699  解封
  141----------2699  预解封
  select * from CFDJ a where a.recid=10957902;
  select * from fwmx a where a.recid=10957902;
  select * from tbhousestatestack a where a.fwbh='22245';
  select * from tbkeyref a where a.recid=10957902;
  select * from fwzk a where a.fwbh='22245';
  select * from tbroom a where a.fwbh='22245';
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1  INTEGER;
  l_stepno  integer;
  iROLEID   integer;
  iActdefid integer;
  ai_bargainid integer;
  iCqzh varchar2(200);
begin
  iActdefid := 3388;
  iROLEID := 10224;
  for rs in(select a.keycode from t_keycode_yy a where a.typeid=118 )loop
    iCqzh := null;
    select SEQ_备案ID.nextval into ai_bargainid from dual;
    insert into CL_LOG(RECID, KEYCODE, Type_Id,ISGD,LX)values(ai_bargainid,rs.keycode,118,1,'存量房');
    select COUNT(1) INTO iCount1 from eisdoc_yy.po_records s where s.keycode=rs.keycode and rownum=1;
    IF iCount1>0 THEN
      select s.ocertno INTO iCqzh from eisdoc_yy.po_records s where s.keycode=rs.keycode and rownum=1;
      insert into cl_备案表(备案id,房产证号,合同编号,提交时间,价格,业务编号,是否多卖,买方地址,
                            买方证件名称,买方证件号码,买方姓名,买方电话,买方邮编,卖方姓名,status)
      select ai_bargainid,s.ocertno,s.bargainno,s.buydate,s.hvalue,s.keycode,0,d.address,1,d.certno,
             d.buyperson,d.tel,d.postalcode,d.sellperson,1
         from eisdoc_yy.po_records s,eisdoc_yy.po_person d
      where s.keycode=d.keycode and s.keycode=rs.keycode and rownum=1;
      select count(1) into iCount FROM cqxx  WHERE cqzh=iCqzh;
      if iCount>0 then
        update fwzk set clfbazt='已备案' where recid in (select recid FROM cqxx  WHERE cqzh=iCqzh) ;
      end if;
    END IF;
  end loop;
  commit;
end;
/
