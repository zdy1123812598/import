-----修正一个KeyCode 对应多个楼盘的情况

insert into EISDOC_YY.OPERATION (KEYCODE, ACC_DATE, TYPE_ID, STATE, ACCMAN, APPMAN, OFFICE, WORKCODE, PRINT_MAN, PRINT_DATE, PO_MAN, PO_DATE, REV_MAN, REV_CODE, ARCHIVES_DATE, ARCHMAN, DISTRICT, SENDTO, SENDTIME, PTTYPE, LIMIT, FORWORD_MAN, FORWORD_TIME, MARK, LOCK1, WORKMAN, STOP_FLAG, APPCELLPHONE, MANUALENTER, MARK1, MARK2, APPIDCNO, APPADDRESS, APPSEX, APPBIRTH, APPNATION, APPORGAN, REGEDITMAN, REGEDITDATE, YSHTNO)
values ('201109070114-1', to_date('07-09-2011 15:59:56', 'dd-mm-yyyy hh24:mi:ss'), 31, '待办', '郑娟', '中房集团淄博市城市建设综合开发公司', null, '2B8C2328-18E7-48A7-A2D7-B9E8CE7C694D', '郑娟', to_date('09-09-2011 13:48:32', 'dd-mm-yyyy hh24:mi:ss'), '郑娟', to_date('06-05-2013 15:29:33', 'dd-mm-yyyy hh24:mi:ss'), '孙凯', '370303197903043118', to_date('19-07-2013 14:34:10', 'dd-mm-yyyy hh24:mi:ss'), '邢科红', '北区', '|邢科红|admin|', to_date('06-05-2013 15:30:05', 'dd-mm-yyyy hh24:mi:ss'), 0, 10, '郑娟', to_date('06-05-2013 15:30:05', 'dd-mm-yyyy hh24:mi:ss'), null, null, '邢科红', 0, null, 0, null, null, null, '张店华光路58号', null, null, null, null, '郑娟', to_date('13-09-2011 10:55:25', 'dd-mm-yyyy hh24:mi:ss'), null);

insert into EISDOC_YY.Presell (KEYCODE, CERTCODE, BUSINESS_CODE, DECLARECO, ITEMNAME, ALLBUILD_NUM, ADDRESS, LAREA, ZAREA, ALLAREA, HOUSE_AREA, OTHER_AREA, ALLSET, HOUSE_SET, OTHER_SET, BANK, BANKNUM, MARK, STREET, PROJECTNO, CONSTRUCTNO, CULCERTNO, ALLINVEST, LANDINVEST, HOUSEINVEST, ORIENT, HOUSEUSE, MONBANK, MONACCOUNT, ISVALID, LOGOUT_DATE, LOGOUT_CAUSE, DEVELOPMENT_LICENCE, DEVELOPER_NAME, C_DATE, W_PROJECTNO)
values ('201109070114-1', '20110093-1', null, 'K000010', '中房翡翠山居F2号楼', 0, '沂源县县城博沂路北侧翡翠山居F5', 133009.3, 0, 3221.44, 2552.8, 668.64, 40, 20, 20, '中国农业银行股份有限公司沂源县支行', '250101040015078', null, null, '建字第37-03-7-201110号', '沂-11017', '地字第37-03-7-201020号', 11000000, 0, 0, '公开出售', '住宅、储藏室', null, null, 1, null, null, '房开证淄开字第20119004号', '中房集团淄博市城市建设综合开发公司', null, null);


update EISDOC_YY.PRESELL_BUILD  a  set  a.keycode='201109070114-1',a.certcode='20110093-1' ,a.build_no='092' where buildcode='13118343543097';

delete FROM   EISDOC_YY.PRESELL_BUILD  b   where   b.keycode='200904230002';

commit;
 create table  EISDOC_YY.Po_Room20151024 as 
 select * from EISDOC_YY.Po_Room a  where  EXISTS (SELECT 1 FROM EISDOC_YY.PRESELL_BUILD B WHERE A.LAND_NO=B.LAND_NO AND A.BUILD_NO=B.BUILD_NO AND A.BUILDCODE<>B.BUILDCODE )
AND A.KEYCODE NOT LIKE 'S%';

 update  EISDOC_YY.Po_Room  a set a.buildcode=(select b.buildcode from EISDOC_YY.PRESELL_BUILD  b where A.LAND_NO=B.LAND_NO AND A.BUILD_NO=B.BUILD_NO
  and rownum=1 and exists (select 1 from EISDOC_YY.Po_Room20151024 c1 where a.roomcode=c1.roomcode  ))
 where a.buildcode is not  null and a.build_no is not null and exists (select 1 from EISDOC_YY.Po_Room20151024 c where a.roomcode=c.roomcode); 
 
 
 update  EISDOC_YY.Po_Room  a set a.buildcode=(select b.buildcode from EISDOC_YY.PRESELL_BUILD  b where A.LAND_NO=B.LAND_NO AND A.BUILD_NO=B.BUILD_NO  )
 where a.buildcode is null and a.build_no is not null;
commit;

update eisdoc_yy.Mo_PERSON a   set a.ocertnum='10-00005559',a.ocertno='10-00018571' where keycode='200911060028';
commit;