SELECT 
  orls.shipment_gid, 
  orls_ref.shipment_REFNUM_QUAL_GID,
  (SELECT to_char(orls2.insert_date,'YYYY-MM-DD')
  FROM shipment ORLS2
  WHERE ORLS2.shipment_gid = ORLS.shipment_gid
  ) AS																OR_INSERT_DATE,
  
  count (orls_ref.shipment_REFNUM_QUAL_GID)
FROM 
  shipment orls
  join shipment_refnum orls_ref on orls.shipment_gid = orls_ref.shipment_gid
WHERE
 1=1

GROUP BY 
orls.shipment_gid, 
  orls_ref.shipment_REFNUM_QUAL_GID
HAVING 
  orls_ref.shipment_REFNUM_QUAL_GID in ('ULE.ULE_FUNCTIONAL_REGION','ULE.ULE_TRANSPORT_CONDITION','ULE.ULE_SHIPMENT_STREAM','ULE.ULE_ORIGINAL_PFS','ULE.ULE_MATERIAL_TYPE')
  and COUNT(orls_ref.shipment_REFNUM_QUAL_GID) > 1		
