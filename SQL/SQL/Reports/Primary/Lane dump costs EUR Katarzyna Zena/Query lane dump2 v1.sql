SELECT CASE WHEN RG.EXPIRATION_DATE<SYSDATE OR RG.IS_ACTIVE='N' THEN 'N' ELSE 'Y' END AS															ACTIVE_LANE,
		TO_CHAR(RG.EFFECTIVE_DATE,'DD.MM.YYYY') AS 																									VALID_FROM,
		TO_CHAR(RG.EXPIRATION_DATE,'DD.MM.YYYY') AS 																								VALID_TO,
		CASE WHEN XL.SOURCE_LOCATION_GID IS NOT NULL THEN SUBSTR(XL.SOURCE_LOCATION_GID,INSTR(LTI.SERVPROV_GID,'.')+1)
			ELSE SUBSTR(XL.SOURCE_REGION_GID,INSTR(LTI.SERVPROV_GID,'.')+1)
		END AS 																																		SOURCE_LOCATION_ID,
		(SELECT LISTAGG(LOC_SOURCE.CITY,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
				FROM LOCATION LOC_SOURCE
				WHERE LOC_SOURCE.LOCATION_GID = XL.SOURCE_LOCATION_GID
				
				) AS 																																SOURCE_CITY,
				CASE WHEN XL.DEST_LOCATION_GID IS NOT NULL THEN SUBSTR(XL.DEST_LOCATION_GID,INSTR(LTI.SERVPROV_GID,'.')+1)
			ELSE SUBSTR(XL.DEST_REGION_GID,INSTR(LTI.SERVPROV_GID,'.')+1)
		END AS 																																		DESTINATION_LOCATION_ID,
		(SELECT LISTAGG(LOC_DEST.CITY,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
				FROM LOCATION LOC_DEST
				WHERE LOC_DEST.LOCATION_GID = XL.DEST_LOCATION_GID
				
				) AS 																																DESTINATION_CITY,
	XL.X_LANE_XID																																	X_LANE_XID,
	'"'||(SELECT LISTAGG(LOC_SOURCE.CITY,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
				FROM LOCATION LOC_SOURCE
				WHERE LOC_SOURCE.LOCATION_GID = XL.SOURCE_LOCATION_GID
		 )||'-'||
		(SELECT LISTAGG(LOC_DEST.CITY,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
			FROM LOCATION LOC_DEST
			WHERE LOC_DEST.LOCATION_GID = XL.DEST_LOCATION_GID
		)||'"' AS 																																	LANE_NAME,
		(SELECT LISTAGG(NVL(LA_NOTIF.LANE_ATTRIBUTE_VALUE,' '),'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)	
				FROM LANE_ATTRIBUTE LA_NOTIF
				WHERE
				XL.X_LANE_GID = LA_NOTIF.X_LANE_GID 
				AND LA_NOTIF.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_NOTIFICATION_TIME_H'
		) AS 																																		NOTIFICATION_H,
		(SELECT NVL(ST_TT_H.SERVICE_TIME_VALUE,0)/3600
		FROM SERVICE_TIME ST_TT_H
		WHERE XL.X_LANE_GID = ST_TT_H.X_LANE_GID
		AND ST_TT_H.RATE_SERVICE_GID = RG.RATE_SERVICE_GID
		)																																			TRANSIT_TIME_H,
	
		SUBSTR(LTI.SERVPROV_GID,INSTR(LTI.SERVPROV_GID,'.')+1) 																						SERVICE_PROVIDER_ID,
		'"'||LOC_TSP.LOCATION_NAME||'"'																												SERVPROV_NAME,

		(SELECT LISTAGG(NVL(LA_MATCAT.LANE_ATTRIBUTE_VALUE,' '),'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)	
				FROM LANE_ATTRIBUTE LA_MATCAT
				WHERE
				XL.X_LANE_GID = LA_MATCAT.X_LANE_GID 
				AND LA_MATCAT.LANE_ATTRIBUTE_DEF_GID ='ULE.ULE_MAT_CATEG'
		) AS 																																		MAT_CAT,

			
		RO.TRANSPORT_MODE_GID AS 																													TRANSPORT_MODE,

		(SELECT SUM(NVL(LA_RAILDIST.LANE_ATTRIBUTE_VALUE,0)) 	
				FROM LANE_ATTRIBUTE LA_RAILDIST
				WHERE
				XL.X_LANE_GID = LA_RAILDIST.X_LANE_GID 
				AND LA_RAILDIST.LANE_ATTRIBUTE_DEF_GID IN ('ULE.ULE_RAIL_DISTANCE','ULE.ULE_WATER_DISTANCE','ULE.ULE_ROAD_DISTANCE')
		) AS 																																		DISTANCE_TOAL,
		TRIM(TO_CHAR(((select nvl((SELECT SUM(CASE
				WHEN (AC.CHARGE_AMOUNT_GID = 'EUR' OR AC.CHARGE_AMOUNT_GID IS NULL) THEN AC.CHARGE_AMOUNT
				WHEN AC.CHARGE_AMOUNT_GID <> 'EUR' THEN AC.CHARGE_AMOUNT * 
				UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(SYSDATE,AC.CHARGE_AMOUNT_GID,'EUR')
				else 0
				END)
	
				FROM ACCESSORIAL_COST AC,
					RATE_GEO_ACCESSORIAL RG_AC
				WHERE RG_AC.ACCESSORIAL_COST_GID = AC.ACCESSORIAL_COST_GID
				AND RG_AC.RATE_GEO_GID = RG.RATE_GEO_GID
				AND TO_CHAR(AC.EFFECTIVE_DATE,'YYYY-MM-DD') = TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYY-MM-DD')
				),0) from dual) +
				(select nvl((CASE
				WHEN (RGC.CHARGE_CURRENCY_GID = 'EUR' OR RGC.CHARGE_CURRENCY_GID IS NULL) THEN RGC.CHARGE_AMOUNT
				WHEN RGC.CHARGE_CURRENCY_GID <> 'EUR' THEN RGC.CHARGE_AMOUNT * 
				UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(SYSDATE,RGC.CHARGE_CURRENCY_GID,'EUR')
				else 0
				END),0) from dual)+
				(0)
				
				),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS 																		TOTAL_PRICE_EUR,
				
				
/* 				((select distinct NVL(RFRJ_FUEL.RATE_FACTOR_RULE_GID,' ')
		from RATE_FACTOR_RULE_JOIN RFRJ_FUEL
		where RG.RATE_GEO_GID = RFRJ_FUEL.RATE_GEO_GID
		)) */
		
		
		
		
				NVL((SELECT R_GEO_REM.REMARK_TEXT
				FROM RATE_GEO_REMARK R_GEO_REM
				WHERE R_GEO_REM.REMARK_QUALIFIER_GID = 'ULE.ULE_SHIPMENTS_PER_YEAR' AND RG.RATE_GEO_GID = R_GEO_REM.RATE_GEO_GID),'-')				SHIPMENTS_PER_YEAR,

		(SELECT LISTAGG(CAP_L.LIMIT,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)	
				FROM CAPACITY_GROUP CAP_G,
				CAPACITY_LIMIT CAP_L
				WHERE CAP_G.CAPACITY_GROUP_GID = RO.CAPACITY_GROUP_GID
				AND	CAP_L.CAPACITY_GROUP_GID = CAP_G.CAPACITY_GROUP_GID AND CAP_L.X_LANE_GID = XL.X_LANE_GID
		)																																			CAPACITY_LIMIT_WEEKLY,
		(SELECT LISTAGG(RGR_DCAP.REMARK_TEXT,'/') WITHIN GROUP (ORDER BY RG.RATE_GEO_GID)
				FROM RATE_GEO_REMARK RGR_DCAP
				WHERE RGR_DCAP.REMARK_QUALIFIER_GID ='ULE.ULE_DAILY_CAPACITY'
				AND	RGR_DCAP.RATE_GEO_GID = RG.RATE_GEO_GID
		)																																			CAPACITY_LIMIT_DAILY,

		CASE
					WHEN RGC.RATE_UNIT_BREAK_PROFILE_GID IS NOT NULL THEN 'LTL'
					ELSE 
						CASE WHEN RGC.LEFT_OPERAND1 = 'SHIPMENT.NUM_EQ_REF_UNITS' THEN
							CASE 
							WHEN RGC.OPER1_GID = 'EQ' THEN TO_CHAR(RGC.LOW_VALUE1)
							WHEN RGC.OPER1_GID = 'BETWEEN' THEN TO_CHAR(RGC.LOW_VALUE1 + 1)
							WHEN RGC.OPER1_GID = 'LE' THEN '1'
							ELSE 'ERROR'
						END
					WHEN RGC.LEFT_OPERAND2 = 'SHIPMENT.NUM_EQ_REF_UNITS' THEN
					CASE 
							WHEN RGC.OPER2_GID = 'EQ' THEN TO_CHAR(RGC.LOW_VALUE1)
							WHEN RGC.OPER2_GID = 'BETWEEN' THEN TO_CHAR(RGC.LOW_VALUE1 + 1)
							WHEN RGC.OPER2_GID = 'LE' THEN '1'
							ELSE 'ERROR'
						END
					WHEN RGC.LEFT_OPERAND3 = 'SHIPMENT.NUM_EQ_REF_UNITS' THEN
					CASE 
							WHEN RGC.OPER3_GID = 'EQ' THEN TO_CHAR(RGC.LOW_VALUE1)
							WHEN RGC.OPER3_GID = 'BETWEEN' THEN TO_CHAR(RGC.LOW_VALUE1 + 1)
							WHEN RGC.OPER3_GID = 'LE' THEN '1'
							ELSE 'ERROR'
						END	
					WHEN RGC.LEFT_OPERAND4 = 'SHIPMENT.NUM_EQ_REF_UNITS' THEN
					CASE 
							WHEN RGC.OPER4_GID = 'EQ' THEN TO_CHAR(RGC.LOW_VALUE1)
							WHEN RGC.OPER4_GID = 'BETWEEN' THEN TO_CHAR(RGC.LOW_VALUE1 + 1)
							WHEN RGC.OPER4_GID = 'LE' THEN '1'
							ELSE 'ERROR'
					END
						END
				END AS 																																		MIN_PFS,
				CASE
					WHEN RGC.RATE_UNIT_BREAK_PROFILE_GID IS NOT NULL THEN 'LTL'
					ELSE 
						CASE
							WHEN RGC.OPER1_GID = 'EQ' THEN RGC.LOW_VALUE1
							WHEN RGC.OPER1_GID = 'BETWEEN' THEN RGC.HIGH_VALUE1
							WHEN RGC.OPER1_GID = 'LE' THEN RGC.LOW_VALUE1
							ELSE 'ERROR'
						END
				END AS 																																		MAX_PFS,
				-------------------------------------------------------------------------------------------------------------

				trim((SELECT TO_CHAR(SUM(CASE
				WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID = 'EUR' OR RGCUB_PALLETS_1.CHARGE_AMOUNT_GID IS NULL) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
				WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' THEN RGCUB_PALLETS_1.CHARGE_AMOUNT * 
				UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(SYSDATE,RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
				END),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
				WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
				AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = 'ULE/PR.PALLET_16'
				)) AS 																																		PRICE_PALLET_16_EUR,

				trim((SELECT TO_CHAR(SUM(CASE
				WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID = 'EUR' OR RGCUB_PALLETS_1.CHARGE_AMOUNT_GID IS NULL) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
				WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' THEN RGCUB_PALLETS_1.CHARGE_AMOUNT * 
				UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(SYSDATE,RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
				END),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1 
				WHERE RGC.RATE_GEO_COST_GROUP_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
				AND RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID = 'ULE/PR.PALLET_25'
				)) AS 																																		PRICE_PALLET_25_EUR,
		
		
				-----------------------
				
				(SELECT LISTAGG(RGR_COMM.REMARK_TEXT,'/') WITHIN GROUP (ORDER BY RG.RATE_GEO_GID)
				FROM RATE_GEO_REMARK RGR_COMM
				WHERE RGR_COMM.REMARK_QUALIFIER_GID ='ULE.ULE_COMMITMENT_ALLOCATION'
				AND	RGR_COMM.RATE_GEO_GID = RG.RATE_GEO_GID
				)																																			COMMITMENT_ALLOCATION,
				(SELECT LISTAGG(RGR_CARBON.REMARK_TEXT,'/') WITHIN GROUP (ORDER BY RG.RATE_GEO_GID)
				FROM RATE_GEO_REMARK RGR_CARBON
				WHERE RGR_CARBON.REMARK_QUALIFIER_GID ='ULE.ULE_ESTIMATED_CARBON'
				AND	RGR_CARBON.RATE_GEO_GID = RG.RATE_GEO_GID
				)																																			ESTIMATED_CARBON,
				
				RG.RATE_GEO_GID AS 																															RATE_GEO_GID


FROM
	X_LANE XL,
	RATE_GEO RG,
	LANE_TENDER_INFO LTI,
	LOCATION LOC_TSP,
	RATE_GEO_COST RGC,
	RATE_OFFERING RO


WHERE
		XL.X_LANE_GID = RG.X_LANE_GID
AND 	XL.DOMAIN_NAME <> 'ULE/SE'
AND		XL.X_LANE_GID = LTI.X_LANE_GID
AND 	LOC_TSP.LOCATION_GID = LTI.SERVPROV_GID
AND     RGC.RATE_GEO_COST_GROUP_GID = RG.RATE_GEO_GID
AND 	RO.RATE_OFFERING_GID = RG.RATE_OFFERING_GID
AND 	RO.SERVPROV_GID = LTI.SERVPROV_GID


		
AND 	(CASE WHEN INSTR(XL.X_LANE_XID,'XD')>0 THEN 'Y' ELSE 'N' END) = 'N'