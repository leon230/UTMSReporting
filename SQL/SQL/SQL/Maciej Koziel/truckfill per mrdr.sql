SELECT sh.shipment_gid
,sh.source_location_gid
,sh.dest_location_gid
,s_eq.equipment_group_gid                                                                                                                                      EQUIPMENT
,ROUND(eg.EFFECTIVE_VOLUME,2)                                                                                                                    eq_effective_volume
,eg.EFFECTIVE_VOLUME_UOM_CODE                                                                                                                    eq_effective_volume_uom
,ROUND(eg.WIDTH_BASE*0.3048,2)                                                                                                                       eq_width
,ROUND(eg.LENGTH_BASE*0.3048,2)                                                                                                                     eg_length
,ROUND(eg.HEIGHT_BASE*0.3048,2)                                                                                                                     eg_height

,(SELECT sh_ref.shipment_refnum_value
               FROM shipment_refnum sh_ref
               WHERE sh_ref.shipment_gid = sh.shipment_gid
                AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_ORIGINAL_PFS'
                )                                                                                                                          PFS
,nvl(NULLIF(sh.total_weight_base*0.45359237,0),1)                                                                                                            SH_WEIGHT
,round(eg.effective_weight_base*0.45359237,2)                                                                                                TRUCK_WEIGHT
--,(SELECT sh_ref_1.shipment_Refnum_Value
-- 		FROM shipment_refnum sh_ref_1
-- 		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
-- 		AND sh_ref_1.shipment_gid = SH.shipment_gid)                                                                                        STREAM
,sh.shipment_type_gid
,su.transport_handling_unit_gid
,sul.packaged_item_gid
,sul.item_package_count
,su.ship_unit_count
,ROUND(su.total_gross_weight_base*0.45359237,2)                                                                                         weight_ship_unit
,ROUND(sul.WEIGHT_BASE*0.45359237,2)                                                                                                    item_weight


FROM shipment sh
LEFT OUTER JOIN shipment_s_equipment_join sh_eq_j ON (sh.shipment_gid = sh_eq_j.shipment_gid)
LEFT OUTER JOIN s_equipment s_eq ON (sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid)
LEFT OUTER JOIN equipment_group eg ON (eg.equipment_group_gid = s_eq.equipment_group_gid)

,order_release orls
LEFT OUTER JOIN ship_unit su ON (su.order_release_gid = orls.order_release_gid)
LEFT OUTER JOIN ship_unit_line sul ON (sul.ship_unit_gid = su.ship_unit_gid)
--LEFT OUTER JOIN packaged_item pi ON (pi.packaged_item_gid = sul.packaged_item_gid)
,order_movement om

WHERE

TO_CHAR(sh.start_time,'YYYY') = '2016'
AND TO_CHAR(sh.start_time,'MM') = '01'
AND om.ordeR_release_gid = orls.ordeR_release_gid
AND sh.shipment_gid = om.shipment_gid
AND sh.shipment_type_gid <> 'APPOINTMENT'
AND NOT EXISTS
(SELECT 1
 		FROM shipment_refnum sh_ref_1
 		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
 		AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
 		AND sh_ref_1.shipment_gid = SH.shipment_gid)
