------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy1_0.log
prompt
prompt --����������Ѻ�������
prompt

@\table\temp_dyxx_special.sql;
update eisdoc_yy.mortagage c
   set c.keycode =
       (select aa.keycode
          from (select distinct a.keycode, a.ocertnum
                  from temp_dyxx_special a, eisdoc_yy.Mm_Person b
                 where a.keycode = b.keycode) aa
         where c.ocertnum = aa.ocertnum
           and c.keycode in
               (select distinct a.keycode from temp_dyxx_special a))
 where c.keycode in (select distinct a.keycode from temp_dyxx_special a)
   and exists
 (select 1
          from (select distinct a.keycode, a.ocertnum
                  from temp_dyxx_special a, eisdoc_yy.Mm_Person b
                 where a.keycode = b.keycode) cc
         where c.ocertnum = cc.ocertnum);

commit;

update eisdoc_yy.mortagage c
   set c.logoutkeycode =
       (select aa.logoutkeycode
          from (select distinct a.ocertnum, a.logoutkeycode
                  from temp_dyxx_special a
                 where a.logoutkeycode is not null
                   and rownum = 1) aa
         where c.ocertnum = aa.ocertnum
           and c.keycode in
               (select distinct a.keycode from temp_dyxx_special a))
 where c.keycode in (select distinct a.keycode from temp_dyxx_special a)
   and exists (select 1
          from (select distinct a.ocertnum, a.logoutkeycode
                  from temp_dyxx_special a
                 where a.logoutkeycode is not null) cc
         where c.ocertnum = cc.ocertnum);
commit;

prompt
prompt --ɾ����Ȩ֤��Ϊ�յ�����
prompt

delete from eisdoc_yy.owner where ocertno is null;
commit;

prompt
prompt --����ɾ����Ȩ֤�Ŵ�������
prompt

delete  from EISDOC_YY.OWNER t where t.keycode=201301280096  and t.ocertno='123111123';
commit;

prompt
prompt --���ռ���ԱΪ�յ�����Ϊ����»
prompt

update eistran_yy.operation  set accman = '����»' where accman is null;
update eisdoc_yy.operation  set accman = '����»' where accman is null;
commit;

prompt
prompt --�޸���Դ����Ҫ�����ﲻ�淶���ֶ�
prompt

update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages is null;
update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='1 ';
update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages =' 1';
update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='1`';
update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='��';
update eistran_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='��';
update eistran_yy.IMPORTANT_DOC a set a.pages = 3 where a.pages ='3.';
update eistran_yy.IMPORTANT_DOC a set a.pages = 2 where a.pages =' 2';
update eistran_yy.IMPORTANT_DOC a set a.pages = 2 where a.pages ='��';

update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages is null;
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='1 ';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages =' 1';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='1`';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='��';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 1 where a.pages ='��';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 3 where a.pages ='3.';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 2 where a.pages =' 2';
update eisdoc_yy.IMPORTANT_DOC a set a.pages = 2 where a.pages ='��';
commit;

prompt
prompt --�޸ı���ֶ�
prompt
alter table tbrec enable row movement; 
alter table YSLPXX add y_qh VARCHAR2(400);
alter table YSLPXX add y_zh VARCHAR2(100);
alter table tbrecdoc add y_docid integer;
alter table TBFILE add y_docid integer;
alter table TBFILE add T_RECID integer;
alter table cl_������ add �򷽵绰1 varchar(100);
UPDATE cl_������ SET �򷽵绰1=�򷽵绰;
ALTER TABLE cl_������ DROP COLUMN �򷽵绰;
alter table cl_������  rename column �򷽵绰1 to �򷽵绰;

prompt
prompt --������
prompt

@\table\bgdj_log.tab;
@\table\cqxx_log.tab;
@\table\dyxx_log.tab;
@\table\lpk_wys_log.tab;
@\table\cl_log.tab;
@\table\t_keycode.tab;
@\table\t_keycode_ld.tab;

