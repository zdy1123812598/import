EXPLAIN PLAN FOR ALTER INDEX eisdoc_yy.I_DOC_OPERATION REBUILD ONLINE;
EXPLAIN PLAN FOR ALTER INDEX eistran_yy.I_TRAN_OPERATION REBUILD ONLINE;

--FWZK----------------------------

EXPLAIN PLAN FOR ALTER INDEX ISYS_FWZK_FWBH REBUILD ONLINE;
EXPLAIN PLAN FOR ALTER INDEX ISYS_INDEX REBUILD ONLINE;

--TBHOUSESTATESTACK-----------------------------------------------------

create index i_tbhousestatestack_fwbh on TBHOUSESTATESTACK (fwbh) online; 
EXPLAIN PLAN FOR ALTER INDEX TBHOUSESTATESTACK_PRY REBUILD ONLINE;
--CQXX-------------------------------------------------------------------

EXPLAIN PLAN FOR ALTER INDEX SYS_C0073630 REBUILD ONLINE;

--TBROOM------------------------------------------------------------------------
EXPLAIN PLAN FOR ALTER INDEX TBROOM_FWBH_IDX REBUILD ONLINE;

--FREEZE-------------------------------------------------------------------------------
-- Create/Recreate indexes 
create index EISDOC_YY.I_DOC_FREEZE_LOGOUTKEYCODE on EISDOC_YY.FREEZE (LOGOUTKEYCODE)
  tablespace EISDOC_YY
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

--MORTAGAGE------------------------------------------------------------------------------------------

-- Create/Recreate indexes 
create index EISDOC_YY.I_DOC_MORTAGAGE_LOGOUTKEYCODE on EISDOC_YY.MORTAGAGE (LOGOUTKEYCODE)
  tablespace EISDOC_YY
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );