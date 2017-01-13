select temp.PICK_LOC,
temp.PICK_LOC_POSTAL,
temp.source_city,
TEMP.DEST_LOC,
temp.dest_city,

temp.DEST_LOC_POSTAL,
count(case when temp.or_pallets = '1' then temp.SHIPMENT_GID end) pal_1,
count(case when temp.or_pallets = '2' then temp.SHIPMENT_GID end) pal_2,
count(case when temp.or_pallets = '3' then temp.SHIPMENT_GID end) pal_3,
count(case when temp.or_pallets = '4' then temp.SHIPMENT_GID end) pal_4,
count(case when temp.or_pallets = '5' then temp.SHIPMENT_GID end) pal_5,
count(case when temp.or_pallets = '6' then temp.SHIPMENT_GID end) pal_6,
count(case when temp.or_pallets = '7' then temp.SHIPMENT_GID end) pal_7,
count(case when temp.or_pallets = '8' then temp.SHIPMENT_GID end) pal_8,
count(case when temp.or_pallets = '9' then temp.SHIPMENT_GID end) pal_9,
count(case when temp.or_pallets = '10' then temp.SHIPMENT_GID end) pal_10,
count(case when temp.or_pallets = '11' then temp.SHIPMENT_GID end) pal_11,
count(case when temp.or_pallets = '12' then temp.SHIPMENT_GID end) pal_12,
count(case when temp.or_pallets = '13' then temp.SHIPMENT_GID end) pal_13,
count(case when temp.or_pallets = '14' then temp.SHIPMENT_GID end) pal_14,
count(case when temp.or_pallets = '15' then temp.SHIPMENT_GID end) pal_15,
count(case when temp.or_pallets = '16' then temp.SHIPMENT_GID end) pal_16,
count(case when temp.or_pallets = '17' then temp.SHIPMENT_GID end) pal_17,
count(case when temp.or_pallets = '18' then temp.SHIPMENT_GID end) pal_18,
count(case when temp.or_pallets = '19' then temp.SHIPMENT_GID end) pal_19,
count(case when temp.or_pallets = '20' then temp.SHIPMENT_GID end) pal_20,
count(case when temp.or_pallets = '21' then temp.SHIPMENT_GID end) pal_21,
count(case when temp.or_pallets = '22' then temp.SHIPMENT_GID end) pal_22,
count(case when temp.or_pallets = '23' then temp.SHIPMENT_GID end) pal_23,
count(case when temp.or_pallets = '24' then temp.SHIPMENT_GID end) pal_24,
count(case when temp.or_pallets = '25' then temp.SHIPMENT_GID end) pal_25,
count(case when temp.or_pallets = '26' then temp.SHIPMENT_GID end) pal_26,
count(case when temp.or_pallets = '27' then temp.SHIPMENT_GID end) pal_27,
count(case when temp.or_pallets = '28' then temp.SHIPMENT_GID end) pal_28,
count(case when temp.or_pallets = '29' then temp.SHIPMENT_GID end) pal_29,
count(case when temp.or_pallets = '30' then temp.SHIPMENT_GID end) pal_30,
count(case when temp.or_pallets = '31' then temp.SHIPMENT_GID end) pal_31,
count(case when temp.or_pallets = '32' then temp.SHIPMENT_GID end) pal_32,
count(case when temp.or_pallets = '33' then temp.SHIPMENT_GID end) pal_33



from (
SELECT sh.SHIPMENT_GID,
ord_rel.ORDER_RELEASE_GID,


sh.SOURCE_LOCATION_GID PICK_LOC,
pic_loc.LOCATION_NAME PICK_LOCK_NAME,
pic_loc.COUNTRY_CODE3_GID PICK_LOC_COUNTRY,
pic_loc.POSTAL_CODE PICK_LOC_POSTAL,
pic_loc.city             source_city,
sh.DEST_LOCATION_GID DEST_LOC,
del_loc.LOCATION_NAME DEST_LOC_NAME,
del_loc.POSTAL_CODE DEST_LOC_POSTAL,
del_loc.COUNTRY_CODE3_GID DEST_LOC_COUNTRY,
del_loc.city                    dest_city,


-- ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE,

--coalesce((TO_NUMBER((case when REGEXP_LIKE(ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
coalesce((TO_NUMBER((case when ord_rel_ref.ORDER_RELEASE_REFNUM_VALUE is null  then '0'
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
del_loc.COUNTRY_CODE3_GID in ('SWE')

and trunc(ord_rel.LATE_DELIVERY_DATE) >= to_date('2015-11-01','YYYY-MM-DD')
and 
trunc(ord_rel.LATE_DELIVERY_DATE) <= to_date('2016-10-31','YYYY-MM-DD')
and sh.source_location_gid in ('ULE.V207480','ULE.V207503')
) temp

group by 
temp.PICK_LOC,
temp.PICK_LOC_POSTAL,
temp.source_city,
TEMP.DEST_LOC,
temp.dest_city,
temp.DEST_LOC_POSTAL