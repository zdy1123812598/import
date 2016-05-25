-----����һ��KeyCode ��Ӧ���¥�̵����

insert into EISDOC_YY.OPERATION (KEYCODE, ACC_DATE, TYPE_ID, STATE, ACCMAN, APPMAN, OFFICE, WORKCODE, PRINT_MAN, PRINT_DATE, PO_MAN, PO_DATE, REV_MAN, REV_CODE, ARCHIVES_DATE, ARCHMAN, DISTRICT, SENDTO, SENDTIME, PTTYPE, LIMIT, FORWORD_MAN, FORWORD_TIME, MARK, LOCK1, WORKMAN, STOP_FLAG, APPCELLPHONE, MANUALENTER, MARK1, MARK2, APPIDCNO, APPADDRESS, APPSEX, APPBIRTH, APPNATION, APPORGAN, REGEDITMAN, REGEDITDATE, YSHTNO)
values ('201109070114-1', to_date('07-09-2011 15:59:56', 'dd-mm-yyyy hh24:mi:ss'), 31, '����', '֣��', '�з������Ͳ��г��н����ۺϿ�����˾', null, '2B8C2328-18E7-48A7-A2D7-B9E8CE7C694D', '֣��', to_date('09-09-2011 13:48:32', 'dd-mm-yyyy hh24:mi:ss'), '֣��', to_date('06-05-2013 15:29:33', 'dd-mm-yyyy hh24:mi:ss'), '�￭', '370303197903043118', to_date('19-07-2013 14:34:10', 'dd-mm-yyyy hh24:mi:ss'), '�Ͽƺ�', '����', '|�Ͽƺ�|admin|', to_date('06-05-2013 15:30:05', 'dd-mm-yyyy hh24:mi:ss'), 0, 10, '֣��', to_date('06-05-2013 15:30:05', 'dd-mm-yyyy hh24:mi:ss'), null, null, '�Ͽƺ�', 0, null, 0, null, null, null, '�ŵ껪��·58��', null, null, null, null, '֣��', to_date('13-09-2011 10:55:25', 'dd-mm-yyyy hh24:mi:ss'), null);

insert into EISDOC_YY.Presell (KEYCODE, CERTCODE, BUSINESS_CODE, DECLARECO, ITEMNAME, ALLBUILD_NUM, ADDRESS, LAREA, ZAREA, ALLAREA, HOUSE_AREA, OTHER_AREA, ALLSET, HOUSE_SET, OTHER_SET, BANK, BANKNUM, MARK, STREET, PROJECTNO, CONSTRUCTNO, CULCERTNO, ALLINVEST, LANDINVEST, HOUSEINVEST, ORIENT, HOUSEUSE, MONBANK, MONACCOUNT, ISVALID, LOGOUT_DATE, LOGOUT_CAUSE, DEVELOPMENT_LICENCE, DEVELOPER_NAME, C_DATE, W_PROJECTNO)
values ('201109070114-1', '20110093-1', null, 'K000010', '�з����ɽ��F2��¥', 0, '��Դ���سǲ���·�������ɽ��F5', 133009.3, 0, 3221.44, 2552.8, 668.64, 40, 20, 20, '�й�ũҵ���йɷ����޹�˾��Դ��֧��', '250101040015078', null, null, '���ֵ�37-03-7-201110��', '��-11017', '���ֵ�37-03-7-201020��', 11000000, 0, 0, '��������', 'סլ��������', null, null, 1, null, null, '����֤�Ϳ��ֵ�20119004��', '�з������Ͳ��г��н����ۺϿ�����˾', null, null);


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