create or replace procedure fnimptest_baht is
/****************************************************************************************
循环  去重后的V_合同bargainNo
select distinct t.bargainNo from V_合同 t     
1.2015之前 去eisweb_yy.bargain_save 查看count(1),
如果是0 更新ysht插入 从V_合同 t 查出 sellperson ,buyperson,buydate ,certcode 值 取rownum=1
如果不是0 从eisweb_yy.bargain_save 中有 需要到tbhetongcaoben 查看是否合同的拆分之后的内容‘
没有则走拆分
*****************************************************************************************/
  iMg integer;
  iRecid integer;
  iActid integer;
  imsg varchar2(200);
  v_msg varchar2(500);
  l_recnum varchar2(500);
  iCount  integer;
  iCount1  integer;
  iCount2  integer;
  iCount3  integer;
  iCount4  integer;
  l_name  varchar2(200);
  l_id  integer;
  l_tname  varchar2(200);
  v_count integer;
  v_count2 integer;
begin
   /*for rs in(select distinct t.bargainNo,t.DeclareCo,t.CertCode from V_合同 t where t.bargainNo is not null
     and t.bargainNo in('200907230011','201505040077','201005270017') order by t.bargainNo) loop*/
 /*for rs in(select a.bargain_no,a.text from eisweb_yy.bargain_save a  where a.bargain_no is not null 
     and  rownum<101  order by a.bargain_no) loop*/
 --for rs in(select a.bargain_no,a.text from eisweb_yy.bargain_save a where  a.bargain_no ='200904280036') loop
   for rs in(select distinct t.bargainNo,t.DeclareCo,t.CertCode from V_合同 t where t.bargainNo is not null order by t.bargainNo) loop
      select count(1) into v_count from eisweb_yy.bargain_save b where b.bargain_no=rs.bargainno;
      select count(1) into iCount1 from eisdoc_yy.po_records d where d.bargainno=rs.bargainNo;
      select count(1) into iCount2 from eistran_yy.po_records d where d.bargainno=rs.bargainNo;
      if iCount1=0 and iCount2=0 then
        insert into BAHT_LOG(KEYCODE, IFCZRYSJ)values(rs.bargainNo,1);
      else
        select count(1) into iCount3 from tbhuman t where t.humancode=rs.declareco ;
        if iCount3=0 then
            insert into BAHT_LOG(KEYCODE,istbroom)values(rs.bargainNo,'无此人员名称：'||rs.declareco);
        else
            select t.humanid,t.humanname into l_id,l_tname from tbhuman t where t.humancode=rs.declareco ;
            img := pkworkflow.startWorkflow(2586,l_id,l_tname,iRecid,iActid,imsg);
            if img < 0 then
              v_msg := '收件失败，原因：'||imsg;
              insert into BAHT_LOG(RECID, KEYCODE, MSG)values(iRecid,rs.bargainNo,v_msg);
            else
               insert into BAHT_LOG(RECID, KEYCODE,  MSG)values(iRecid,rs.bargainNo,v_msg);
               if v_count=0 then
                 insert into YSHT(recid,HTBH,SAVEFLAG,CMR ,MSR,DETYSXKZ)
                        select iRecid,rs.bargainNo,1,t.sellperson ,t.buyperson,t.certcode 
                            from V_合同 t 
                            where t.bargainNo= rs.bargainNo and rownum=1;
                 --加入第三个存储过程 
                 fnhetonginfosp(rs.bargainNo,iRecid); 
              else
                insert into YSHT(recid,HTBH,SAVEFLAG)values(iRecid,rs.bargainNo,1);
                select count(1) into v_count2 from tbhetongcaoben t where t.t_no=rs.bargainNo;
                if v_count2>0 then
                   fnhetonginfo2(rs.bargainNo,iRecid);
                else
                   fnhetonginfo(rs.bargainNo,iRecid);
                end if;
                update YSHT y set y.detysxkz=rs.certcode where y.recid=iRecid; 
              end if;
              --更新tbroom 
              update tbroom a set a.bazt='已备案',a.bahtbh=rs.bargainno,a.fwzt=6 ,a.ysfwzt=6 where a.fwbh in (select d.roomcode from ysht c,eisdoc_yy.po_room d where c.htbh=d.bargainno and c.htzt=2 and c.htbh=rs.bargainno);   
          end if;
        end if;
      end if;
  end loop;
  commit;
end;
/

