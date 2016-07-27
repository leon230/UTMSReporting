SELECT sh.SHIPMENT_GID										as shipment,
	sh.INSERT_USER											as shipment_insert_user,
	shs.STATUS_VALUE_GID									as shipment_status,
	sh.INDICATOR											as indicator_colour,
	sh.SERVPROV_GID											as tsp_id,
	loc_sv.LOCATION_NAME									as tsp_name,
	sh.SOURCE_LOCATION_GID									as source_loc_id,
	loc_src.CITY											as source_loc_city,
	loc_src.COUNTRY_CODE3_GID								as source_loc_country,
	sh.PORT_OF_LOAD_LOCATION_GID							as POL,
	sh.PORT_OF_DIS_LOCATION_GID								as POD,
	sh.DEST_LOCATION_GID									as destination_loc_id,
	loc_des.CITY											as destination_loc_city,
	loc_des.COUNTRY_CODE3_GID								as destination_loc_country,
	sh.FIRST_EQUIPMENT_GROUP_GID							as first_equipment,
	sh.TRANSPORT_MODE_GID									as shipment_mode,
	to_char((From_tz(cast(sh.start_time+7 AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')	as shipment_start_time_CET,
	to_char((From_tz(cast(sh.end_time+7 AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET'), 'DD-MM-YYYY HH24:MI')		as shipment_end_time_CET
	
FROM
	SHIPMENT sh,
	SHIPMENT_STATUS shs,
	LOCATION LOC_SV,
	LOCATION LOC_SRC,
	LOCATION LOC_DES
	
	
WHERE
	sh.SHIPMENT_GID = shs.SHIPMENT_GID
	and shs.STATUS_TYPE_GID = 'UGO.SECURE RESOURCES'
	and shs.STATUS_VALUE_GID != 'UGO.SECURE RESOURCES_ACCEPTED'
	and sh.TRANSPORT_MODE_GID in ('UL_OCEAN','UL_LCL')
	and sh.DOMAIN_NAME = 'UGO'
	and sh.SERVPROV_GID = loc_sv.LOCATION_GID
	and	loc_src.LOCATION_GID = sh.SOURCE_LOCATION_GID
	and loc_des.LOCATION_GID = sh.DEST_LOCATION_GID