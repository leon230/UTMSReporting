	select 
	temp.source_location_gid,
			temp.source_loc_name,
			temp.source_loc_city,
			TEMP.POL,
			TEMP.POD,
			temp.dest_location_gid,
			temp.dest_loc_name,
			temp.dest_loc_city,
			TEMP.DANGEROUS,
			TEMP.INCOTERM,
			TEMP.MATERIAL,
			TEMP.CATEGORY,
			TEMP.INTENERARY,
			temp.EQUIPMENT,
			temp.condition,
			-- SUBSTR(TEMP.SERVPROV,5,LENGTH(TEMP.SERVPROV)) SERVPROV,
			count( distinct temp.OR_ID)			number_of_orders
			
			
			
			
			-- SUM(COUNTER_EQUIPMENT) AS NUMBER_OF_TEU,
			
			
	from(
	select DISTINCT 		
				to_char(ORLS.INSERT_DATE,'MM-YYYY')																			ORLS_INSERT_DATE,
				SH.SHIPMENT_GID																								SH_ID,
				orls.order_release_gid																						OR_ID,
				sh.PORT_OF_LOAD_LOCATION_GID																				POL, --dane z SH
				
				sh.PORT_OF_DIS_LOCATION_GID																				POD,
				(SELECT sh_ref_1.ORDER_RELEASE_REFNUM_VALUE
				FROM ORDER_RELEASE_REFNUM sh_ref_1
				WHERE sh_ref_1.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_DG_ORDER'
				AND sh_ref_1.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)													DANGEROUS,	
				
				ORLS.INCO_TERM_GID																							INCOTERM,
				(SELECT sh_ref_1.ORDER_RELEASE_REFNUM_VALUE
				FROM ORDER_RELEASE_REFNUM sh_ref_1
				WHERE sh_ref_1.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE'
				AND sh_ref_1.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)													MATERIAL,	
				
				(SELECT sh_ref_1.ORDER_RELEASE_REFNUM_VALUE
				FROM ORDER_RELEASE_REFNUM sh_ref_1
				WHERE sh_ref_1.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_CATEGORY'
				AND sh_ref_1.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)													CATEGORY,
				
				ORLS.bUY_ITINERARY_PROFILE_GID																				INTENERARY,
				
				(select loc.location_name
					from location loc
				where loc.location_gid = orls.source_location_gid
				)																											source_loc_name,
				(select loc.city
					from location loc
				where loc.location_gid = orls.source_location_gid
				)																											source_loc_city,
				
				(select loc.location_name
					from location loc
				where loc.location_gid = orls.dest_location_gid
				)																											dest_loc_name,
				(select loc.city
					from location loc
				where loc.location_gid = orls.dest_location_gid
				)																											dest_loc_city,
				
				orls.source_location_gid,
				orls.dest_location_gid,
				ORLS.EQUIPMENT_GROUP_GID AS 																				EQUIPMENT,
				substr(orls.EQUIPMENT_GROUP_GID,instr(orls.EQUIPMENT_GROUP_GID,'.')+1,
				instr(orls.EQUIPMENT_GROUP_GID,'_')+1-instr(orls.EQUIPMENT_GROUP_GID,'.')-2) as condition,
				-- SH.SERVPROV_GID AS 																							SERVPROV,
				CASE WHEN ORLS.EQUIPMENT_GROUP_GID IN ('UGO.DRY_40CO','UGO.REF_40HC','UGO.REF_40CO','UGO.DRY_40HC') THEN 2
				ELSE 1
				END AS																										COUNTER_EQUIPMENT
		
				--IMO  - HAZMAT GENERIC ID Z SHIP UNIT ->HAZARDOUS
			
				--CARRIAGE CONDITION NA ORDERZE - D2P ETC
				--Commodity Name   
														  
				--OD 01.06.2015 - YTD
				--SERVICE Z OR OCEAN OUTBOUND/IN-FCL

	from 
	SHIPMENT SH,
	order_release orls,
	VIEW_SHIPMENT_ORDER_RELEASE VORLS

	where 1=1
	AND VORLS.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
	AND VORLS.SHIPMENT_GID = SH.SHIPMENT_GID
	AND SH.DOMAIN_NAME ='UGO'

	and sh.TRANSPORT_MODE_GID
				IN ('UL_OCEAN','UL_LCL')
	and trunc(sh.INSERT_DATE) >= to_date('07-2015','MM-YYYY')
	and sh.servprov_gid = 'ULE.T1050731'
	 

	) temp	
	GROUP BY
	TEMP.POL,
			TEMP.POD,
			temp.source_location_gid,
			temp.source_loc_name,
			temp.source_loc_city,
			temp.dest_loc_name,
			temp.dest_location_gid,
			temp.dest_loc_city,
			TEMP.DANGEROUS,
			TEMP.INCOTERM,
			TEMP.MATERIAL,
			TEMP.CATEGORY,
			TEMP.INTENERARY,
			temp.EQUIPMENT,
			temp.condition
			