SELECT SH.SHIPMENT_GID
,sh.servprov_gid
,(select loc.location_name
from location loc
where loc.location_gid = sh.servprov_gid

)													tsp_name
,sh.TOTAL_ACTUAL_COST								shipment_cost
,OM.ORDER_RELEASE_GID
,(select SS.status_value_gid from
shipment_status ss
					where ss.shipment_gid = sh.shipment_gid

                    and ss.status_type_gid = 'ULE/PR.SHIPMENT_COST')



FROM shipment sh
,order_movement om

WHERE
sh.shipment_gid = om.shipment_gid

and exists
(select 1
		from order_release_refnum orls_ref
		,ORDER_MOVEMENT OM1
		where OM1.order_release_gid = ORLS_REF.order_release_gid
		anD OM1.SHIPMENT_GID = SH.SHIPMENT_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_PAYER'
		)
AND EXISTS
(select 1
		from order_release_refnum orls_ref
		,ORDER_MOVEMENT OM1
		where OM1.order_release_gid = ORLS_REF.order_release_gid
		and OM1.SHIPMENT_GID = SH.SHIPMENT_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID  IN ('ULE.ULE_LEG1_PAYER','ULE.ULE_LEG2_PAYER')

		)


		-- AND SH.SHIPMENT_GID = 'ULE/PR.101806963'
AND TO_CHAR(SH.INSERT_DATE,'YYYY') = '2016'