@\sequence\seqhumancode.seq;
@\sequence\seqhuman.seq;

prompt
prompt --����t_keycode_ld
prompt

declare
begin
 insert into t_keycode_ld(keycode, t_user,TYPEID)
   select a.keycode,'eistran_yy',a.type_id from eistran_yy.operation a where a.accman like  '%¼��%'
   union all
   select a.keycode,'eisdoc_yy',a.type_id from eisdoc_yy.operation a where a.accman like  '%¼��%';
 delete from t_keycode_ld s where s.keycode in (select a.keycode from t_keycode_ld a group by a.keycode having count(1)>1) and s.t_user='eistran_yy';
 commit;
end;
/


prompt
prompt --������Ա��Ϣ
prompt

declare
  l_mid integer;
  y  integer;
begin
   for rt in (select s.username,s.sex from eistran_yy.userpower s where s.username <> '����»' and s.username <> 'admin')loop
     select max(d.humanid) into l_mid from tbhuman d;
     select SEQHUMANCODE.Nextval into y from dual;
     insert into tbhuman(humanid,humanname,gender,status,password,unitid,disporder,cantoncode,humancode)
       values (l_mid+1,rt.username,decode(rt.sex,'��',1,'Ů',0),1,'202cb962ac59075b964b07152d234b70',18,9999,10,10||y);
   end loop;
   commit;
end;
/

declare
  l_mid integer;
  y  integer;
begin
   for rt in (select a.accman  from eisdoc_yy.operation a where a.accman not in (select h.humanname from tbhuman h where 
               h.cantoncode=10) group by a.accman)loop
     select max(d.humanid) into l_mid from tbhuman d;
     select SEQHUMANCODE.Nextval into y from dual;
     insert into tbhuman(humanid,humanname,status,password,unitid,disporder,cantoncode,humancode)
       values (l_mid+1,rt.accman,1,'202cb962ac59075b964b07152d234b70',18,9999,10,10||y);
   end loop;
   commit;
end;
/

prompt
prompt --���뿪����
prompt

declare
  l_unit integer;
  i  integer;
begin
  select max(a.humanid)+10000 into l_unit from tbhuman a;
  i := 1; 
  for rw in(select s.developer_name from eistran_yy.developer s where s.developer_name not in ('�з������Ͳ��г��н����ۺϿ�����˾'))loop
    if i=1 then
      insert into tbunit(unitid,unitname,parentid,disporder,cantoncode)
             values(l_unit,rw.developer_name,1039,9999,10);
    elsif i>1 then
      select max(s.unitid) into l_unit from tbunit s;
      insert into tbunit(unitid,unitname,parentid,disporder,cantoncode)
             values(l_unit+1,rw.developer_name,1039,9999,10);
    end if;
    i := i+1;
  end loop;
  commit;
end;
/


prompt
prompt --���� �з������Ͳ��г��н����ۺϿ�����˾  �˿����̶�Ӧ����Ա��Ϣ
prompt

insert into tbhuman (humanid,humanname,status,password,unitid,disporder,cantoncode,humancode)
  select SEQHUMAN.NEXTVAL,h.developer_man,1,'202cb962ac59075b964b07152d234b70',a.unitid,0,10,h.code from eistran_yy.developer h,tbunit a where h.developer_name=a.unitname and h.developer_name = '�з������Ͳ��г��н����ۺϿ�����˾';
  commit;


prompt
prompt --�������������̶�Ӧ����Ա��Ϣ
prompt

declare
  i integer;
  y integer;
begin
  for rn in(select s.unitid,s.unitname from tbunit s where s.parentid=1039 and s.cantoncode=10)loop
    select SEQHUMAN.NEXTVAL into i from dual;
    select SEQHUMANCODE.Nextval into y from dual;
    insert into tbhuman(humanid,humanname,status,password,unitid,disporder,cantoncode,humancode)
      select i,h.developer_man,1,'202cb962ac59075b964b07152d234b70',rn.unitid,0,10,h.code from eistran_yy.developer h where h.developer_name=rn.unitname;
  end loop;
  commit;
