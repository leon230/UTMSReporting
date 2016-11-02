SELECT 
  orls.order_release_gid, 
  orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID,
  (SELECT to_char(orls2.insert_date,'YYYY-MM-DD')
  FROM ORDER_RELEASE ORLS2
  WHERE ORLS2.order_release_gid = ORLS.order_release_gid
  ) AS																OR_INSERT_DATE,
  
  count (orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID)
FROM 
  order_release orls
  join order_release_REFNUM orls_ref on orls.order_release_gid = orls_ref.order_release_gid
WHERE
 1=1
GROUP BY 
orls.order_release_gid, 
  orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID
HAVING 
--  orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID in ('ULE.ULE_ORIGINAL_PFS','ULE.ULE_MATERIAL_TYPE','ULE.ULE_SERVICE_CRITICAL','ULE.ULE_SPECIAL_ORDER',
--  'ULE.ULE_EXPRESS_BY_CUSTOMER','ULE.ULE_MATERIAL_TYPE')
   COUNT(orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID) > 1
