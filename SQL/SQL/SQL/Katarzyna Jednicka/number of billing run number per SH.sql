SELECT /*+ LEADING(sh) INDEX(sh)*/  sh.shipment_gid
,om.order_release_gid
-- ,nvl(((SELECT count(om1.order_release_gid)
-- FROM order_movement om1
-- WHERE om1.shipment_gid = sh.shipment_gid
-- )																		
 -- - (SELECT count(or_ref.order_release_refnum_value)
-- FROM order_release_refnum or_ref

-- WHERE or_ref.order_release_gid in
-- (SELECT om1.order_release_gid
-- FROM order_movement om1
-- WHERE om1.shipment_gid = sh.shipment_gid
-- )
-- AND or_ref.order_release_refnum_qual_gid like '%FINAL_BILLING%'


-- )),0)																					BILLING_COUNT
-- ,(SELECT count(om1.order_release_gid)
-- FROM order_movement om1
-- WHERE om1.shipment_gid = sh.shipment_gid
-- )																								or_count
,(SELECT count(or_ref.order_release_refnum_value)
FROM order_release_refnum or_ref

WHERE or_ref.order_release_gid = om.order_release_gid
AND or_ref.order_release_refnum_qual_gid like '%FINAL_BILLING%'


)																		billing_count																																			
-- ,(SELECT count(or_ref.order_release_refnum_value)
-- FROM order_release_refnum or_ref

-- WHERE or_ref.order_release_gid in
-- (SELECT om1.order_release_gid
-- FROM order_movement om1
-- WHERE om1.shipment_gid = sh.shipment_gid
-- )
-- AND or_ref.order_release_refnum_qual_gid like '%FINAL_BILLING%'


-- )																								billing_count				

FROM shipment sh
,order_movement om



WHERE
sh.shipment_gid = om.shipment_gid
and sh.start_time > = sysdate - 100
-- AND NOT exists			
-- (SELECT 1
-- FROM shipment_stop ss
-- ,location_refnum lrp
-- WHERE
-- ss.shipment_gid = sh.shipment_gid
-- AND lrp.LOCATION_GID = ss.location_gid
-- AND lrp.location_refnum_qual_gid = 'ULE.ULE_SEND_TO_LOGISTAR'
-- )
AND EXISTS
(SELECT 1
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
		AND SH_STATUS.STATUS_VALUE_GID = 'ULE/PR.SC_NO CHANGES ALLOWED'
		AND SH_STATUS.UPDATE_USER = 'DBA.ADMIN'
		)
AND NOT EXISTS
(SELECT 1
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.INVOICE_READY'
		AND SH_STATUS.STATUS_VALUE_GID = 'ULE/PR.INVOICE_EXCLUDED'
		)
AND (SELECT count(or_ref.order_release_refnum_value)
FROM order_release_refnum or_ref

WHERE or_ref.order_release_gid = om.order_release_gid
AND or_ref.order_release_refnum_qual_gid like '%FINAL_BILLING%'


) = 0