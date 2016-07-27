SELECT /*+ leading(sh) full(sh) */ sh.shipment_gid																																	SH_ID
,orls.order_release_gid																															OR_ID
,(SELECT LISTAGG(or_ref.order_release_refnum_value,',') WITHIN GROUP (ORDER BY or_ref.order_release_gid)
FROM ORDER_RELEASE_REFNUM or_ref
WHERE or_ref.order_release_gid = orls.order_release_gid
AND or_ref.order_release_refnum_qual_gid = 'ULE.ULE_DN_NUMBER'
)																																				DN_NUM
,(SELECT LISTAGG(sh_ref.shipment_refnum_value,',') WITHIN GROUP (ORDER BY sh_ref.shipment_gid)
FROM SHIPMENT_REFNUM sh_ref
WHERE sh_ref.shipment_gid = sh.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_SHIPMENT_STREAM'
)																																				STREAM
,sh_s_loc.location_gid																															SH_SOURCE_LOC
,sh_s_loc.location_name																															SH_SOURCE_NAME
,sh_s_loc.PROVINCE_CODE																															SH_SOURCE_PROVINCE
,sh_s_loc.POSTAL_CODE																																SH_SOURCE_POSTAL
,sh_s_loc.COUNTRY_CODE3_GID																																SH_SOURCE_COUNTRY
,sh_s_loc.city																																SH_SOURCE_CITY


,sh_d_loc.location_gid																															SH_DEST_LOC
,sh_d_loc.location_name																															SH_DEST_NAME
,sh_d_loc.PROVINCE_CODE																															SH_DEST_PROVINCE
,sh_d_loc.POSTAL_CODE																																SH_DEST_POSTAL
,sh_d_loc.COUNTRY_CODE3_GID																																SH_DEST_COUNTRY
,sh_d_loc.city																																SH_DEST_CITY
-------ORDER----------
,or_s_loc.location_gid																															OR_SOURCE_LOC
,or_s_loc.location_name																															OR_SOURCE_NAME
,or_s_loc.PROVINCE_CODE																															OR_SOURCE_PROVINCE
,or_s_loc.POSTAL_CODE																																OR_SOURCE_POSTAL
,or_s_loc.COUNTRY_CODE3_GID																																OR_SOURCE_COUNTRY
,or_s_loc.city																																OR_SOURCE_CITY


,or_d_loc.location_gid																															OR_DEST_LOC
,or_d_loc.location_name																															OR_DEST_NAME
,or_d_loc.PROVINCE_CODE																															OR_DEST_PROVINCE
,or_d_loc.POSTAL_CODE																																OR_DEST_POSTAL
,or_d_loc.COUNTRY_CODE3_GID																																OR_DEST_COUNTRY
,or_d_loc.city																																OR_DEST_CITY
----------------------
,sh.servprov_gid																																SERVPROV_ID
,tsp_loc.location_name																																	SERVPROV_NAME
,(SELECT LISTAGG(or_ref.order_release_refnum_value,',') WITHIN GROUP (ORDER BY or_ref.order_release_gid)
FROM ORDER_RELEASE_REFNUM or_ref
WHERE or_ref.order_release_gid = orls.order_release_gid
AND or_ref.order_release_refnum_qual_gid = 'ULE.ULE_MATERIAL_CATEGORY'
)																																				MATERIAL_CATEGORY
,(SELECT LISTAGG(sh_ref.shipment_refnum_value,',') WITHIN GROUP (ORDER BY sh_ref.shipment_gid)
FROM SHIPMENT_REFNUM sh_ref
WHERE sh_ref.shipment_gid = sh.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_TRANSPORT_CONDITION'
)																																				TRANSPORT_CONDITION




-- ,shs.stop_num																																	STOP_NUM
-- ,TO_CHAR(shs.actual_arrival,'YYYY-MM-DD HH24:MI')																								ACTUAL_ARRIVAL
-- ,shs.stop_type																																	STOP_TYPE
,(SELECT TO_CHAR(shs.actual_arrival,'YYYY-MM-DD HH24:MI')
FROM shipment_stop shs
WHERE shs.shipment_gid = sh.shipment_gid
ANd shs.stop_num = 1

)																																				ACTUAL_ARRIVAL	
,(SELECT TO_CHAR(shs.actual_arrival,'YYYY-MM-DD HH24:MI')
FROM shipment_stop shs
WHERE shs.shipment_gid = sh.shipment_gid
AND shs.stop_num = NVL(sh.num_stops,2)

)																																				ACTUAL_DELIVERY	




