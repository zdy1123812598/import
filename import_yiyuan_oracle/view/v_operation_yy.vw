create or replace view v_operation_yy as
select distinct keycode,acc_date,type_id from(
select s.keycode,s.acc_date,s.type_id from eisdoc_yy.operation s union
select t.keycode,t.acc_date,t.type_id from eistran_yy.operation t where  not exists (select * from eisdoc_yy.operation where keycode=t.keycode));