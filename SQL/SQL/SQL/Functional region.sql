select distinct orls.order_release_gid																													OR_ID,
		sh.shipment_gid																																	SH_ID,
		TO_CHAR(orls.insert_date,'YYYY-MM-DD') 																											OR_INSERT_DATE,
		RPT_GENERAL.F_REMOVE_DOMAIN(ORLS.ORDER_RELEASE_TYPE_GID) 																						RELEASE_ATTRIBUTE,
		(
		select listagg(orls_REF.order_release_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orls_REF.order_release_GID)
		from order_release_REFNUM orls_REF
		
		where orls_REF.order_release_GID = orls.order_release_GID 
		AND orls_REF.order_release_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_TYPE'

		) AS 																																			MATERIAL,
		RPT_GENERAL.F_REMOVE_DOMAIN((select ss.location_gid
		from shipment_stop ss
		where ss.shipment_gid = sh.shipment_gid
		AND SS.STOP_NUM = 1
		))																																				FIRST_STOP_LOC,
		RPT_GENERAL.F_REMOVE_DOMAIN((select loc.country_code3_gid
		from shipment_stop ss,
			location loc
		where ss.shipment_gid = sh.shipment_gid
		AND SS.STOP_NUM = 1
		and ss.location_gid = loc.location_gid
		))																																				FIRST_STOP_LOC_COUNTRY,
		
		nvl((
		select listagg(orls_REF.order_release_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orls_REF.order_release_GID)
		from order_release_REFNUM orls_REF
		
		where orls_REF.order_release_GID = orls.order_release_GID 
		AND orls_REF.order_release_REFNUM_QUAL_GID ='ULE.ULE_BULK'

		),'NO') AS 																																		BULK_FLAG,
		sh.num_stops																																	STOPS_NUMBER,
		SH.NUM_ORDER_RELEASES																															NUM_ORDER_RELEASES,
		(
		select listagg(orls_REF.order_release_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orls_REF.order_release_GID)
		from order_release_REFNUM orls_REF
		
		where orls_REF.order_release_GID = orls.order_release_GID 
		AND orls_REF.order_release_REFNUM_QUAL_GID ='ULE.ULE_FUNCTIONAL_REGION'

		) AS 																																			OR_REGION,
		(
		select listagg(orls_REF.INSERT_USER,'|') WITHIN GROUP (ORDER BY orls_REF.order_release_GID)
		from order_release_REFNUM orls_REF
		
		where orls_REF.order_release_GID = orls.order_release_GID 
		AND orls_REF.order_release_REFNUM_QUAL_GID ='ULE.ULE_FUNCTIONAL_REGION'

		) AS 																																			OR_REGION_INSERT_USER,
		(
		select listagg(orls_REF.UPDATE_USER,'|') WITHIN GROUP (ORDER BY orls_REF.order_release_GID)
		from order_release_REFNUM orls_REF
		
		where orls_REF.order_release_GID = orls.order_release_GID 
		AND orls_REF.order_release_REFNUM_QUAL_GID ='ULE.ULE_FUNCTIONAL_REGION'

		) AS 																																			OR_REGION_UPDATE_USER,
		(select NVL(SR_REF.SHIPMENT_REFNUM_VALUE,'N/A') AS REGION
		from SHIPMENT_REFNUM SR_REF
		where SR_REF.SHIPMENT_GID = sh.SHIPMENT_GID AND SR_REF.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		)																																				SH_REGION,
		(select NVL(SR_REF.INSERT_USER,'N/A') AS REGION
		from SHIPMENT_REFNUM SR_REF
		where SR_REF.SHIPMENT_GID = sh.SHIPMENT_GID AND SR_REF.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		)																																				SH_REGION_INSERT_USER,
		(select NVL(SR_REF.UPDATE_USER,'N/A') AS REGION
		from SHIPMENT_REFNUM SR_REF
		where SR_REF.SHIPMENT_GID = sh.SHIPMENT_GID AND SR_REF.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		)																																				SH_REGION_UPDATE_USER
		

from shipment sh,
		order_release orls,
		view_shipment_order_release vorls
		
		
		
where
	sh.shipment_gid = vorls.shipment_gid
	and orls.order_release_gid = vorls.order_release_gid
	and orls.insert_date between to_date('2015-03-01','YYYY-MM-DD') and to_date('2015-03-31','YYYY-MM-DD')
	
	AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)
	and (CASE
		WHEN (SELECT 
			sh_ref_1.SHIPMENT_REFNUM_VALUE
		FROM 
			shipment_refnum sh_ref_1
		WHERE 
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_XLS_UPLD_SHIPMENT_REF_NO') is null THEN 'N'
		ELSE 'Y'
	END) = 'N'
	
	and NOT EXISTS
(SELECT SH_TEMP.SHIPMENT_GID
FROM SHIPMENT SH_TEMP,
VIEW_SHIPMENT_ORDER_RELEASE VORLS_TEMP,
	ORDER_RELEASE ORLS_TEMP
	
WHERE 1=1
AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
AND ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
	
)
	--xdock ou
	--col ilosc OR w SH
	--first stop country code