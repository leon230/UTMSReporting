SELECT sh.shipment_gid																							SHIPMENT_GID
,sh.source_location_gid																							SOURCE_LOCATION_GID
,sh.dest_location_gid																							DEST_LOCATION_GID
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))                               								SOURCE_CITY
,UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))																DEST_CITY
,sh.source_location_gid||'-'||sh.dest_location_gid																UTMS_KEY
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))||'-'||UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))		LANE_NAME
,to_char(sh.start_time,'MM')																									SH_START_TIME
,(CASE WHEN (UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
FROM shipment_refnum sh_ref
WHERE sh_ref.shipment_gid = sh.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
))) = 'INBOUND' THEN
(
'INBOUND-'||(SELECT loc.location_refnum_value
FROM location_refnum loc
WHERE loc.location_gid = sh.source_location_gid
AND loc.location_refnum_qual_gid = 'ULE.ULE_LTL_DBR'
))

ELSE
(UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
FROM shipment_refnum sh_ref
WHERE sh_ref.shipment_gid = sh.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
)))

END)																																					DISPATCHING_REGION

,NVL(
(UPPER((SELECT listagg(sh_ref.RATE_GEO_REFNUM_VALUE,'/') within group (order by sh.shipment_gid)
                  FROM rate_geo_refnum sh_ref
                  WHERE sh_ref.rate_geo_gid = sh.rate_geo_gid
                  AND sh_ref.RATE_GEO_REFNUM_QUAL_GID = 'ULE.RG_CATEGORY'))),

(case
         WHEN (NVL((UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
                        FROM shipment_refnum sh_ref
                        WHERE sh_ref.shipment_gid = sh.shipment_gid
                        AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_MATERIAL_TYPE'))),'N/A')) <> 'FINISHED GOODS' THEN

         (UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
                  FROM location_refnum loc_ref
                  WHERE loc_ref.location_gid = sh.DEST_LOCATION_GID
                  AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY'))
                  )
         ELSE
         (UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
               FROM location_refnum loc_ref
               WHERE loc_ref.location_gid = sh.source_location_gid
               AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_CATEGORY' ))
         ) END )
      )                                                                                                                                                                        DISPATCH_CATEGORY

,UPPER((SELECT listagg(NVL(loc_ref.location_refnum_value,'n/a'),'/') within group (order by sh.source_location_gid)
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.dest_location_gid
AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_MSO'

))																																                                                RECEIVING_MSO
,ROUND(CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
to_number((SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

FROM 		EQUIP_GROUP_EQUIP_REF_UNIT  egeru

WHERE egeru.EQUIPMENT_GROUP_GID =
(SELECT s_eq.equipment_group_gid
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
AND rownum <2
	)

AND egeru.EQUIPMENT_REFERENCE_UNIT_GID = 'ULE.PFS-EURO_PAL'

))

ELSE sh.total_num_reference_units			END,0)																											                        PFS
--,sh.total_num_reference_units	PFS


,sh.total_weight_base*0.45359237																																				PALLET_GROSS_WEIGHT_KG


,(SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

FROM 		EQUIP_GROUP_EQUIP_REF_UNIT  egeru

WHERE egeru.EQUIPMENT_GROUP_GID =
(SELECT s_eq.equipment_group_gid
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
AND rownum <2
	)

AND egeru.EQUIPMENT_REFERENCE_UNIT_GID = 'ULE.PFS-EURO_PAL'

)																																									TRUCK_CAPACITY_PFS

,(SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

FROM EQUIPMENT_GROUP EG
WHERE EG.EQUIPMENT_GROUP_GID =
(SELECT s_eq.equipment_group_gid
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
AND rownum <2
	)
)																																									TRUCK_CAPACITY_WEIGHT

,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
	)																																								EQUIPMENT_TYPE

,nvl(TRIM(
(SELECT
SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				ELSE 0
				END	)						COST

		        FROM shipment_cost alloc_d

                WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                AND alloc_d.IS_WEIGHTED = 'N'
                AND alloc_d.COST_TYPE in ('B','A')
)),0)																											                                                    TOTAL_COST_EUR



-- ,round(((CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
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

         -- ELSE sh.total_num_reference_units			END	)/
		-- (SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

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

-- )),2)																																								PFS_PERC

-- ,CASE WHEN (round((
-- sh.total_weight_base*0.45359237/
-- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

-- FROM EQUIPMENT_GROUP EG
-- WHERE EG.EQUIPMENT_GROUP_GID =
-- (SELECT s_eq.equipment_group_gid
-- FROM shipment_s_equipment_join sh_eq_j
-- ,s_equipment s_eq
-- WHERE
-- sh.shipment_gid = sh_eq_j.shipment_gid
-- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
-- AND rownum <2
-- ))),2)) > 1 THEN 1
-- ELSE
-- (round((
-- sh.total_weight_base*0.45359237/
-- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

-- FROM EQUIPMENT_GROUP EG
-- WHERE EG.EQUIPMENT_GROUP_GID =
-- (SELECT s_eq.equipment_group_gid
-- FROM shipment_s_equipment_join sh_eq_j
-- ,s_equipment s_eq
-- WHERE
-- sh.shipment_gid = sh_eq_j.shipment_gid
-- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
-- AND rownum <2
-- ))),2)) END																																								WEIGHT_PERC


