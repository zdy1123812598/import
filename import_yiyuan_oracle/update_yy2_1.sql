------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy2_1.log

prompt
prompt --1�����·��������ֹ�ϵ�ͷ���״̬
prompt

EXEC fnupdateroomstate_yy;

update ysht set fzzt=1 where recid in(select   a.recid from ysht a,tbroom  b, fwzk c ,cqxx d 
where a.htbh= b.bahtbh  and b.fwbh=c.fwbh and  c.recid=d.recid and length(d.cqr)<5);

commit;

spool off