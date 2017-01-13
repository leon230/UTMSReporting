select temp.PICK_LOC,
temp.PICK_LOC_POSTAL,
temp.source_city,
TEMP.DEST_LOC,
temp.DEST_LOC_POSTAL,
temp.dest_city,
temp.COUNTRY_CODE3_GID,
-- temp.sh_TOTAL_WEIGHT_KG,
-- count(temp.SHIPMENT_GID) num_shipments,

-- COUNT(CASE WHEN TEMP.PAL_RANGE = '0-300' THEN temp.SHIPMENT_GID END) PAL_300,
-- COUNT(CASE WHEN TEMP.PAL_RANGE = '301-500' THEN temp.SHIPMENT_GID END ) PAL_500,
-- COUNT(CASE WHEN TEMP.PAL_RANGE = '501-1000' THEN temp.SHIPMENT_GID END ) PAL_1000,
-- COUNT(CASE WHEN TEMP.PAL_RANGE = '1001-2000' THEN temp.SHIPMENT_GID END ) PAL_2000,
-- COUNT(CASE WHEN TEMP.PAL_RANGE = '2001-10000' THEN temp.SHIPMENT_GID END ) PAL_10000,
-- COUNT(CASE WHEN TEMP.PAL_RANGE = 'OVER 10000' THEN temp.SHIPMENT_GID END ) PAL_OVER_10000

SUM(CASE WHEN TEMP.PAL_RANGE = '0-300' THEN temp.sh_TOTAL_WEIGHT_KG END) PAL_300,
SUM(CASE WHEN TEMP.PAL_RANGE = '301-500' THEN temp.sh_TOTAL_WEIGHT_KG END ) PAL_500,
SUM(CASE WHEN TEMP.PAL_RANGE = '501-1000' THEN temp.sh_TOTAL_WEIGHT_KG END ) PAL_1000,
SUM(CASE WHEN TEMP.PAL_RANGE = '1001-2000' THEN temp.sh_TOTAL_WEIGHT_KG END ) PAL_2000,
SUM(CASE WHEN TEMP.PAL_RANGE = '2001-10000' THEN temp.sh_TOTAL_WEIGHT_KG END ) PAL_10000,
SUM(CASE WHEN TEMP.PAL_RANGE = 'OVER 10000' THEN temp.sh_TOTAL_WEIGHT_KG END ) PAL_OVER_10000



from (
SELECT sh.SHIPMENT_GID,
ord_rel.ORDER_RELEASE_GID
,del_loc.COUNTRY_CODE3_GID

,NVL(TRIM(TO_CHAR(sh.TOTAL_WEIGHT_BASE*0.45359237,'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')),'-')									sh_TOTAL_WEIGHT_KG,


case when sh.TOTAL_WEIGHT_BASE*0.45359237 >=0 and sh.TOTAL_WEIGHT_BASE*0.45359237 <=300 then '0-300'

when sh.TOTAL_WEIGHT_BASE*0.45359237 >=301 and sh.TOTAL_WEIGHT_BASE*0.45359237 <=500 then '301-500'

when sh.TOTAL_WEIGHT_BASE*0.45359237 >=501 and sh.TOTAL_WEIGHT_BASE*0.45359237 <=1000 then '501-1000'

when sh.TOTAL_WEIGHT_BASE*0.45359237 >=1001 and sh.TOTAL_WEIGHT_BASE*0.45359237 <=2000 then '1001-2000'

when sh.TOTAL_WEIGHT_BASE*0.45359237 >=2001 and sh.TOTAL_WEIGHT_BASE*0.45359237 <=10000 then '2001-10000'

when sh.TOTAL_WEIGHT_BASE*0.45359237 >=10001 then	'OVER 10000'

end 																														AS PAL_RANGE,

sh.SOURCE_LOCATION_GID PICK_LOC,
pic_loc.LOCATION_NAME PICK_LOCK_NAME,
pic_loc.city             source_city,
pic_loc.COUNTRY_CODE3_GID PICK_LOC_COUNTRY,
pic_loc.POSTAL_CODE PICK_LOC_POSTAL,
sh.DEST_LOCATION_GID DEST_LOC,
del_loc.LOCATION_NAME DEST_LOC_NAME,
del_loc.city                    dest_city,
del_loc.POSTAL_CODE DEST_LOC_POSTAL,
del_loc.COUNTRY_CODE3_GID DEST_LOC_COUNTRY,


-- ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE,


coalesce((TO_NUMBER((case when ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE is null then '0'
		else

		((TRIM(TO_CHAR(replace(ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),sh.total_ship_unit_count)																													or_pallets,

ord_rel_STR.ORDER_RELEASE_REFNUM_VALUE,
-- ord_rel.TOTAL_WEIGHT OR_TOTAL_WEIGHT,
-- ord_mov.TOTAL_WEIGHT_UOM_CODE,
sh.SERVPROV_GID TSP_ID
-- al_ord_rel_d.COST_DESCRIPTION,
-- al_ord_rel_d.ACCESSORIAL_CODE_GID,
-- al_ord_rel_d.COST,
-- al_ord_rel_d.COST_CURRENCY_GID
FROM
SHIPMENT sh
join LOCATION pic_loc on sh.source_location_gid = pic_loc.location_gid
join LOCATION del_loc on sh.dest_location_gid = del_loc.location_gid
join ORDER_MOVEMENT ord_mov on sh.shipment_gid = ord_mov.shipment_gid
join ORDER_RELEASE ord_rel on ord_mov.order_release_gid = ord_rel.order_release_gid
left outer join ORDER_RELEASE_REFNUM ord_rel_ref on ord_rel.order_release_gid = ord_rel_ref.order_release_gid and ord_rel_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS'
join ORDER_RELEASE_REFNUM ord_rel_STR on ord_rel.order_release_gid = ord_rel_STR.order_release_gid and ord_rel_STR.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM' and ord_rel_STR.ORDER_RELEASE_REFNUM_VALUE = 'SECONDARY'
-- join ALLOCATION_ORDER_RELEASE_D al_ord_rel_d on ord_rel.order_release_gid = al_ord_rel_d.order_release_gid
WHERE
-- pic_loc.COUNTRY_CODE3_GID in ('SWE')
-- and
--del_loc.COUNTRY_CODE3_GID in ('SWE','FIN')
trunc(ord_rel.LATE_DELIVERY_DATE) >= to_date('2015-11-01','YYYY-MM-DD')
and trunc(ord_rel.LATE_DELIVERY_DATE) <= to_date('2016-10-31','YYYY-MM-DD')
and sh.source_location_gid in ('ULE.V207493')
) temp

group by
temp.PICK_LOC,
temp.PICK_LOC_POSTAL,
temp.source_city,
TEMP.DEST_LOC,
temp.DEST_LOC_POSTAL,
temp.dest_city,
temp.COUNTRY_CODE3_GID
-- temp.sh_TOTAL_WEIGHT_KG