-- ,(CASE WHEN (
-- nvl(TRIM(
-- (SELECT
-- SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				-- WHEN alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				-- unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				-- ELSE 0
				-- END	)						COST
                -- FROM shipment_cost alloc_d
                -- WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
		        -- AND alloc_d.IS_WEIGHTED = 'N'
		        -- AND alloc_d.COST_TYPE in ('B','A')
-- )),0)) < 0 THEN 0 ELSE
-- TO_NUMBER(
-- nvl(TRIM(
-- (SELECT
-- SUM(case when (alloc_d.COST_GID = 'EUR' OR alloc_d.COST_GID IS null) THEN alloc_d.cost
				-- when alloc_d.COST_GID <> 'EUR' THEN alloc_d.cost *
				-- unilever.ebs_procedures_ule.get_quarterly_ex_rate(nvl(sh.start_time,SYSDATE-60),alloc_d.COST_GID,'EUR')
				-- ELSE 0
				-- END	)						COST
		        -- FROM shipment_cost alloc_d
                -- WHERE alloc_d.SHIPMENT_GID = sh.SHIPMENT_GID
                -- AND alloc_d.IS_WEIGHTED = 'N'
                -- AND alloc_d.COST_TYPE in ('B','A')
-- )),0)) END) *

-- (case when (UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
           -- FROM shipment_refnum sh_ref
           -- WHERE sh_ref.shipment_gid = sh.shipment_gid
           -- AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
           -- ))) = 'BULK'


 -- then
 -- ((1-(CASE WHEN (round((
       -- sh.total_weight_base*0.45359237/
       -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

       -- FROM EQUIPMENT_GROUP EG
       -- WHERE EG.EQUIPMENT_GROUP_GID =
       -- (SELECT s_eq.equipment_group_gid
       -- FROM shipment_s_equipment_join sh_eq_j
       -- ,s_equipment s_eq
       -- WHERE
       -- sh.shipment_gid = sh_eq_j.shipment_gid
       -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
       -- AND rownum <2
       -- ))),2)) > 1 THEN 1
       -- ELSE
       -- (round((
       -- sh.total_weight_base*0.45359237/
       -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

       -- FROM EQUIPMENT_GROUP EG
       -- WHERE EG.EQUIPMENT_GROUP_GID =
       -- (SELECT s_eq.equipment_group_gid
       -- FROM shipment_s_equipment_join sh_eq_j
       -- ,s_equipment s_eq
       -- WHERE
       -- sh.shipment_gid = sh_eq_j.shipment_gid
       -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
       -- AND rownum <2
       -- ))),2)) END	)
   -- ))

 -- else

