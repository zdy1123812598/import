create or replace procedure fnimptest_cqxx_doc_special_del is
/****************************************************************************************

*****************************************************************************************/

begin
    for rs in(
    select  distinct a.*, t.keycode ,c.ocertno from EISdoc_YY.Operation t,eistran_yy.service a ,EISDOC_YY.OWNER c  where
     t.type_id=a.sercode and t.keycode=c.keycode and t.keycode in (SELECT AA1.KEYCODE FROM  (
SELECT  DISTINCT A.KEYCODE,A.OCERTNO  FROM EISDOC_YY.OWNER A WHERE A.OCERTNO IS NOT NULL ) AA1 GROUP BY AA1.KEYCODE HAVING COUNT(10)>1)   )loop

        delete from tbrec where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from cqxx where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from shd where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from fwzk where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from gyxx where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from tdzk where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from sfxx where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);        
        delete from sfhj where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
        delete from tbrecdoc where recid in (select recid from v_keycoderecid_yy where keycode=rs.keycode);
    
        delete from ZXXX_LOG where keycode = rs.keycode;
        delete from YSXX_LOG where keycode = rs.keycode;
        delete from BGDJ_LOG where keycode = rs.keycode;
        delete from ZYDJ_LOG where keycode = rs.keycode;
        delete from DYXX_LOG where keycode = rs.keycode;
        delete from CFXX_LOG where keycode = rs.keycode;
        delete from YCFXX_LOG where keycode = rs.keycode;
        delete from SPFYG_LOG where keycode = rs.keycode;
        delete from SYQZYYG_LOG where keycode = rs.keycode;
        delete from SPFDYYG_LOG where keycode = rs.keycode;
        delete from CL_LOG where keycode = rs.keycode;
        delete from CQXX_LOG where keycode = rs.keycode;
        delete from BAHT_LOG where keycode = rs.keycode;
        delete from HTCX_LOG where keycode = rs.keycode;
        commit;
  end loop; 
end;
/

