SELECT 
  shipment_gid
FROM 
  shipment
WHERE 
  UNILEVER.ebs_procedures_ule.get_quarterly_ex_rate(insert_date,currency_gid,'EUR') != 1
  AND UNILEVER.ebs_procedures_ule.Late_p(shipment_gid) = 0
  AND UNILEVER.ebs_procedures_ule.Late_d(shipment_gid) = 0
  AND rownum = 1