-- ((CASE WHEN
-- (
-- round(((CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
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

        -- ELSE sh.total_num_reference_units			END	)/
		-- (SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

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

-- )),2)
-- ) > (CASE WHEN (round((
     -- sh.total_weight_base*0.45359237/
     -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

     -- FROM EQUIPMENT_GROUP EG
     -- WHERE EG.EQUIPMENT_GROUP_GID =
     -- (SELECT s_eq.equipment_group_gid
     -- FROM shipment_s_equipment_join sh_eq_j
     -- ,s_equipment s_eq
     -- WHERE
     -- sh.shipment_gid = sh_eq_j.shipment_gid
     -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
     -- AND rownum <2
     -- ))),2)) > 1 THEN 1
     -- ELSE
     -- (round((
     -- sh.total_weight_base*0.45359237/
     -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

     -- FROM EQUIPMENT_GROUP EG
     -- WHERE EG.EQUIPMENT_GROUP_GID =
     -- (SELECT s_eq.equipment_group_gid
     -- FROM shipment_s_equipment_join sh_eq_j
     -- ,s_equipment s_eq
     -- WHERE
     -- sh.shipment_gid = sh_eq_j.shipment_gid
     -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
     -- AND rownum <2
     -- ))),2)) END
-- ) THEN

-- (1-(round(((CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
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

            -- ELSE sh.total_num_reference_units			END	)/
    		-- (SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

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

    -- )),2)))

-- ELSE
 -- (1-(CASE WHEN (round((
     -- sh.total_weight_base*0.45359237/
     -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

     -- FROM EQUIPMENT_GROUP EG
     -- WHERE EG.EQUIPMENT_GROUP_GID =
     -- (SELECT s_eq.equipment_group_gid
     -- FROM shipment_s_equipment_join sh_eq_j
     -- ,s_equipment s_eq
     -- WHERE
     -- sh.shipment_gid = sh_eq_j.shipment_gid
     -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
     -- AND rownum <2
     -- ))),2)) > 1 THEN 1
     -- ELSE
     -- (round((
     -- sh.total_weight_base*0.45359237/
     -- (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

     -- FROM EQUIPMENT_GROUP EG
     -- WHERE EG.EQUIPMENT_GROUP_GID =
     -- (SELECT s_eq.equipment_group_gid
     -- FROM shipment_s_equipment_join sh_eq_j
     -- ,s_equipment s_eq
     -- WHERE
     -- sh.shipment_gid = sh_eq_j.shipment_gid
     -- AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
     -- AND rownum <2
     -- ))),2)) END	)
 -- )

-- END
-- )) END

                                                                                                                                                      -- )WASTAGE
,sul.ship_unit_gid
,sul.packaged_item_gid
,pitem.description

FROM shipment sh
,location s_loc
,location d_loc
,order_movement om
,order_release orls
,ship_unit su
,ship_unit_line sul
left outer join packaged_item pitem ON (pitem.packaged_item_gid = sul.packaged_item_gid)

WHERE 1=1
AND s_loc.location_gid = sh.source_location_gid
AND d_loc.location_gid = sh.dest_location_gid
AND om.shipment_gid = sh.shipment_gid
AND om.order_release_gid = orls.order_release_gid
ANd su.order_release_gid = orls.order_release_gid
AND su.ship_unit_gid = sul.ship_unit_gid


 AND TO_CHAR(sh.start_time,'YYYY') = :P_YEAR
 AND TO_CHAR(sh.start_time,'MM') = :P_MONTH
--AND (SH.START_TIME) >= TO_DATE('2016-02-01','YYYY-MM-DD')
--AND (SH.START_TIME) < TO_DATE('2016-02-10','YYYY-MM-DD')
 --AND TO_CHAR(sh.start_time,'MM') <= TO_CHAR(TRUNC(SYSDATE,'MM')-1,'MM')
AND NOT exists
	(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)
--AND sh.domain_name <> 'UGO'

AND	sh.shipment_type_gid = 'TRANSPORT'


AND NOT exists
(SELECT 1
FROM shipment_stop ss
,location_refnum lrp
WHERE
ss.shipment_gid = sh.shipment_gid
AND lrp.LOCATION_GID = ss.location_gid
AND lrp.location_refnum_qual_gid = 'ULE.ULE_SEND_TO_LOGISTAR'
)
and EXISTS (SELECT 1
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		AND SH_STATUS.STATUS_VALUE_GID = 'ULE/PR.NOT CANCELLED'
		)


AND
(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
FROM shipment_s_equipment_join sh_eq_j
,s_equipment s_eq
WHERE
sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
	) <> 'ULE.UNLIMITED'