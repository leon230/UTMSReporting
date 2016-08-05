SELECT SH.SHIPMENT_GID
,sh.servprov_gid
,(select loc.location_name
from location loc
where loc.location_gid = sh.servprov_gid

)													tsp_name
,sh.TOTAL_ACTUAL_COST								shipment_cost
,OM.ORDER_RELEASE_GID
,or_ref.order_release_refnum_value                              ref_val
,or_ref.order_release_refnum_qual_gid                              qual_gid
,to_char(or_ref.insert_date,'YYYY-MM-DD HH24:MI')       ref_ins_date



FROM shipment sh
,order_movement om
,order_release_refnum or_ref

WHERE
sh.shipment_gid = om.shipment_gid
AND or_ref.order_release_gid = om.order_release_gid
AND or_ref.order_release_refnum_qual_gid in ('ULE.ULE_PAYER','ULE.ULE_LEG1_PAYER','ULE.ULE_LEG2_PAYER','ULE.ULE_HANDLING_PAYER')

and exists
(select 1
		from order_release_refnum orls_ref
		,ORDER_MOVEMENT OM1
		where OM1.order_release_gid = om.order_release_gid
		AND OM1.ORDER_RELEASE_GID = orls_ref.order_release_gid
		anD OM1.SHIPMENT_GID = SH.SHIPMENT_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_PAYER'
		)
AND EXISTS
(select 1
		from order_release_refnum orls_ref
		,ORDER_MOVEMENT OM1
		where OM1.order_release_gid = om.order_release_gid
		AND OM1.ORDER_RELEASE_GID = orls_ref.order_release_gid
		and OM1.SHIPMENT_GID = SH.SHIPMENT_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID  IN ('ULE.ULE_LEG1_PAYER','ULE.ULE_LEG2_PAYER','ULE.ULE_HANDLING_PAYER')

		)
AND exists
(select SS.status_value_gid from
shipment_status ss
					where ss.shipment_gid = sh.shipment_gid
                    AND ss.status_value_gid != 'ULE/PR.SC_NO CHANGES ALLOWED'
                    and ss.status_type_gid = 'ULE/PR.SHIPMENT_COST')


		-- AND SH.SHIPMENT_GID = 'ULE/PR.101806963'
AND TO_CHAR(SH.INSERT_DATE,'YYYY') = '2016'