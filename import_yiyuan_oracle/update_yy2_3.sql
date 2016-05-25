------------------------------------------------------
-- 沂源数据导库脚本20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy2_3.log

prompt
prompt --1、反写FWZK
prompt

update fwzk a set a.syqzh = (select b.cqzh from cqxx b where a.recid=b.recid) where a.recid >= (select min(recid) from v_keycoderecid_yy);
commit;

update fwzk a set a.status = (select decode(b.state,0,1,2) from eisdoc_yy.owner b where b.roomcode=a.fwbh and b.ocertno = a.syqzh) where a.recid >= (select min(recid) from v_keycoderecid_yy) AND EXISTS (SELECT 1 FROM  eisdoc_yy.owner b1 where b1.roomcode=a.fwbh and b1.ocertno = a.syqzh);
commit;

update fwzk a set a.status =0  where a.recid >= (select min(recid) from v_keycoderecid_yy)  AND A.SYQZH IS NULL;
commit;

prompt
prompt --2、反写TBKEYREF
prompt

DELETE FROM tbkeyref A  WHERE a.recid>=(select min(recid) from v_keycoderecid_yy);
commit;

insert into tbkeyref
select  a.uuid,a.recid,b.uuid,b.recid  from  fwmx a ,fwzk b where a.fwbh=b.fwbh and a.syqzh=b.syqzh and a.recid>=(select min(recid) from v_keycoderecid_yy);
commit;

insert into tbkeyref
select  a.uuid,a.recid,b.uuid,b.recid  from  lpfwmx a ,tbroom b where a.fwbh=b.fwbh  and a.recid>=(select min(recid) from v_keycoderecid_yy);
commit;

prompt
prompt --3、反写TBRELINST
prompt

delete from tbrelinst where srcrecid>=(select min(recid) from v_keycoderecid_yy);
commit;

insert into tbrelinst
  (srcrecid, dstrecid)
  select distinct srcrecid, dstrecid
    from (
          --产权
          select bb.recid srcrecid, aa.recid dstrecid
            from (select a.*, b.fwbh
                     from cqxx a, fwzk b
                    where a.recid = b.recid
                      and a.cqzh is not null
                      and a.recid >= (select min(recid) from v_keycoderecid_yy)) aa,
                  (select a.*, b.fwbh
                     from cqxx a, fwzk b
                    where a.recid = b.recid
                      and a.cqzh is not null
                      and a.recid >= (select min(recid) from v_keycoderecid_yy)) bb
           where aa.sscqzh = bb.cqzh
             and aa.fwbh = bb.fwbh
          union
          --抵押,有证查封
          select a.recid srcrecid, b.recid dstrecid
            from cqxx a, fwmx b
           where a.cqzh = b.syqzh
             and a.cqzh is not null
             and b.recid in
                 (select recid from tbrec where subbizid in (2505, 2646, 2698))
             and a.recid >= (select min(recid) from v_keycoderecid_yy)
          union
          --抵押注销
          select a.recid srcrecid, b.recid dstrecid
            from dyxx a, v_keycoderecid_yy b
           where to_char(a.zxyy) = b.keycode
             and a.recid in
                 (select recid from tbrec where subbizid in (2710, 2711))
             and a.zxyy is not null);
commit;

prompt
prompt --4、反写XMXX
prompt

update xmxx a set a.status = 1 where a.recid>=(select min(recid) from v_keycoderecid_yy);
commit;

prompt
prompt --5、反写TBHOUSESTATESTACK
prompt

update fwmx set status=2 where uuid in (
 select b.uuid from  dyxx a,fwmx b ,EISDOC_YY.MORTAGAGE c where a.recid=b.recid  and  a.slbh=c.keycode and c.roomcode=b.fwbh and b.status<>decode(c.lo_flag,0,1,2)
 and c.lo_flag=1); 
commit;

DELETE FROM TBHOUSESTATESTACK  WHERE  RECID IN (SELECT  DISTINCT B.RECID  FROM  eisdoc_yy.mortagage A ,DYXX B WHERE A.KEYCODE=B.SLBH );
commit;

INSERT INTO TBHOUSESTATESTACK
  SELECT A1.FWBH,A1.RECID,11,1  FROM FWMX A1  WHERE A1.RECID IN (
SELECT  DISTINCT B.RECID  FROM  eisdoc_yy.mortagage A ,DYXX B WHERE A.KEYCODE=B.SLBH )   AND A1.STATUS=1;
commit;

