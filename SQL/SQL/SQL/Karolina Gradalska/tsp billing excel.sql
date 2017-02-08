SELECT
		ORLS.ORDER_RELEASE_GID																																	OR_ID,
		VORLS.SHIPMENT_GID 																																		SH_GID,
		or_ref_po.order_release_refnum_value                                                                                                                    PO,
		TO_CHAR(SH.END_TIME,'YYYY-MM-DD')                                                                                                                         unloading_time,

		src_loc.location_xid																															cr_id,
		src_loc.location_name																															cr_name,
		dest_loc.location_xid																															cn_id,
		dest_loc.location_name																															cn_name,




        sh.servprov_gid                                                                                                                                     billing_partner,
        (select loc.location_name
		from location loc
		where loc.location_gid = sh.servprov_gid)    																										billing_partner_name,

		(select rg.X_LANE_GID
		from rate_geo rg
		where rg.RATE_GEO_GID = sh.RATE_GEO_GID)																											lane_id,


		ORLS.EQUIPMENT_GROUP_GID																															CONTAINER_TYPE,

		(SELECT ORLS_REF.ORDER_RELEASE_REFNUM_VALUE
		FROM ORDER_RELEASE_REFNUM ORLS_REF
		WHERE
		ORLS_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		AND ORLS_REF.ORDER_RELEASE_REFNUM_QUAL_GID='ULE.ULE_TRANSPORT_CONDITION'

		) AS																																					SERVICE_LEVEL,


		CASE WHEN ORLS.ORDER_RELEASE_TYPE_GID = 'INBOUND' THEN 'INBOUND'
		ELSE 'OUTBOUND'
		END AS																																					INB_OUTB,




		(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_GLN'

		) 																													GLN,
		(select orls_ref.ORDER_RELEASE_REFNUM_VALUE
		from order_release_refnum orls_ref
		where orls_ref.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
		and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_COST CENTER'

		) 																													COST_CENTER,


		(SELECT LISTAGG(OR_MAT.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY OR_MAT.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM OR_MAT
		WHERE OR_MAT.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		AND OR_MAT.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_TYPE') AS 																					MATERIAL



		     , CASE WHEN (or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                (SELECT alloc_line.cost_currency_gid
                 FROM   allocation_or_line_d alloc_line
                       ,order_release_line   orl_line
                       ,allocation_base      alloc_base
                 WHERE  orl_line.order_release_gid IN ORLS.order_release_gid
                 AND    alloc_base.shipment_gid         = SH.shipment_gid
                 AND    alloc_line.cost_description     = 'B'
                 AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                 AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no
                 --IC 20131208 added rownum = 1 because one order can have several order release lines
				 AND ROWNUM = 1)
               ELSE
			   (SELECT alloc.cost_currency_gid
                 FROM   allocation_order_release_d alloc
                       ,allocation_base            alloc_base
                 WHERE  alloc.order_release_gid = ORLS.order_release_gid
                 AND    alloc_base.shipment_gid = SH.shipment_gid
                 AND    alloc.cost_description  = 'B'
                 AND    alloc.alloc_seq_no      = alloc_base.alloc_seq_no
				 AND    ROWNUM = 1)
             END                                                                      CURRENCY

     , ROUND(NVL(CASE WHEN(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                 (SELECT SUM(alloc_line.cost)
                  FROM   allocation_or_line_d alloc_line
                        ,order_release_line   orl_line
                        ,allocation_base      alloc_base
                  WHERE  orl_line.order_release_gid IN ORLS.order_release_gid
                  AND    alloc_base.shipment_gid         = SH.shipment_gid
                  AND    alloc_line.cost_description IN ('A','B')
                  AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                  AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no)
                  ELSE
                 (SELECT SUM(alloc.cost)
                  FROM   allocation_order_release_d alloc
                        ,allocation_base alloc_base
                  WHERE  alloc.order_release_gid = ORLS.order_release_gid
                  AND    alloc_base.shipment_gid = SH.shipment_gid
                  AND    alloc.cost_description IN ('A','B')
                  AND    alloc.alloc_seq_no      = alloc_base.alloc_seq_no)
          END
		  ,0), 2)                                                                  TOTAL_COST

		  , ROUND(NVL(CASE WHEN(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                 (SELECT SUM(alloc_line.cost)
                  FROM   allocation_or_line_d alloc_line
                        ,order_release_line   orl_line
                        ,allocation_base      alloc_base
                        ,accessorial_code     ac
                  WHERE  orl_line.order_release_gid IN orls.order_release_gid
                  AND    alloc_base.shipment_gid         = sh.shipment_gid
                  AND    alloc_line.cost_description IN ('A')
                  AND    alloc_line.accessorial_code_gid = ac.accessorial_code_gid

                        and ac.accessorial_code_xid not like 'ULE_FUEL_SURCHARGE_%'
                        and ac.accessorial_code_xid != 'ULE_FUEL SURCHARGE CORLECTION'
                  AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                  AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no)
                 ELSE
				 (SELECT SUM(alloc.cost)
                   FROM   allocation_order_release_d alloc
                         ,allocation_base            alloc_base
                         ,accessorial_code           ac
                   WHERE  alloc.order_release_gid    = orls.order_release_gid
                   AND    alloc_base.shipment_gid    = sh.shipment_gid
                   AND    alloc.cost_description IN ('A')
                   AND    alloc.accessorial_code_gid = ac.accessorial_code_gid

                        and ac.accessorial_code_xid not like 'ULE_FUEL_SURCHARGE_%'
                        and ac.accessorial_code_xid != 'ULE_FUEL SURCHARGE CORLECTION'
                   AND    alloc.alloc_seq_no         = alloc_base.alloc_seq_no)
                 END
				 , 0), 2)                                                          CLAIMED_COST

				      , ROUND(DECODE (sh.transport_mode_gid, 'TL'
                    ,NVL(CASE WHEN(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                               (SELECT SUM(alloc_line.cost)
                                FROM   allocation_or_line_d alloc_line
                                      ,order_release_line   orl_line
                                      ,allocation_base      alloc_base
                                WHERE  orl_line.order_release_gid IN orls.order_release_gid
                                AND    alloc_base.shipment_gid         = sh.shipment_gid
                                AND    alloc_line.cost_description IN ('B')
                                AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                                AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no)
                    ELSE
					(SELECT SUM(alloc.cost)
                      FROM  allocation_order_release_d alloc
                           ,allocation_base            alloc_base
                      WHERE alloc.order_release_gid = orls.order_release_gid
                      AND   alloc_base.shipment_gid = sh.shipment_gid
                      AND   alloc.cost_description in ('B')
                      AND   alloc.alloc_seq_no = alloc_base.alloc_seq_no)
                    END
						,0)
              ,0), 2)                                                               FREIGHT_COST_BASIC_FTL

     , ROUND(DECODE (sh.transport_mode_gid, 'LTL'
                    ,NVL(CASE WHEN(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                               (SELECT SUM(alloc_line.cost)
                                FROM   allocation_or_line_d alloc_line
                                      ,order_release_line   orl_line
                                      ,allocation_base      alloc_base
                                WHERE  orl_line.order_release_gid IN orls.order_release_gid
                                AND    alloc_base.shipment_gid         = sh.shipment_gid
                                AND    alloc_line.cost_description IN ('B')
                                AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                                AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no)
                    ELSE
					(SELECT SUM(alloc.cost)
                      FROM   allocation_order_release_d alloc
                            ,allocation_base            alloc_base
                      WHERE  alloc.order_release_gid = orls.order_release_gid
                      AND    alloc_base.shipment_gid = sh.shipment_gid
                      AND    alloc.cost_description IN ('B')
                      AND    alloc.alloc_seq_no      = alloc_base.alloc_seq_no)
                    END
					,0)
              ,0), 2)                                                               FREIGHT_COST_BASIC_LTL

	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'FUEL_SURCHARGE_%')                  FUEL_SURCHARGE_STD
     , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_CANCELLATION_COST')	             CANCELLATION_COST
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_ADDITIONAL_DISTANCE')		         ADDITIONAL_DISTANCE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_CONTAINER_COOLING')		         UGO_CONTAINER_COOLING
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_CONTAINER_STUFFING_DESTUFFING')  STUFFING_DESTUFFING
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_CUSTOM_CLEARANCE_EXPORT')  UGO_CUSTOM_CLEARANCE_EXPORT
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_CUSTOM_CLEARANCE_IMPORT')  UGO_CUSTOM_CLEARANCE_IMPORT
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DEMURRAGE_AT_CUSTOMS')  UGO_DEMURRAGE_AT_CUSTOMS
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DEMURRAGE_AT_TERMINAL')  UGO_DEMURRAGE_AT_TERMINAL
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DEMURRAGE_AT_THE_PORT')  UGO_DEMURRAGE_AT_THE_PORT
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DEMURRAGE_LOADING_COST')  UGO_DEMURRAGE_LOADING_COST
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DEMURRAGE_UNLOADING_COST')  UGO_DEMURRAGE_UNLOADING_COST
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DTHC')  					UGO_DTHC
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_DG_SURCHARGE')  			UGO_DG_SURCHARGE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_ADDITIONAL_DISTANCE')  			UGO_ADDITIONAL_DISTANCE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_FUEL_SURCHARGE_CORRECTION')  	UGO_FUEL_SURCHARGE_CORRECTION
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_HEATING_COSTS')  	UGO_HEATING_COSTS
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_OTHC')  	UGO_OTHC
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_PICK_UP_FEE')  	UGO_PICK_UP_FEE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'SERVICE_CREDIT_CHARGE')  	SERVICE_CREDIT_CHARGE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_STORAGE_COSTS')  	UGO_STORAGE_COSTS
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_TERMINAL_HANDLING_COST')  	UGO_TERMINAL_HANDLING_COST
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_INSPECTION_FEE')  	UGO_INSPECTION_FEE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_LOW_WATER_SURCHARGE')  	UGO_LOW_WATER_SURCHARGE
	 , reportowner.UGO_PRELIMINARY_BILLING_TSP.UGO_ALLOC_ACCESSORIAL_COST(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE, sh.shipment_gid, orls.order_release_gid, 'UGO_WEIGHING_FEE')  	UGO_WEIGHING_FEE

	 , ROUND(NVL(CASE WHEN(or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'BULK' OR or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_BULK') THEN
                 (SELECT SUM(alloc_line.cost)
                  FROM   allocation_or_line_d alloc_line
                        ,order_release_line   orl_line
                        ,allocation_base      alloc_base
                        ,accessorial_code     ac
                  WHERE  orl_line.order_release_gid IN orls.order_release_gid
                  AND    alloc_base.shipment_gid         = sh.shipment_gid
                  AND    alloc_line.cost_description IN ('A')
                  AND    alloc_line.accessorial_code_gid = ac.accessorial_code_gid
                  AND    ac.accessorial_code_xid IN ('WEEKEND_COST','UGO_DESTINATION_INLAND','TANK_CHASSIS_HIRE','SULPHUR_FUEL_SURCHARGE','SECOND_DRIVER_EXPORESS_DELIVERY','OVERWEIGHT_SURCHARGE','LTL_FREIGHT_COST_CORRECTION','LCL_FREIGHT_COST_CORRECTION','INSURANCE','INLAND_ORIGIN','INLAND_DESTINATION','HIGH_VALUE','HAZARDOUS','HAZ','FUEL_SURCHARGE_ORIGIN','FUEL_SURCHARGE_INTERMODAL_BULK_OCEAN_25','FUEL_SURCHARGE_DESTINATION','FUEL_SURCHARGE_BULK_OCEAN_24','FTL_FREIGHT_COST_CORRECTION','FREIGHT_COST_BASIC_LTL_PER_PALLET','FREIGHT_COST_BASIC_FTL','FORWARDING_AGENT_COMMISION','FCL_FREIGHT_COST_CORRECTION','EXCHANGE_RATE_CORRECTION','DETENTION','CREDIT_NOTE','BUNKER ADJUSTMENT FACTOR','BAS','ALL_IN_RATE','ADDITIONAL_CLEANING_REQUIRED')
                  AND    orl_line.order_release_line_gid = alloc_line.order_release_line_gid
                  AND    alloc_line.alloc_seq_no         = alloc_base.alloc_seq_no)
                 ELSE
				 (SELECT SUM(alloc.cost)
                   FROM   allocation_order_release_d alloc
                         ,allocation_base            alloc_base
                         ,accessorial_code           ac
                   WHERE  alloc.order_release_gid    = orls.order_release_gid
                   AND    alloc_base.shipment_gid    = sh.shipment_gid
                   AND    alloc.cost_description IN ('A')
                   AND    alloc.accessorial_code_gid = ac.accessorial_code_gid
                   AND    ac.accessorial_code_xid IN ('WEEKEND_COST','UGO_DESTINATION_INLAND','TANK_CHASSIS_HIRE','SULPHUR_FUEL_SURCHARGE','SECOND_DRIVER_EXPORESS_DELIVERY','OVERWEIGHT_SURCHARGE','LTL_FREIGHT_COST_CORRECTION','LCL_FREIGHT_COST_CORRECTION','INSURANCE','INLAND_ORIGIN','INLAND_DESTINATION','HIGH_VALUE','HAZARDOUS','HAZ','FUEL_SURCHARGE_ORIGIN','FUEL_SURCHARGE_INTERMODAL_BULK_OCEAN_25','FUEL_SURCHARGE_DESTINATION','FUEL_SURCHARGE_BULK_OCEAN_24','FTL_FREIGHT_COST_CORRECTION','FREIGHT_COST_BASIC_LTL_PER_PALLET','FREIGHT_COST_BASIC_FTL','FORWARDING_AGENT_COMMISION','FCL_FREIGHT_COST_CORRECTION','EXCHANGE_RATE_CORRECTION','DETENTION','CREDIT_NOTE','BUNKER ADJUSTMENT FACTOR','BAS','ALL_IN_RATE','ADDITIONAL_CLEANING_REQUIRED')

                   AND    alloc.alloc_seq_no         = alloc_base.alloc_seq_no)
                 END
				 , 0), 2)                                                          OTHER





FROM
ORDER_RELEASE ORLS
join order_release_refnum or_ref_bill on (or_ref_bill.order_release_gid = orls.order_release_gid and or_ref_bill.ORDER_RELEASE_REFNUM_QUAL_GID like '%FINAL_BILLING%')
left join order_release_refnum or_ref_po on (or_ref_po.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID and or_ref_po.ORDER_RELEASE_REFNUM_QUAL_GID in ('CUST_PO','PO'))
left join order_release_refnum or_ref_TYPE on (ORLS.order_release_gid = or_ref_TYPE.order_release_gid
AND (or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORDER_TYPE' OR (or_ref_TYPE.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM' AND or_ref_TYPE.ORDER_RELEASE_REFNUM_VALUE = 'PRIMARY'))),
SHIPMENT SH,
order_movement VORLS
,LOCATION SRC_LOC,
    location DEST_LOC

WHERE
SH.SHIPMENT_GID = VORLS.SHIPMENT_GID
AND VORLS.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
AND ORLS.DOMAIN_NAME='UGO'
AND (SELECT SH_TEMP.TRANSPORT_MODE_GID
		FROM SHIPMENT SH_TEMP
		WHERE SH_TEMP.SHIPMENT_GID = VORLS.SHIPMENT_GID

		)	IN ('UL_OCEAN','UL_LCL')

  AND SRC_LOC.LOCATION_GID   = sh.SOURCE_LOCATION_GID
  AND DEST_LOC.LOCATION_GID  = sh.DEST_LOCATION_GID
-- and sh.insert_date >= to_date('2016-12-01','YYYY-MM-DD')
-- AND SH.SHIPMENT_GID = 'UGO.10060135'
AND or_ref_bill.ORDER_RELEASE_REFNUM_VALUE = :P_FINAL_NUM