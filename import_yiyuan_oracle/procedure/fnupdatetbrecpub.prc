create or replace procedure fnupdatetbrecpub is
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
  for rs in (select t.recid from v_keycoderecid_yy t) loop
    
    insert into tbRecPub(RecID,BizName,SubBizName,Creator,Creator_Id,ActDefName,CurPartName)
      select rs.recid, b.Bizname, c.bizname, a.creator, a.creatorid, d.actdefname, d.partname
             from tbRec a, tbBiz b, tbBiz c, tbActInst d
             where a.RecID = d.RecID and a.ProcID = b.BizID and a.subbizid = c.bizid(+)
             and a.RecID = rs.recid 
             and exists (select 1 from tbactinst where recid = a.recid)
             and d.actid = (select max(actid) from tbActInst where recid = rs.recid); 
    insert into tbRecPub_CQCJ(RecID,Slbh) 
      select rs.recid, RecNum from tbRec where RecID = rs.recid;
      
    pkRecPubManager.UpdateRecPubFieldAfterSavePage(rs.recid); 
     
  end loop;
  commit;
end;
/
