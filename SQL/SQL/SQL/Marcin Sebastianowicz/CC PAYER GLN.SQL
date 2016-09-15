SELECT ord_rel_ref_str.ORDER_RELEASE_REFNUM_VALUE "Order_Release Stream",
ord_rel_ref_reg.ORDER_RELEASE_REFNUM_VALUE "Functional Region",
case when instr(sh.shipment_gid,'_W0_')>0 then 1 else 0 end "Is Secondary W0 Shipment",
ord_rel.ORDER_RELEASE_XID "Order Release XID",
to_char(ord_rel.insert_date,'YYYY-MM-DD') "Insert Date Day",
ord_rel.INSERT_USER "Order Insert User",
ord_pic_loc.LOCATION_XID "Pickup Location ID",
ord_pic_loc.CITY "Pickup City",
ord_pic_loc_cou.COUNTRY_NAME "Pickup Country Name",
ord_del_loc.LOCATION_XID "Delivery Location ID",
ord_del_loc.CITY "Delivery City",
ord_del_loc_cou.COUNTRY_NAME "Delivery Country Name",
to_char(ord_rel.TOTAL_SHIP_UNIT_COUNT,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') "Total Number of Pallets (Or)",
ord_rel_ref_org_pfs.ORDER_RELEASE_REFNUM_VALUE "ULE_ORIGINAL_PFS (Or)",
sh_stat_col536.status_value_gid "Ule/Pr.Invoice_Ready",
ord_rel_ref_col1021.ORDER_RELEASE_REFNUM_VALUE "Material_Type"
,ord_rel_ref_os.ORDER_RELEASE_REFNUM_VALUE          ORIGINAL_STREAM
FROM
ORDER_RELEASE ord_rel
  join LOCATION ord_pic_loc on ord_rel.source_location_gid = ord_pic_loc.location_gid
 left outer join COUNTRY_CODE ord_pic_loc_cou on ord_pic_loc.COUNTRY_CODE3_GID = ord_pic_loc_cou.COUNTRY_CODE3_GID
  join LOCATION ord_del_loc on ord_rel.dest_location_gid = ord_del_loc.location_gid
 left outer join COUNTRY_CODE ord_del_loc_cou on ord_del_loc.COUNTRY_CODE3_GID = ord_del_loc_cou.COUNTRY_CODE3_GID
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_col1021 on ord_rel.order_release_gid = ord_rel_ref_col1021.order_release_gid and ord_rel_ref_col1021.order_release_refnum_qual_gid='ULE.ULE_MATERIAL_TYPE'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_org_pfs on ord_rel.order_release_gid = ord_rel_ref_org_pfs.order_release_gid and ord_rel_ref_org_pfs.order_release_refnum_qual_gid='ULE.ULE_ORIGINAL_PFS'
 left outer join ORDER_RELEASE_REFNUM ord_rel_ref_reg on ord_rel.order_release_gid = ord_rel_ref_reg.order_release_gid and ord_rel_ref_reg.order_release_refnum_qual_gid='ULE.ULE_FUNCTIONAL_REGION'
 left outer join ORDER_RELEASE_REFNUM  ord_rel_ref_str on ord_rel.order_release_gid = ord_rel_ref_str.order_release_gid and ord_rel_ref_str.order_release_refnum_qual_gid='ULE.ULE_STREAM'
 left outer join ORDER_RELEASE_REFNUM  ord_rel_ref_cc on ord_rel.order_release_gid = ord_rel_ref_cc.order_release_gid and ord_rel_ref_cc.order_release_refnum_qual_gid='ULE.ULE_COST CENTER'
 left outer join ORDER_RELEASE_REFNUM  ord_rel_ref_os on ord_rel.order_release_gid = ord_rel_ref_os.order_release_gid and ord_rel_ref_os.order_release_refnum_qual_gid='ULE.ORIGINAL_STREAM'
 left outer join ORDER_MOVEMENT ord_mov on ord_rel.order_release_gid = ord_mov.order_release_gid
 left outer join SHIPMENT sh on ord_mov.shipment_gid = sh.shipment_gid
 left outer join SHIPMENT_STATUS sh_stat_col536 on sh.shipment_gid = sh_stat_col536.shipment_gid and sh_stat_col536.status_type_gid='ULE/PR.INVOICE_READY' and sh.domain_name = sh_stat_col536.domain_name
WHERE
ord_rel.DOMAIN_NAME <> 'UGO'
AND ord_rel.INSERT_DATE >= nvl(TO_DATE(:P_DATE_FROM, :P_DATE_TIME_FORMAT),ord_rel.INSERT_DATE )
AND ord_rel.INSERT_DATE <= nvl(TO_DATE(:P_DATE_TO, :P_DATE_TIME_FORMAT),ord_rel.INSERT_DATE )
AND ord_rel_ref_reg.ORDER_RELEASE_REFNUM_VALUE = NVL(:P_REGION,ord_rel_ref_reg.ORDER_RELEASE_REFNUM_VALUE)
and ord_rel_ref_cc.ORDER_RELEASE_REFNUM_VALUE is null