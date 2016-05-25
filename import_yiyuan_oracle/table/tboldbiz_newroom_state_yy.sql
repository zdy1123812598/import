create table TBOLDBIZ_NEWROOM_STATE_YY
(
  sercode    VARCHAR2(15) not null,
  serclass   VARCHAR2(20),
  sertype    VARCHAR2(50),
  roomstate  INTEGER,
  weight     INTEGER,
  showforkfs INTEGER
);
comment on column TBOLDBIZ_NEWROOM_STATE_YY.roomstate
  is '房屋状态';
comment on column TBOLDBIZ_NEWROOM_STATE_YY.weight
  is '权重';
comment on column TBOLDBIZ_NEWROOM_STATE_YY.showforkfs
  is '是否开发商显示';

insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('3', '初始登记', '商品房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('5', '变更登记', '更名', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('6', '变更登记', '自然状况', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('7', '转移登记', '二手房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('18', '转移登记', '拆迁', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('20', '抵押登记', '私产', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('26', '注销登记', '注销登记', -1, -1, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('27', '补证登记', '私产', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('30', '换证登记', '单位产', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('31', '预售许可登记', '预售许可登记', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('32', '预售备案登记', '预售备案登记', 6, 50, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('33', '租赁登记', '房屋租赁', 15, 80, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('36', '司法协助', '查封', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('39', '查档登记', '查档登记', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('44', '挂失登记', '挂失', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('46', '更正登记', '所有权更正', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('47', '异议登记', '异议登记', 14, 150, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('49', '预告登记', '所有权转让预告', 10, 100, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('56', '查档登记', '借档登记', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('58', '租赁登记', '无证房租赁', 15, 80, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('62', '地役权登记', '地役权设定', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('75', '变更登记', '分割', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('76', '补证登记', '单位产', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('77', '补证登记', '产权证补打', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('79', '初始登记', '个人建房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('80', '初始登记', '单位建房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('82', '抵押登记', '预购商品房', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('83', '抵押登记', '在建工程', 13, 70, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('84', '抵押登记', '单位产', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('85', '抵押登记', '抵押变更', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('86', '抵押登记', '注销抵押', -1, -1, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('88', '地役权登记', '地役权注销', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('89', '地役权登记', '地役权变更', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('90', '地役权登记', '地役权转移', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('91', '更正登记', '抵押权更正', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('92', '更正登记', '地役权更正', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('93', '更正登记', '预告登记更正', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('94', '更正登记', '查封登记更正', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('95', '挂失登记', '挂失解除', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('96', '换证登记', '私产', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('97', '司法协助', '解封', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('99', '异议登记', '异议注销', 14, 150, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('100', '预告登记', '预告注销', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('101', '预告登记', '预购商品房预告', 7, 90, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('102', '预售备案登记', '预售备案注销', 3, 25, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('103', '预售许可登记', '撤销预售许可', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('104', '转移登记', '划拨', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('106', '转移登记', '分割', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('107', '转移登记', '合并', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('108', '转移登记', '司法裁决', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('109', '转移登记', '房产入股', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('110', '转移登记', '房改房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('111', '转移登记', '继承', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('112', '转移登记', '赠与', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('113', '转移登记', '新建商品房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('114', '转移登记', '单位产', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('115', '转移登记', '交换', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('116', '转移登记', '房改房上市', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('117', '转移登记', '经济适用房上市', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('118', '存量房备案登记', '存量房备案登记', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('119', '预告登记', '房屋设定抵押权预告', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('120', '预告登记', '预购商品房设定抵押权预告', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('121', '预告登记', '在建工程设定抵押权预告', 13, 70, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('124', '变更登记', '门牌号', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('125', '抵押登记', '最高额抵押', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('126', '抵押登记', '最高额抵押变更', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('127', '抵押登记', '最高额抵押转移', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('128', '抵押登记', '抵押转移', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('129', '初始登记', '经济适用房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('130', '转移登记', '二手房无原产权', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('131', '转移登记', '经济适用房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('132', '转移登记', '离婚', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('133', '转移登记', '经济适用房无原产权', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('134', '初始登记', '集体土地建房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('135', '更正登记', '自然状况更正', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('136', '转移登记', '无原房拆迁', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('137', '变更登记', '合并', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('138', '转移登记', '有原产权房改房', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('139', '转移登记', '房改房过渡', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('140', '司法协助', '预查封', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('141', '司法协助', '预解封', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('142', '转移登记', '按揭转现', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('142', '转移登记', '按揭转现', 11, 130, 0);
commit;