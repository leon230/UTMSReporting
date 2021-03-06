SELECT DISTINCT SH.SHIPMENT_GID AS																														SH_ID,
		ORLS.ORDER_RELEASE_GID	AS																														OR_ID,		
		ORLS.SOURCE_LOCATION_GID AS																														SOURCE_LOC_ID,
		LOC_SOURCE.CITY AS 																																SOURCE_CITY,
		LOC_SOURCE.COUNTRY_CODE3_GID AS 																												SOURCE_country,
		ORLS.DEST_LOCATION_GID	AS																														DEST_LOC_ID,
		loc_source.location_name as																														Source_name,
		LOC_DEST.CITY AS 																																DESTINATION_CITY,
		LOC_DEST.COUNTRY_CODE3_GID AS 																													DEST_country,	
		loc_dest.location_name as																														Dest_name,
		(sh.servprov_gid) as 																															SERVICE_PROVIDER,
		loc_tsp.LOCATION_NAME as 																														SERVPROV_NAME,
		(
		select listagg(SH_STATUS.STATUS_VALUE_GID,'|') WITHIN GROUP (ORDER BY SH_STATUS.SHIPMENT_GID)
		from SHIPMENT_STATUS SH_STATUS
		
		where SH.SHIPMENT_GID = SH_STATUS.SHIPMENT_GID 
				AND SH_STATUS.STATUS_TYPE_GID IN ('ULE/PR.SECURE RESOURCES')
		
		
		) AS 																																			STATUS,
		
		TO_char(sh.start_time,'DD-MM-YYYY HH24:MI:SS')																									SH_START_TIME,
		TO_char(sh.END_TIME,'DD-MM-YYYY HH24:MI:SS')																									SH_END_TIME,
		(
		select listagg(orls_CAT.order_release_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orls_CAT.order_release_GID)
		from order_release_REFNUM orls_CAT
		
		where orls_CAT.order_release_GID = orls.order_release_GID 
		AND orls_CAT.order_release_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_CATEGORY'
		) AS 																																	CATEGORY,
		
		(
		select listagg(orls_CAT.order_release_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orls_CAT.order_release_GID)
		from order_release_REFNUM orls_CAT
		
		where orls_CAT.order_release_GID = orls.order_release_GID 
		AND orls_CAT.order_release_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_TYPE'

		) AS 																																	MATERIAL,
		(select NVL(SR_REGION.SHIPMENT_REFNUM_VALUE,'N/A') AS REGION
		from SHIPMENT_REFNUM SR_REGION 
		where SR_REGION.SHIPMENT_GID = sh.SHIPMENT_GID AND SR_REGION.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		)																																		REGION,
		(select listagg(SHR_RA.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_RA.SHIPMENT_GID)																										
		from SHIPMENT_REFNUM SHR_RA 
		where (SHR_RA.SHIPMENT_GID = sh.SHIPMENT_GID AND SHR_RA.SHIPMENT_REFNUM_QUAL_GID='ULE/PR.ULE_OR_REL_ATR')
		) as 																																			RELEASE_ATTR,
		(
		select listagg(orlsr_EXP.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orlsr_EXP.ORDER_RELEASE_GID)
		from ORDER_RELEASE_REFNUM orlsr_EXP
		
		where orls.ORDER_RELEASE_GID = orlsr_EXP.ORDER_RELEASE_GID 
				AND orlsr_EXP.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_EXPRESS_BY_CUSTOMER')

		) AS 																																			EXPRESS,
		
		to_char(ORLS.insert_date,'DD-MM-YYYY HH24:MI:SS') AS 																			or_INSERT_date,
		to_char(ORLS.early_pickup_date,'DD-MM-YYYY HH24:MI:SS') AS 																					early_pickup_date,
		to_char(ORLS.late_delivery_date,'DD-MM-YYYY HH24:MI:SS') AS 																				late_delivery_date,
		'"'||(
		select listagg(orlsr_po.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orlsr_po.ORDER_RELEASE_GID)
		from ORDER_RELEASE_REFNUM orlsr_po 
		
		where orls.ORDER_RELEASE_GID = orlsr_po.ORDER_RELEASE_GID 
				AND orlsr_po.ORDER_RELEASE_REFNUM_QUAL_GID IN ('PO','ULE.ULE_PO_NUMBER','ULE.ULE_SAP_PO_NUMBER','CUST_PO','ULE.ULE_FINANCE_PO_NUMBER')
		
		
		)||'"' AS 																																			OR_PO_NUM,
		'"'||(
		select listagg(orlsr_DN_ULE.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY orlsr_DN_ULE.ORDER_RELEASE_GID)
		from ORDER_RELEASE_REFNUM orlsr_DN_ULE 
		
		where orls.ORDER_RELEASE_GID = orlsr_DN_ULE.ORDER_RELEASE_GID 
				AND orlsr_DN_ULE.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_DN_NUMBER','UL_SAP_DN')
		
		
		)||'"' AS 																																			OR_DN_NUM,
		LTRIM(TO_CHAR(ORLS.TOTAL_SHIP_UNIT_COUNT,'999999999','NLS_NUMERIC_CHARACTERS = '', ''')) AS															OR_NUM_OF_PALLETS,
		
		(--CASE WHEN ss.stop_type ='D' THEN 
		
		SELECT listagg(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,ORLS.SOURCE_LOCATION_GID),'DD-MM-YYYY HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				--AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND	LR_LOAD_T.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */

		--ELSE NULL
		--END
		) AS 																																			APP_PICKUP,
		(--CASE WHEN ss.stop_type ='D' THEN 
		
		SELECT listagg(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,ORLS.DEST_LOCATION_GID),'DD-MM-YYYY HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				--AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND	LR_LOAD_T.LOCATION_GID = ORLS.DEST_LOCATION_GID
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		
		
		--ELSE NULL
		--END
		) AS 																																			APP_DESTINATION
	
