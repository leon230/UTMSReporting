WITH BULK_DATA AS (

SELECT
sh.shipment_gid
,sh.source_location_gid
,sh.dest_location_gid
,DECODE(sh_ref_tm.shipment_refnum_value,'ROAD-SEA','SINGLE-MODAL','ROAD','SINGLE-MODAL','INTERMODAL') trans_mode
,s_eq.equipment_group_gid EQUIPMENT
,ROUND(sh.total_weight_base*0.45359237,0)   weight

FROM shipment sh
,shipment_refnum sh_ref_reg
,shipment_refnum sh_ref_tm
,shipment_s_equipment_join sh_eq_j
,s_equipment s_eq

WHERE
sh.shipment_gid = sh_ref_reg.shipment_gid
AND sh.shipment_gid = sh_ref_tm.shipment_gid
AND sh_ref_reg.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
AND sh_ref_reg.shipment_refnum_value = 'BULK'
AND sh_ref_tm.shipment_refnum_qual_gid = 'ULE.ULE_TRANSPORT_MODE'
AND sh.shipment_gid = sh_eq_j.shipment_gid
AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
)

,ROAD_DATA AS (
SELECT /*+ FULL(sh) leading(sh bd) */ sh.shipment_gid

,NVL(
NULLIF((ROUND(CASE WHEN NVL(sh.total_num_reference_units,0) > 33 THEN
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

ELSE sh.total_num_reference_units			END,0)),0)
    ,33
)	                                                                                                                                                         PFS
,nvl(NULLIF(sh.total_weight_base*0.45359237,0),1)                                                                                                            WEIGHT
,CASE WHEN sh.rate_geo_gid is null then 'N/A'
ELSE to_char(ROUND(sh.TOTAL_VOLUME_BASE*0.02831685))
END                                                                                                                                                TOTAL_VOLUME_CUM

,NVL(
NULLIF((
(SELECT listagg(egeru.LIMIT_NUM_REFERENCE_UNITS,'/') within group (order by sh.shipment_gid)

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

 )),'0')
 ,33)                                                                                                                                     TRUCK_CAPACITY_PFS
,(CASE
		WHEN (SELECT
			sh_ref_1.SHIPMENT_REFNUM_VALUE
		FROM
			shipment_refnum sh_ref_1
		WHERE
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_XLS_UPLD_SHIPMENT_REF_NO') is null THEN 'N'
		ELSE 'Y'
	END)																																								FLATTO

,CASE WHEN (SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
    FROM shipment_s_equipment_join sh_eq_j
 ,s_equipment s_eq
 WHERE
 sh.shipment_gid = sh_eq_j.shipment_gid
 AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
 	) like '%LTL%' THEN 'LTL' ELSE 'FTL' END 		                                                                                                                    FTL_LTL

,NVL(
NULLIF((CASE WHEN
 (UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
           FROM shipment_refnum sh_ref
           WHERE sh_ref.shipment_gid = sh.shipment_gid
           AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
           ))) = 'BULK' THEN
(select max(weight)
 from bulk_data bd
 where sh.source_location_gid = bd.source_location_gid
 and sh.dest_location_gid = bd.dest_location_gid
 AND bd.trans_mode = (select DECODE(sh_ref_tm.shipment_refnum_value,'ROAD-SEA','SINGLE-MODAL','ROAD','SINGLE-MODAL','INTERMODAL')
                                             FROM shipment_refnum sh_ref_tm
                                             WHERE sh_ref_tm.shipment_gid = sh.shipment_gid
                                             AND sh_ref_tm.shipment_refnum_qual_gid = 'ULE.ULE_TRANSPORT_MODE')
 AND bd.equipment =    (SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
                       FROM shipment_s_equipment_join sh_eq_j
                       ,s_equipment s_eq
                       WHERE
                       sh.shipment_gid = sh_eq_j.shipment_gid
                       AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
                       	)

 )
WHEN
    (SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
     FROM shipment_s_equipment_join sh_eq_j
     ,s_equipment s_eq
     WHERE
     sh.shipment_gid = sh_eq_j.shipment_gid
     AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
        ) IN ('ULE.13_6M ISOTHERMAL BOX TRAILER-33_26 PAL','ULE.LTL GENERIC TEMP_C','ULE.13_6M BOX TRAILER-33_26 PAL-A',
        'ULE.13_6M TILT TRAILER-33_26 PAL 28T','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL','ULE.LTL GENERIC AMB','ULE.13_6M TILT TRAILER-33_26 PAL',
        'ULE.13_6M MEGA TRAILER-33_26 PAL','ULE.13_6M TILT TRAILER-34_26 PAL (26T)','ULE.STANDARD_TRAILER_33_2Y','ULE.13_6M BOX TRAILER-33_26 PAL-A_2Y',
        'ULE.13_6M BOX TRAILER-33_26 PAL','ULE.13_6M CURTAIN SIDE TRAILER-33_26 PAL','ULE.TL GENERIC AMB','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL-A')
THEN
    (SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0) - 500

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
     )

ELSE

(SELECT round(EG.EFFECTIVE_WEIGHT_BASE*0.45359237,0)

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
 )   END),0)
 ,24000)                                                                                                                                     TRUCK_CAPACITY_WEIGHT


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
 )),0)                                                                                                                                      TOTAL_COST
