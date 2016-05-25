create or replace procedure fnimptest_ysxx  is
/****************************************************************************************
  31-----------2538  预售许可登记
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  l_humancode integer;
begin
  for rs in(
    select a.keycode,p.declareco
       from eistran_yy.operation a,eistran_yy.presell p
     where a.keycode=p.keycode(+)
      and a.workcode in (select workcode from eistran_yy.WorkFlow where sercode=31 and stepno in (0,1,2,3,4))
      and a.type_id = 31 and a.keycode<>'201405210039'
    )loop
    select s.humanid into l_humancode from tbhuman s where s.humanname=(select a.accman from eistran_yy.operation a where a.keycode=rs.keycode) and s.cantoncode=10;
    img := pkworkflow.startWorkflow(2538,l_humancode,null,iRecid,iActid,imsg);
    if img < 0 then
        v_msg := '收件失败，原因：'||imsg;
        insert into YSXX_LOG(RECID, KEYCODE, MSG, Type_Id,ISGD)values(iRecid,rs.keycode,v_msg,31,0);
    else
        insert into YSXX_LOG(RECID, KEYCODE,  MSG, Type_Id,ISGD)values(iRecid,rs.keycode,v_msg,31,0);
        --插入YSXX
        insert into YSXX(RECID,SFDB,YSDUIXIANG,YSXKZH,YSQX,SLBH,YWMC,XKZLX)
            select iRecid,0,'群众',p.certcode,'1',rs.keycode,'预售许可登记','商品'
                from eistran_yy.presell p
            where p.keycode=rs.keycode;
        --插入YSLPXX
        insert into YSLPXX(RECID, LPBH,y_Qh,y_zh)
           select iRecid,b.buildcode,b.land_no,b.build_no from eistran_yy.presell_build b where b.keycode=rs.keycode;
        --插入XMXX
        insert into XMXX(RECID,GSLXDH,DWDZ,FDDBR,XMBH,XMMC,XMDZ,ZJHM,
                       TDZH,TDDJ,YYZZ,KFGS,DWXZ,XMFZR,GHXKZ,KFJYXKZ,
                       ZJJGZH,ZJJGYX,ZZDJ,KHYX,STATUS,TDMJ)
          select iRecid,d.developer_tel,d.developer_add,d.developer_man,p.projectno,p.itemname,p.address,d.developer_register,
                 p.culcertno,d.developer_level,d.developer_register,p.developer_name,d.developer_type,d.developer_man,
                 p.projectno,p.development_licence,p.banknum,p.bank,d.developer_level,p.bank,0,p.allarea
            from eistran_yy.developer d, eistran_yy.presell p
          where d.code = p.declareco
          and d.code = rs.declareco
          and p.keycode = rs.keycode;
        --插入审核单
        insert into SHD2 (recid,SLR,Slr_Rq,SLYJ,CSR,Csr_Rq,Csyj,Fsr,Fsr_Rq,FSYJ,DBR,DBYJ,DBR_RQ)
          select iRecid,
                 f.r_man,
                 f.r_date,
                 f.r_mark,
                 f.first_man,
                 f.first_date,
                 f.first_mark,
                 f.aud_man,
                 f.aud_date,
                 f.aud_mark,
		 f.eaa_man,
		 f.eaa_mark,
		 f.eaa_date
            from EISTRAN_YY.EAA_Table f
           where f.keycode = rs.keycode;
        --收费
        insert into SFXX(UUID,RECID,CREATEDATE,JFXM,SFBZ,JE)
          select sys_guid(),iRecid,sysdate,a.item,a.standard,a.should from eistran_yy.charge_item a where a.keycode=rs.keycode;
        insert into SFHJ(RECID,SFHJ)
          select iRecid,sum(a.should) from eistran_yy.charge_item a where a.keycode=rs.keycode;
        update tbrec set recnum=rs.keycode where recid=iRecid;
        select count(1) into iCount from eistran_yy.presell p where p.keycode=rs.keycode;
        --要件
        delete from tbrecdoc where recid=iRecid;
        insert into tbrecdoc(docid,recid,docdefid,docname,doctype,disporder,copies,pages,checked,groupid,y_docid)
           select seqdocid.nextval,
                  iRecid,
                  0,
                  a.name,
                  decode(a.type, '复印件', 2, '原件', 1, 3),
                  0,
                  1,
                  a.pages,
                  1,
                  1,
                  a.id
             from eistran_yy.IMPORTANT_DOC a
            where a.keycode = rs.keycode and a.id <>0;
        fnupdayj(iRecid,rs.keycode);       
     end if;
  end loop;
  commit;
end;
/

