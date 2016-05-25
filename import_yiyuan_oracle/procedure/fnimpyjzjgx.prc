create or replace procedure fnimpyjzjgx(p_recid integer,p_ssrecid varchar2) is
/****************************************************************************************

*****************************************************************************************/
 iCount integer;
 l_uuid varchar2(200);
begin
  for rs in (select DOCID,y_docid,docname from tbrecdoc  where recid=p_recid)loop
    for rn in (select s.docid,s.fileid from tbrecdocfile_yy s where s.docid=rs.docid)loop
      --≤Â»ÎTBFILE
      l_uuid := sys_guid();
      insert into TBFILE(FILEID,FILENAME,FILEPATH,LASTUPDATE,CONVERTED,STOREFILENAME,Y_DOCID,t_Recid)
        select l_uuid,b.filename,b.filepath,b.lastupdate,b.converted,b.storefilename,b.y_docid,b.t_recid 
          from tbrecdocfile_yy a,TBFILE_yy b 
        where a.fileid=b.fileid and a.docid=rn.docid and b.fileid=rn.fileid;
      --≤Â»Îtbrecdocfile
      insert into tbrecdocfile(docid,fileid)values(rs.docid,l_uuid);
    end loop;
  end loop;
  commit; 
end;
/
