select orls.source_location_gid, ORLS.dest_location_gid, ORLS.order_release_gid 
,or_ref.ORDER_RELEASE_REFNUM_VALUE
,(select LISTAGg(OR_REF.ORDER_RELEASE_REFNUM_VALUE,',') WITHIN GROUP (ORDER BY or_ref.ORDER_RELEASE_GID)
from order_release_refnum or_ref
WHERE 
or_ref.ORDER_RELEASE_REFNUM_QUAL_GID LIKE '%PAYER%' 
AND OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
)																			PAYER
,(select LISTAGg(OR_REF.ORDER_RELEASE_REFNUM_VALUE,',') WITHIN GROUP (ORDER BY or_ref.ORDER_RELEASE_GID)
from order_release_refnum or_ref
WHERE or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_COST CENTER' 
AND OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
)																			CC
,(select LISTAGg(OR_REF.ORDER_RELEASE_REFNUM_VALUE,',') WITHIN GROUP (ORDER BY or_ref.ORDER_RELEASE_GID)
from order_release_refnum or_ref
WHERE or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_GLN' 
AND OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
)																			GLN
,om.shipment_gid
,(select shs.STATUS_VALUE_GID
FROM shipment_status shs
WHERE shs.shipment_gid = om.shipment_gid
ANd shs.STATUS_TYPE_GID = 'ULE/PR.FINANCE'
)																		FINANCE
,(select shs.STATUS_VALUE_GID
FROM shipment_status shs
WHERE shs.shipment_gid = om.shipment_gid
ANd shs.STATUS_TYPE_GID = 'ULE.INVOICE_READY'
)																		INVOICE
from order_release orls,
ORDER_MOVEMENT OM,
order_release_refnum or_ref
where
or_ref.order_release_gid  = orls.order_release_gid
AND OM.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID

and or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE' 
-- ANd order_release_gid in ('ULE.0180842747','ULE.0180835478','ULE.0180842775','ULE.20151223-0405','ULE.0180835458','ULE.0180842776','ULE.0180842746')
AND OM.SHIPMENT_GID = 'ULE/PR.101927093'