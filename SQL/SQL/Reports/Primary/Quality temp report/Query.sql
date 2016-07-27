select sh.end_time         																																		SH_END_TIME,
		sh.shipment_xid 																																		SH_ID,
		orls.order_release_xid																																	or_id,
		sh.servprov_gid																																			servprov,
		(SELECT LOC_TEMP.city
		FROM LOCATION LOC_TEMP
		WHERE
		sh.source_location_gid = LOC_TEMP.location_gid 
		
		) AS																																					CONSIGNOR_CITY,
		
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		sh.source_location_gid = LOC_TEMP.LOCATION_GID 
		
		) AS																																					CONSIGNOR_country,
		
		(SELECT LOC_TEMP.city
		FROM LOCATION LOC_TEMP
		WHERE
		sh.dest_location_gid = LOC_TEMP.location_gid 
		
		) AS																																					dest_CITY,
		
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		sh.dest_location_gid = LOC_TEMP.location_gid 
		
		) AS																																					dest_country,
		
		shr_po.SHIPMENT_REFNUM_VALUE AS 																														SH_PO,
		SHR_DN.SHIPMENT_REFNUM_VALUE AS 																														SH_DN,
		(or_ref_po.order_release_REFNUM_VALUE) AS 																												OR_PO_NUM,
		(or_ref_dn.order_release_REFNUM_VALUE) AS 																												OR_DN_NUM


from shipment sh,
shipment sh_po
LEFT OUTER JOIN SHIPMENT_REFNUM SHR_PO  ON (SHR_PO.SHIPMENT_GID = sh_po.SHIPMENT_GID AND SHR_PO.SHIPMENT_REFNUM_QUAL_GID = 'ULE.PO'),
shipment sh_dn
LEFT OUTER JOIN SHIPMENT_REFNUM SHR_DN ON (SHR_DN.SHIPMENT_GID = sh_dn.SHIPMENT_GID AND SHR_DN.SHIPMENT_REFNUM_QUAL_GID = 'ULE.DN'),
order_release orls,
VIEW_SHIPMENT_ORDER_RELEASE VORLS,
order_release or_po
LEFT OUTER JOIN order_release_refnum or_ref_po ON (or_po.ORDER_RELEASE_GID = or_ref_po.ORDER_RELEASE_GID 
and or_ref_po.ORDER_RELEASE_REFNUM_QUAL_GID IN ('PO','ULE.ULE_PO_NUMBER','ULE.ULE_SAP_PO_NUMBER','CUST_PO')),
order_release or_dn
LEFT OUTER JOIN order_release_refnum or_ref_dn ON (or_ref_dn.ORDER_RELEASE_GID = or_dn.ORDER_RELEASE_GID
and or_ref_dn.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_DN_NUMBER','UL_SAP_DN'))



where 1=1
and sh_po.SHIPMENT_GID = sh.SHIPMENT_GID
and sh_dn.SHIPMENT_GID = sh.SHIPMENT_GID
and sh.SHIPMENT_GID = vorls.SHIPMENT_GID
and orls.order_Release_gid = vorls.order_Release_gid
and or_po.order_Release_gid = orls.order_Release_gid
and or_dn.order_Release_gid = orls.order_Release_gid
and trunc(sh.end_time) >= TRUNC(TO_DATE(:P_END_TIME_FROM,:P_DATE_TIME_FORMAT))
AND TRUNC(SH.END_TIME) <= TRUNC(TO_DATE(:P_END_TIME_TO,:P_DATE_TIME_FORMAT))
