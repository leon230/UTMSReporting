SELECT orl.ORDER_RELEASE_GID							as ORDER_RELEASE,
	orls.STATUS_VALUE_GID								as ORDER_PLANNING_STATUS,
	orlr_ccc.ORDER_RELEASE_REFNUM_VALUE					as CCC,
	orl.INCO_TERM_GID									as INCOTERM,
	orl.SOURCE_LOCATION_GID								as SOURCE_LOC_ID,
	loc_src.CITY										as SOURCE_LOC_CITY,
	loc_src.COUNTRY_CODE3_GID							as SOURCE_LOC_COUNTRY,
	orl.DEST_LOCATION_GID								as DESTINATION_LOC_ID,
	loc_des.CITY										as DESTINATION_LOC_CITY,
	loc_des.COUNTRY_CODE3_GID							as DESTINATION_LOC_COUNTRY,
	orlr_cc.ORDER_RELEASE_REFNUM_VALUE					as COST_CENTER,
	orlr_mattype.ORDER_RELEASE_REFNUM_VALUE				as MATERIAL_TYPE,
	orlr_cond.ORDER_RELEASE_REFNUM_VALUE				as TRANSPORT_CONDITION,
	orlr_hazmat.ORDER_RELEASE_REFNUM_VALUE				as HAZARDOUS,
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
	ORDER_RELEASE_STATUS orls,
	ORDER_RELEASE or_ccc
	left outer join ORDER_RELEASE_REFNUM orlr_ccc on (orlr_ccc.ORDER_RELEASE_GID = or_ccc.ORDER_RELEASE_GID AND orlr_ccc.ORDER_RELEASE_REFNUM_QUAL_GID = 'UGO.ULE_CARRIAGE_CONDITION'),
	ORDER_RELEASE or_cc
	left outer join ORDER_RELEASE_REFNUM orlr_cc on (orlr_cc.ORDER_RELEASE_GID = or_cc.ORDER_RELEASE_GID AND orlr_cc.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_COST CENTER'),	
	ORDER_RELEASE or_cond
	left outer join ORDER_RELEASE_REFNUM orlr_cond on (orlr_cond.ORDER_RELEASE_GID = or_cond.ORDER_RELEASE_GID AND orlr_cond.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'),	
	ORDER_RELEASE or_mattype
	left outer join ORDER_RELEASE_REFNUM orlr_mattype on (orlr_mattype.ORDER_RELEASE_GID = or_mattype.ORDER_RELEASE_GID AND orlr_mattype.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE'),
	ORDER_RELEASE or_hazmat
	left outer join ORDER_RELEASE_REFNUM orlr_hazmat on (orlr_hazmat.ORDER_RELEASE_GID = or_hazmat.ORDER_RELEASE_GID AND orlr_hazmat.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_DG_ORDER'),	
	LOCATION loc_src,
	LOCATION loc_des	
	
WHERE
	orl.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
	and orl.DOMAIN_NAME = 'UGO'
	and orls.STATUS_TYPE_GID = 'UGO.PLANNING'
	and loc_src.LOCATION_GID = orl.SOURCE_LOCATION_GID
	and loc_des.LOCATION_GID = orl.DEST_LOCATION_GID
	and or_ccc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
	and or_cc.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
	and or_cond.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
	and or_mattype.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
	and or_hazmat.ORDER_RELEASE_GID = orl.ORDER_RELEASE_GID
	and orl.order_release_gid not in
		(select v_or_sh.order_release_gid 
		from shipment shp,
			View_Shipment_Order_Release v_or_sh
		where 
			(TRANSPORT_MODE_GID = 'UL_OCEAN' 
			or TRANSPORT_MODE_GID = 'UL_LCL'
			or TRANSPORT_MODE_GID = 'AIR')
			and v_or_sh.shipment_gid = shp.shipment_gid)
			
			
	AND orl.EQUIPMENT_GROUP_GID	<> 'UGO.LCL-DRY'