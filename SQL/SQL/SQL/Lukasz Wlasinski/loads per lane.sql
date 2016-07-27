select temp.SOURCE_LOCATION_GID
,temp.DEST_LOCATION_GID
,temp.SOURCE_CITY
,temp.DEST_CITY
,temp.SOURCE_COUNTRY
,temp.DEST_COUNTRY
,temp.s_loc_type
,temp.d_loc_type
,temp.tr_mode
,COUNT(CASE WHEN TEMP.TR_COND = 'AMBIENT' THEN TEMP.SHIPMENT_GID END) SH_AMB_COUNT
,COUNT(CASE WHEN TEMP.TR_COND = 'TEMPC' THEN TEMP.SHIPMENT_GID END) SH_TEMPC_COUNT
-- ,COUNT(CASE WHEN TEMP.TR_COND not in ('TEMPC','AMBIENT') THEN TEMP.SHIPMENT_GID END) SH_other_COUNT
,SUM(CASE WHEN TEMP.TR_COND = 'AMBIENT' THEN TEMP.TOTAL_COST_EUR END) SH_AMB_COUNT
,SUM(CASE WHEN TEMP.TR_COND = 'TEMPC' THEN TEMP.TOTAL_COST_EUR END) SH_TEMPC_COUNT
-- ,SUM(CASE WHEN TEMP.TR_COND not in ('TEMPC','AMBIENT') THEN TEMP.TOTAL_COST_EUR END) SH_other_COUNT




from(
SELECT sh.shipment_gid																							SHIPMENT_GID
,sh.transport_mode_gid																							TR_MODE
,sh.source_location_gid																							SOURCE_LOCATION_GID
,sh.dest_location_gid																							DEST_LOCATION_GID
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))                               								SOURCE_CITY
,UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))																DEST_CITY
,s_loc.country_code3_gid																						SOURCE_COUNTRY
,d_loc.country_code3_gid																						DEST_COUNTRY
,sh.source_location_gid||'-'||sh.dest_location_gid																UTMS_KEY
,UPPER(convert(s_loc.city,'US7ASCII','AL32UTF8'))||'-'||UPPER(convert(d_loc.city,'US7ASCII','AL32UTF8'))		LANE_NAME
,to_char(sh.start_time,'MM')																									SH_START_TIME
-- ,(CASE WHEN (UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
-- FROM shipment_refnum sh_ref
-- WHERE sh_ref.shipment_gid = sh.shipment_gid
-- AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
-- ))) = 'INBOUND' THEN
-- (
-- 'INBOUND')

-- ELSE
-- ('OUTBOUND')

-- END)																																					DISPATCHING_REGION
,(SELECT LISTAGG(sh_ref_1.shipment_refnum_value,'/') WITHIN GROUP (ORDER BY sh.shipment_gid)
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_TRANSPORT_CONDITION'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)																									TR_COND																											

,NVL(
(UPPER((SELECT listagg(sh_ref.RATE_GEO_REFNUM_VALUE,'/') within group (order by sh.shipment_gid)
                  FROM rate_geo_refnum sh_ref
                  WHERE sh_ref.rate_geo_gid = sh.rate_geo_gid
                  AND sh_ref.RATE_GEO_REFNUM_QUAL_GID = 'ULE.RG_CATEGORY'))),

(case
         WHEN ( UPPER((SELECT listagg(sh_ref.shipment_refnum_value,'/') within group (order by sh.shipment_gid)
                        FROM shipment_refnum sh_ref
                        WHERE sh_ref.shipment_gid = sh.shipment_gid
                        AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_MATERIAL_TYPE'))) <> 'FINISHED GOODS' THEN

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
,(SELECT LISTAGG(loc_ref.location_refnum_value,'/') WITHIN GROUP (ORDER BY sh.source_location_gid)
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.source_location_gid
AND loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE')																															S_LOC_TYPE
,(SELECT LISTAGG(loc_ref.location_refnum_value,'/') WITHIN GROUP (ORDER BY sh.dest_location_gid)
FROM location_refnum loc_ref
WHERE loc_ref.location_gid = sh.dest_location_gid
AND loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE')																															D_LOC_TYPE



--,sh.total_num_reference_units	PFS




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

FROM shipment sh
,location s_loc
,location d_loc

WHERE 1=1
AND s_loc.location_gid = sh.source_location_gid
AND d_loc.location_gid = sh.dest_location_gid
AND TO_CHAR(sh.start_time,'YYYY') = '2016'
-- AND TO_CHAR(sh.start_time,'MM') = '01'
-- AND TO_CHAR(sh.start_time,'MM') <= TO_CHAR(TRUNC(SYSDATE,'MM')-1,'MM')
AND NOT exists
	(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		AND sh_ref_1.shipment_gid = SH.shipment_gid)
-- AND sh.domain_name <> 'UGO'

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
) temp
group by
temp.SOURCE_LOCATION_GID
,temp.DEST_LOCATION_GID
,temp.SOURCE_CITY
,temp.DEST_CITY
,temp.SOURCE_COUNTRY
,temp.DEST_COUNTRY
,temp.s_loc_type
,temp.d_loc_type
,temp.tr_mode
HAVING
COUNT(CASE WHEN TEMP.TR_COND = 'AMBIENT' THEN TEMP.SHIPMENT_GID END) > 3
AND COUNT(CASE WHEN TEMP.TR_COND = 'TEMPC' THEN TEMP.SHIPMENT_GID END) > 3