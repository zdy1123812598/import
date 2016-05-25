create or replace procedure fnupdateroomstate_yy is
/****************************************************************************************
������Դ����״̬
*****************************************************************************************/
v_fwzt int;--����״̬
v_fwzt_count int;
v_fwzt_ys int;--����Ԥ��״̬
v_fwzt_ys_count int;
v_count_142 int;
v_count_142_dy int;--�Ƿ���ڵ�Ѻ
i_count int;
v_prekeycode varchar2(20) := '-1';--���ְ����ʶ
v_presercode varchar2(20) := '-1';--����ҵ���ʶ
v_pre_recid varchar2(20) := '-1';--����isys�����ʶ

v_cq_pre_recid varchar2(20) := '-1';--���ֲ�Ȩisys�����ʶ

l_total int;
l_cur int :=0;
begin
  delete from tblog_updateroomstate_yy;
  delete from tbprogress_updateroomstate_yy;
  insert into  tbprogress_updateroomstate_yy(msg) values('');
  select count(*) into l_total from tbroom_yy;
  for room in(select fwbh from tbroom_yy )loop
    v_fwzt := -2;
    v_fwzt_ys := -2;
    v_prekeycode := '-1';
    v_presercode := '-1';
    v_pre_recid := '-1';

    v_cq_pre_recid := '-1';
     ---------------------------------------------------------------------------------------------------
     --1 ������Ԥ��״̬
     ---------------------------------------------------------------------------------------------------
     select count(*) into v_fwzt_ys_count from t_roomtran_yy where roomcode=room.fwbh and roomstate is not null and weight=(select max(weight) from  t_roomtran_yy where roomcode=room.fwbh and showforkfs=1);
     if v_fwzt_ys_count>0 then
     select distinct roomstate into v_fwzt_ys from t_roomtran_yy where roomcode=room.fwbh and weight=(select max(weight) from  t_roomtran_yy where roomcode=room.fwbh and showforkfs=1);
      if v_fwzt_ys>-2 then
     --update tbroom set ysfwzt = v_fwzt_ys where fwbh=room.fwbh and ssq = '��Դ��';
     update tbroom set ysfwzt = v_fwzt_ys where fwbh=room.fwbh;
     end if;
     else
       --insert into tblog_updateroomstate_yy(roomcode,msg)values(room.fwbh,'���ݡ�'||room.fwbh||'��û���ҵ�Ԥ��״̬');
       insert into tblog_updateroomstate_yy(roomcode,msg)values(room.fwbh,'Ԥ��');
       update tbroom set ysfwzt = 3 where fwbh=room.fwbh;
     end if;
     ------------------------------------------------------------------------------------------------
     --2 �����·�������״̬
     ------------------------------------------------------------------------------------------------
     select count(*) into v_fwzt_count from t_roomtran_yy where  roomcode=room.fwbh and roomstate is not null;
     if v_fwzt_count>0 then
        select count(*) into v_count_142 from t_roomtran_yy where  roomcode=room.fwbh and sercode=142;     
        if v_count_142>0 then
        --������״̬
        select count(*) into v_count_142_dy from t_mortagage_yy where roomcode=room.fwbh;
        if v_count_142_dy>0 then
           select distinct roomstate into v_fwzt from t_roomtran_yy where roomcode=room.fwbh and weight=(select max(weight) from  t_roomtran_yy where roomcode=room.fwbh and (sercode!=142 or (sercode=142 and weight!=60)));
        else
           select distinct roomstate into v_fwzt from t_roomtran_yy where roomcode=room.fwbh and weight=(select max(weight) from  t_roomtran_yy where roomcode=room.fwbh and (sercode!=142 or (sercode=142 and weight!=130)));
        end if;
      else      
       select distinct roomstate into v_fwzt from t_roomtran_yy where roomcode=room.fwbh and weight=(select max(weight) from  t_roomtran_yy where roomcode=room.fwbh and sercode!=142);
      end if;
     
      if v_fwzt>-2 then
       --update tbroom set fwzt = v_fwzt where fwbh=room.fwbh and ssq = '��Դ��';
       update tbroom set fwzt = v_fwzt where fwbh=room.fwbh;
      end if;
      else
        --insert into tblog_updateroomstate_yy(roomcode,msg)values(room.fwbh,'���ݡ�'||room.fwbh||'��û���ҵ�����״̬');
        insert into tblog_updateroomstate_yy(roomcode,msg)values(room.fwbh,'����');
        update tbroom set fwzt = 3 where fwbh=room.fwbh;
     end if;
     commit;
     ---------------------------------------------------------------------------------------------------
     --3 ����������ת���¶�Ӧ�����״̬
     ---------------------------------------------------------------------------------------------------
     for roomrec in(select * from t_room_operation_biz_recid_yy where roomcode = room.fwbh) loop
       --1 ����������״̬
       fnupdateroomstate_yy_curhand(room.fwbh,roomrec.keycode,roomrec.sercode,roomrec.recid);
       if v_prekeycode != '-1' and v_presercode != '-1'  then         
         --2 ����������״̬
         fnupdateroomstate_yy_prehand(room.fwbh,v_prekeycode,v_pre_recid,v_presercode,roomrec.keycode,roomrec.recid,roomrec.sercode,v_cq_pre_recid);
       end if;
	--�ϸ����������ֵ
       v_prekeycode := roomrec.keycode;
       v_presercode := roomrec.sercode;
       v_pre_recid := roomrec.recid;
	--��Ȩ������ֵ
       select count(1) into i_count from fwzk where recid = roomrec.recid;
       if i_count > 0 then
       v_cq_pre_recid := roomrec.recid;
       end if;
     end loop;
     l_cur := l_cur+1;     
     update  tbprogress_updateroomstate_yy set msg = '�Ѹ���״̬'||l_cur||'�� '||'���ȣ�'||(l_cur/l_total*100)||'%)';
     --delete from tbprogress_updateroomstate_yy;
     --insert into  tbprogress_updateroomstate_yy(msg) values('�Ѹ���״̬'||l_cur||'�� '||'���ȣ�'||(l_cur/l_total*100)||'%)');
     commit;    
  end loop;  
end;
/
