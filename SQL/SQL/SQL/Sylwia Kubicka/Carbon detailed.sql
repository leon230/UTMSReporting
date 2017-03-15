SELECT distinct
	to_char(sh.END_TIME, 'MM-YYYY')                                                  													Shipment_Delivery_Month,
	to_char(sh.END_TIME, 'YYYY') 																								   		Shipment_Delivery_Year,
    (select loc.LOCATION_REFNUM_VALUE
	from location_refnum loc
	where loc.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY'
	and loc.location_gid = sh.source_location_gid)                                                                                Material_Category

    ,(select loc.LOCATION_REFNUM_VALUE
    	from location_refnum loc
    	where loc.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY_SMALL'
    	and loc.location_gid = sh.source_location_gid)                                                                                Material_Category_small
    ,case when sh_source.COUNTRY_CODE3_GID	= sh_dest.COUNTRY_CODE3_GID	then 'NATIONAL' ELSE 'INTERNATIONAL' END AS                     National_international
    ,null                                                                                                                                SOURCE_CLUSTER
    ,sh_source.COUNTRY_CODE3_GID																											SH_SOURCE_COUNTRY,
    sh_source.CITY  																													SH_SOURCE_CITY,
	nvl(rpt_general.f_remove_domain(sh.SOURCE_LOCATION_GID),'n/a')																	ORLS_Source_ID,

	null                                                                                                                               DEST_CLUSTER
	,sh_dest.COUNTRY_CODE3_GID																											SH_DESTINATION_COUNTRY,
	sh_dest.CITY																														SH_DESTINATION_CITY,
	nvl(rpt_general.f_remove_domain(sh.DEST_LOCATION_GID),'n/a')																		ORLS_Dest_ID,
    nvl(rpt_general.f_remove_domain(orls.SOURCE_LOCATION_GID),'n/a')||' '||nvl(rpt_general.f_remove_domain(orls.DEST_LOCATION_GID),'n/a')	KEY_id
    ,sh.shipment_xid 																												   	Shipment_Number,
	nvl(rpt_general.f_remove_domain(sh.FIRST_EQUIPMENT_GROUP_GID),'n/a')																Shipment_Equipment_Type,
    COALESCE(rpt_general.f_remove_domain(sh.RATE_GEO_GID),rpt_general.f_remove_domain(sh.PLANNED_RATE_GEO_GID),'n/a')					Rate_Record,
    SH.NUM_ORDER_RELEASES                                                                                                               number_of_order_releases
    ,SH.TOTAL_SHIP_UNIT_COUNT 	 																										THU_PER_SHIPMENT
    ,(SELECT nvl(listagg(orr_trans_cond.ORDER_RELEASE_REFNUM_VALUE,'; ') WITHIN GROUP (ORDER BY orr_trans_cond.ORDER_RELEASE_REFNUM_VALUE),'n/a')
	FROM
		ORDER_RELEASE_REFNUM orr_trans_cond
	WHERE
		orls.ORDER_RELEASE_GID = orr_trans_cond.ORDER_RELEASE_GID
		AND orr_trans_cond.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION')												Transport_Condition,
    sh.TRANSPORT_MODE_GID 																											   	Shipment_Transport_Mode,
    NVL(TRIM(TO_CHAR(ROUND((orls.TOTAL_WEIGHT_BASE * 0.45359237)/1000,5),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'n/a')						Order_Gross_Weight_KG,
    null                                                                                                                                   vechicle_capacity_tonnes
    ,null                                                                                                                                   unilever_loadfill_rounded
    ,null                                                                                                                                   vehicle_loadfill_rounded
	,(SELECT nvl(listagg(l_att_mode.LANE_ATTRIBUTE_VALUE,'; ') WITHIN GROUP (ORDER BY l_att_mode.LANE_ATTRIBUTE_VALUE),'n/a')
		FROM
			RATE_GEO r_geo_mode,
			X_LANE x_mode,
			LANE_ATTRIBUTE l_att_mode
		WHERE
			sh.RATE_GEO_GID = r_geo_mode.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_mode.X_LANE_GID = x_mode.X_LANE_GID
			AND x_mode.X_LANE_GID = l_att_mode.X_LANE_GID
			AND l_att_mode.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_TRANSPORT_MODE'
			AND l_att_mode.DOMAIN_NAME = 'ULE/PR')																						LANE_TRANSPORT_MODE,
    nvl((SELECT l_att_rd_eq.LANE_ATTRIBUTE_VALUE
		FROM
			RATE_GEO r_geo_rd_eq,
			X_LANE x_rd_eq,
			LANE_ATTRIBUTE l_att_rd_eq
		WHERE
			sh.RATE_GEO_GID = r_geo_rd_eq.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_rd_eq.X_LANE_GID = x_rd_eq.X_LANE_GID
			AND x_rd_eq.X_LANE_GID = l_att_rd_eq.X_LANE_GID
			AND l_att_rd_eq.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_ROAD_EQUIPMENT_TYPE'
			AND l_att_rd_eq.DOMAIN_NAME = 'ULE/PR'),'n/a')																			    ROAD_EQUIPMENT_TYPE,
    nvl((SELECT l_att_r_eq.LANE_ATTRIBUTE_VALUE
		FROM
			RATE_GEO r_geo_r_eq,
			X_LANE x_r_eq,
			LANE_ATTRIBUTE l_att_r_eq
		WHERE
			sh.RATE_GEO_GID = r_geo_r_eq.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_r_eq.X_LANE_GID = x_r_eq.X_LANE_GID
			AND x_r_eq.X_LANE_GID = l_att_r_eq.X_LANE_GID
			AND l_att_r_eq.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_RAIL_EQUIPMENT_TYPE'
			AND l_att_r_eq.DOMAIN_NAME = 'ULE/PR'),'n/a')																			    RAIL_EQUIPMENT_TYPE,
    nvl((SELECT l_att_w_eq.LANE_ATTRIBUTE_VALUE
		FROM
			RATE_GEO r_geo_w_eq,
			X_LANE x_w_eq,
			LANE_ATTRIBUTE l_att_w_eq
		WHERE
			sh.RATE_GEO_GID = r_geo_w_eq.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_w_eq.X_LANE_GID = x_w_eq.X_LANE_GID
			AND x_w_eq.X_LANE_GID = l_att_w_eq.X_LANE_GID
			AND l_att_w_eq.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_WATER_EQUIPMENT_TYPE'
			AND l_att_w_eq.DOMAIN_NAME = 'ULE/PR'),'n/a')																			    WATER_EQUIPMENT_TYPE,

    nvl((SELECT ltrim(to_char(l_att_rd_dist.LANE_ATTRIBUTE_VALUE,'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))
		FROM
			RATE_GEO r_geo_rd_dist,
			X_LANE x_rd_dist,
			LANE_ATTRIBUTE l_att_rd_dist
		WHERE
			sh.RATE_GEO_GID = r_geo_rd_dist.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_rd_dist.X_LANE_GID = x_rd_dist.X_LANE_GID
			AND x_rd_dist.X_LANE_GID = l_att_rd_dist.X_LANE_GID
			AND l_att_rd_dist.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_ROAD_DISTANCE'
			AND l_att_rd_dist.DOMAIN_NAME = 'ULE/PR'),'n/a')																			ROAD_DISTANCE,

	nvl((SELECT ltrim(to_char(l_att_r_dist.LANE_ATTRIBUTE_VALUE,'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))
		FROM
			RATE_GEO r_geo_r_dist,
			X_LANE x_r_dist,
			LANE_ATTRIBUTE l_att_r_dist
		WHERE
			sh.RATE_GEO_GID = r_geo_r_dist.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_r_dist.X_LANE_GID = x_r_dist.X_LANE_GID
			AND x_r_dist.X_LANE_GID = l_att_r_dist.X_LANE_GID
			AND l_att_r_dist.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_RAIL_DISTANCE'
			AND l_att_r_dist.DOMAIN_NAME = 'ULE/PR'),'n/a')																			    RAIL_DISTANCE,

	nvl((SELECT ltrim(to_char(l_att_w_dist.LANE_ATTRIBUTE_VALUE,'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))
		FROM
			RATE_GEO r_geo_w_dist,
			X_LANE x_w_dist,
			LANE_ATTRIBUTE l_att_w_dist
		WHERE
			sh.RATE_GEO_GID = r_geo_w_dist.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND r_geo_w_dist.X_LANE_GID = x_w_dist.X_LANE_GID
			AND x_w_dist.X_LANE_GID = l_att_w_dist.X_LANE_GID
			AND l_att_w_dist.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_WATER_DISTANCE'
			AND l_att_w_dist.DOMAIN_NAME = 'ULE/PR'),'n/a')																			    WATER_DISTANCE,

        null                                                                                                                                   total_distance
        ,null                                                                                                                                   road_ef
        ,null                                                                                                                                   rail_ef
        ,null                                                                                                                                   water_ef
        ,nvl((SELECT R_REF_TECH_NAME.RATE_GEO_REFNUM_VALUE
		FROM
			RATE_GEO R_GEO_TECH_NAME,
			RATE_GEO_REFNUM R_REF_TECH_NAME

		WHERE
			sh.RATE_GEO_GID = R_GEO_TECH_NAME.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND R_GEO_TECH_NAME.RATE_GEO_GID = R_REF_TECH_NAME.RATE_GEO_GID
			AND R_REF_TECH_NAME.RATE_GEO_REFNUM_QUAL_GID = 'UL_TECHNOLOGY_NAME'),'n/a')													TECHNOLOGY_NAME

        ,nvl((SELECT R_REF_TECH_FACT.RATE_GEO_REFNUM_VALUE
		FROM
			RATE_GEO R_GEO_TECH_FACT,
			RATE_GEO_REFNUM R_REF_TECH_FACT

		WHERE
			sh.RATE_GEO_GID = R_GEO_TECH_FACT.RATE_GEO_GID
			AND sh.DOMAIN_NAME = 'ULE/PR'
			AND R_GEO_TECH_FACT.RATE_GEO_GID = R_REF_TECH_FACT.RATE_GEO_GID
			AND R_REF_TECH_FACT.RATE_GEO_REFNUM_QUAL_GID = 'UL_TECHNOLOGY_FACTOR'),'n/a')												TECHNOLOGY_FACTOR

        ,rpt_general.f_remove_domain(SH.SERVPROV_GID)																						SERVICE_PROVIDER_ID
        ,null                                                                                                                                   aero_factor
        ,null                                                                                                                                   dt_factor
	,orls.order_release_xid 																											   	Order_Number,

	nvl((SELECT nvl(listagg(CO2_VAL.SHIPMENT_REFNUM_VALUE,'; ') WITHIN GROUP (ORDER BY CO2_VAL.SHIPMENT_REFNUM_VALUE),'n/a')
	FROM
		shipment_refnum CO2_VAL
	WHERE
		SH.SHIPMENT_GID = CO2_VAL.SHIPMENT_GID
		AND	CO2_VAL.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_CO2_VALUE'),'n/a')																CO2_VALUE

FROM
	SHIPMENT sh,
	SHIPMENT_STOP ss,
	SHIPMENT_STOP_D ssd,
	S_SHIP_UNIT ssu,
	S_SHIP_UNIT_LINE ssul,
	ORDER_RELEASE orls,
	LOCATION sh_source,
	LOCATION sh_dest,
	LOCATION ORLS_SOURCE,
	LOCATION ORLS_DEST


WHERE
	sh.DOMAIN_NAME IN ('ULE/PR','ULE')
    AND sh.TRANSPORT_MODE_GID <> 'HANDLING'
	AND ss.shipment_gid = sh.shipment_gid
	AND ssd.SHIPMENT_GID = ss.SHIPMENT_GID
	AND ssd.stop_num = ss.stop_num
	AND ssd.S_SHIP_UNIT_GID = ssu.S_SHIP_UNIT_GID
	AND ssu.S_SHIP_UNIT_GID = ssul.S_SHIP_UNIT_GID
	AND ssul.order_release_gid = orls.order_release_gid
	AND sh_source.LOCATION_GID = sh.SOURCE_LOCATION_GID
	AND sh_dest.LOCATION_GID = sh.DEST_LOCATION_GID
	AND ORLS_SOURCE.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
	AND ORLS_DEST.LOCATION_GID = ORLS.DEST_LOCATION_GID
	AND ss.STOP_TYPE = 'D'
	AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)

	AND TO_CHAR(sh.END_TIME,'MM') = :P_MONTH
	AND TO_CHAR(sh.END_TIME,'YYYY') = :P_YEAR

	AND 	(SELECT nvl(sr_region.SHIPMENT_REFNUM_VALUE,'n/a')
        	FROM
        		shipment_refnum sr_region
        	WHERE
        		sh.shipment_gid = sr_region.shipment_gid
        		AND sr_region.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION') NOT IN ('BULK','INBOUND')

    and exists (SELECT 1
    FROM
        ORDER_RELEASE_REFNUM orr_mat_type
    WHERE
        orls.ORDER_RELEASE_GID = orr_mat_type.ORDER_RELEASE_GID
        AND orr_mat_type.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE'
        and orr_mat_type.ORDER_RELEASE_REFNUM_VALUE in ('FINISHED GOODS') )

    and not exists (SELECT 1
        	FROM
        		SHIPMENT_STATUS SHS_STATUS
        	WHERE
        		sh.SHIPMENT_GID = SHS_STATUS.SHIPMENT_GID AND SHS_STATUS.STATUS_TYPE_GID = 'ULE/PR.ENROUTE'
        		and SHS_STATUS.STATUS_VALUE_GID = 'ENROUTE_NOT STARTED')

    and not exists	(SELECT 1
        	FROM
        		SHIPMENT_STATUS SHS_STATUS_CANC
        	WHERE
        		sh.SHIPMENT_GID = SHS_STATUS_CANC.SHIPMENT_GID AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
        		and SHS_STATUS_CANC.STATUS_VALUE_GID = 'ULE/PR.CANCELLED')