,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
 FROM shipment_s_equipment_join sh_eq_j
 ,s_equipment s_eq
 WHERE
 sh.shipment_gid = sh_eq_j.shipment_gid
 AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
 	)                                                                                                                                       EQUIPMENT

FROM shipment sh

WHERE
NOT exists
	(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		AND sh_ref_1.shipment_gid = sh.shipment_gid)

AND (SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
 FROM shipment_s_equipment_join sh_eq_j
 ,s_equipment s_eq
 WHERE
 sh.shipment_gid = sh_eq_j.shipment_gid
 AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
 	) <> 'UNLIMITED'
)



SELECT /*+ leading(sh) */ sh.shipment_gid																							SHIPMENT_GID
,sh.source_location_gid																							SOURCE_LOCATION_GID
,sh.dest_location_gid																							DEST_LOCATION_GID
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))                               								SOURCE_CITY
,UPPER(convert(s_loc.country_code3_gid,'US7ASCII','AL32UTF8'))                               								SOURCE_COUNTRY
,UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))																DEST_CITY
,UPPER(convert(d_loc.country_code3_gid,'US7ASCII','AL32UTF8'))																DEST_COUNTRY
,sh.source_location_gid||'-'||sh.dest_location_gid																UTMS_KEY
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))||'-'||UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))		LANE_NAME
,to_char(sh.start_time,'YYYY-MM-DD')																									SH_START_TIME
,to_char(sh.end_time,'YYYY-MM-DD')																									SH_END_TIME
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
                        AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'))),'N/A')) in ('INBOUND','BULK') THEN

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
,rd.flatto                                                                                                                                                   FLATTO
,rd.pfs																											                                            PFS

,rd.weight																															                        PALLET_GROSS_WEIGHT_KG
,rd.TOTAL_VOLUME_CUM                                                                                                                                            TOTAL_VOLUME_CUM

,rd.truck_capacity_pfs																																		TRUCK_CAPACITY_PFS

,rd.truck_capacity_weight																																	TRUCK_CAPACITY_WEIGHT

,rd.equipment																																				EQUIPMENT_TYPE

,rd.total_cost																											                                    TOTAL_COST_EUR

,round(rd.pfs/rd.truck_capacity_pfs,2)																														PFS_PERC

,CASE WHEN rd.equipment in ('ULE.BARGE_AMB_1299_MT','ULE.BARGE_TEMPC_2333_MT','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_AMB_6513_MT','ULE.COASTER_BARGE_TEMPC_6513_MT') THEN 1
WHEN (round((rd.weight/(rd.truck_capacity_weight)),2)) > 1 THEN 1
WHEN (rd.weight/rd.pfs + rd.weight)> (rd.truck_capacity_weight) THEN 1
ELSE (round((rd.weight/(rd.truck_capacity_weight)),2)) END                                                                                                  WEIGHT_PERC