INSERT INTO TBHOUSESTATESTACK
  SELECT A1.FWBH,A1.RECID,11,-1  FROM FWMX A1  WHERE A1.RECID IN (
SELECT  DISTINCT B.RECID  FROM  eisdoc_yy.mortagage A ,DYXX B WHERE A.KEYCODE=B.SLBH )   AND A1.STATUS=2;
commit;

DELETE FROM  TBHOUSESTATESTACK   WHERE RECID IN (
SELECT  DISTINCT B.RECID  FROM  eisdoc_yy.mortagage A ,DYXX B WHERE A.LOGOUTKEYCODE=B.SLBH AND A.LOGOUTKEYCODE IS  NOT  NULL );
commit;
 
 update  tbroom  set  dyzt=null,fwzt=9 where fwbh in (
select  t.fwbh  from tbroom  t WHERE  t.fwbh  in (
select roomcode  from EISDOC_YY.MORTAGAGE t  where t.lo_flag=1
 and not exists (select roomcode  from EISDOC_YY.MORTAGAGE a where  a.lo_flag=0 and  a.roomcode=t.roomcode ))) and fwzt=11;
commit;
 
  update  fwzk  set  dyzt=null    where fwbh in (
select roomcode  from EISDOC_YY.MORTAGAGE t  where t.lo_flag=1
 and not exists (select roomcode  from EISDOC_YY.MORTAGAGE a where  a.lo_flag=0 and  a.roomcode=t.roomcode )) ;
commit;

update  CFDJ  a set  a.status=2 where recid in (select  A.RECID   from EISDOC_YY.FREEZE t, cfdj a   where  a.slbh=t.logoutkeycode and t.logoutkeycode is not null);
commit;

update  fwmx  a set  a.status=2 where recid in (select  A.RECID   from EISDOC_YY.FREEZE t, cfdj a   where  a.slbh=t.logoutkeycode and t.logoutkeycode is not null);
commit;

delete  tbhousestatestack a where  exists (select 1 from 
 (select distinct  recid , fwbh  from (
select  a.recid ,b.fwbh  from cfdj a,fwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy)  union 
select   a.recid ,b.fwbh  from cfdj a,lpfwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy) )) aa1 where aa1.recid=a.recid and aa1.fwbh=a.fwbh);
commit;

insert into   tbhousestatestack a 
 select fwbh ,recid ,12,1 from 
 (select distinct  recid , fwbh  from (
select  a.recid ,b.fwbh  from cfdj a,fwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy)  and b.status=1 union 
select   a.recid ,b.fwbh  from cfdj a,lpfwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy) and b.status=1 )) aa1;
commit;

insert into   tbhousestatestack a 
 select fwbh ,recid ,12,-1 from 
 (select distinct  recid , fwbh  from (
select  a.recid ,b.fwbh  from cfdj a,fwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy)  and b.status=2 union 
select   a.recid ,b.fwbh  from cfdj a,lpfwmx b where a.recid=b.recid  and a.recid>=(select min(recid) from v_keycoderecid_yy) and b.status=2 )) aa1;
commit;

prompt
prompt --6、反写合同
prompt
  
update ysht
   set htzt = 1
 where htbh in (select b.bargainno
                  from eisdoc_yy.po_records b
                 where b.isauditing = 0
                   and b.bargainno is not null)
   and recid >= (select min(recid) from v_keycoderecid_yy);
commit;

update ysht
   set htzt = 3
 where htbh in (select b.bargainno
                  from eisdoc_yy.po_records b
                 where b.logoutkeycode is not null
                   and b.bargainno is not null)
   and recid >= (select min(recid) from v_keycoderecid_yy);
commit;

update tbroom a
   set (bazt, bahtbh, ysfwzt) =
       (select '已备案', b.htbh, 6
          from lpfwmx c, ysht b
         where c.recid = b.recid
           and b.recid >= (select min(recid) from v_keycoderecid_yy)
           and a.fwbh = c.fwbh
           and b.htzt = 2
           and rownum = 1)
 where recid >= (select min(recid) from v_keycoderecid_yy)
   and exists
 (select 1
          from lpfwmx c1, ysht b1
         where c1.recid = b1.recid
           and b1.recid >= (select min(recid) from v_keycoderecid_yy)
           and a.fwbh = c1.fwbh
           and b1.htzt = 2);
