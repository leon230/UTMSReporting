SELECT  sh.SHIPMENT_GID
,sh.SHIPMENT_XID
,orls.ORDER_RELEASE_GID
,to_char(TRUNC(sh.START_TIME),'YYYY-MM-DD')										SH_START_TIME
,to_char(sh.END_TIME,'YYYY-MM-DD')													SH_END_TIME
,to_char(TRUNC(orls.early_pickup_date),'YYYY-MM-DD')								ORLS_PICK_DATE
,sh.INSERT_USER
,to_char(sh.INSERT_DATE,'YYYY-MM-DD HH24:MI:SS')									SH_INSERT_DATE
,orls.TIME_WINDOW_EMPHASIS_GID
,UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
FROM shipment_refnum sh_ref
WHERE sh_ref.shipment_gid = sh.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'


))																																DISPATCHING_REGION
 
FROM SHIPMENT sh
 INNER JOIN VIEW_SHIPMENT_ORDER_RELEASE vorls ON sh.SHIPMENT_GID=vorls.SHIPMENT_GID
 INNER JOIN ORDER_RELEASE orls ON vorls.ORDER_RELEASE_GID=orls.ORDER_RELEASE_GID
    
WHERE   
  TRUNC(sh.INSERT_DATE) = TRUNC(to_date('2016-03-24','YYYY-MM-DD HH24:MI'))
 and TRUNC(sh.START_TIME) <> trunc(orls.early_pickup_date)
  