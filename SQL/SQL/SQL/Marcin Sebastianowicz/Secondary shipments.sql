SELECT sh.shipment_gid
,TO_CHAR(sh.start_time,'YYYY-MM-DD')											sh_start_time
,TO_CHAR(sh.end_time,'YYYY-MM-DD')												sh_end_time
,sh.source_location_gid 														source_loc_id
,s_loc.location_name															source_loc_name
,s_loc_ref.LOCATION_REFNUM_VALUE												source_loc_plant
,s_loc.CITY																		source_loc_city
,s_loc.country_code3_gid														source_loc_country
,s_loc.postal_code																source_loc_postal_code
,sh.dest_location_gid 															dest_loc_id
,d_loc.location_name															dest_loc_name
,d_loc_ref.LOCATION_REFNUM_VALUE												dest_loc_plant
,s_loc.CITY																		dest_loc_city
,d_loc.country_code3_gid														dest_loc_country
,d_loc.postal_code																dest_loc_postal_code
,sh.servprov_gid																tsp_id
,tsp_loc.location_name															tsp_name
,NVL(
(UPPER((SELECT listagg(sh_ref.RATE_GEO_REFNUM_VALUE,'/') within group (order by sh.shipment_gid)
                  FROM rate_geo_refnum sh_ref
                  WHERE sh_ref.rate_geo_gid = sh.rate_geo_gid
                  AND sh_ref.RATE_GEO_REFNUM_QUAL_GID = 'ULE.RG_CATEGORY'))),

(case
         WHEN ( UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
                        FROM shipment_refnum sh_ref
                        WHERE sh_ref.shipment_gid = sh.shipment_gid
                        AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_MATERIAL_TYPE'))) <> 'FINISHED GOODS' THEN

         (UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
                  FROM location_refnum loc_ref
                  WHERE loc_ref.location_gid = sh.DEST_LOCATION_GID
                  AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY'))
                  )
         ELSE
         (UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
               FROM location_refnum loc_ref
               WHERE loc_ref.location_gid = sh.source_location_gid
               AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY' ))
         ) END )
      )                                                                                                                                                                        CATEGORY_PRIMARY
,(UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
                  FROM location_refnum loc_ref
                  WHERE loc_ref.location_gid = sh.DEST_LOCATION_GID
                  AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY'))
                  )	  																																								dest_loc_category
,(UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
                  FROM location_refnum loc_ref
                  WHERE loc_ref.location_gid = sh.source_LOCATION_GID
                  AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY'))
                  )	  																																								source_loc_category				  
	  
	  
	  
	  
	  ,nvl(TRIM(
(SELECT
SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				ELSE 0
				END	)						COST

		        FROM shipment_cost alloc_d

                WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                AND alloc_d.IS_WEIGHTED = 'N'
                AND alloc_d.COST_TYPE in ('B')
)),0)																											                                                    TOTAL_BASE_COST_EUR
,nvl(TRIM(
(SELECT
SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				ELSE 0
				END	)						COST

		        FROM shipment_cost alloc_d

                WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                AND alloc_d.IS_WEIGHTED = 'N'
                AND alloc_d.COST_TYPE in ('A')
				AND alloc_d.accessorial_code_gid not like '%FUEL%'
)),0)																											                                                    TOTAL_ACC_COST_EUR

,nvl(TRIM(
(SELECT
SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				ELSE 0
				END	)						COST

		        FROM shipment_cost alloc_d

                WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                AND alloc_d.IS_WEIGHTED = 'N'
                AND alloc_d.COST_TYPE in ('A')
				AND alloc_d.accessorial_code_gid like '%FUEL%'
)),0)																											                                                    TOTAL_FUEL_COST_EUR
,NVL((SELECT (ST.service_time_value/3600)/24
FROM service_time st
,rate_geo rg
WHERE st.X_LANE_GID = rg.X_LANE_GID
AND rg.RATE_GEO_GID = sh.RATE_GEO_GID


),(sh.end_time-sh.start_time))																																		service_time
,NVL((SELECT 
		
		SUM(
		
		case when LOADED_DISTANCE_UOM_CODE = 'MI' then SH_TEMP.LOADED_DISTANCE*1.609344 when LOADED_DISTANCE_UOM_CODE = 'KM' THEN SH_TEMP.LOADED_DISTANCE ELSE 0 END)
		FROM SHIPMENT SH_TEMP
		WHERE SH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID),0)																											TOTAL_DISTANCE

,(SELECT listagg(la.LANE_ATTRIBUTE_VALUE,',') within group (order by sh.shipment_gid)
FROM lane_attribute la
,rate_geo rg
WHERE la.X_LANE_GID = rg.X_LANE_GID
AND rg.RATE_GEO_GID = sh.RATE_GEO_GID
AND la.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_TRANSPORT_MODE'

)																																										TRANSPORT_MODE
,sh.transport_mode_gid																																					load_type
,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
FROM shipment_s_equipment_join sh_eq_j 
,s_equipment s_eq
WHERE 	
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
	)																																								EQUIPMENT_TYPE
,ROUND(sh.total_weight_base*0.45359237,2)																																PALLET_GROSS_WEIGHT_KG

,ROUND(
case when sh.total_num_reference_units > 0 then sh.total_num_reference_units
else sh.total_ship_unit_count end,2)																								                        PFS




,(SELECT SH_STATUS.STATUS_VALUE_GID
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		)																																								CANCELLATION_STATUS




FROM shipment sh
,location s_loc
LEFT OUTER JOIN location_refnum s_loc_ref ON s_loc_ref.location_gid = s_loc.location_gid and s_loc_ref.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_PLANT'
,location d_loc
LEFT OUTER JOIN location_refnum d_loc_ref ON d_loc_ref.location_gid = d_loc.location_gid and d_loc_ref.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_PLANT'
,location tsp_loc



WHERE 
sh.start_time >= to_date('2016-01-01','YYYY-MM-DD') 
AND sh.start_time < to_date('2016-02-01','YYYY-MM-DD')
AND sh.source_location_gid = s_loc.location_gid
AND sh.dest_location_gid = d_loc.location_gid
ANd sh.servprov_gid = tsp_loc.location_gid

AND	sh.shipment_type_gid <> 'APPOINTMENT'

AND exists
	(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)
AND NOT EXISTS
(SELECT 1
FROM order_movement om
,order_release_refnum or_ref

WHERE om.shipment_gid = sh.shipment_gid
AND or_ref.order_release_gid = om.order_release_gid
AND or_ref.order_release_refnum_qual_gid = 'ULE.ORIGINAL_STREAM'
AND or_ref.order_release_refnum_value = 'PRIMARY')