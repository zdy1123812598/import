------------------------------------------------------
-- ��Դ���ݵ���ű�20150702                      --
-- Created by Dcx on 2015-07-02, 18:36:34 --
------------------------------------------------------
set define off
spool update_yy2_2.log

prompt
prompt --1�����¿�����ҵ��Ϣ��Ϳ�����ҵ����Ա��Ϣ��
prompt


@\table\kfqy_log.tab;
@\procedure\fnupdatekfqy.prc;
@\procedure\fnupdatetbrecpub.prc;
commit;


EXEC fnupdatekfqy;
EXEC fnupdatetbrecpub;

commit;

spool off