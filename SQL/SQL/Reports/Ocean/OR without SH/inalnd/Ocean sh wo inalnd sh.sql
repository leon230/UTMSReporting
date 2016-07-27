SELECT SH.SHIPMENT_GID,
orl.ORDER_RELEASE_GID							as ORDER_RELEASE,




(select orls_st.STATUS_VALUE_GID	
	from ORDER_RELEASE_STATUS orls_st
	where orls_st.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orl.ORDER_RELEASE_GID = orls_st.ORDER_RELEASE_GID
	and orls_st.STATUS_TYPE_GID = 'UGO.PLANNING') 																										ORDER_PLANNING_STATUS,
	
	(select orlr_ccc.ORDER_RELEASE_REFNUM_VALUE	
	from ORDER_RELEASE_REFNUM orlr_ccc 
	where orlr_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_CARRIAGE_CONDITION'
	
) 																										CCC,
	
	
	
	
	
	orl.INCO_TERM_GID									as INCOTERM,
	orl.SOURCE_LOCATION_GID								as SOURCE_LOC_ID,
	
	
	
	loc_src.CITY										as SOURCE_LOC_CITY,
	loc_src.COUNTRY_CODE3_GID							as SOURCE_LOC_COUNTRY,
	orl.DEST_LOCATION_GID								as DESTINATION_LOC_ID,
	loc_des.CITY										as DESTINATION_LOC_CITY,
	loc_des.COUNTRY_CODE3_GID							as DESTINATION_LOC_COUNTRY,
	
	
	(select orlr_ccc.ORDER_RELEASE_REFNUM_VALUE	
	from ORDER_RELEASE_REFNUM orlr_ccc 
	where orlr_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_COST CENTER') 																										COST_CENTER,
	(select orlr_ccc.ORDER_RELEASE_REFNUM_VALUE	
	from ORDER_RELEASE_REFNUM orlr_ccc 
	where orlr_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_TRANSPORT_CONDITION') 																										TRANSPORT_CONDITION,
	(select orlr_ccc.ORDER_RELEASE_REFNUM_VALUE	
	from ORDER_RELEASE_REFNUM orlr_ccc 
	where orlr_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_MATERIAL_TYPE') 																										MATERIAL_TYPE,
	(select orlr_ccc.ORDER_RELEASE_REFNUM_VALUE	
	from ORDER_RELEASE_REFNUM orlr_ccc 
	where orlr_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID 
	AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_DG_ORDER') 																										HAZARDOUS,
	

	orl.EQUIPMENT_GROUP_GID								as EQUIPMENT_GROUP,
	
	
	
	to_char((From_tz(cast(orl.EARLY_PICKUP_DATE AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')	as early_pickup_CET,
	to_char((From_tz(cast(orl.LATE_PICKUP_DATE AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')		as late_pickup_CET,
	to_char((From_tz(cast(orl.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')	as early_delivery_CET,
	to_char((From_tz(cast(orl.LATE_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')	as late_delivery_CET,
	orl.INSERT_USER										as order_insert_user,
(select listagg(vorls.shipment_gid,'/') within group (order by orl.ORDER_RELEASE_GID)
		from VIEW_SHIPMENT_ORDER_RELEASE vorls,
				shipment sh_temp
		where vorls.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
		and sh_temp.shipment_gid = vorls.shipment_gid
		and sh_temp.source_location_gid = orl.source_location_gid
	
	
		)																														Inland_pre_shipment,
		(select listagg(vorls.shipment_gid,'/') within group (order by orl.ORDER_RELEASE_GID)
			from VIEW_SHIPMENT_ORDER_RELEASE vorls,
					shipment sh_temp
			where vorls.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
			and sh_temp.shipment_gid = vorls.shipment_gid
			and sh_temp.dest_location_gid = orl.dest_location_gid
	
	
		)																														Inland_post_shipment
	
	
	
	
FROM
	ORDER_RELEASE orl,
	LOCATION loc_src,
	LOCATION loc_des,
	ORDER_MOVEMENT OM,
	SHIPMENT SH
	
WHERE
	
	 orl.DOMAIN_NAME = 'UGO'
	
	and loc_src.LOCATION_GID = orl.SOURCE_LOCATION_GID
	and loc_des.LOCATION_GID = orl.DEST_LOCATION_GID
	
	AND OM.ORDER_RELEASE_GID = ORL.ORDER_RELEASE_GID
	AND SH.SHIPMENT_GID = OM.SHIPMENT_GID
	AND SH.TRANSPORT_MODE_GID  in ( 'UL_OCEAN','UL_LCL','AIR')
	
	and to_char(trunc(sh.insert_date),'YYYY') = :P_YEAR
	
	