end;
/

prompt
prompt --Ԥ�۵Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sertype='Ԥ����ɵǼ�')loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=5)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --��ʼ�Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass='��ʼ�Ǽ�' and a.sercode<>80)loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode=80)loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=6)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --����Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass='����Ǽ�' and a.sercode not in (5,137))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where  a.sercode in (5,137))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=6)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --ת�ƵǼ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass='ת�ƵǼ�' and a.sercode not in (139,142))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where  a.sercode  in (139,142))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=6)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --��Ѻ�Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass='��Ѻ�Ǽ�' and a.sercode not in (82,83))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --�����Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass='�����Ǽ�')loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --�����Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (36,97))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (140,141))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=2)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --Ԥ��Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (100))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=8)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (49,101))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --Ԥ���Ѻ
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (120))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --��֤
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode in (30,96))loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --��ͬ����
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode=102)loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=5)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --ע���Ǽ�
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.sercode=26)loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=6)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eisdoc_yy';
  end loop;
  commit;
end;
/

prompt
prompt --������
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a WHERE a.sercode=118)loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     WHERE a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     WHERE a.type_id = rs.sercode; 
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt --��֤
prompt

declare
begin
  for rs in (select a.sercode from eistran_yy.service a where a.serclass like '%��֤%')loop
    insert into t_keycode(keycode, t_user,TYPEID)
     select a.keycode,'eistran_yy',rs.sercode
       from eistran_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode and stepno >=7)
      and a.type_id = rs.sercode 
     union all
     select a.keycode,'eisdoc_yy',rs.sercode
       from eisdoc_yy.operation a
     where a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=rs.sercode )
      and a.type_id = rs.sercode 
     union all
     select s.keycode,'eisdoc_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eisdoc_yy'
     union all
     select s.keycode,'eistran_yy',rs.sercode from t_keycode_ld s where s.typeid=rs.sercode and s.t_user='eistran_yy';
     delete from t_keycode s
         where s.keycode in (select a.keycode
                       from t_keycode a
                      where a.typeid = rs.sercode
                      group by a.keycode
                     having count(1) > 1)
      and s.typeid = rs.sercode
      and s.t_user = 'eistran_yy';
  end loop;
  commit;
end;
/

prompt
prompt ----------------------------------------------------------------------------------------------------
prompt �������չ鵵�����
prompt ----------------------------------------------------------------------------------------------------
prompt

create table t_keycode_yy as select distinct keycode,t_user,typeid from t_keycode;
commit;

prompt
prompt ----------------------------------------------------------------------------------------------------
prompt �������ݵ���洢����
prompt ----------------------------------------------------------------------------------------------------
prompt


prompt
prompt --1��¥�̿�
prompt


@\table\lpk_log.tab;
@\view\eisdoc_room.vw;
@\view\eisdoc_wys_room.vw;
@\procedure\fnimptest_insertroom.prc;
@\procedure\fnimptest_insertroom_wysxk.prc;
@\procedure\fnimptest_lpk.prc;
@\procedure\fnimptest_lpk_wysxk.prc;
@\procedure\fnimptest_lpk_tb.prc;

prompt
prompt --2����ͬ
prompt

@\view\V_��ͬ.vw;
@\table\baht_log.tab;
--@\table\tbhetongcaoben.tab;
@\table\tbhetongdzck.tab;
@\procedure\fnhetonginfo.prc;
@\procedure\fnhetonginfosp.prc;
@\procedure\fnhetonginfo2.prc;
@\procedure\fnimptest_baht.prc;

prompt
prompt --3����ʼ
prompt

