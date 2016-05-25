create index EISTRAN_YY.I_TRAN_IMPORTANTDOC on EISTRAN_YY.IMPORTANT_DOC (KEYCODE)
  tablespace EISTRAN_YY
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

create index EISDOC_YY.I_DOC_IMPORTANTDOC on EISDOC_YY.IMPORTANT_DOC (KEYCODE)
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

create index EISFILES_YY.I_TBVICES_KEYCODE on EISFILES_YY.TBVICES (KEYCODE)
  tablespace EISFILES_YY
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

create index EISFILES_YY.I_TBVICES_DOCID on EISFILES_YY.TBVICES (DOCID)
  tablespace EISFILES_YY
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

create index EISDOC_YY.I_DOC_OPERATION on EISDOC_YY.OPERATION (KEYCODE)
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

  create index EISTRAN_YY.I_TRAN_OPERATION on EISTRAN_YY.OPERATION (KEYCODE)
  tablespace EISTRAN_YY
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

create index I_HTCB_NAME on TBHETONGCAOBEN (T_NAME)
  tablespace ISYS
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

create index I_HTCB_NO on TBHETONGCAOBEN (T_NO)
  tablespace ISYS
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

create index EISDOC_YY.KEYCODE_DOC on EISDOC_YY.LINK_OPERATION (KEYCODE)
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

create index EISDOC_YY.ROOMCODE_DOC on EISDOC_YY.LINK_OPERATION (ROOMCODE)
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

create index EISTRAN_YY.KEYCODE_TRAN on EISTRAN_YY.LINK_OPERATION (KEYCODE)
  tablespace EISTRAN_YY
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

create index EISTRAN_YY.ROOMCODE_TRAN on EISTRAN_YY.LINK_OPERATION (ROOMCODE)
  tablespace EISTRAN_YY
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

----------------------------------------------------------------------------------
--执行完倒数据后 再执行
create unique index I_T_KEYCODE_YY on T_KEYCODE_YY (KEYCODE)
  tablespace ISYS
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

--t_roomtran_yy Create/Recreate indexes 
create index I_ROOMTRAN_ROOMCODE on T_ROOMTRAN_YY (ROOMCODE)
  tablespace ISYS
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
create index I_ROOMTRAN_ROOMSTATE on T_ROOMTRAN_YY (ROOMSTATE)
  tablespace ISYS
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
create index I_ROOMTRAN_WEIGHT on T_ROOMTRAN_YY (WEIGHT)
  tablespace ISYS
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


--t_mortagage_yy Create/Recreate indexes 
create index I_MORTAGGE_ROOMCODE on T_MORTAGAGE_YY (ROOMCODE)
  tablespace ISYS
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

--t_keycoderecid_yy Create/Recreate indexes 
create index I_KEYCODERECID_KEYCODE on T_KEYCODERECID_YY (KEYCODE)
  tablespace ISYS
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
create index I_KEYCODERECID_RECID on T_KEYCODERECID_YY (RECID)
  tablespace ISYS
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

-- t_room_operation_biz_yy Create/Recreate indexes 
create index I_ROONOPBIZ_KEYCODE on T_ROOM_OPERATION_BIZ_YY (KEYCODE)
  tablespace ISYS
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

-------------------------------------------------------------------------------------------
create index I_FWZK_RECID on FWZK (RECID)
  tablespace ISYS
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
