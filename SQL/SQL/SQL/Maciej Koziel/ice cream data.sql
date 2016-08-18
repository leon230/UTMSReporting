SELECT sh.shipment_gid
,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
 FROM shipment_s_equipment_join sh_eq_j
 ,s_equipment s_eq
 WHERE
 sh.shipment_gid = sh_eq_j.shipment_gid
 AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
 	)                                                                                                                                       EQUIPMENT
,(SELECT sh_ref.shipment_refnum_value
               FROM shipment_refnum sh_ref
               WHERE sh_ref.shipment_gid = sh.shipment_gid
                AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_ORIGINAL_PFS'
                )
,sh.total_weight_base*0.45359237                                                                                                           WEIGHT
,(SELECT sh_ref_1.shipment_Refnum_Value
 		FROM shipment_refnum sh_ref_1
 		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
 		AND sh_ref_1.shipment_gid = SH.shipment_gid)                                                                                        STREAM
,sh.shipment_type_gid

FROM shipment sh


WHERE

TO_CHAR(sh.start_time,'YYYY') = '2016'
AND SH.SOURCE_LOCATION_GID IN ('ULE.V205315','ULE.V205283','ULE.V205292','ULE.V214488 ','ULE.V50474879  ','ULE.V162314','ULE.V207493')