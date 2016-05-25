CREATE OR REPLACE FORCE VIEW V_ºÏÍ¬ AS
SELECT  pr.KeyCode, pr.bargainNo, pr.sellCode, pr.RoomCode, pm.Room_No, pm.House_Sit,
  to_char(pr.buydate,'yyyy') as BuyYear,
  to_char(pr.buydate,'mm') as BuyMonth,
  to_char(pr.buydate,'dd') as BuyDay,
  to_char(pr.buydate,'yyyy-mm-dd') as PassDate,
  d.DEVELOPER_NAME AS sellperson, pp.Buyperson, pr.buydate AS buydate, p.DeclareCo, pr.isAuditing, pr.OperationType,
  p.CertCode,pr.IsNewVersion,pr.mVersion,
   pr.flag
   FROM eisdoc_yy.Presell_Build pb
  INNER JOIN eisdoc_yy.Presell p ON eisdoc_yy.pb.CertCode = p.CertCode and pb.KeyCode=p.KeyCode
  INNER JOIN eisdoc_yy.PO_Room pm ON pb.BuildCode = pm.BuildCode
  INNER JOIN eisdoc_yy.PO_Records pr on pm.KeyCode=pr.KeyCode and pm.bargainNo=pr.bargainNo and pm.RoomCode=pr.RoomCode
  INNER JOIN eisdoc_yy.PO_Person pp ON pr.KeyCode=pp.KeyCode and pr.bargainNo=pp.bargainno and pr.RoomCode = pp.RoomCode
  INNER JOIN eistran_yy.developer d ON p.DeclareCo = d.code;

