select 1
from order_release orl
where
orl.order_release_gid = ?
AND trunc(orl.EARLY_PICKUP_DATE) <= trunc(sysdate) + 90
and trunc(orl.LATE_PICKUP_DATE) <= trunc(sysdate) + 90
and trunc(orl.EARLY_DELIVERY_DATE) <= trunc(sysdate) + 90
and trunc(orl.LATE_DELIVERY_DATE) <= trunc(sysdate) + 90
and exists
(select 1
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = orl.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
and orl_stream.ORDER_RELEASE_REFNUM_VALUE = 'PRIMARY'
)
OR ORL.INSERT_USER = 'ULE.INTEGRATION'
/
select 1
from order_release orl,
ORDER_MOVEMENT OM
where
OM.SHIPMENT_GID = ?
AND 
OM.ORDER_RELEASE_GID = ORL.ORDER_RELEASE_GID

and

(select DISTINCT orl_stream.ORDER_RELEASE_REFNUM_VALUE
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = orl.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
) = 
(select sh_ref.SHIPMENT_REFNUM_VALUE
from shipment_refnum sh_ref
WHERE
sh_ref.shipment_gid = OM.shipment_gid 
and sh_ref.shipment_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
)


-----CZY ISTNIEJE NA sh STREAM I CZY ROWNA SIE TYM NA OR



/
select 1
from order_release orl
where orl.is_template = 'N'
AND orl.order_release_gid = ?




/
SELECT 
CASE WHEN (SELECT COUNT(OM1.ORDER_RELEASE_GID) FROM ORDER_MOVEMENT OM1 WHERE OM1.SHIPMENT_GID = SH.SHIPMENT_GID)
=

(select COUNT(*)
from order_release orl,
ORDER_MOVEMENT OM
where
OM.SHIPMENT_GID = SH.SHIPMENT_GID
AND OM.order_release_gid = ORL.ORDER_RELEASE_GID

and ( exists
(select 1
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = orl.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_CATEGORY'
)
AND  exists
(select 1
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = orl.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE'
)))
THEN 1
ELSE NULL
END
FROM SHIPMENT SH  
WHERE SH.SHIPMENT_GID ='ULE/PR.101200502'

----ERROR
--MISSING IN OT OUT PARAMETER SH 101200502,101198132
/
SELECT 
CASE WHEN (SELECT COUNT(OM1.ORDER_RELEASE_GID) FROM ORDER_MOVEMENT OM1 WHERE OM1.SHIPMENT_GID = ?)
=

(select COUNT(1)
from order_release orl,
ORDER_MOVEMENT OM
where
OM.SHIPMENT_GID = ?
AND OM.order_release_gid = ORL.ORDER_RELEASE_GID

and  exists
(select 1
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = orl.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
)
)
THEN 1
ELSE NULL
END
FROM DUAL  
/
select 1
from SHIPMENT_REFNUM sr1,SHIPMENT_REFNUM sr2
where sr1.SHIPMENT_GID =sr2.SHIPMENT_GID
and sr1.shipment_gid = ?
and sr1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'
and sr1.SHIPMENT_REFNUM_VALUE not in ('FROZEN','CHILLED')
and sr2.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
and sr2.SHIPMENT_REFNUM_VALUE ='PRIMARY'
-----------------------/koszt powyzej 1k/----------------------------------------------
select 1

from shipment_cost sc

where
 sc.shipment_gid = ?
and 
(CASE WHEN (sc.COST_GID = 'EUR' or sc.COST_GID is null) THEN sc.COST
when sc.COST_GID <> 'EUR' then sc.COST * unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sysdate,sc.COST_GID,'EUR')END) <1000
and exists
(select 1
from shipment_refnum sh_ref
WHERE
sh_ref.shipment_gid = sc.shipment_gid 
and sh_ref.shipment_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
and sh_ref.SHIPMENT_REFNUM_VALUE ='PRIMARY'
)
-----------------------/ORDERLESS Z ULE/----------------------------------------------
select 1
from shipment sh
where 
sh.shipment_gid = ?
and sh.SHIPMENT_TYPE_GID = 'APPOINTMENT'
and sh.domain_name <> 'ULE'
--------------------/Sekwencja dat/-------------------------------------------------------------------------
select 1
from shipment sh
where 
sh.shipment_gid = ?
and sh.SHIPMENT_TYPE_GID = 'APPOINTMENT'
and sh.domain_name <> 'ULE'




















