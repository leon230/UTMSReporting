select sh.shipment_gid,
ss.LOCATION_GID,
ss.stop_type,
	(select nvl(loc_ref.LOCATION_REFNUM_VALUE,'N')
	from location_refnum loc_ref
	where loc_ref.location_gid = ss.LOCATION_GID
	and loc_ref.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_DB_LOCATION'
	
	
	)																loc_db_required
/* 	(select nvl(loc_ref.LOCATION_REFNUM_VALUE,'N')
	from location_refnum loc_ref
	where loc_ref.location_gid = sh.dest_location_gid
	and loc_ref.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_DB_LOCATION'
	
	
	)																DEST_loc_db_required */



from shipment sh,
shipment_stop ss

where
trunc(sh.end_time) >= trunc(to_date('2015-01-01','YYYY-MM-DD'))
AND trunc(sh.end_time) < trunc(to_date('2015-02-01','YYYY-MM-DD'))
/* AND SH.RATE_GEO_GID IS NULL */
and ss.shipment_gid = sh.shipment_gid
	AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)