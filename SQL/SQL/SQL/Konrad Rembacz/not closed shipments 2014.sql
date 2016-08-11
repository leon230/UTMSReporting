SELECT sh.shipment_gid
,orls.order_release_gid
,(SELECT sh_ref_reg.shipment_refnum_value
FROM shipment_refnum sh_ref_reg
WHERE
sh_ref_reg.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
AND sh_ref_reg.shipment_gid = sh.shipment_gid
)                                                                                                       REGION
,s_loc.location_name                                                                                    SOURCE_LOC_NAME
,d_loc.location_name                                                                                    DEST_LOC_NAME
,sh.servprov_gid                                                                                        TSP_ID
,ser_loc.location_name                                                                                  TSP_NAME
,TO_CHAR(sh.insert_date,'YYYY-MM-DD')                                                                   SH_INSERT_DATE
,TO_CHAR(orls.insert_date,'YYYY-MM-DD')                                                                 OR_INSERT_DATE

FROM shipment sh
,order_movement om
,order_release orls
,location s_loc
,location d_loc
,location ser_loc



WHERE
sh.shipment_gid = om.shipment_gid
AND orls.order_release_gid = om.order_release_gid
--AND TO_CHAR(orls.insert_date,'YYYY') = '2014'
AND orls.insert_date BETWEEN to_date('2014-01-01','YYYY-MM-DD') AND to_date('2015-01-01','YYYY-MM-DD')
AND s_loc.location_gid = orls.source_location_gid
AND d_loc.location_gid = orls.dest_location_gid
AND ser_loc.location_gid = sh.servprov_gid

AND NOT EXISTS
        (SELECT 1
        FROM shipment_status ss
        WHERE ss.shipment_gid = sh.shipment_gid
        AND ss.status_type_gid = 'ULE/PR.SHIPMENT_COST'
        and ss.status_value_gid <> 'ULE/PR.SC_NO CHANGES ALLOWED'
        )
AND EXISTS (SELECT 1
		FROM
		shipment_status sh_status
		WHERE
		sh_status.shipment_gid = sh.shipment_gid
		AND sh_status.status_type_gid = 'ULE/PR.TRANSPORT CANCELLATION'
		AND sh_status.status_value_gid = 'ULE/PR.NOT CANCELLED'
		)
AND EXISTS (SELECT 1
		FROM
		order_release_status or_status
		WHERE
		or_status.order_release_gid = orls.order_release_gid
		AND or_status.status_type_gid = 'ULE.CANCELLED'
		AND or_status.status_value_gid = 'ULE.CANCELLED_NOT CANCELLED'
		)
and rownum > 11