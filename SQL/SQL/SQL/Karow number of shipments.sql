select sh.servprov_gid,
loc.location_name as 											tsp_name,
to_char(sh.end_time,'MM-YYYY') as Miesiac,
COUNT(DISTINCT SH.SHIPMENT_GID) as Number_of_shipments




from shipment sh,
LOCATION LOC


where 

	NOT EXISTS(SELECT 1
	FROM SHIPMENT_REFNUM
	WHERE SHIPMENT_GID = SH.SHIPMENT_GID
	AND SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
	AND SHIPMENT_REFNUM_VALUE = 'SECONDARY')
	
and trunc(sh.end_time) >= trunc(to_date('2014-03-01','YYYY-MM-DD'))
AND TRUNC(SH.END_TIME) <= trunc(to_date('2015-02-28','YYYY-MM-DD'))

AND	SH.SHIPMENT_TYPE_GID IN ('TRANSPORT')

and (SELECT SHS_STATUS_CANC.STATUS_VALUE_GID
				FROM SHIPMENT_STATUS SHS_STATUS_CANC
				WHERE SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
				and SHS_STATUS_CANC.SHIPMENT_GID = SH.SHIPMENT_GID
		) <> 'ULE/PR.CANCELLED'
		
AND loc.location_gid = sh.servprov_gid
AND SH.DOMAIN_NAME NOT IN ('ULE/SE','UGO')
GROUP BY
sh.servprov_gid,
loc.location_name,
to_char(sh.end_time,'MM-YYYY')