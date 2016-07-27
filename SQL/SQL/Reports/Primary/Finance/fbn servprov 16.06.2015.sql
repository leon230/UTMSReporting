select 
-- DISTINCT sh.shipment_gid,
-- orls.order_release_gid,
distinct sh.servprov_gid,
-- or_ref.ORDER_RELEASE_REFNUM_qual_gid,
-- SH.SOURCE_LOCATION_GID,
-- SH.DEST_LOCATION_GID,
-- ORLS.SOURCE_LOCATION_GID,
-- ORLS.DEST_LOCATION_GID,
(select or_ref_temp.ORDER_RELEASE_REFNUM_VALUE
from order_release_refnum or_ref_temp,
order_release orls_temp,
shipment sh_temp,
view_shipment_order_release vorls_temp
where 
or_ref_temp.order_release_gid = orls.order_release_gid
and orls_temp.order_release_gid = orls.order_release_gid
and or_ref_temp.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
and or_ref_temp.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FINAL_BILLING_NUMBER'
-- and or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = or_ref.ORDER_RELEASE_REFNUM_qual_gid
and orls_temp.order_release_gid = vorls_temp.order_release_gid
and sh_temp.shipment_gid = vorls_temp.shipment_gid
and sh_temp.servprov_gid = sh.servprov_gid
AND SH.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
AND or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = 'ULE.ULE_FINAL_BILLING_NUMBER'
and sh_temp.dest_location_gid NOT in  ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837','ULE.X207480') 
AND sh_temp.SOURCE_LOCATION_GID NOT in  ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837','ULE.X207480') 


) FBN,
(select or_ref_temp.ORDER_RELEASE_REFNUM_VALUE
from order_release_refnum or_ref_temp,
order_release orls_temp,
shipment sh_temp,
view_shipment_order_release vorls_temp
where 
or_ref_temp.order_release_gid = orls.order_release_gid
and orls_temp.order_release_gid = orls.order_release_gid
and or_ref_temp.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
-- and or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = or_ref.ORDER_RELEASE_REFNUM_qual_gid
and orls_temp.order_release_gid = vorls_temp.order_release_gid
and sh_temp.shipment_gid = vorls_temp.shipment_gid
and sh_temp.servprov_gid = sh.servprov_gid
AND SH.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
AND or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = 'ULE.ULE_FINAL_BILLING_NUMBER_LEG1'
and sh_temp.dest_location_gid in  ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837','ULE.X207480') 
and sh_temp.source_location_gid <> sh_temp.dest_location_gid

) FBN_LEG1,
(select or_ref_temp.ORDER_RELEASE_REFNUM_VALUE
from order_release_refnum or_ref_temp,
order_release orls_temp,
shipment sh_temp,
view_shipment_order_release vorls_temp
where 
or_ref_temp.order_release_gid = orls.order_release_gid
and orls_temp.order_release_gid = orls.order_release_gid
and or_ref_temp.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
-- and or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = or_ref.ORDER_RELEASE_REFNUM_qual_gid
and orls_temp.order_release_gid = vorls_temp.order_release_gid
and sh_temp.shipment_gid = vorls_temp.shipment_gid
and sh_temp.servprov_gid = sh.servprov_gid
AND SH.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
AND or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = 'ULE.ULE_FINAL_BILLING_NUMBER_LEG2'
and sh_temp.source_location_gid in  ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837','ULE.X207480') 
and sh_temp.source_location_gid <> sh_temp.dest_location_gid

) FBN_LEG2,

(select or_ref_temp.ORDER_RELEASE_REFNUM_VALUE
from order_release_refnum or_ref_temp,
order_release orls_temp,
shipment sh_temp,
view_shipment_order_release vorls_temp
where 
or_ref_temp.order_release_gid = orls.order_release_gid
and orls_temp.order_release_gid = orls.order_release_gid
and or_ref_temp.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
-- and or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = or_ref.ORDER_RELEASE_REFNUM_qual_gid
and orls_temp.order_release_gid = vorls_temp.order_release_gid
and sh_temp.shipment_gid = vorls_temp.shipment_gid
and sh_temp.servprov_gid = sh.servprov_gid
AND SH.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
AND or_ref_temp.ORDER_RELEASE_REFNUM_qual_gid = 'ULE.ULE_FINAL_BILLING_NUMBER_HANDLING'
and sh_temp.dest_location_gid in  ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837','ULE.X207480') 
and sh_temp.source_location_gid = sh_temp.dest_location_gid

) FBN_HANDLING


from
shipment sh,
order_movement vorls,
order_release_refnum orls_ref,
order_release orls


-- order_release_refnum or_ref


where

orls.order_release_gid = vorls.order_release_gid
and sh.shipment_gid = vorls.shipment_gid
and orls_ref.order_release_gid = orls.order_release_gid
and orls_ref.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID  LIKE 'ULE.ULE_FINAL_BILLING_NUMBER%'

AND NOT EXISTS (SELECT 1
							 FROM SHIPMENT_REFNUM SH_REF_1
							 WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
							 AND SH_REF_1.SHIPMENT_REFNUM_VALUE = 'SECONDARY'
							 AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID)
							 
-- and or_ref.order_release_gid = orls.order_release_gid
-- and or_ref.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'


-- AND ORLS.ORDER_RELEASE_GID = 'ULE.0180642769'
-- and sh.servprov_gid = 'ULE.T1015208'