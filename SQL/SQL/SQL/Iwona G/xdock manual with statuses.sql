SELECT om.shipment_gid,
		orls.order_release_gid,
		 or_ref.order_release_refnum_qual_gid,
 OR_REF.ORDER_RELEASE_REFNUM_VALUE,
 
(SELECT SS.status_value_gid
	FROM shipment_status SS
	WHERE SS.shipment_gid = OM.shipment_gid
	AND ss.STATUS_TYPE_GID = 'ULE/PR.FINANCE')								FINANCE,
	
	(SELECT SS.status_value_gid
	FROM shipment_status SS
	WHERE SS.shipment_gid = OM.shipment_gid
	AND ss.STATUS_TYPE_GID = 'ULE/PR.INVOICE_READY')								INVOICE
		





FROM ORDER_RELEASE ORLS,
	ORDER_MOVEMENT OM,
	ORDEr_RELEASE_REFNUM OR_REF













WHERE
OR_REF.ORDER_RELEASE_GID = orls.order_release_gid
and or_ref.order_release_refnum_qual_gid like '%FINAL%'
AND OR_REF.ORDER_RELEASE_REFNUM_VALUE NOT LIKE 'M20%'

and om.order_release_gid = orls.order_release_gid

and exists 
(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
			
			
and (SELECT SS.status_value_gid
	FROM shipment_status SS
	WHERE SS.shipment_gid = OM.shipment_gid
	AND ss.STATUS_TYPE_GID = 'ULE/PR.FINANCE') <> 'ULE/PR.FINANCE_READY'