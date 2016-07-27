SELECT SH.SHIPMENT_GID,
			S_EQ.EQUIPMENT_GROUP_GID,
			TRIM(TO_CHAR(SH.LOADED_DISTANCE,'999999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))	LOADED_DISTANCE,
			sh.LOADED_DISTANCE_UOM_CODE 																					distance_uom_code,
			
			
			TO_CHAR((select sh_ref.SHIPMENT_REFNUM_VALUE
			from shipment_refnum sh_ref
			where sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_ROAD_DISTANCE'
			and sh_ref.shipment_gid = sh.shipment_gid
			
			),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')												ROAD_DIST,
			TO_CHAR((select sh_ref.SHIPMENT_REFNUM_VALUE
			from shipment_refnum sh_ref
			where sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_WATER_DISTANCE'
			and sh_ref.shipment_gid = sh.shipment_gid
			
			),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')																WATER_DIST,
			TO_CHAR((select sh_ref.SHIPMENT_REFNUM_VALUE
			from shipment_refnum sh_ref
			where sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_RAIL_DISTANCE'
			and sh_ref.shipment_gid = sh.shipment_gid
			
			),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')																RAIL_DIST,
			(select listagg(sh_ref.SHIPMENT_REFNUM_VALUE,'/') within group (order by sh.shipment_gid)
			from shipment_refnum sh_ref
			where sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'
			and sh_ref.shipment_gid = sh.shipment_gid
			
			)																				ULE_TRANSPORT_CONDITION







FROM
SHIPMENT SH,
SHIPMENT_S_EQUIPMENT_JOIN EQ_J,
S_EQUIPMENT S_EQ




WHERE 

SH.SHIPMENT_GID = EQ_J.SHIPMENT_GID
AND EQ_J.S_EQUIPMENT_GID = S_EQ.S_EQUIPMENT_GID 

AND to_char(trunc(SH.insert_date),'YYYY') = '2015'
AND to_char(trunc(SH.insert_date),'MM') = '04'
and sh.source_location_gid IN('ULE.V207503','ULE.V207480')

-- AND SH.SHIPMENT_GID='ULE/PR.101024839'
AND  EXISTS
							(SELECT 1
							 FROM SHIPMENT_REFNUM SH_REF_1
							 WHERE SH_REF_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
							 AND SH_REF_1.SHIPMENT_REFNUM_VALUE = 'SECONDARY'
							 AND SH_REF_1.SHIPMENT_GID = SH.SHIPMENT_GID)
-- AND SH.SHIPMENT_XID NOT LIKE '%W0%'
