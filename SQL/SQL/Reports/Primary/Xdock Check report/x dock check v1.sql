select orls.order_release_gid,
		to_char(orls.late_delivery_date,'YYYY-MM-DD')														OR_LATE_DELIVERY_DATE,
		(select count(vorls.shipment_gid)
		from view_shipment_order_release vorls
		where vorls.order_release_gid = orls.order_release_gid
		)																									COUNT_SH,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_COST CENTER'
		)																									CC_COUNT,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_DESTLEG_PAYER'
		)																									DEST_LEG_PAYER,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_GLN'
		)																									GLN,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_HANDLING_PAYER'
		)																									HANDLING_PAYER,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_LEG1_PAYER'
		)																									LEG1_PAYER,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_LEG2_PAYER'
		)																									LEG2_PAYER,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_PAYER'
		)																									PAYER,
		(select count(orls_ref.ORDER_RELEASE_REFNUM_VALUE)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = orls.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_SOURCELEG_PAYER'
		)																									SOURCE_LEG_PAYER,
		case WHEN (SELECT listagG(SH_TEMP.SHIPMENT_GID,'/') within group (order by orls.ORDER_RELEASE_GID)
			FROM SHIPMENT SH_TEMP,
			VIEW_SHIPMENT_ORDER_RELEASE VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
			is not null then 'Y' else 'N' end as																											XDOCK_SHIPMENT,
			
		(select count(shs.STATUS_VALUE_GID)
		from shipment_status shs,
			view_shipment_order_release vorls
		
		where  vorls.order_release_gid = orls.order_release_gid
		and shs.SHIPMENT_GID = vorls.SHIPMENT_GID
		
		
		and shs.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
		and shs.STATUS_VALUE_GID = 'ULE/PR.SC_NO CHANGES ALLOWED'
		
		)																																					NO_CHANGES_ALLOWED_COUNT
		
		
from order_release orls
/* where  orls.insert_date > sysdate -60 */
WHERE to_char(orls.late_delivery_date,'YYYY') = '2015'
and (select count(vorls.shipment_gid)
		from view_shipment_order_release vorls
		where vorls.order_release_gid = orls.order_release_gid
		)>0
and 
(select count(shs.STATUS_VALUE_GID)
		from shipment_status shs,
			view_shipment_order_release vorls
		
		where  vorls.order_release_gid = orls.order_release_gid
		and shs.SHIPMENT_GID = vorls.SHIPMENT_GID
		
		
		and shs.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
		and shs.STATUS_VALUE_GID = 'ULE/PR.SC_NO CHANGES ALLOWED'
		
		) <> (select count(vorls.shipment_gid)
		from view_shipment_order_release vorls
		where vorls.order_release_gid = orls.order_release_gid
		)
and
(select count(vorls.shipment_gid)
		from view_shipment_order_release vorls
		where vorls.order_release_gid = orls.order_release_gid
		)>1
		 

AND NOT EXISTS(SELECT 1
	FROM order_release_refnum
	WHERE ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
	AND ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
	AND 	ORDER_RELEASE_REFNUM_VALUE = 'SECONDARY')