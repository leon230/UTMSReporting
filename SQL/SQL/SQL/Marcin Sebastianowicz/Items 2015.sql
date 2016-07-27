select DISTINCT or_line.PACKAGED_ITEM_GID,
(select ii.ITEM_NAME
from ITEM ii
WHERE or_line.PACKAGED_ITEM_GID = ii.item_gid

)					item_name,


(select LISTAGG(or_ref.ORDER_RELEASE_REFNUM_VALUE,'/') WITHIN GROUP (ORDER BY OR_REF.order_release_gid)
from ORDER_RELEASE_REFNUM or_ref
where
or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_CATEGORY'
and or_ref.order_release_gid = orls.order_release_gid


)																order_category,

(select LISTAGG(sh.RATE_GEO_GID,'/') WITHIN GROUP (ORDER BY SH.SHIPMENT_GID)
from shipment sh,
order_movement om
where om.shipment_gid = sh.shipment_gid
and om.order_release_gid = orls.order_release_gid



)																	rate_geo_gid





from order_release orls,
ORDER_RELEASE_LINE or_line



where 
or_line.order_release_gid = orls.order_release_gid
and exists
(select 1
from order_release_refnum or_ref
where or_ref.order_release_gid = orls.order_release_gid
and or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'
AND OR_REF.ORDER_RELEASE_REFNUM_VALUE = 'TEMPC'

)
-- and to_char(orls.insert_date,'YYYY') = '2016'
and trunc(orls.insert_date) >= to_date('2016-01-01','YYYY-MM-DD')
and trunc(orls.insert_date) < to_date('2016-02-01','YYYY-MM-DD')


and orls.IS_TEMPLATE = 'N'



--CATEOGRY Z ORDERU
--X_LANE
--STYCZEN 2016