commit;  

update tbroom a
   set (bazt, bahtbh, ysfwzt) =
       (select null, null, 5
          from lpfwmx c, ysht b
         where c.recid = b.recid
           and b.recid >= (select min(recid) from v_keycoderecid_yy)
           and a.fwbh = c.fwbh
           and b.htzt = 1
           and rownum = 1)
 where recid >= (select min(recid) from v_keycoderecid_yy)
   and exists
 (select 1
          from lpfwmx c1, ysht b1
         where c1.recid = b1.recid
           and b1.recid >= (select min(recid) from v_keycoderecid_yy)
           and a.fwbh = c1.fwbh
           and b1.htzt = 1);
commit;
  
delete from tbhousestatestack a where a.recid >= (select min(recid) from v_keycoderecid_yy) and a.housestateid=6 ;
commit;

  insert into tbhousestatestack
  select distinct c.fwbh, c.recid, 6, 1
    from lpfwmx c, ysht b
   where c.recid = b.recid
     and b.recid >= (select min(recid) from v_keycoderecid_yy)
     and b.htzt = 2;
commit;
   
 insert into tbhousestatestack
  select distinct c.fwbh, c.recid, 6, -1
    from lpfwmx c, ysht b
   where c.recid = b.recid
     and b.recid >= (select min(recid) from v_keycoderecid_yy)
     and b.htzt = 3;
commit;
 
insert into tbhousestatestack
  select distinct c.fwbh, c.recid, 5, 0
    from lpfwmx c, ysht b
   where c.recid = b.recid
     and b.recid >= (select min(recid) from v_keycoderecid_yy)
     and b.htzt = 1;
commit;
  
DELETE from tbhousestatestack a
 WHERE FWBH IN
       (SELECT A.FWBH
          FROM TBROOM A
         WHERE A.recid >= (select min(recid) from v_keycoderecid_yy))
   and A.HOUSESTATEID = 3;
commit;
     
INSERT INTO tbhousestatestack A
  SELECT A.FWBH, 0, 3, 1
    FROM TBROOM A
   WHERE A.recid >= (select min(recid) from v_keycoderecid_yy);
commit;   
   
DELETE  FROM HTSHYJB WHERE RECID>=(select min(recid) from v_keycoderecid_yy);
commit;
   
INSERT INTO HTSHYJB
  select DISTINCT a.recid, 1, NULL, NULL, b.passdate, a.htbh
    from ysht a, eisdoc_yy.po_records b
   where a.htbh = b.bargainno
     and a.recid >= (select min(recid) from v_keycoderecid_yy)
     and a.htzt > 1
     and htbh NOT like 'S%'
     AND B.KEYCODE NOT IN ('201109090024', '201411210046');
commit;

INSERT INTO HTSHYJB
  select a.recid, 1, NULL, NULL, b.passdate, a.htbh
    from ysht a, eisdoc_yy.po_records b
   where a.htbh = b.bargainno
     and a.recid >= (select min(recid) from v_keycoderecid_yy)
     and a.htzt = 2
     and htbh NOT like 'S%'
     AND B.KEYCODE IN ('201411210046')
     AND ROWNUM = 1;
commit;
   
INSERT INTO HTSHYJB
  select a.recid, 1, NULL, NULL, b.passdate, a.htbh
    from ysht a, eisdoc_yy.po_records b
   where a.htbh = b.bargainno
     and a.recid >= (select min(recid) from v_keycoderecid_yy)
     and a.htzt = 2
     and htbh NOT like 'S%'
     AND B.KEYCODE IN ('201109090024')
     AND ROWNUM = 1;
commit;
   
INSERT INTO HTSHYJB
  select DISTINCT a.recid, 0, NULL, NULL, b.passdate, a.htbh
    from ysht a, eisdoc_yy.po_records b
   where a.htbh = b.bargainno
     and a.recid >= (select min(recid) from v_keycoderecid_yy)
     and a.htzt = 1
     and htbh NOT like 'S%';
commit;
   
INSERT INTO HTCX
  (RECID, CXZT, CXBH, HTBH)
  select DISTINCT a.recid, 1, b.LOGOUTKEYCODE, a.htbh
    from ysht a, eisdoc_yy.po_records b
   where a.htbh = b.bargainno
     and a.recid >= (select min(recid) from v_keycoderecid_yy)
     and a.htzt = 3
     and htbh NOT like 'S%';