@\table\tbvices.tab;
@\procedure\fnupdayj.prc;
@\table\resxx_log.tab;
@\table\cfxx_log.tab;
@\table\t_recid.tab;
@\procedure\fnimptest_cqxx.prc;
@\procedure\fnimptest_cqxx_80.prc;
@\procedure\fnimptest_cqxx_bj_doc.prc;
@\procedure\fnimptest_cqxx_bj_doc_80.prc;
@\procedure\fnimptest_cqxx_bj_tran.prc;
@\procedure\fnimptest_cqxx_bj_tran_80.prc;

prompt
prompt --4��ת��
prompt

@\table\zydj_log.tab;
@\procedure\fnimptest_zydj.prc;
@\procedure\fnimptest_zydj_next.prc;
@\procedure\fnimptest_zydj_doc.prc;
@\procedure\fnimptest_zydj_doc_next.prc;
@\procedure\fnimptest_zydj_tran.prc;
@\procedure\fnimptest_zydj_tran_next.prc;

prompt
prompt --5�����
prompt

@\procedure\fnimptest_bgdj.prc;
@\procedure\fnimptest_bgdj_next.prc;
@\procedure\fnimptest_bgxx_bj_tran.prc;
@\procedure\fnimptest_bgxx_bj_tran_next.prc;
@\procedure\fnimptest_bgxx_bj_doc.prc;
@\procedure\fnimptest_bgxx_bj_doc_next.prc;

prompt
prompt --6��ע��
prompt

@\table\zxxx_log.tab;
@\procedure\fnimptest_zxxx.prc;
@\procedure\fnimptest_zxxx_tran.prc;
@\procedure\fnimptest_zxxx_doc.prc;

prompt
prompt --7����Ѻ
prompt

@\procedure\fnimptest_dyxx.prc;
@\procedure\fnimptest_dyxx_bj_tran.prc;
@\procedure\fnimptest_dyxx_bj_doc.prc;

prompt
prompt --8����⡢Ԥ��⡢��⡢Ԥ���
prompt

@\procedure\fnimptest_cfxx.prc;
@\procedure\fnimptest_cfxx_bj_tran.prc;
@\procedure\fnimptest_cfxx_bj_doc.prc;
@\table\ycfxx_log.tab;
@\procedure\fnimptest_ycfxx.prc;
@\procedure\fnimptest_ycfxx_bj_tran.prc;
@\procedure\fnimptest_ycfxx_bj_doc.prc;
@\procedure\fnimptest_jfxx.prc;
@\procedure\fnimptest_jfxx_tran.prc;
@\procedure\fnimptest_jfxx_doc.prc;
@\procedure\fnimptest_yjfxx.prc;
@\procedure\fnimptest_yjfxx_bj_tran.prc;
@\procedure\fnimptest_yjfxx_bj_doc.prc;

prompt
prompt --9����ͬ����
prompt

@\table\htcx_log.tab;
@\procedure\fnimptest_htcx_bj_tran.prc;

prompt
prompt --10��Ԥ���Ԥ���Ѻ
prompt

@\table\t_test.tab;
@\table\spfyg_log.tab;
@\procedure\fnimptest_ygspfygdj.prc;
@\procedure\fnimptest_ygspfygdj_tran.prc;
@\procedure\fnimptest_ygspfygdj_doc.prc;
@\table\syqzyyg_log.tab;
@\procedure\fnimptest_syqzyygdj.prc;
@\procedure\fnimptest_syqzyygdj_tran.prc;
@\procedure\fnimptest_syqzyygdj_doc.prc;
@\table\spfdyyg_log.tab;
@\procedure\fnimptest_ygspfdyygdj.prc;
@\procedure\fnimptest_ygspfdyygdj_tran.prc;
@\procedure\fnimptest_ygspfdyygdj_doc.prc;

prompt
prompt --11��Ԥ��
prompt

@\table\ysxx_log.tab;
@\procedure\fnimptest_ysxx.prc;
@\procedure\fnimptest_ysxx_bj_doc.prc;
@\procedure\fnimptest_ysxx_bj_tran.prc;

commit;

spool off