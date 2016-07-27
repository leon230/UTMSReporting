SELECT orls.order_release_gid
,COUNT(om.shipment_gid) SHIPMENT_COUNT



FROM order_release orls
,shipment sh
,order_movement om

WHERE
om.order_release_gid = orls.order_release_gid
AND om.shipment_gid = sh.shipment_gid
AND orls.insert_date >= TO_DATE('2016-01-01','YYYY-MM-DD')
AND EXISTS 
(SELECT 1
FROM shipment_refnum sh_ref
WHERE sh_ref.shipment_gid = OM.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
AND sh_ref.shipment_refnum_value = 'INBOUND'


)
AND NOT exists			
(SELECT 1
FROM shipment_stop ss
,LOCATION_ROLE_PROFILE lrp
WHERE
ss.shipment_gid = sh.shipment_gid
AND lrp.LOCATION_GID = ss.location_gid
AND lrp.LOCATION_ROLE_GID = 'XDOCK'
)

AND NOT exists			
(SELECT 1
FROM shipment_stop ss
,location_refnum lrp
WHERE
ss.shipment_gid = sh.shipment_gid
AND lrp.LOCATION_GID = ss.location_gid
AND lrp.location_refnum_qual_gid = 'ULE.ULE_SEND_TO_LOGISTAR'
)	


-- om.shipment_gid = sh.shipment_gid
GROUP BY orls.order_release_gid
HAVING COUNT(om.shipment_gid)>1