commit;

prompt
prompt --7、反写预告与预抵押
prompt

UPDATE LPFWMX
   SET STATUS = 1
 WHERE RECID IN (SELECT B.RECID
                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                  WHERE A.KEYCODE = B.SLBH
                    AND A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 120));
commit;
 
UPDATE DYXX
   SET STATUS = 1
 WHERE RECID IN (SELECT B.RECID
                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                  WHERE A.KEYCODE = B.SLBH
                    AND A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 120));
commit;
 
UPDATE LPFWMX
   SET STATUS = 2
 WHERE RECID IN (SELECT b.RECID
                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                  WHERE A.KEYCODE = B.SLBH
                    AND A.FREE_FLAG = 1
                    AND A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 120));
commit;
 
UPDATE DYXX
   SET STATUS = 2
 WHERE RECID IN (SELECT B.RECID
                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                  WHERE A.KEYCODE = B.SLBH
                    AND A.FREE_FLAG = 1
                    AND A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 120));
commit; 
 
DELETE FROM TBHOUSESTATESTACK
 WHERE RECID IN (SELECT B.RECID
                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                  WHERE A.KEYCODE = B.SLBH
                    AND A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 120));
commit;
 
insert into tbhousestatestack
  select distinct fwbh, recid, 8, 1
    from lpfwmx
   where status = 1
     and recid in (select b.recid
                     FROM EISDOC_YY.PREDECLARE A, DYXX B
                    WHERE A.KEYCODE IN (SELECT KEYCODE
                                          FROM EISTRAN_YY.OPERATION B
                                         WHERE B.TYPE_ID = 120)
                      AND A.KEYCODE = B.SLBH);
commit;
 
insert into tbhousestatestack
  select distinct fwbh, recid, 8, -1
    from lpfwmx
   where status = 2
     and recid in (select b.recid
                     FROM EISDOC_YY.PREDECLARE A, DYXX B
                    WHERE A.KEYCODE IN (SELECT KEYCODE
                                          FROM EISTRAN_YY.OPERATION B
                                         WHERE B.TYPE_ID = 120)
                      AND A.KEYCODE = B.SLBH);
commit;
 
UPDATE TBROOM A
   SET A.Dyygzt = '已抵押预告'
 where fwbh in (select distinct fwbh
                  from lpfwmx
                 where status = 1
                   and recid in (select b.recid
                                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                                  WHERE A.KEYCODE IN
                                        (SELECT KEYCODE
                                           FROM EISTRAN_YY.OPERATION B
                                          WHERE B.TYPE_ID = 120)
                                    AND A.KEYCODE = B.SLBH));
commit; 
  
UPDATE TBROOM A
   SET A.Dyygzt = null
 where fwbh in (select distinct fwbh
                  from lpfwmx
                 where status = 2
                   and recid in (select b.recid
                                   FROM EISDOC_YY.PREDECLARE A, DYXX B
                                  WHERE A.KEYCODE IN
                                        (SELECT KEYCODE
                                           FROM EISTRAN_YY.OPERATION B
                                          WHERE B.TYPE_ID = 120)
                                    AND A.KEYCODE = B.SLBH));
commit; 
  
update lpfwmx
   set status = 1
 where recid in (select b.recid
                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                  WHERE A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 101)
                    AND A.KEYCODE = B.SLBH);
commit; 
 
update lpfwmx
   set status = 2
 where recid in (select b.recid
                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                  WHERE A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 101)
                    AND A.KEYCODE = B.SLBH
                    and a.free_flag = 1);
commit;
 
update CQXX
   set status = 1
 where recid in (select b.recid
                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                  WHERE A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 101)
                    AND A.KEYCODE = B.SLBH);
commit;
 
update CQXX
   set status = 2
 where recid in (select b.recid
                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                  WHERE A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 101)
                    AND A.KEYCODE = B.SLBH
                    and a.free_flag = 1);
commit; 
 
delete from tbhousestatestack
 where recid in (select b.recid
                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                  WHERE A.KEYCODE IN (SELECT KEYCODE
                                        FROM EISTRAN_YY.OPERATION B
                                       WHERE B.TYPE_ID = 101)
                    AND A.KEYCODE = B.SLBH);
