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
  is '����״̬';
comment on column TBOLDBIZ_NEWROOM_STATE_YY.weight
  is 'Ȩ��';
comment on column TBOLDBIZ_NEWROOM_STATE_YY.showforkfs
  is '�Ƿ񿪷�����ʾ';

insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('3', '��ʼ�Ǽ�', '��Ʒ��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('5', '����Ǽ�', '����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('6', '����Ǽ�', '��Ȼ״��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('7', 'ת�ƵǼ�', '���ַ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('18', 'ת�ƵǼ�', '��Ǩ', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('20', '��Ѻ�Ǽ�', '˽��', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('26', 'ע���Ǽ�', 'ע���Ǽ�', -1, -1, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('27', '��֤�Ǽ�', '˽��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('30', '��֤�Ǽ�', '��λ��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('31', 'Ԥ����ɵǼ�', 'Ԥ����ɵǼ�', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('32', 'Ԥ�۱����Ǽ�', 'Ԥ�۱����Ǽ�', 6, 50, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('33', '���޵Ǽ�', '��������', 15, 80, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('36', '˾��Э��', '���', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('39', '�鵵�Ǽ�', '�鵵�Ǽ�', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('44', '��ʧ�Ǽ�', '��ʧ', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('46', '�����Ǽ�', '����Ȩ����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('47', '����Ǽ�', '����Ǽ�', 14, 150, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('49', 'Ԥ��Ǽ�', '����Ȩת��Ԥ��', 10, 100, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('56', '�鵵�Ǽ�', '�赵�Ǽ�', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('58', '���޵Ǽ�', '��֤������', 15, 80, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('62', '����Ȩ�Ǽ�', '����Ȩ�趨', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('75', '����Ǽ�', '�ָ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('76', '��֤�Ǽ�', '��λ��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('77', '��֤�Ǽ�', '��Ȩ֤����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('79', '��ʼ�Ǽ�', '���˽���', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('80', '��ʼ�Ǽ�', '��λ����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('82', '��Ѻ�Ǽ�', 'Ԥ����Ʒ��', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('83', '��Ѻ�Ǽ�', '�ڽ�����', 13, 70, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('84', '��Ѻ�Ǽ�', '��λ��', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('85', '��Ѻ�Ǽ�', '��Ѻ���', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('86', '��Ѻ�Ǽ�', 'ע����Ѻ', -1, -1, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('88', '����Ȩ�Ǽ�', '����Ȩע��', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('89', '����Ȩ�Ǽ�', '����Ȩ���', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('90', '����Ȩ�Ǽ�', '����Ȩת��', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('91', '�����Ǽ�', '��ѺȨ����', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('92', '�����Ǽ�', '����Ȩ����', 18, 55, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('93', '�����Ǽ�', 'Ԥ��ǼǸ���', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('94', '�����Ǽ�', '���ǼǸ���', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('95', '��ʧ�Ǽ�', '��ʧ���', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('96', '��֤�Ǽ�', '˽��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('97', '˾��Э��', '���', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('99', '����Ǽ�', '����ע��', 14, 150, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('100', 'Ԥ��Ǽ�', 'Ԥ��ע��', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('101', 'Ԥ��Ǽ�', 'Ԥ����Ʒ��Ԥ��', 7, 90, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('102', 'Ԥ�۱����Ǽ�', 'Ԥ�۱���ע��', 3, 25, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('103', 'Ԥ����ɵǼ�', '����Ԥ�����', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('104', 'ת�ƵǼ�', '����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('106', 'ת�ƵǼ�', '�ָ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('107', 'ת�ƵǼ�', '�ϲ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('108', 'ת�ƵǼ�', '˾���þ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('109', 'ת�ƵǼ�', '�������', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('110', 'ת�ƵǼ�', '���ķ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('111', 'ת�ƵǼ�', '�̳�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('112', 'ת�ƵǼ�', '����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('113', 'ת�ƵǼ�', '�½���Ʒ��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('114', 'ת�ƵǼ�', '��λ��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('115', 'ת�ƵǼ�', '����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('116', 'ת�ƵǼ�', '���ķ�����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('117', 'ת�ƵǼ�', '�������÷�����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('118', '�����������Ǽ�', '�����������Ǽ�', null, null, null);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('119', 'Ԥ��Ǽ�', '�����趨��ѺȨԤ��', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('120', 'Ԥ��Ǽ�', 'Ԥ����Ʒ���趨��ѺȨԤ��', 8, 110, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('121', 'Ԥ��Ǽ�', '�ڽ������趨��ѺȨԤ��', 13, 70, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('124', '����Ǽ�', '���ƺ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('125', '��Ѻ�Ǽ�', '��߶��Ѻ', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('126', '��Ѻ�Ǽ�', '��߶��Ѻ���', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('127', '��Ѻ�Ǽ�', '��߶��Ѻת��', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('128', '��Ѻ�Ǽ�', '��Ѻת��', 11, 130, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('129', '��ʼ�Ǽ�', '�������÷�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('130', 'ת�ƵǼ�', '���ַ���ԭ��Ȩ', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('131', 'ת�ƵǼ�', '�������÷�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('132', 'ת�ƵǼ�', '���', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('133', 'ת�ƵǼ�', '�������÷���ԭ��Ȩ', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('134', '��ʼ�Ǽ�', '�������ؽ���', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('135', '�����Ǽ�', '��Ȼ״������', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('136', 'ת�ƵǼ�', '��ԭ����Ǩ', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('137', '����Ǽ�', '�ϲ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('138', 'ת�ƵǼ�', '��ԭ��Ȩ���ķ�', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('139', 'ת�ƵǼ�', '���ķ�����', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('140', '˾��Э��', 'Ԥ���', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('141', '˾��Э��', 'Ԥ���', 12, 160, 1);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('142', 'ת�ƵǼ�', '����ת��', 9, 60, 0);
insert into TBOLDBIZ_NEWROOM_STATE_YY (sercode, serclass, sertype, roomstate, weight, showforkfs)
values ('142', 'ת�ƵǼ�', '����ת��', 11, 130, 0);
commit;