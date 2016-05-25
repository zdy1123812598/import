create or replace view v_lpfwmx_tbroom as
select l.uuid uuid,l.recid recid,t.uuid refuuid,t.recid refrecid from lpfwmx l,tbroom t where l.fwbh=t.fwbh;