,sh.total_num_reference_units																													PFS
,ROUND(sh.total_weight_base*0.45359237,2)																											PALLET_GROSS_WEIGHT_KG
,nvl(TRIM(TO_CHAR(
(SELECT 
SUM(case
				when (alloc_d.cost_currency_gid = 'EUR' or alloc_d.cost_currency_gid IS null) THEN alloc_d.cost
				when alloc_d.cost_currency_gid <> 'EUR' THEN alloc_d.cost * 
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.cost_currency_gid,'EUR')
				ELSE 0
				END	)						COST
				
		FROM allocation_order_release_d alloc_d
		,ALLOCATION_BASE AB

		WHERE alloc_d.order_release_gid = orls.order_release_gid
		AND alloc_d.cost_description  = 'B'
		AND ab.alloc_seq_no = alloc_d.alloc_seq_no
		AND ab.shipment_gid = sh.shipment_gid
		-- AND alloc_d.IS_WEIGHTED = 'N'
		-- AND (alloc_d.ACCESSORIAL_CODE_GID  LIKE '%FUEL%' OR alloc_d.cost_description = 'B' )
),'999999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')),0)																		TOTAL_COST_BASE
,nvl(TRIM(TO_CHAR(
(SELECT 
SUM(case
				when (alloc_d.cost_currency_gid = 'EUR' or alloc_d.cost_currency_gid IS null) THEN alloc_d.cost
				when alloc_d.cost_currency_gid <> 'EUR' THEN alloc_d.cost * 
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.cost_currency_gid,'EUR')
				ELSE 0
				END	)						COST
				
		FROM allocation_order_release_d alloc_d
		,ALLOCATION_BASE AB

		WHERE alloc_d.order_release_gid = orls.order_release_gid
		-- AND (alloc_d.cost_description  in ('B','A'))
		AND ab.alloc_seq_no = alloc_d.alloc_seq_no
		AND ab.shipment_gid = sh.shipment_gid
		-- AND alloc_d.IS_WEIGHTED = 'N'
		AND alloc_d.ACCESSORIAL_CODE_GID  LIKE '%FUEL%' 
),'999999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')),0)																		TOTAL_COST_FUEL
,nvl(TRIM(TO_CHAR(
(SELECT 
SUM(case
				when (alloc_d.cost_currency_gid = 'EUR' or alloc_d.cost_currency_gid IS null) THEN alloc_d.cost
				when alloc_d.cost_currency_gid <> 'EUR' THEN alloc_d.cost * 
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.cost_currency_gid,'EUR')
				ELSE 0
				END	)						COST
				
		FROM allocation_order_release_d alloc_d
		,ALLOCATION_BASE AB

		WHERE alloc_d.order_release_gid = orls.order_release_gid
		AND alloc_d.cost_description  = 'A'
		AND ab.alloc_seq_no = alloc_d.alloc_seq_no
		AND ab.shipment_gid = sh.shipment_gid
		-- AND alloc_d.IS_WEIGHTED = 'N'
),'999999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')),0)																	TOTAL_COST_ACCESSORIAL
,(SELECT SUM(NVL(la_raildist.lane_attribute_value,0)) 	
				FROM lane_attribute la_raildist
				,rate_geo rg
				WHERE
				rg.rate_geo_gid = sh.rate_geo_gid
				AND rg.X_LANE_GID = la_raildist.x_lane_gid 
				-- XL.x_lane_gid = la_raildist.x_lane_gid 
				AND la_raildist.lane_attribute_def_gid IN ('ULE.ULE_RAIL_DISTANCE','ULE.ULE_WATER_DISTANCE','ULE.ULE_ROAD_DISTANCE')
		) AS 																																		DISTANCE_TOAL


FROM shipment sh
,order_release orls
,view_shipment_order_release vorls
,location sh_s_loc
,location sh_d_loc
,location or_s_loc
,location or_d_loc
,location tsp_loc
-- ,shipment_stop shs

WHERE
vorls.order_release_gid = orls.order_release_gid
AND sh.shipment_gid = vorls.shipment_gid
AND sh_s_loc.location_gid = sh.source_location_gid
AND sh_d_loc.location_gid = sh.dest_location_gid
AND or_s_loc.location_gid = orls.source_location_gid
AND or_d_loc.location_gid = orls.dest_location_gid
AND tsp_loc.location_gid = sh.servprov_gid
-- AND shs.shipment_gid = sh.shipment_gid

AND (sh_s_loc.country_code3_gid = 'ESP' or sh_d_loc.country_code3_gid = 'ESP')
AND sh.start_time >= to_date('2015-08-01','YYYY-MM-DD')
AND sh.start_time < to_date('2016-01-01','YYYY-MM-DD')

