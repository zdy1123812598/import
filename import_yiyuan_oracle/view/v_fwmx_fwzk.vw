create or replace view v_fwmx_fwzk as
select f.uuid uuid,f.recid recid,w.uuid refuuid,w.recid refrecid from fwmx f,fwzk w where f.fwbh=w.fwbh and f.syqzh=w.syqzh;
