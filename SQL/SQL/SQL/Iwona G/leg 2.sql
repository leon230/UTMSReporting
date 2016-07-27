SELECT 
sh_l1.SHIPMENT_GID "Leg 2 Shipment GID",
sh_stat_fr.STATUS_VALUE_GID "Finance Ready",
sh_stat_ir.STATUS_VALUE_GID "Invoice Ready",
sh_stat_nc.STATUS_VALUE_GID "Shipment Cost",
NVL(sh_stat_fr.UPDATE_DATE,sh_stat_fr.INSERT_DATE) "Shipment Cost Update",
sh_l1.INSERT_DATE "Shipment Insert Date",
ord_rel.order_release_gid "Leg 2 Order Release",
ord_rel_ref1.ORDER_RELEASE_REFNUM_VALUE "Leg 2 FBR",
(SELECT LISTAGG(to_char(SS_L1.actual_arrival,'YYYY-MM-DD HH24:MI'),'/') WITHIN GROUP (ORDER BY sh_l1.shipment_gid )
FROM SHIPMENT_STOP SS_L1 
WHERE SS_L1.shipment_gid = sh_l1.shipment_gid 
and SS_L1.location_gid = sh_l1.source_location_gid
) 																											ACTUAL_ARRIVAL,
(SELECT LISTAGG(to_char(SS_L1.actual_arrival,'YYYY-MM-DD HH24:MI'),'/') WITHIN GROUP (ORDER BY sh_l1.shipment_gid )
FROM SHIPMENT_STOP SS_L1 
WHERE SS_L1.shipment_gid = sh_l1.shipment_gid 
and SS_L1.location_gid = sh_l1.source_location_gid
) 																											ACTUAL_DEPARTURE,

(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_HANDLING_PAYER'
		)																									HANDLING_PAYER,
		(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_LEG1_PAYER'
		)																									LEG1_PAYER,
		(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_LEG2_PAYER'
		)																									LEG2_PAYER,
		(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_PAYER'
		)																									PAYER,

(select listagg(orls_ref.ORDER_RELEASE_REFNUM_VALUE,'/') within group (order by ord_rel.order_release_gid)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_FINAL_BILLING_NUMBER'
		)																									FINAL_BILLING_NUMBER,
		(select listagg(orls_ref.ORDER_RELEASE_REFNUM_VALUE,'/') within group (order by ord_rel.order_release_gid)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_FINAL_BILLING_NUMBER_HANDLING'
		)																									FINAL_BILLING_NUMBER_HANDLING,
		(select listagg(orls_ref.ORDER_RELEASE_REFNUM_VALUE,'/') within group (order by ord_rel.order_release_gid)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_FINAL_BILLING_NUMBER_LEG1'
		)																									FINAL_BILLING_NUMBER_LEG1,
		(select listagg(orls_ref.ORDER_RELEASE_REFNUM_VALUE,'/') within group (order by ord_rel.order_release_gid)
		from order_release_refnum orls_ref
		where orls_ref.order_release_gid = ord_rel.order_release_gid
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_FINAL_BILLING_NUMBER_LEG2'
		)																									FINAL_BILLING_NUMBER_LEG2
		
		
		
		


FROM
SHIPMENT sh_l1
left outer join SHIPMENT_STATUS sh_stat_nc on sh_l1.SHIPMENT_GID = sh_stat_nc.SHIPMENT_GID and sh_stat_nc.status_type_gid='ULE/PR.SHIPMENT_COST'
left outer join SHIPMENT_STATUS sh_stat_fr on sh_l1.SHIPMENT_GID = sh_stat_fr.SHIPMENT_GID and sh_stat_fr.status_type_gid='ULE/PR.FINANCE' 
 left outer join SHIPMENT_STATUS sh_stat_ir on sh_l1.SHIPMENT_GID = sh_stat_ir.SHIPMENT_GID and sh_stat_ir.status_type_gid='ULE/PR.INVOICE_READY'
left outer join SHIPMENT_REFNUM sh_ref_st on sh_l1.SHIPMENT_GID = sh_ref_st.SHIPMENT_GID and sh_ref_st.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
left outer join view_shipment_order_release ord_mov_l1 on ord_mov_l1.SHIPMENT_GID = sh_l1.SHIPMENT_GID
left outer join LOCATION_ROLE_PROFILE loc_rp on loc_rp.location_gid = sh_l1.SOURCE_location_gid
left outer join order_release ord_rel on ord_mov_l1.order_release_gid = ord_rel.order_release_gid
left outer join order_release_refnum ord_rel_ref1 on ord_rel.order_release_gid = ord_rel_ref1.order_release_gid and ord_rel_ref1.order_release_refnum_qual_gid = 'ULE.ULE_FINAL_BILLING_NUMBER_LEG1' 
where 
  loc_rp.location_role_gid = 'XDOCK'
  and NVL(sh_ref_st.SHIPMENT_REFNUM_VALUE,'PRIMARY') = 'PRIMARY'
  and sh_l1.SHIPMENT_TYPE_GID = 'TRANSPORT'
  -- and sh_l1.SHIPMENT_GID = 'ULE/PR.100374922'
  and sh_l1.source_location_gid <> sh_l1.dest_location_gid
