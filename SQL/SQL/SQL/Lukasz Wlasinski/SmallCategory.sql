WITH LOCATION_DATA AS (
SELECT loc_temp.location_gid
,loc_temp.location_name
,loc_temp.city
FROM location loc_temp

WHERE
EXISTS
(SELECT 1
 FROM order_release orls
 ,order_movement om
 ,shipment sh
 WHERE
 orls.order_release_gid = om.order_release_gid
 AND om.shipment_gid = sh.shipment_gid
 AND loc_temp.location_gid in (orls.source_location_gid, orls.dest_location_gid, orls.PLAN_FROM_LOCATION_GID, orls.PLAN_TO_LOCATION_GID,
 sh.source_location_gid, sh.dest_location_gid)
 AND NOT EXISTS
    (SELECT 1
        FROM shipment_refnum sh_ref_1
        WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
        AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
        AND sh_ref_1.shipment_gid = sh.shipment_gid)
 AND sh.insert_date >= to_date('2015-01-01','YYYY-MM-DD')
 AND sh.insert_date < to_date('2016-01-01','YYYY-MM-DD')
 )
)
SELECT loc.location_gid
,loc.location_name
,loc.city
,NVL(loc_ref_1.location_refnum_value,'REFNUM_MISSING')           CATEGORY_REFNUM
,NVL(loc_ref_2.location_refnum_value,'REFNUM_MISSING')           SMALL_CATEGORY_REFNUM


FROM LOCATION_DATA loc
LEFT OUTER JOIN location_refnum loc_ref_1 ON (loc_ref_1.location_gid = loc.location_gid AND loc_ref_1.location_refnum_qual_gid = 'ULE.ULE_CATEGORY')
LEFT OUTER JOIN location_refnum loc_ref_2 ON (loc_ref_2.location_gid = loc.location_gid AND loc_ref_2.location_refnum_qual_gid ='ULE.ULE_CATEGORY_SMALL' )

WHERE
loc.location_gid = nvl(:P_LOC,loc.location_gid )
AND
((loc_ref_1.location_refnum_qual_gid is null and loc_ref_2.location_refnum_qual_gid is null)
or (
:P_CATEGORY <> 'ALL' and
(NOT EXISTS
(SELECT 1
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = loc.location_gid

AND(
loc_ref.location_refnum_qual_gid =
CASE WHEN
    :P_CATEGORY = 'CATEGORY SMALL' THEN 'ULE.ULE_CATEGORY_SMALL'
WHEN
    :P_CATEGORY = 'CATEGORY' THEN 'ULE.ULE_CATEGORY'
END
))
)
))
