SELECT 
  orls.shipment_gid, 

  
  count (orls_ref.ACCESSORIAL_CODE_GID)
FROM 
  shipment orls
  join shipment_cost orls_ref on orls.shipment_gid = orls_ref.shipment_gid
WHERE
 1=1
 AND NOT EXISTS(SELECT 1
	FROM shipment_refnum
	WHERE shipment_gid = orls.shipment_gid
	AND shipment_refnum_qual_gid = 'ULE.ULE_SHIPMENT_STREAM'
	AND shipment_refnum_value = 'SECONDARY')
	and orls_ref.ACCESSORIAL_CODE_GID like '%ULE_FUEL_REIMBURSEMENT%'
GROUP BY 
orls.shipment_gid

HAVING 
  
   COUNT(orls_ref.ACCESSORIAL_CODE_GID) > 1		
