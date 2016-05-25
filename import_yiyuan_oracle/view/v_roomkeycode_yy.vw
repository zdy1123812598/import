create or replace force view v_roomkeycode_yy as
select distinct roomcode,keycode from(
select s.roomcode,s.keycode from eisdoc_yy.link_operation s union
select t.roomcode,t.keycode from eistran_yy.link_operation t);