commit;  
 
insert into tbhousestatestack
  select distinct fwbh, recid, 7, 1
    from lpfwmx
   where status = 1
     and recid in (select b.recid
                     FROM EISDOC_YY.PREDECLARE A, CQXX B
                    WHERE A.KEYCODE IN (SELECT KEYCODE
                                          FROM EISTRAN_YY.OPERATION B
                                         WHERE B.TYPE_ID = 101)
                      AND A.KEYCODE = B.SLBH);
commit;

insert into tbhousestatestack
  select distinct fwbh, recid, 7, -1
    from lpfwmx
   where status = 2
     and recid in (select b.recid
                     FROM EISDOC_YY.PREDECLARE A, CQXX B
                    WHERE A.KEYCODE IN (SELECT KEYCODE
                                          FROM EISTRAN_YY.OPERATION B
                                         WHERE B.TYPE_ID = 101)
                      AND A.KEYCODE = B.SLBH);
commit; 
 
UPDATE TBROOM A
   SET A.ygzt = '已预告'
 where fwbh in (select distinct fwbh
                  from lpfwmx
                 where status = 1
                   and recid in (select b.recid
                                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                                  WHERE A.KEYCODE IN
                                        (SELECT KEYCODE
                                           FROM EISTRAN_YY.OPERATION B
                                          WHERE B.TYPE_ID = 101)
                                    AND A.KEYCODE = B.SLBH));
commit;
 
UPDATE TBROOM A
   SET A.ygzt = null
 where fwbh in (select distinct fwbh
                  from lpfwmx
                 where status = 2
                   and recid in (select b.recid
                                   FROM EISDOC_YY.PREDECLARE A, CQXX B
                                  WHERE A.KEYCODE IN
                                        (SELECT KEYCODE
                                           FROM EISTRAN_YY.OPERATION B
                                          WHERE B.TYPE_ID = 101)
                                    AND A.KEYCODE = B.SLBH));
commit; 

prompt
prompt --8、反写抵押查封
prompt


update fwmx
   set status = 2
 where uuid in (select b.uuid
                  from dyxx a, fwmx b, EISDOC_YY.MORTAGAGE c
                 where a.recid = b.recid
                   and a.slbh = c.keycode
                   and c.roomcode = b.fwbh
                   and b.status <> decode(c.lo_flag, 0, 1, 2)
                   and c.lo_flag = 1);
commit; 

DELETE FROM TBHOUSESTATESTACK
 WHERE RECID IN (SELECT DISTINCT B.RECID
                   FROM eisdoc_yy.mortagage A, DYXX B
                  WHERE A.KEYCODE = B.SLBH);
commit;

INSERT INTO TBHOUSESTATESTACK
  SELECT A1.FWBH, A1.RECID, 11, 1
    FROM FWMX A1
   WHERE A1.RECID IN (SELECT DISTINCT B.RECID
                        FROM eisdoc_yy.mortagage A, DYXX B
                       WHERE A.KEYCODE = B.SLBH)
     AND A1.STATUS = 1;
commit;

INSERT INTO TBHOUSESTATESTACK
  SELECT A1.FWBH, A1.RECID, 11, -1
    FROM FWMX A1
   WHERE A1.RECID IN (SELECT DISTINCT B.RECID
                        FROM eisdoc_yy.mortagage A, DYXX B
                       WHERE A.KEYCODE = B.SLBH)
     AND A1.STATUS = 2;
commit;

DELETE FROM TBHOUSESTATESTACK
 WHERE RECID IN (SELECT DISTINCT B.RECID
                   FROM eisdoc_yy.mortagage A, DYXX B
                  WHERE A.LOGOUTKEYCODE = B.SLBH
                    AND A.LOGOUTKEYCODE IS NOT NULL);
commit;
 
update tbroom
   set dyzt = null, fwzt = 9
 where fwbh in
       (select t.fwbh
          from tbroom t
         WHERE t.fwbh in (select roomcode
                            from EISDOC_YY.MORTAGAGE t
                           where t.lo_flag = 1
                             and not exists
                           (select roomcode
                                    from EISDOC_YY.MORTAGAGE a
                                   where a.lo_flag = 0
                                     and a.roomcode = t.roomcode)))
   and fwzt = 11;
commit;
 
