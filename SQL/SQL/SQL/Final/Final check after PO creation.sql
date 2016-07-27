SELECT ord_rel.ORDER_RELEASE_GID "Order Release GID",
SH.SHIPMENT_GID,
SH.SERVPROV_GID,




(SELECT LOC.LOCATION_NAME
FROM LOCATION LOC
WHERE LOC.LOCATION_GID = SH.SERVPROV_GID

)																			TSP_NAME,



ord_rel_ref_col648.ORDER_RELEASE_REFNUM_VALUE "FBR",
ord_rel_ref_col652.ORDER_RELEASE_REFNUM_VALUE "Finance_Po_Number",
ord_rel_ref_col649.ORDER_RELEASE_REFNUM_VALUE "FBR HANDLING",
ord_rel_ref_col653.ORDER_RELEASE_REFNUM_VALUE "Finance_Po_Number_Hand",
ord_rel_ref_col650.ORDER_RELEASE_REFNUM_VALUE "FBR L1",
ord_rel_ref_col654.ORDER_RELEASE_REFNUM_VALUE "Finance_Po_Number_Leg1",
ord_rel_ref_col651.ORDER_RELEASE_REFNUM_VALUE "FBR L2",
ord_rel_ref_col655.ORDER_RELEASE_REFNUM_VALUE "Finance_Po_Number_Leg2"
FROM
ORDER_RELEASE ord_rel
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col648 on ord_rel.order_release_gid = ord_rel_ref_col648.order_release_gid and ord_rel_ref_col648.order_release_refnum_qual_gid='ULE.ULE_FINAL_BILLING_NUMBER'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col649 on ord_rel.order_release_gid = ord_rel_ref_col649.order_release_gid and ord_rel_ref_col649.order_release_refnum_qual_gid='ULE.ULE_FINAL_BILLING_NUMBER_HANDLING'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col650 on ord_rel.order_release_gid = ord_rel_ref_col650.order_release_gid and ord_rel_ref_col650.order_release_refnum_qual_gid='ULE.ULE_FINAL_BILLING_NUMBER_LEG1'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col651 on ord_rel.order_release_gid = ord_rel_ref_col651.order_release_gid and ord_rel_ref_col651.order_release_refnum_qual_gid='ULE.ULE_FINAL_BILLING_NUMBER_LEG2'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col652 on ord_rel.order_release_gid = ord_rel_ref_col652.order_release_gid and ord_rel_ref_col652.order_release_refnum_qual_gid='ULE.ULE_FINANCE_PO_NUMBER'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col653 on ord_rel.order_release_gid = ord_rel_ref_col653.order_release_gid and ord_rel_ref_col653.order_release_refnum_qual_gid='ULE.ULE_FINANCE_PO_NUMBER_HANDLING'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col654 on ord_rel.order_release_gid = ord_rel_ref_col654.order_release_gid and ord_rel_ref_col654.order_release_refnum_qual_gid='ULE.ULE_FINANCE_PO_NUMBER_LEG1'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col655 on ord_rel.order_release_gid = ord_rel_ref_col655.order_release_gid and ord_rel_ref_col655.order_release_refnum_qual_gid='ULE.ULE_FINANCE_PO_NUMBER_LEG2'
 left outer join ORDER_MOVEMENT ord_mov on ord_rel.order_release_gid = ord_mov.order_release_gid
 left outer join SHIPMENT sh on ord_mov.shipment_gid = sh.shipment_gid
WHERE
ord_rel_ref_col648.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
OR
ord_rel_ref_col649.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
OR
ord_rel_ref_col650.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'
OR
ord_rel_ref_col651.ORDER_RELEASE_REFNUM_VALUE like 'M20150531%'

and (


)