select sh.shipment_gid,
to_char(sh.end_time,'YYYY-MM-DD') END_TIME,
SH.RATE_GEO_GID,
sh.source_location_gid||'-'||sh.dest_location_gid 										Vendor_to_vendor,
(select listagg(loc.city,'/') within group (order by LOC.LOCATION_GID)
FROM LOCATION LOC
WHERE LOC.LOCATION_GID = SH.SOURCE_LOCATION_GID)
||'-'||
(select listagg(loc.city,'/') within group (order by LOC.LOCATION_GID)
FROM LOCATION LOC
WHERE LOC.LOCATION_GID = SH.dest_location_gid)   										cITY_CITY,
SH.SERVPROV_GID,
(select loc.LOCATION_NAME
FROM LOCATION LOC
WHERE LOC.LOCATION_GID = SH.SERVPROV_GID) 												servprov_name,

(select listagg(s_eq.EQUIPMENT_GROUP_GID,'/') within group (order by sh_seq.shipment_gid)
from 
SHIPMENT_S_EQUIPMENT_JOIN sh_seq,
S_EQUIPMENT s_eq
where
sh_seq.S_EQUIPMENT_GID = s_eq.S_EQUIPMENT_GID
and sh_seq.shipment_gid = sh.shipment_gid
)																									equipment,
NVL((SELECT listagg(SH_REF_1.SHIPMENT_REFNUM_VALUE,'/') within group (order by SH_REF_1.shipment_gid)
							 FROM SHIPMENT_REFNUM SH_REF_1
							 WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
							 AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID),'-')										REGION







from shipment sh


where
NOT EXISTS(SELECT 1
	FROM SHIPMENT_REFNUM
	WHERE SHIPMENT_GID = SH.SHIPMENT_GID
	AND SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
	AND SHIPMENT_REFNUM_VALUE = 'SECONDARY')
-- ANd NVL((SELECT SH_REF_1.SHIPMENT_REFNUM_VALUE
							 -- FROM SHIPMENT_REFNUM SH_REF_1
							 -- WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
							 -- AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID),'-') IN ('BULK','-')

and NVL((SELECT listagg(SH_REF_1.SHIPMENT_REFNUM_VALUE,'/') within group (order by SH_REF_1.shipment_gid)
							 FROM SHIPMENT_REFNUM SH_REF_1
							 WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
							 AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID
							 and rownum = 1),'-') like '%BULK%'						 
and to_char(sh.end_time,'YYYY') = '2015'
and sh.SHIPMENT_TYPE_GID = 'TRANSPORT'