update fwzk
   set dyzt = null
 where fwbh in
       (select t.fwbh
          from tbroom t
         WHERE t.fwbh in (select roomcode
                            from EISDOC_YY.MORTAGAGE t
                           where t.lo_flag = 1
                             and not exists
                           (select roomcode
                                    from EISDOC_YY.MORTAGAGE a
                                   where a.lo_flag = 0
                                     and a.roomcode = t.roomcode)));
commit;

update tbroom t
   set t.dyzt = '已抵押'
 WHERE t.fwbh in
       (select roomcode from EISDOC_YY.MORTAGAGE t where t.lo_flag = 0)
   and t.dyzt is null;
commit; 

update fwzk t
   set t.dyzt = '已抵押'
 WHERE t.fwbh in
       (select roomcode from EISDOC_YY.MORTAGAGE t where t.lo_flag = 0)
   and t.dyzt is null
   and status = 1;
commit;

update CFDJ a
   set a.status = 2
 where recid in (select A.RECID
                   from EISDOC_YY.FREEZE t, cfdj a
                  where a.slbh = t.logoutkeycode
                    and t.logoutkeycode is not null);
commit;

update fwmx a
   set a.status = 2
 where recid in (select A.RECID
                   from EISDOC_YY.FREEZE t, cfdj a
                  where a.slbh = t.logoutkeycode
                    and t.logoutkeycode is not null);
commit;

delete tbhousestatestack a
 where exists (select 1
          from (select distinct recid, fwbh
                  from (select a.recid, b.fwbh
                          from cfdj a, fwmx b
                         where a.recid = b.recid
                           and a.recid >=
                               (select min(recid) from v_keycoderecid_yy)
                        union
                        select a.recid, b.fwbh
                          from cfdj a, lpfwmx b
                         where a.recid = b.recid
                           and a.recid >=
                               (select min(recid) from v_keycoderecid_yy))) aa1
         where aa1.recid = a.recid
           and aa1.fwbh = a.fwbh);
commit;

insert into tbhousestatestack a
  select fwbh, recid, 12, 1
    from (select distinct recid, fwbh
            from (select a.recid, b.fwbh
                    from cfdj a, fwmx b
                   where a.recid = b.recid
                     and a.recid >=
                         (select min(recid) from v_keycoderecid_yy)
                     and b.status = 1
                  union
                  select a.recid, b.fwbh
                    from cfdj a, lpfwmx b
                   where a.recid = b.recid
                     and a.recid >=
                         (select min(recid) from v_keycoderecid_yy)
                     and b.status = 1)) aa1;
commit;

insert into tbhousestatestack a
  select fwbh, recid, 12, -1
    from (select distinct recid, fwbh
            from (select a.recid, b.fwbh
                    from cfdj a, fwmx b
                   where a.recid = b.recid
                     and a.recid >=
                         (select min(recid) from v_keycoderecid_yy)
                     and b.status = 2
                  union
                  select a.recid, b.fwbh
                    from cfdj a, lpfwmx b
                   where a.recid = b.recid
                     and a.recid >=
                         (select min(recid) from v_keycoderecid_yy)
                     and b.status = 2)) aa1;
commit;
 
update tbroom b
   set b.cfzt = null, fwzt = '9', ysfwzt = '6'
 where fwbh in
       (select distinct roomcode
          from EISDOC_YY.freeze t
         where t.free_flag = 1
           and not exists (select roomcode
                  from EISDOC_YY.freeze a
                 where a.free_flag = 0
                   and a.roomcode = t.roomcode));
commit;  
  
update fwzk b
   set b.cfzt = null
 where fwbh in
       (select distinct roomcode
          from EISDOC_YY.freeze t
         where t.free_flag = 1
           and not exists (select roomcode
                  from EISDOC_YY.freeze a
                 where a.free_flag = 0
                   and a.roomcode = t.roomcode));
commit;
 
update fwzk b
   set cfzt = '已查封'
 where fwbh in (select distinct roomcode
                  from EISDOC_YY.freeze t
                 where t.free_flag = 0)
   and b.status = 1
   and cfzt is null;
commit;
 
update tbroom b
   set cfzt = '已查封'
 where fwbh in (select distinct roomcode
                  from EISDOC_YY.freeze t
                 where t.free_flag = 0)
   and cfzt is null;
commit;

spool off