SELECT COUNT(TEMP.SHIPMENT_GID)
FROM (
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
TO_CHAR(sh.start_time,'YYYY') = '2016'
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
)TEMP