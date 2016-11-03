select sh.shipment_gid,
    TO_CHAR(cast(From_tz(cast(sh.start_time AS TIMESTAMP), 'GMT') AT TIME ZONE (select time_zone_gid from location where location_gid = sh.source_location_gid) as date),'DD-MM-YYYY HH24:MI:SS') START_TIME,
    TO_CHAR(cast(From_tz(cast(sh.end_time AS TIMESTAMP), 'GMT') AT TIME ZONE (select time_zone_gid from location where location_gid =  sh.dest_location_gid) as date),'DD-MM-YYYY HH24:MI:SS') END_TIME,
    A.STATUS_REASON_CODE_GID,
    F.DESCRIPTION Reason_Code,
    C.reporting_gluser Report_user,
    TO_CHAR(nvl(cast(From_tz(cast(C.insert_date AS TIMESTAMP), 'GMT') AT TIME ZONE (select time_zone_gid from location where location_gid = c.event_location_gid) as date),C.insert_date),'DD-MM-YYYY HH24:MI:SS') INSERT_DATE ,
    TO_CHAR(nvl(cast(From_tz(cast(a.eventdate AS TIMESTAMP), 'GMT') AT TIME ZONE (select time_zone_gid from location where location_gid = c.event_location_gid) as date),C.insert_date),'DD-MM-YYYY HH24:MI:SS') EVENT_DATE,

    sh.source_location_gid,
    (select loc1.city from location loc1 where loc1.location_gid = sh.source_location_gid) source_city,
    sh.dest_location_gid,
    (select loc1.city from location loc1 where loc1.location_gid = sh.dest_location_gid) dest_city ,
    sr_region.shipment_refnum_value "REGION",
    SH.SERVPROV_GID,
    (SELECT
            CAR_LOC.LOCATION_NAME
        FROM
            LOCATION CAR_LOC
        WHERE
            SH.SERVPROV_GID = CAR_LOC.location_gid) 	CARRIER_NAME,
      C.shipment_stop_num
    ,(select
    sum(CASE
                    WHEN (sc_temp.COST_GID = 'EUR' or sc_temp.COST_GID is null) THEN sc_temp.COST
                    when sc_temp.COST_GID <> 'EUR' then sc_temp.COST *
                    unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sh.start_time,sc_temp.COST_GID,'EUR')
                    END)
    from shipment_cost sc_temp
    WHERE sc_temp.shipment_gid = sh.shipment_gid
    )																								FINAL_SHIPMENT_COST
    ,SH.PLANNED_RATE_GEO_GID
    ,(select sum(rgc_temp.CHARGE_AMOUNT)
     		from rate_geo_cost rgc_temp
     		WHERE rgc_temp.RATE_GEO_COST_GROUP_GID = SH.PLANNED_RATE_GEO_GID
     		AND rgc_temp.CHARGE_ACTION = 'A'
     		)                                                                                       PLANNED_COST
    ,
    (SELECT (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN '-' ELSE TO_CHAR(RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS
    				FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1
    				WHERE RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID = SH.PLANNED_RATE_GEO_GID
    				AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = 'ULE/PR.PALLET_'||SH.TOTAL_SHIP_UNIT_COUNT
    				)                                                                               PLANNED_COST_LTL
    ,SH.TOTAL_SHIP_UNIT_COUNT                                                                           PFS
    ,SH.TRANSPORT_MODE_GID                                                                              TRANSPORT_MODE_GID
    ,(SELECT listagg(s_eq.equipment_group_gid,'/') within group (order by sh.shipment_gid)
      FROM shipment_s_equipment_join sh_eq_j
      ,s_equipment s_eq
      WHERE
      sh.shipment_gid = sh_eq_j.shipment_gid
      AND sh_eq_j.s_equipment_gid = s_eq.s_equipment_gid
      	)                                                                                                                                       EQUIPMENT
     ,(SELECT sh_ref.SHIPMENT_REFNUM_VALUE
     FROM shipment_refnum sh_ref
     WHERE
     	sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.TEMPERATURE_RANGE'
     	and sh_ref.shipment_gid = sh.shipment_gid

     )                                                                                                                                           TEMPERATURE_RANGE
     ,(SELECT sh_ref.SHIPMENT_REFNUM_VALUE
         FROM shipment_refnum sh_ref
         WHERE
         	sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_MODE'
         	and sh_ref.shipment_gid = sh.shipment_gid

         )                                                                                                                                           TRANSPORT_MODE


from shipment sh
    join ss_status_history C on sh.shipment_gid = C.shipment_gid
    join ie_shipmentstatus A on C.i_transaction_no = A.i_transaction_no
    join bs_reason_code F on A.STATUS_REASON_CODE_GID = F.bs_reason_code_gid
    left outer join shipment_refnum sr_region on sh.shipment_gid = sr_region.shipment_gid AND sr_region.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'



where
--    sh.start_time >= to_date('2015-10-01','YYYY-MM-DD')
--    AND sh.start_time < to_date('2016-01-01','YYYY-MM-DD')

    sh.start_time >= to_date('2016-01-01','YYYY-MM-DD')
  AND sh.start_time < to_date('2016-10-01','YYYY-MM-DD')
    -- cast(From_tz(cast(sh.end_time AS TIMESTAMP), 'GMT') AT TIME ZONE (select time_zone_gid from location where location_gid = sh.dest_location_gid) as date) between to_date(:P_START_DATE,:P_DATE_TIME_FORMAT) AND to_date(:P_END_DATE,:P_DATE_TIME_FORMAT)
    and a.domain_name = 'ULE/PR'
    -- AND sr_region.shipment_refnum_value = NVL(:P_REGION,sr_region.shipment_refnum_value)
    and sh.IS_SPOT_COSTED = 'Y'