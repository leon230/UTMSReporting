select sh.shipment_gid
,SH_REF.SHIPMENT_REFNUM_VALUE
,(SELECT sh_ref.SHIPMENT_REFNUM_VALUE
                          FROM SHIPMENT_REFNUM sh_ref
                          WHERE sh_ref.SHIPMENT_GID=sh.shipment_gid
                          AND SHIPMENT_REFNUM_QUAL_GID ='XTN') XTN
						  
from 

shipment sh
left outer join shipment_refnum sh_ref on (sh_ref.shipment_gid = sh.shipment_gid and sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.TRUCK PLATE')



where SH.SHIPMENT_GID IN ()




where sh_ref.SHIPMENT_REFNUM_VALUE is null







and sh.SHIPMENT_TYPE_GID = 'TRANSPORT'





and exists
(SELECT 1
                          FROM SHIPMENT_REFNUM sh_ref
                          WHERE sh_ref.SHIPMENT_GID=sh.shipment_gid
                          AND SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_SHIPMENT_STREAM'
                          and SHIPMENT_REFNUM_VALUE = 'PRIMARY')
AND EXISTS
(SELECT 1
                          FROM SHIPMENT_REFNUM sh_ref
                          WHERE sh_ref.SHIPMENT_GID=sh.shipment_gid
                          AND SHIPMENT_REFNUM_QUAL_GID ='XTN')
						  
AND TO_CHAR(SH.INSERT_DATE,'YYYY') = '2016'