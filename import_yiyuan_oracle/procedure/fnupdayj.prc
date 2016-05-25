create or replace procedure fnupdayj(p_recid integer,l_keycode varchar2) is
/****************************************************************************************

*****************************************************************************************/
 iCount integer;
 l_uuid varchar2(200);
begin
  for rs in (select DOCID,y_docid,docname from tbrecdoc  where recid=p_recid)loop
    select count(1) into iCount from eisfiles_yy.tbvices a where a.docid=rs.y_docid;
    if iCount>0 then
      for rn in (select a.docid,a.filename,a.id,a.keycode,a.status,a.disporder from eisfiles_yy.tbvices a where a.keycode = l_keycode and a.docid = rs.y_docid and a.status=0)loop
        l_uuid := sys_guid();
        insert into TBFILE(FILEID,FILENAME,FILEPATH,LASTUPDATE,CONVERTED,STOREFILENAME,Y_DOCID,t_recid)
          values(l_uuid,rn.filename,'/ImpDoc/yyyj/DocFiles_'||substr(l_keycode,1,6),sysdate,0,rn.disporder||'_'||rn.id||'_'||rn.filename,rs.y_docid,p_recid);
       insert into tbrecdocfile(docid,fileid)values(rs.docid,l_uuid);
      end loop;
    end if;
  end loop;
  commit;
end;
/