,(CASE WHEN (rd.total_cost) < 0 THEN 0 ELSE
TO_NUMBER(rd.total_cost) END) *

(
case when (UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
           FROM shipment_refnum sh_ref
           WHERE sh_ref.shipment_gid = sh.shipment_gid
           AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
           ))) = 'BULK'


 then
 ((1-(CASE WHEN rd.equipment in ('ULE.BARGE_AMB_1299_MT','ULE.BARGE_TEMPC_2333_MT','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_AMB_6513_MT','ULE.COASTER_BARGE_TEMPC_6513_MT') THEN 1
      WHEN (round((rd.weight/(rd.truck_capacity_weight)),2)) > 1 THEN 1
      WHEN (rd.weight/rd.pfs + rd.weight)> (rd.truck_capacity_weight) THEN 1
      ELSE (round((rd.weight/(rd.truck_capacity_weight)),2)) END)
   ))

 else

((CASE WHEN
(
round((
CASE WHEN rd.equipment in ('ULE.BARGE_AMB_1299_MT','ULE.BARGE_TEMPC_2333_MT','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_AMB_6513_MT','ULE.COASTER_BARGE_TEMPC_6513_MT') THEN 1
WHEN (round((rd.weight/(rd.truck_capacity_weight)),2)) > 1 THEN 1
WHEN (rd.weight/rd.pfs + rd.weight)> (rd.truck_capacity_weight) THEN 1
ELSE (round((rd.weight/(rd.truck_capacity_weight)),2)) END
),2)
) > round(rd.pfs/rd.truck_capacity_pfs,2)	THEN

(1-(round((CASE WHEN rd.equipment in ('ULE.BARGE_AMB_1299_MT','ULE.BARGE_TEMPC_2333_MT','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_AMB_6513_MT','ULE.COASTER_BARGE_TEMPC_6513_MT') THEN 1
           WHEN (round((rd.weight/(rd.truck_capacity_weight)),2)) > 1 THEN 1
           WHEN (rd.weight/rd.pfs + rd.weight)> (rd.truck_capacity_weight) THEN 1
           ELSE (round((rd.weight/(rd.truck_capacity_weight)),2)) END
                                                        ),2)))

ELSE
 (1-(round(rd.pfs/rd.truck_capacity_pfs,2)		)
 )

END
)) END)                                                                                                                                                         WASTAGE


FROM shipment sh
,road_data rd
,location s_loc
,location d_loc


WHERE 1=1
AND s_loc.location_gid = sh.source_location_gid
AND d_loc.location_gid = sh.dest_location_gid
 AND TO_CHAR(sh.start_time,'YYYY') = :P_YEAR
 AND TO_CHAR(sh.start_time,'MM') = :P_MONTH
 AND sh.source_location_gid = NVL(:P_SOURCE,sh.source_location_gid)
 AND sh.dest_location_gid = NVL(:P_DEST,sh.dest_location_gid)

 ANd rd.shipment_gid = sh.shipment_gid

 AND EXISTS
 (SELECT 1
 FROM shipment_refnum sh_ref
 WHERE sh_ref.shipment_gid = sh.shipment_gid
 ANd sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
 AND sh_ref.shipment_refnum_value = NVL(:P_REGION,sh_ref.shipment_refnum_value)
 )

AND COALESCE(:P_MSO,(SELECT loc_ref.location_refnum_value
               FROM location_refnum loc_ref
               WHERE loc_ref.location_gid = sh.dest_location_gid
               AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_MSO'
               ),'ALL') =
NVL((SELECT loc_ref.location_refnum_value
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.dest_location_gid
AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_MSO'
),'ALL')
--AND (SH.START_TIME) >= TO_DATE('2016-01-01','YYYY-MM-DD')
--AND (SH.START_TIME) < TO_DATE('2016-01-10','YYYY-MM-DD')
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

--AND SH.SOURCE_LOCATION_GID IN ('ULE.V205315','ULE.V205283','ULE.V205292','ULE.V214488 ','ULE.V50474879 ','ULE.V162314','ULE.V207493')