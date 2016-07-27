SELECT sh.shipment_gid
,sh.servprov_gid
,(select loc.location_name
FROM location loc
WHERE loc.location_gid = sh.servprov_gid
)																																	TSP_NAME
,sh.transport_mode_gid
,sh.num_stops																							NUMBER_OF_STOPS
,sh.source_location_gid
,(SELECT LISTAGG(loc_ref.location_refnum_value,'/') WITHIN GROUP (ORDER BY sh.dest_location_gid)
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.source_location_gid
AND loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE')																															SOURCE_LOC_TYPE

,sh.dest_location_gid

,(SELECT LISTAGG(loc_ref.location_refnum_value,'/') WITHIN GROUP (ORDER BY sh.dest_location_gid)
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.dest_location_gid
AND loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE')																															DEST_LOC_TYPE

,(SELECT LISTAGG(sh_ref_1.shipment_refnum_value,'/') WITHIN GROUP (ORDER BY sh.shipment_gid)
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)																									SHIPMENT_STREAM	
,TO_CHAR(SH.START_TIME,'YYYY-MM-DD HH24:MI')																											SHIPMENT_START_TIME
,TO_CHAR(SH.END_TIME,'YYYY-MM-DD HH24:MI')																											SHIPMENT_END_TIME
,NVL(ST.SERVICE_TIME_VALUE/3600,ROUND((SH.END_TIME - SH.START_TIME) * 24,2))																		TRANSIT_TIME_HOURS							





FROM shipment sh
LEFT OUTER JOIN rate_geo rg ON (rg.rate_geo_gid = sh.rate_geo_gid)
LEFT OUTER JOIN service_time st ON (st.x_lane_gid = rg.x_lane_gid)

WHERE 
to_char(sh.start_time,'YYYY') = '2016'
AND to_char(sh.start_time,'MM') = '04'
-- AND SH.SERVPROV_GID IN ('ULE.T1044945','ULE.T1119521','ULE.T200747','ULE.T901558','ULE.T76180','ULE.T46583','ULE.T103','ULE.T50428294','ULE.T1107541','ULE.T1037455','ULE.T1123830','ULE.T83457','ULE.T4912116','ULE.T130982','ULE.T4910405','ULE.T206201','ULE.T80922','ULE.T50432216','ULE.T1064124','ULE.T230846','ULE.T142464','ULE.T39761','ULE.T200185','ULE.T1095551','ULE.T58010','ULE.T1034610','ULE.T1047787','ULE.T3300109','ULE.T1055320','ULE.T231617','ULE.T1108904','ULE.T4910526','ULE.T83007','ULE.T91394','ULE.T1028260','ULE.T1104003','ULE.T9471','ULE.T952118','ULE.T1093117','ULE.T1118963')
AND SH.SERVPROV_GID IN ('ULE.T3002170','ULE.T1105438','ULE.T447382','ULE.T991329','ULE.T9811725','ULE.T1010119','ULE.T921152','ULE.T34509','ULE.T181620','ULE.T50477540','ULE.T18833','ULE.T1106583','ULE.T1092555','ULE.T3699','ULE.T1063009','ULE.T30671','ULE.T50359191','ULE.T200689','ULE.T222098','ULE.T50269041','ULE.T231113','ULE.T1045618','ULE.T97961','ULE.T97941','ULE.T7984','ULE.T221977','ULE.T328653','ULE.T1024177','ULE.T9810102','ULE.T1116776','ULE.T98033','ULE.T50474650','ULE.T80278','ULE.T1124797','ULE.T50269173','ULE.T6282','ULE.T50418328','ULE.T1019034','ULE.T1044743','ULE.T98014','ULE.T85620','ULE.T800998','ULE.T1036765','ULE.T922825','ULE.T50356754','ULE.T50485599','ULE.T1082711','ULE.T50417498','ULE.T233254','ULE.T70525','ULE.T1098219','ULE.T97929','ULE.T218827','ULE.T50479889','ULE.T1108188','ULE.T1033384','ULE.T1080080','ULE.T1103190','ULE.T92230','ULE.T199741')