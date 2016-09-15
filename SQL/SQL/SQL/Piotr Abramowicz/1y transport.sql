SELECT sh.shipment_gid																							SHIPMENT_GID
,om.order_release_gid																							or_id
,orls.source_location_gid																						or_source_loc
,orls.dest_location_gid																							or_dest_loc
,sh.source_location_gid																							sh_SOURCE_LOCATION_GID
,sh.dest_location_gid																							sh_DEST_LOCATION_GID
-- ,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))                               								SOURCE_CITY
-- ,UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))																DEST_CITY
-- ,sh.source_location_gid||'-'||sh.dest_location_gid																UTMS_KEY
-- ,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))||'-'||UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))		LANE_NAME
,to_char(sh.start_time,'YYYY-MM-DD')																									SH_START_TIME



-- ,CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
-- to_number((SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

-- FROM 		EQUIP_GROUP_EQUIP_REF_UNIT  egeru

-- WHERE egeru.EQUIPMENT_GROUP_GID =
-- (SELECT s_eq.equipment_group_gid
-- FROM shipment_s_equipment_join sh_eq_j
-- ,s_equipment s_eq
-- WHERE
-- sh.shipment_gid = sh_eq_j.shipment_gid
-- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
-- AND rownum <2
	-- )

-- AND egeru.EQUIPMENT_REFERENCE_UNIT_GID = 'ULE.PFS-EURO_PAL'

-- ))

-- ELSE sh.total_num_reference_units			END																											                        PFS
,sh.total_num_reference_units																													                        PFS
,nvl(NULLIF(sh.total_weight_base*0.45359237,0),1)                                                                                                            WEIGHT




,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
	)																																								EQUIPMENT_TYPE

-- ,nvl(TRIM(
-- (SELECT
-- SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				-- when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				-- unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				-- ELSE 0
				-- END	)						COST

		        -- FROM shipment_cost alloc_d

                -- WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                -- AND alloc_d.IS_WEIGHTED = 'N'
                -- AND alloc_d.COST_TYPE in ('B','A')f
-- )),0)																											                                                    TOTAL_COST_EUR
,nvl(TRIM(
(SELECT 
SUM(case
				when (alloc_d.cost_currency_gid = 'EUR' or alloc_d.cost_currency_gid IS null) THEN alloc_d.cost
				when alloc_d.cost_currency_gid <> 'EUR' THEN alloc_d.cost * 
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.cost_currency_gid,'EUR')
				ELSE 0
				END	)						COST
				
		FROM allocation_order_release_d alloc_d
		,ALLOCATION_BASE AB

		WHERE alloc_d.order_release_gid = orls.order_release_gid
		-- AND (alloc_d.cost_description  in ('B','A'))
		AND ab.alloc_seq_no = alloc_d.alloc_seq_no
		AND ab.shipment_gid = sh.shipment_gid
		-- AND alloc_d.IS_WEIGHTED = 'N'
		AND alloc_d.COST_DESCRIPTION in ('B','A')
)),0)																																										TOTAL_BASE_COST_EUR



FROM shipment sh
,location s_loc
,location d_loc
,order_movement om
,order_release orls

WHERE 1=1
AND s_loc.location_gid = sh.source_location_gid
AND d_loc.location_gid = sh.dest_location_gid
--AND sh.start_time >= to_date('2016-04-01','YYYY-MM-DD')
--AND sh.start_time < to_date('2016-05-01','YYYY-MM-DD')
AND sh.start_time >= to_date(:P_DATE_FROM,:P_DATE_TIME_FORMAT)
AND sh.start_time < to_date(:P_DATE_TO,:P_DATE_TIME_FORMAT)

AND om.shipment_gid = sh.shipment_gid
AND orls.order_release_gid = om.order_release_gid
-- AND TO_CHAR(sh.start_time,'YYYY') = :P_YEAR
-- AND TO_CHAR(sh.start_time,'MM') <= TO_CHAR(TRUNC(SYSDATE,'MM')-1,'MM')

AND NOT exists
	(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_Refnum_Value = 'PRIMARY'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)
		
		
AND sh.domain_name <> 'UGO'
--AND SH.SHIPMENT_GID IN ('ULE/PR.102181167','ULE/PR.102181359','ULE/PR.102174106','ULE/PR.102184372','ULE/PR.102184785')

--AND NOT exists (SELECT 1
--FROM shipment_refnum sh_ref
--WHERE sh_ref.shipment_gid = sh.shipment_gid
--AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
--AND sh_ref.shipment_refnum_value IN ('BULK')
--)
--AND	sh.shipment_type_gid = 'TRANSPORT'


--AND  exists
--(SELECT 1
--FROM shipment_stop ss
--,location_refnum lrp
--WHERE
--ss.shipment_gid = sh.shipment_gid
--AND lrp.LOCATION_GID = ss.location_gid
--AND lrp.location_refnum_qual_gid = 'ULE.ULE_SEND_TO_LOGISTAR'
--)
--and EXISTS (SELECT 1
--		FROM
--		SHIPMENT_STATUS SH_STATUS
--		WHERE
--		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
--		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
--		AND SH_STATUS.STATUS_VALUE_GID <> 'ULE/PR.NOT CANCELLED'
--		)






-- AND
-- (SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
-- FROM shipment_s_equipment_join sh_eq_j
-- ,s_equipment s_eq
-- WHERE
-- sh.shipment_gid = sh_eq_j.shipment_gid
-- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
	-- ) <> 'ULE.UNLIMITED'
