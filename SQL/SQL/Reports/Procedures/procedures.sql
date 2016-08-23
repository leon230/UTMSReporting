create or replace PACKAGE BODY EBS_PROCEDURES_ULE
AS
FUNCTION LATE_P(
    P_SHIPMENT_GID VARCHAR2)
  RETURN NUMBER
IS
  LATE NUMBER(1) :=2 ;
BEGIN
  SELECT
    (SELECT
      CASE
        WHEN EXISTS
          (SELECT 1
          FROM shipment_stop ST,
            ORDER_MOVEMENT vsor,
            order_release orls,
            shipment sh
          WHERE SH.SHIPMENT_GID      = P_SHIPMENT_GID
          AND SH.shipment_gid        = ST.shipment_gid
          AND vsor.order_release_gid = orls.order_release_gid
          AND vsor.shipment_gid      = sh.shipment_gid
          AND ST.stop_type           = 'P'
          AND ST.stop_num            = 1
          AND ( (
            CASE
              WHEN ( st.appointment_pickup IS NOT NULL )
              THEN
                CASE
                  WHEN TRUNC(CAST(From_tz(CAST(st.appointment_pickup AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE)) <= TRUNC(CAST(From_tz(CAST(St.planned_arrival AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE))
                  THEN ( CAST(From_tz(CAST(st.appointment_pickup AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE) + 120 / 60 / 24 )
                  ELSE To_date('01/01/1901', 'DD/MM/YYYY')
                END
              ELSE (
                CASE
                  WHEN st.planned_arrival > ALL(ORLS.LATE_PICKUP_DATE)
                  THEN CAST(From_tz(CAST(st.planned_arrival AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid
                    FROM location
                    WHERE location_gid = st.location_gid
                    ) AS DATE)
                  ELSE CAST(From_tz(CAST(
                    (SELECT MAX(ORLS1.LATE_PICKUP_DATE)
                    FROM ORDER_RELEASE ORLS1,
                      ORDER_MOVEMENT VSOR1
                    WHERE SH.SHIPMENT_GID       = VSOR1.SHIPMENT_GID
                    AND VSOR1.ORDER_RELEASE_GID = ORLS1.ORDER_RELEASE_GID
                    ) AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE)
                END                                       + NVL(
                (SELECT MAX(loc_ref.location_refnum_value)/24
                FROM location_refnum loc_ref
                WHERE st.location_gid                = loc_ref.location_gid
                AND loc_ref.location_refnum_qual_gid = 'ULE.CONTRACTED PICKUP TIME'
                ) , 0) )
            END ) - CAST(From_tz(CAST(st.actual_arrival AS TIMESTAMP), 'GMT') AT TIME ZONE
            (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
            ) AS DATE) ) < 0
          )
        THEN 1
        ELSE 0
      END AS late
    FROM dual
    )
  INTO LATE
  FROM DUAL ;
  -- TODO: Implementation required for FUNCTION EBS_PROCEDURES_ULE.BM_PICKUP
  RETURN LATE;
END LATE_P;
FUNCTION LATE_D(
    P_SHIPMENT_GID VARCHAR2)
  RETURN NUMBER
IS
  LATE NUMBER(1) :=2 ;
BEGIN
  SELECT
    (SELECT
      CASE
        WHEN EXISTS
          (SELECT 1
          FROM shipment_stop ST,
            ORDER_MOVEMENT vsor,
            order_release orls,
            shipment sh
          WHERE 1                    =1
          AND SH.SHIPMENT_GID        = P_SHIPMENT_GID
          AND SH.shipment_gid        = ST.shipment_gid
          AND vsor.order_release_gid = orls.order_release_gid
          AND vsor.shipment_gid      = sh.shipment_gid
          AND ST.stop_type           = 'D'
          AND ST.stop_num            =
            (SELECT num_stops
            FROM shipment
            WHERE shipment_gid = sh.shipment_gid
            )
          AND ( (
            CASE
              WHEN ( st.appointment_delivery IS NOT NULL )
              THEN
                CASE
                  WHEN TRUNC(CAST(From_tz(CAST(st.appointment_delivery AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE)) <= TRUNC(CAST(From_tz(CAST(St.planned_arrival + st.wait_time/60/60/24 AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE))
                  THEN ( CAST(From_tz(CAST(st.appointment_delivery AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE) + 120 / 60 / 24 )
                  ELSE To_date('01/01/1901', 'DD/MM/YYYY')
                END
              ELSE (
                CASE
                  WHEN (st.PLANNED_ARRIVAL                   + st.WAIT_TIME/60/60/24) > ALL(ORLS.LATE_DELIVERY_DATE)
                  THEN CAST(From_tz(CAST((st.PLANNED_ARRIVAL + st.WAIT_TIME/60/60/24) AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid
                    FROM location
                    WHERE location_gid = st.location_gid
                    ) AS DATE)
                  ELSE CAST(From_tz(CAST(
                    (SELECT MAX(ORLS1.LATE_DELIVERY_DATE)
                    FROM ORDER_RELEASE ORLS1,
                      ORDER_MOVEMENT VSOR1
                    WHERE SH.SHIPMENT_GID       = VSOR1.SHIPMENT_GID
                    AND VSOR1.ORDER_RELEASE_GID = ORLS1.ORDER_RELEASE_GID
                    ) AS TIMESTAMP), 'GMT') AT TIME ZONE
                    (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
                    ) AS DATE)
                END                                       + NVL(
                (SELECT MAX(loc_ref.location_refnum_value)/24
                FROM location_refnum loc_ref
                WHERE st.location_gid                = loc_ref.location_gid
                AND loc_ref.location_refnum_qual_gid = 'ULE.CONTRACTED DELIVERY TIME'
                ) , 0) )
            END ) - CAST(From_tz(CAST(st.actual_arrival AS TIMESTAMP), 'GMT') AT TIME ZONE
            (SELECT time_zone_gid FROM location WHERE location_gid = st.location_gid
            ) AS DATE) ) < 0
          )
        THEN 1
        ELSE 0
      END AS late
    FROM dual
    )
  INTO LATE
  FROM DUAL ;
  -- TODO: Implementation required for FUNCTION EBS_PROCEDURES_ULE.BM_PICKUP
  RETURN LATE;
END LATE_D;
FUNCTION GET_QUARTERLY_EX_RATE(
    COST_DATE                  IN DATE,
    FROM_CURRENCY              IN VARCHAR2,
    TO_CURRENCY                IN VARCHAR2,
    MATCH_LATEST_IF_EX_MISSING IN BOOLEAN DEFAULT TRUE)
  RETURN NUMBER
IS
  EX_RATE NUMBER;
BEGIN
  SELECT EX_R_1.EXCHANGE_RATE
  INTO EX_RATE
  FROM CURRENCY_EXCHANGE_RATE EX_R_1
  WHERE EX_R_1.TO_CURRENCY_GID     = TO_CURRENCY
  AND EX_R_1.EXCHANGE_RATE_GID     = 'ULE.ULE_QTY_EXCHANGE'
  AND TO_CHAR(COST_DATE, 'Q-YYYY') = TO_CHAR(EX_R_1.EFFECTIVE_DATE, 'Q-YYYY')
  AND EX_R_1.FROM_CURRENCY_GID     = FROM_CURRENCY;
  IF SQL%found THEN
    RETURN EX_RATE;
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  BEGIN
    SELECT EX_R_2.EXCHANGE_RATE
    INTO EX_RATE
    FROM CURRENCY_EXCHANGE_RATE EX_R_2
    WHERE EX_R_2.TO_CURRENCY_GID                           = TO_CURRENCY
    AND EX_R_2.EXCHANGE_RATE_GID                           = 'ULE.ULE_QTY_EXCHANGE'
    AND EX_R_2.FROM_CURRENCY_GID                           = FROM_CURRENCY
    AND (EX_R_2.EFFECTIVE_DATE, EX_R_2.FROM_CURRENCY_GID) IN
      (SELECT MAX(EFFECTIVE_DATE),
        FROM_CURRENCY_GID
      FROM CURRENCY_EXCHANGE_RATE
      WHERE TO_CURRENCY_GID = TO_CURRENCY
      AND FROM_CURRENCY_GID = FROM_CURRENCY
      AND EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE'
      GROUP BY FROM_CURRENCY_GID
      );
    IF MATCH_LATEST_IF_EX_MISSING = TRUE THEN
      RETURN EX_RATE;
    ELSE
      RETURN NULL;
    END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END;
END GET_QUARTERLY_EX_RATE;

PROCEDURE FINAL_ROLLBACK(P_FINAL_DATE DATE,
P_STREAM VARCHAR2)
IS
  
--Order list-----------------------------------  
 CURSOR P_OR_LIST
    IS 
      SELECT orls_ref.order_release_gid,orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID,orls_ref.ORDER_RELEASE_REFNUM_VALUE,orls_ref.domain_name
      FROM order_release_REFNUM orls_ref
      WHERE 
      trunc(ORLS_REF.INSERT_DATE) = P_FINAL_DATE
      and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_FINANCE_PO_NUMBER_LEG1','ULE.ULE_FINANCE_PO_NUMBER_LEG2','ULE.ULE_FINANCE_PO_NUMBER','ULE.ULE_FINANCE_PO_NUMBER_DESTLEG',
      'ULE.ULE_FINANCE_PO_NUMBER_SOURCELEG','ULE.ULE_FINANCE_PO_NUMBER_TRANSLEG','ULE.ULE_FINANCE_PO_NUMBER_HANDLING','ULE.ULE_FINAL_BILLING_NUMBER','ULE.ULE_FINAL_BILLING_NUMBER_HANDLING',
      'ULE.ULE_FINAL_BILLING_NUMBER_TRANSLEG','ULE.ULE_FINAL_BILLING_NUMBER_DESTLEG','ULE.ULE_FINAL_BILLING_NUMBER_LEG1','ULE.ULE_FINAL_BILLING_NUMBER_LEG2','ULE.ULE_FINAL_BILLING_NUMBER_SOURCELEG')
      -- 'ULE/PR.2013061525927_0001_0001'
      --and orls_ref.ORDER_RELEASE_REFNUM_VALUE = P_FINAL_NUMBER
      AND EXISTS(SELECT 1
      FROM order_release_refnum or_ref_temp
      WHERE or_ref_temp.ORDER_RELEASE_GID = ORLS_REF.ORDER_RELEASE_GID
      AND or_ref_temp.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
      AND or_ref_temp.ORDER_RELEASE_REFNUM_VALUE = P_STREAM);
      
--Shipment list--------------------------------------------------------
  CURSOR P_SHP_LIST
    IS 
    SELECT SH_STAT_TEMP.SHIPMENT_GID,SH_STAT_TEMP.STATUS_TYPE_GID,SH_STAT_TEMP.STATUS_VALUE_GID,SH_STAT_TEMP.DOMAIN_NAME
    FROM SHIPMENT_STATUS SH_STAT_TEMP
    WHERE SH_STAT_TEMP.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
    and SH_STAT_TEMP.STATUS_VALUE_GID = 'ULE/PR.SC_NO CHANGES ALLOWED'
    and trunc(SH_STAT_TEMP.update_date) = P_FINAL_DATE
    
    AND EXISTS(SELECT 1
    FROM SHIPMENT_REFNUM sh_ref_temp
    WHERE sh_ref_temp.SHIPMENT_GID = SH_STAT_TEMP.SHIPMENT_GID
    AND sh_ref_temp.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
    AND sh_ref_temp.SHIPMENT_REFNUM_VALUE = P_STREAM);
----------------------------------------------------------------------------------------


BEGIN
  SYS.DBMS_OUTPUT.PUT_LINE('PROCEDURE START' || P_FINAL_DATE);
--ORDER RELEASE REFNUM DELETE---------------------------  
dbms_output.put_line('ORDER_RELEASE');
dbms_output.put_line('ORDER_RELEASE_GID,ORDER_RELEASE_REFNUM_QUAL_GID,ORDER_RELEASE_REFNUM_VALUE,DOMAIN_NAME');


  FOR P_OR1 IN P_OR_LIST
    LOOP
      dbms_output.put_line(P_OR1.order_release_gid || ',' || P_OR1.ORDER_RELEASE_REFNUM_QUAL_GID || ',' || P_OR1.ORDER_RELEASE_REFNUM_VALUE || ',' || P_OR1.domain_name);
      --DELETE FROM ORDER_RELEASE_REFNUM OR_REFN WHERE OR_REFN.ORDER_RELEASE_GID =  p_sh.order_release_gid AND OR_REFN.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FINANCE_PO_NUMBER';
      --commit;
  END LOOP;
  --CLOSE P_OR_LIST;
  
dbms_output.put_line('SHIPMENT');
dbms_output.put_line('SHIPMENT_GID,STATUS_TYPE_GID,STATUS_VALUE_GID,DOMAIN_NAME');  
  
  FOR P_SH1 IN P_SHP_LIST
    LOOP
      dbms_output.put_line(P_SH1.SHIPMENT_GID || ',' || P_SH1.STATUS_TYPE_GID || ',' || P_SH1.STATUS_VALUE_GID || ',' || P_SH1.domain_name);
      --DELETE FROM ORDER_RELEASE_REFNUM OR_REFN WHERE OR_REFN.ORDER_RELEASE_GID =  p_sh.order_release_gid AND OR_REFN.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FINANCE_PO_NUMBER';
      --commit;
  END LOOP;
  --CLOSE P_SHP_LIST;
  
  
---------------------------------------------------------------------------------------
  Exception
  When others then
  dbms_output.put_line('ERROR' || SQLERRM || ' ' || SQLCODE);
  rollback;
END FINAL_ROLLBACK;


PROCEDURE FINAL_BILLING_CHECK(P_RUN_DATE DATE DEFAULT SYSDATE)
IS
  
  
 CURSOR C_MISMATCH_CURRENCY
    IS 
      SELECT SH_INV.shipment_gid
      FROM ule_view_invoice_status SH_INV
      WHERE SH_INV.mismacth_currency = 'Y'
            AND SH_INV.missing_base_cost = 'N'
            and rownum < 11;
      
    

BEGIN
  SYS.DBMS_OUTPUT.PUT_LINE('PROCEDURE START');
  SYS.DBMS_OUTPUT.PUT_LINE('MISMATCH CURRENCY START');
  
  FOR p_sh1 IN C_MISMATCH_CURRENCY
    LOOP
      dbms_output.put_line('SH NR: ' || p_sh1.shipment_gid);
      --DELETE FROM ORDER_RELEASE_REFNUM OR_REFN WHERE OR_REFN.ORDER_RELEASE_GID =  p_sh.order_release_gid AND OR_REFN.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FINANCE_PO_NUMBER';
      --commit;
    END LOOP;  


  Exception
  When others then
  dbms_output.put_line('ERROR' || SQLERRM);
  rollback;
END FINAL_BILLING_CHECK;

FUNCTION XDOCK_DIRECT_PRICE(P_SOURCE VARCHAR2, P_DESTINATION VARCHAR2, 
P_REF_DATE DATE, P_CONDITION VARCHAR2, P_SEARCH_COL VARCHAR2, P_MATCHING_TYPE VARCHAR2 DEFAULT NULL) RETURN VARCHAR2

IS 
  p_result varchar2(50) := NULL;

BEGIN
----------------CITY - CITY - START TIME - ROAD---------------------------------------
  select min(
  (SELECT (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN '-' ELSE TO_CHAR(RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS
				FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
				WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
				AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = P_SEARCH_COL
				)
        )
  into p_result
  from X_LANE XL,
        RATE_GEO RG,
        RATE_GEO_COST RGC,
        location loc_source,
        location loc_dest
        
  where XL.X_LANE_GID = RG.X_LANE_GID
  and loc_source.location_gid = xl.source_location_gid
  and loc_dest.location_gid = xl.dest_location_gid
  and loc_source.city = P_SOURCE
  and loc_dest.city = P_DESTINATION
  and P_REF_DATE between RG.EFFECTIVE_DATE and RG.EXPIRATION_DATE
  and RGC.RATE_GEO_COST_GROUP_GID = RG.RATE_GEO_GID
  AND rgc.RATE_GEO_COST_GROUP_GID NOT LIKE '%2Y%'
  AND RGC.CHARGE_ACTION <> 'W'
  AND (case when (CASE
							WHEN RGC.LEFT_OPERAND1 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE1
							ELSE  CASE
                      WHEN RGC.LEFT_OPERAND2 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE2
                      ELSE  CASE
                              WHEN RGC.LEFT_OPERAND3 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE3
                              ELSE  CASE
                                      WHEN RGC.LEFT_OPERAND4 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE4
                                      ELSE ' ' END
                                    END
                            END
                    END) in ('ULE.13_6M BOX TRAILER-33_26 PAL','ULE.13_6M BOX TRAILER-33_26 PAL 28T','ULE.13_6M DOUBLE DECK-2 WIN TYPE-52_40 PAL','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL',
    'ULE.45FT PALLETWIDE CTR-33_26 PAL','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_TEMPC_6513_MT','ULE.LTL GENERIC TEMP_C','ULE.REF_20CO-10_9 PAL','ULE.REF_40CO-23_20 PAL','ULE.REF_40HC-23_20 PAL',
    'ULE.SMALL TRUCK-UP TO 1_5T-8_6 PAL','ULE.SMALL TRUCK-UP TO 3_5T-15_12 PAL','ULE.SMALL TRUCK-UP TO 5_5T-18_14 PAL','ULE.TANKER-UP TO 33T','ULE.TANKER-UP TO 33T MULTICOMPARTMENT','ULE.TANKER-UP TO 35T',
    'ULE.13_6M BOX TRAILER-33_26 PAL_NORDICS','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL-NORD','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL [26T]','ULE.13_6M DOUBLE DECK-2 WIN TYPE-54_40 PAL','ULE.LTL GENERIC TEMP NL') 
		then 'TEMPC' ELSE 'AMB' end) = P_CONDITION
    AND EXISTS (SELECT 1	
				FROM LANE_ATTRIBUTE LA_TYPE,
				RATE_GEO RG_TEMP
				WHERE
				RG_TEMP.X_LANE_GID = LA_TYPE.X_LANE_GID 
        AND LA_TYPE.X_LANE_GID = XL.X_LANE_GID 
				AND RG_TEMP.RATE_GEO_GID = RG.RATE_GEO_GID
				AND LA_TYPE.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_TRANSPORT_MODE'
        AND LA_TYPE.LANE_ATTRIBUTE_VALUE = 'ROAD'
		)
  ;
---------------------------------------------------------------------------------------------------------------- 
  ----------------CITY - CITY - START TIME - INTERMODAL---------------------------------------
  if p_result is  null then
    select min(
    (SELECT (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN '-' ELSE TO_CHAR(RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS
          FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
          WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
          AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = P_SEARCH_COL
          )
          )
    into p_result
    from X_LANE XL,
          RATE_GEO RG,
          RATE_GEO_COST RGC,
          location loc_source,
          location loc_dest
          
    where XL.X_LANE_GID = RG.X_LANE_GID
    and loc_source.location_gid = xl.source_location_gid
    and loc_dest.location_gid = xl.dest_location_gid
    and loc_source.city = P_SOURCE
    and loc_dest.city = P_DESTINATION
    and P_REF_DATE between RG.EFFECTIVE_DATE and RG.EXPIRATION_DATE
    and RGC.RATE_GEO_COST_GROUP_GID = RG.RATE_GEO_GID
    AND rgc.RATE_GEO_COST_GROUP_GID NOT LIKE '%2Y%'
    AND RGC.CHARGE_ACTION <> 'W'
    AND (case when (CASE
                WHEN RGC.LEFT_OPERAND1 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE1
                ELSE  CASE
                        WHEN RGC.LEFT_OPERAND2 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE2
                        ELSE  CASE
                                WHEN RGC.LEFT_OPERAND3 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE3
                                ELSE  CASE
                                        WHEN RGC.LEFT_OPERAND4 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE4
                                        ELSE ' ' END
                                      END
                              END
                      END) in ('ULE.13_6M BOX TRAILER-33_26 PAL','ULE.13_6M BOX TRAILER-33_26 PAL 28T','ULE.13_6M DOUBLE DECK-2 WIN TYPE-52_40 PAL','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL',
      'ULE.45FT PALLETWIDE CTR-33_26 PAL','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_TEMPC_6513_MT','ULE.LTL GENERIC TEMP_C','ULE.REF_20CO-10_9 PAL','ULE.REF_40CO-23_20 PAL','ULE.REF_40HC-23_20 PAL',
      'ULE.SMALL TRUCK-UP TO 1_5T-8_6 PAL','ULE.SMALL TRUCK-UP TO 3_5T-15_12 PAL','ULE.SMALL TRUCK-UP TO 5_5T-18_14 PAL','ULE.TANKER-UP TO 33T','ULE.TANKER-UP TO 33T MULTICOMPARTMENT','ULE.TANKER-UP TO 35T',
      'ULE.13_6M BOX TRAILER-33_26 PAL_NORDICS','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL-NORD','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL [26T]','ULE.13_6M DOUBLE DECK-2 WIN TYPE-54_40 PAL','ULE.LTL GENERIC TEMP NL') 
      then 'TEMPC' ELSE 'AMB' end) = P_CONDITION
      AND EXISTS (SELECT 1	
          FROM LANE_ATTRIBUTE LA_TYPE,
          RATE_GEO RG_TEMP
          WHERE
          RG_TEMP.X_LANE_GID = LA_TYPE.X_LANE_GID 
          AND LA_TYPE.X_LANE_GID = XL.X_LANE_GID 
          AND RG_TEMP.RATE_GEO_GID = RG.RATE_GEO_GID
          AND LA_TYPE.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_TRANSPORT_MODE'
          AND LA_TYPE.LANE_ATTRIBUTE_VALUE <> 'ROAD'
      )
    ;
  end if;
---------------------------------------------------------------------------------------------------------------- 
  
----------------CITY - CITY - ROAD---------------------------------------
  select min(
  (SELECT (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN '-' ELSE TO_CHAR(RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS
				FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
				WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
				AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = P_SEARCH_COL
				)
        )
  into p_result
  from X_LANE XL,
        RATE_GEO RG,
        RATE_GEO_COST RGC,
        location loc_source,
        location loc_dest
        
  where XL.X_LANE_GID = RG.X_LANE_GID
  and loc_source.location_gid = xl.source_location_gid
  and loc_dest.location_gid = xl.dest_location_gid
  and loc_source.city = P_SOURCE
  and loc_dest.city = P_DESTINATION
  and RGC.RATE_GEO_COST_GROUP_GID = RG.RATE_GEO_GID
  AND rgc.RATE_GEO_COST_GROUP_GID NOT LIKE '%2Y%'
  AND RGC.CHARGE_ACTION <> 'W'
  AND (case when (CASE
							WHEN RGC.LEFT_OPERAND1 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE1
							ELSE  CASE
                      WHEN RGC.LEFT_OPERAND2 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE2
                      ELSE  CASE
                              WHEN RGC.LEFT_OPERAND3 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE3
                              ELSE  CASE
                                      WHEN RGC.LEFT_OPERAND4 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE4
                                      ELSE ' ' END
                                    END
                            END
                    END) in ('ULE.13_6M BOX TRAILER-33_26 PAL','ULE.13_6M BOX TRAILER-33_26 PAL 28T','ULE.13_6M DOUBLE DECK-2 WIN TYPE-52_40 PAL','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL',
    'ULE.45FT PALLETWIDE CTR-33_26 PAL','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_TEMPC_6513_MT','ULE.LTL GENERIC TEMP_C','ULE.REF_20CO-10_9 PAL','ULE.REF_40CO-23_20 PAL','ULE.REF_40HC-23_20 PAL',
    'ULE.SMALL TRUCK-UP TO 1_5T-8_6 PAL','ULE.SMALL TRUCK-UP TO 3_5T-15_12 PAL','ULE.SMALL TRUCK-UP TO 5_5T-18_14 PAL','ULE.TANKER-UP TO 33T','ULE.TANKER-UP TO 33T MULTICOMPARTMENT','ULE.TANKER-UP TO 35T',
    'ULE.13_6M BOX TRAILER-33_26 PAL_NORDICS','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL-NORD','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL [26T]','ULE.13_6M DOUBLE DECK-2 WIN TYPE-54_40 PAL','ULE.LTL GENERIC TEMP NL') 
		then 'TEMPC' ELSE 'AMB' end) = P_CONDITION
    AND EXISTS (SELECT 1	
				FROM LANE_ATTRIBUTE LA_TYPE,
				RATE_GEO RG_TEMP
				WHERE
				RG_TEMP.X_LANE_GID = LA_TYPE.X_LANE_GID 
        AND LA_TYPE.X_LANE_GID = XL.X_LANE_GID 
				AND RG_TEMP.RATE_GEO_GID = RG.RATE_GEO_GID
				AND LA_TYPE.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_TRANSPORT_MODE'
        AND LA_TYPE.LANE_ATTRIBUTE_VALUE = 'ROAD'
		)
  ;
---------------------------------------------------------------------------------------------------------------- 
  ----------------CITY - CITY - INTERMODAL---------------------------------------
  if p_result is  null then
    select min(
    (SELECT (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN '-' ELSE TO_CHAR(RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS
          FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
          WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
          AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = P_SEARCH_COL
          )
          )
    into p_result
    from X_LANE XL,
          RATE_GEO RG,
          RATE_GEO_COST RGC,
          location loc_source,
          location loc_dest
          
    where XL.X_LANE_GID = RG.X_LANE_GID
    and loc_source.location_gid = xl.source_location_gid
    and loc_dest.location_gid = xl.dest_location_gid
    and loc_source.city = P_SOURCE
    and loc_dest.city = P_DESTINATION
    and RGC.RATE_GEO_COST_GROUP_GID = RG.RATE_GEO_GID
    AND rgc.RATE_GEO_COST_GROUP_GID NOT LIKE '%2Y%'
    AND RGC.CHARGE_ACTION <> 'W'
    AND (case when (CASE
                WHEN RGC.LEFT_OPERAND1 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE1
                ELSE  CASE
                        WHEN RGC.LEFT_OPERAND2 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE2
                        ELSE  CASE
                                WHEN RGC.LEFT_OPERAND3 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE3
                                ELSE  CASE
                                        WHEN RGC.LEFT_OPERAND4 = 'SHIPMENT.EQUIPMENT.EQUIPMENT_GROUP_GID' THEN RGC.LOW_VALUE4
                                        ELSE ' ' END
                                      END
                              END
                      END) in ('ULE.13_6M BOX TRAILER-33_26 PAL','ULE.13_6M BOX TRAILER-33_26 PAL 28T','ULE.13_6M DOUBLE DECK-2 WIN TYPE-52_40 PAL','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL',
      'ULE.45FT PALLETWIDE CTR-33_26 PAL','ULE.BARGE_TEMPC_2333_MT','ULE.COASTER_BARGE_TEMPC_6513_MT','ULE.LTL GENERIC TEMP_C','ULE.REF_20CO-10_9 PAL','ULE.REF_40CO-23_20 PAL','ULE.REF_40HC-23_20 PAL',
      'ULE.SMALL TRUCK-UP TO 1_5T-8_6 PAL','ULE.SMALL TRUCK-UP TO 3_5T-15_12 PAL','ULE.SMALL TRUCK-UP TO 5_5T-18_14 PAL','ULE.TANKER-UP TO 33T','ULE.TANKER-UP TO 33T MULTICOMPARTMENT','ULE.TANKER-UP TO 35T',
      'ULE.13_6M BOX TRAILER-33_26 PAL_NORDICS','ULE.21_3M BOX ROAD-TRAIN-52_40 PAL-NORD','ULE.13_6M DOUBLE DECK-REMOV FLOOR-66_52 PAL [26T]','ULE.13_6M DOUBLE DECK-2 WIN TYPE-54_40 PAL','ULE.LTL GENERIC TEMP NL') 
      then 'TEMPC' ELSE 'AMB' end) = P_CONDITION
      AND EXISTS (SELECT 1	
          FROM LANE_ATTRIBUTE LA_TYPE,
          RATE_GEO RG_TEMP
          WHERE
          RG_TEMP.X_LANE_GID = LA_TYPE.X_LANE_GID 
          AND LA_TYPE.X_LANE_GID = XL.X_LANE_GID 
          AND RG_TEMP.RATE_GEO_GID = RG.RATE_GEO_GID
          AND LA_TYPE.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_TRANSPORT_MODE'
          AND LA_TYPE.LANE_ATTRIBUTE_VALUE <> 'ROAD'
      )
    ;
  end if;
---------------------------------------------------------------------------------------------------------------- 


  if p_result is null then
    p_result := 'No Data avaialable';
  end if;

RETURN p_result;


END XDOCK_DIRECT_PRICE;




END EBS_PROCEDURES_ULE;


  PROCEDURE FINAL_ROLLBACK(P_FINAL_DATE DATE,
                            P_FINAL_NUMBER VARCHAR2 DEFAULT NULL,
                            P_SHIPMENT_NUMBER VARCHAR2 DEFAULT NULL,
                            P_SERVPROV_ID VARCHAR2 DEFAULT NULL,
                            P_STREAM VARCHAR2);
                            
  PROCEDURE FINAL_BILLING_CHECK(P_RUN_DATE DATE DEFAULT SYSDATE);
  
  
  FUNCTION XDOCK_DIRECT_PRICE(P_SOURCE VARCHAR2, P_DESTINATION VARCHAR2, 
P_REF_DATE DATE, P_CONDITION VARCHAR2, P_SEARCH_COL VARCHAR2, P_MATCHING_TYPE VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

/
FUNCTION TRUCKFILL_PFS(p_truckfill BOOLEAN) RETURN VARCHAR2

IS
  p_result varchar2(50) := NULL;

BEGIN


/








































