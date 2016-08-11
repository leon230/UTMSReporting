SELECT SH.SHIPMENT_GID
,orls.order_release_gid
,sh_ref_reg.shipment_refnum_value                                                       or_condition
,or_ref_reg.order_release_refnum_value                                                       sh_condition
,TO_CHAR(sh_ref_reg.insert_date,'YYYY-MM-DD')                                                                 SH_INSERT_DATE
,TO_CHAR(sh_ref_reg.update_date,'YYYY-MM-DD')                                                                 SH_UPDATE_DATE
,TO_CHAR(or_ref_reg.insert_date,'YYYY-MM-DD')                                                                 OR_INSERT_DATE
,TO_CHAR(or_ref_reg.update_date,'YYYY-MM-DD')                                                                 OR_UPDATE_DATE


,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
 FROM shipment_s_equipment_join sh_eq_j
 ,s_equipment s_eq
 WHERE
 sh.shipment_gid = sh_eq_j.shipment_gid
 AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
 	)                                                                                                                                       EQUIPMENT




FROM shipment sh
left outer join shipment_refnum sh_ref_reg on ( sh_ref_reg.shipment_refnum_qual_gid = 'ULE.ULE_TRANSPORT_CONDITION'
                                                AND sh_ref_reg.shipment_gid = sh.shipment_gid)
,order_movement om
,order_release orls
left outer join order_release_refnum or_ref_reg on ( or_ref_reg.order_release_refnum_qual_gid = 'ULE.ULE_TRANSPORT_CONDITION'
                                                     AND or_ref_reg.order_release_gid = orls.order_release_gid)



WHERE
sh.shipment_gid = om.shipment_gid
AND orls.order_release_gid = om.order_release_gid
AND TO_CHAR(orls.insert_date,'YYYY') = '2016'
--AND TO_CHAR(orls.insert_date,'MM') = '01'
--AND ORLS.order_release_gid = 'ULE.4216049013'
AND (sh_ref_reg.shipment_refnum_value is null or or_ref_reg.order_release_refnum_value is null)