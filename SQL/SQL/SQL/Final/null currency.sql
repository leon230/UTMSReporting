select sh.shipment_gid,


	(select sh_c.COST_GID
	from shipment_cost sh_c
	where
	sh_c.shipment_gid = sh.shipment_gid
	and sh_c.COST_TYPE = 'B'
	)													currency
	



from shipment sh



where

sh.currency_gid is null
AND NOT EXISTS (SELECT 1
							 FROM SHIPMENT_REFNUM SH_REF_1
							 WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
							 AND SH_REF_1.SHIPMENT_REFNUM_VALUE = 'SECONDARY'
							 AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID)
							 
							 
and sh.SHIPMENT_TYPE_GID = 'TRANSPORT'