FROM
	SHIPMENT_STOP SS,
	SHIPMENT SH,
	SHIPMENT_STOP_D SSD,
	S_SHIP_UNIT SSU,
	S_SHIP_UNIT_LINE SSUL,
	ORDER_RELEASE ORLS,
	LOCATION LOC_SOURCE,
	LOCATION LOC_DEST,
	location loc_tsp,
	SHIP_UNIT_EQUIP_REF_UNIT_JOIN SUERUJ_PALLET,
	ship_unit su

WHERE 1=1
	AND SH.DOMAIN_NAME = 'ULE/PR'
	AND	SH.SHIPMENT_TYPE_GID = 'TRANSPORT'
	
	AND	SS.SHIPMENT_GID = SH.SHIPMENT_GID
	AND SSD.SHIPMENT_GID = SS.SHIPMENT_GID
	AND SSD.STOP_NUM = SS.STOP_NUM
	AND SSD.S_SHIP_UNIT_GID = SSU.S_SHIP_UNIT_GID
	AND SSU.S_SHIP_UNIT_GID = SSUL.S_SHIP_UNIT_GID
	AND SSUL.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
	
	and	su.SHIP_UNIT_GID = SUERUJ_PALLET.SHIP_UNIT_GID
	and	su.SHIP_UNIT_GID = SSU.SHIP_UNIT_GID
	
	AND	LOC_SOURCE.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
	AND	LOC_DEST.LOCATION_GID = ORLS.DEST_LOCATION_GID
	
	AND	loc_tsp.location_gid = sh.servprov_gid
	
	
	/* and sh.shipment_gid in ('ULE/PR.100187592') */

	AND (SELECT SHS_STATUS_CANC.STATUS_VALUE_GID
	FROM SHIPMENT SH_STATUS_CANC
	LEFT OUTER JOIN SHIPMENT_STATUS SHS_STATUS_CANC ON (SH_STATUS_CANC.SHIPMENT_GID = SHS_STATUS_CANC.SHIPMENT_GID 
	AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION')
	WHERE SH_STATUS_CANC.SHIPMENT_GID = SH.SHIPMENT_GID
	)='ULE/PR.NOT CANCELLED'
	AND	ORLS.INSERT_DATE >= trunc(SYSDATE) - 15
	
	AND(
	ORLS.SOURCE_LOCATION_GID = nvl(:SOURCE_LOC,ORLS.SOURCE_LOCATION_GID)
	OR
	ORLS.DEST_LOCATION_GID = nvl(:DEST_LOC,ORLS.DEST_LOCATION_GID)
	)
UNION ALL
(
SELECT SH.SHIPMENT_GID	AS																														SH_ID,
		'ORDERLESS' AS 																															OR_ID,
		SH.SOURCE_LOCATION_GID AS																												SOURCE_LOC_ID,
		loc_source.location_name as																														Source_name,
		LOC_SOURCE.CITY AS 																														SOURCE_CITY,
		LOC_SOURCE.COUNTRY_CODE3_GID AS 																													SOURCE_country,
		SH.DEST_LOCATION_GID AS																													DEST_LOC_ID,
		LOC_DEST.CITY AS 																														DESTINATION_CITY,
		LOC_DEST.COUNTRY_CODE3_GID AS 																											DEST_country,	
		loc_dest.location_name as																												Dest_name,
		(sh.servprov_gid) as 																													SERVICE_PROVIDER,
		loc_tsp.LOCATION_NAME as 																												SERVICE_PROVIDER_NAME,
		(
		select listagg(SH_STATUS.STATUS_VALUE_GID,'|') WITHIN GROUP (ORDER BY SH_STATUS.SHIPMENT_GID)
		from SHIPMENT_STATUS SH_STATUS
		
		where SH.SHIPMENT_GID = SH_STATUS.SHIPMENT_GID 
				AND SH_STATUS.STATUS_TYPE_GID IN ('ULE/PR.SECURE RESOURCES')
		
		
		) AS 																																			STATUS,
		TO_char(sh.start_time,'DD-MM-YYYY HH24:MI:SS')																									SH_START_TIME,
		TO_char(sh.END_TIME,'DD-MM-YYYY HH24:MI:SS')																									SH_END_TIME,

		(
		select listagg(SH_CAT.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SH_CAT.SHIPMENT_GID)
		from SHIPMENT_REFNUM SH_CAT
		
		where SH_CAT.SHIPMENT_GID = SH.SHIPMENT_GID 
		AND SH_CAT.SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_CATEGORY'
		
		
		) AS 																																			CATEGORY,
		(
		select listagg(SH_CAT.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SH_CAT.SHIPMENT_GID)
		from SHIPMENT_REFNUM SH_CAT
		
		where SH_CAT.SHIPMENT_GID = SH.SHIPMENT_GID 
		AND SH_CAT.SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_TYPE'
		) AS 																																			MATERIAL,
		(select NVL(SR_REGION.SHIPMENT_REFNUM_VALUE,'N/A') AS REGION
		from SHIPMENT_REFNUM SR_REGION 
		where SR_REGION.SHIPMENT_GID = sh.SHIPMENT_GID AND SR_REGION.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		)																																		REGION,
		(select listagg(SHR_RA.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_RA.SHIPMENT_GID)																										
		from SHIPMENT_REFNUM SHR_RA 
		where (SHR_RA.SHIPMENT_GID = sh.SHIPMENT_GID AND SHR_RA.SHIPMENT_REFNUM_QUAL_GID='ULE/PR.ULE_OR_REL_ATR')
		) as 																																			RELEASE_ATTR,

		'N/A' AS 																																EXPRESS,
		'N/A' AS 																																or_INSERT_date,
		'N/A' AS 																																early_pickup_date,
		'N/A' AS 																																late_delivery_date,
		'N/A' AS 																																OR_po_num,
		'N/A' AS																																OR_DN_NUM,
		'N/A' AS																																OR_NUM_OF_PALLETS,
		(--CASE WHEN ss.stop_type ='D' THEN 
		
		SELECT listagg(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,SH.SOURCE_LOCATION_GID),'DD-MM-YYYY HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				--AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND	LR_LOAD_T.LOCATION_GID = SH.SOURCE_LOCATION_GID
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */

		--ELSE NULL
		--END
		) AS 																																			APP_PICKUP,
		(--CASE WHEN ss.stop_type ='D' THEN 
		
		SELECT listagg(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,SH.DEST_LOCATION_GID),'DD-MM-YYYY HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				--AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND	LR_LOAD_T.LOCATION_GID = SH.DEST_LOCATION_GID
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */

		--ELSE NULL
		--END
		) AS 																																			APP_DESTINATION

FROM
		SHIPMENT SH
				LEFT OUTER JOIN SHIPMENT_STOP SS ON	(SS.SHIPMENT_GID = SH.SHIPMENT_GID)
				LEFT OUTER JOIN SHIPMENT_STOP_D SSD ON (SSD.SHIPMENT_GID = SS.SHIPMENT_GID AND SSD.STOP_NUM = SS.STOP_NUM)
				LEFT OUTER JOIN S_SHIP_UNIT SSU ON (SSD.S_SHIP_UNIT_GID = SSU.S_SHIP_UNIT_GID)
				LEFT OUTER JOIN S_SHIP_UNIT_LINE SSUL ON (SSU.S_SHIP_UNIT_GID = SSUL.S_SHIP_UNIT_GID)
				LEFT OUTER JOIN ship_unit su ON (su.SHIP_UNIT_GID = SSU.SHIP_UNIT_GID)
				LEFT OUTER JOIN SHIP_UNIT_EQUIP_REF_UNIT_JOIN SUERUJ_PALLET on (su.SHIP_UNIT_GID = SUERUJ_PALLET.SHIP_UNIT_GID),
				
		LOCATION LOC_SOURCE,
		LOCATION LOC_DEST,
		location loc_tsp


WHERE 1=1	
	AND SH.DOMAIN_NAME = 'ULE/PR'
	AND	SH.SHIPMENT_TYPE_GID = 'APPOINTMENT'
	
	AND	LOC_SOURCE.LOCATION_GID = SH.SOURCE_LOCATION_GID
	AND	LOC_DEST.LOCATION_GID = SH.DEST_LOCATION_GID
	
	AND	loc_tsp.location_gid = sh.servprov_gid
	
	/* and	sh.shipment_gid in ('ULE/PR.100187592') */

	AND (SELECT SHS_STATUS_CANC.STATUS_VALUE_GID
	FROM SHIPMENT SH_STATUS_CANC
	LEFT OUTER JOIN SHIPMENT_STATUS SHS_STATUS_CANC ON (SH_STATUS_CANC.SHIPMENT_GID = SHS_STATUS_CANC.SHIPMENT_GID 
	AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION')
	WHERE SH_STATUS_CANC.SHIPMENT_GID = SH.SHIPMENT_GID
	)='ULE/PR.NOT CANCELLED'
	AND	SH.INSERT_DATE >= trunc(SYSDATE) - 15

)
/* order by 1,2 */