create or replace procedure fnupdatekfqy is
/****************************************************************************************

*****************************************************************************************/
  iMg integer;
  l_recid integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  l_humancode integer;
begin

--插入中房集团淄博市城市建设综合开发公司的企业管理员信息
  select a.recid into l_recid from kfqyxx a where a.qymc = '中房集团淄博市城市建设综合开发公司';
  insert into kfsglyxx(uuid,recid,createdate,ryxm,mm,dlm,STATUS,humanid)
                      select sys_guid(),
                             l_recid,
                             sysdate,
                             b.humanname,
                             '202cb962ac59075b964b07152d234b70',
                             b.humancode,
                             1,
                             b.humanid
                      from tbhuman b where b.humancode = 'K000010';
--插入其他开发企业的企业信息和企业管理员信息
  for rs in(
    select * from tbunit t,eistran_yy.developer s where t.unitname = s.developer_name and s.developer_name not in ('中房集团淄博市城市建设综合开发公司')
    )loop
      img := pkworkflow.startWorkflow(2589,496,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into KFQY_LOG(RECID, MSG,ISGD)values(iRecid,v_msg,0);
     else
       insert into kfqyxx (recid, status, qyxz, frdb, jjxz, qymc, zcdz, unitid)
                          values( iRecid,1,'开发企业',rs.developer_man,'有限责任公司',rs.unitname,rs.developer_add,rs.unitid);
       insert into kfsglyxx (uuid, recid, createdate, ryxm, mm, dlm, status, humanid)
                            select sys_guid(),
                                   iRecid,
                                   sysdate,
                                   rs.developer_man,
                                   '202cb962ac59075b964b07152d234b70',
                                   t.humancode,
                                   1,
                                   t.humanid
                            from tbhuman t where t.humanname = rs.developer_man and t.unitid = rs.unitid;
     end if;
  end loop;
  commit;
end;
/
