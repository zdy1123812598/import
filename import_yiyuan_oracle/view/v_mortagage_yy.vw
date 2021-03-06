create or replace force view v_mortagage_yy as
select distinct "KEYCODE","OCERTNUM","ROOMCODE","KIND","O_CERTNO","O_NAME","PART","LAND_AREA","LAND_VALUE","ALL_AREA","HOUSE_AREA","HOUSE_VALUE","START_DATE","END_DATE","EVAL_VALUE","RATE","RIGHT_VALUE","PACT_CODE","SET_DATE","LIMIT_DATE","LO_DATE","LO_FLAG","P_MONEY","LO_CAUSE","MIND","SERIALNO","PREOCERTNUM","LOGOUTKEYCODE","O_CERTNOEX" from  (select * from eistran_yy.mortagage union
select * from eisdoc_yy.mortagage);

