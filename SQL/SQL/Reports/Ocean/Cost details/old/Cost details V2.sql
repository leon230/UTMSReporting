select distinct (SELECT TO_CHAR(SH_TEMP.START_TIME,'DD-MM-YYYY')
		FROM SHIPMENT SH_TEMP
		WHERE SH_TEMP.SHIPMENT_GID = VORLS.SHIPMENT_GID
		)	AS																																					SHIPMENT_START_DATE,
		orlsl.ORDER_RELEASE_LINE_GID                                																							OR_LINE_ID,
		orls.order_release_gid																																	OR_ID,
		VORLS.SHIPMENT_GID 																																		SH_GID,
		(SELECT LISTAGG(OR_CAT.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY OR_CAT.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM OR_CAT
		WHERE OR_CAT.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CAT.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_CATEGORY') AS 																				CATEGORY,
		(SELECT LISTAGG(OR_MAT.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY OR_MAT.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM OR_MAT
		WHERE OR_MAT.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_MAT.ORDER_RELEASE_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_TYPE') AS 																					MATERIAL,
		ORLS.TRANSPORT_MODE_GID																																	TRANSPORT_MODE,
		
		CASE WHEN ORLS.ORDER_RELEASE_TYPE_GID = 'INBOUND' THEN 'INBOUND'
		ELSE 'OUTBOUND'
		END AS																																					INB_OUTB,
		
		ORLS.INCO_TERM_GID																																		INCOTERM,
		
		NVL((SELECT LISTAGG(OR_CARR.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY OR_CARR.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM OR_CARR
		WHERE OR_CARR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CARR.ORDER_RELEASE_REFNUM_QUAL_GID ='UGO.ULE_CARRIAGE_CONDITION'),'-') AS 																		CARRIAGE_CONDITION,
		
		(SELECT LISTAGG(OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID,'|') WITHIN GROUP (ORDER BY OR_CONSIGNOR.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='UGO.UGO_CONSIGNOR') AS 																						CONSIGNOR_ID,
		
		(SELECT LISTAGG(LOC_TEMP.LOCATION_NAME,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='UGO.UGO_CONSIGNOR'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNOR_NAME,
		(SELECT LISTAGG(LOC_TEMP.CITY,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='UGO.UGO_CONSIGNOR'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNOR_CITY,
		(SELECT LISTAGG(LOC_TEMP.COUNTRY_CODE3_GID,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='UGO.UGO_CONSIGNOR'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNOR_COUNTRY,

		/* (SELECT LISTAGG(LOC_TEMP.SUBSTITUTE_LOCATION_GID,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION_SUBSTITUTE LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID IN 
		(SELECT OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID
		FROM ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='UGO.UGO_CONSIGNOR')
		
		) AS																																					CONSIGNOR_SUBSTITUTE, */
		
		(SELECT LISTAGG(OR_CONSIGNEE.INVOLVED_PARTY_CONTACT_GID,'|') WITHIN GROUP (ORDER BY OR_CONSIGNEE.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_INV_PARTY OR_CONSIGNEE
		WHERE OR_CONSIGNEE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNEE.INVOLVED_PARTY_QUAL_GID ='CONSIGNEE') AS 																								CONSIGNEE_ID,
		
		(SELECT LISTAGG(LOC_TEMP.LOCATION_NAME,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='CONSIGNEE'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNEE_NAME,
		(SELECT LISTAGG(LOC_TEMP.CITY,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='CONSIGNEE'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNEE_CITY,
		(SELECT LISTAGG(LOC_TEMP.COUNTRY_CODE3_GID,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION LOC_TEMP,
		ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE
		OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='CONSIGNEE'
		AND OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID = LOC_TEMP.LOCATION_GID
		
		) AS																																					CONSIGNEE_COUNTRY,
		
		/* (SELECT LISTAGG(LOC_TEMP.SUBSTITUTE_LOCATION_GID,'|') WITHIN GROUP (ORDER BY LOC_TEMP.LOCATION_GID)
		FROM LOCATION_SUBSTITUTE LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID IN 
		(SELECT OR_CONSIGNOR.INVOLVED_PARTY_CONTACT_GID
		FROM ORDER_RELEASE_INV_PARTY OR_CONSIGNOR
		WHERE OR_CONSIGNOR.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND OR_CONSIGNOR.INVOLVED_PARTY_QUAL_GID ='CONSIGNEE')
		
		) AS																																					CONSIGNEE_SUBSTITUTE, */
		ORLS.SOURCE_LOCATION_GID AS																																SOURCE_LOCATION_ID,
		(SELECT LOC_TEMP.LOCATION_NAME
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
		) AS																																					SOURCE_LOC_NAME,
		(SELECT LOC_TEMP.CITY
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
		) AS																																					SOURCE_LOC_CITY,
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
		) AS																																					SOURCE_LOC_COUNTRY,
		
		ORLS.PORT_OF_LOAD_LOCATION_GID AS																														pol,
		(SELECT LOC_TEMP.LOCATION_NAME
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_LOAD_LOCATION_GID
		) AS																																					pol_NAME,
		(SELECT LOC_TEMP.CITY
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_LOAD_LOCATION_GID
		) AS																																					pol_CITY,
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_LOAD_LOCATION_GID
		) AS																																					pol_COUNTRY,
		
		ORLS.PORT_OF_DIS_LOCATION_GID AS																														pod,
		(SELECT LOC_TEMP.LOCATION_NAME
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_DIS_LOCATION_GID
		) AS																																					pod_NAME,
		(SELECT LOC_TEMP.CITY
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_DIS_LOCATION_GID
		) AS																																					pod_CITY,
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.PORT_OF_DIS_LOCATION_GID
		) AS																																					pod_COUNTRY,
		
		ORLS.dest_LOCATION_GID AS																																SOURCE_LOCATION_ID,
		(SELECT LOC_TEMP.LOCATION_NAME
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.dest_LOCATION_GID
		) AS																																					dest_LOC_NAME,
		(SELECT LOC_TEMP.CITY
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.dest_LOCATION_GID
		) AS																																					dest_LOC_CITY,
		(SELECT LOC_TEMP.COUNTRY_CODE3_GID
		FROM LOCATION LOC_TEMP
		WHERE
		LOC_TEMP.LOCATION_GID = ORLS.dest_LOCATION_GID
		) AS																																					dest_LOC_COUNTRY,
		(SELECT ORLS_REF.ORDER_RELEASE_REFNUM_VALUE
		FROM ORDER_RELEASE_REFNUM ORLS_REF
		WHERE
		ORLS_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		AND ORLS_REF.ORDER_RELEASE_REFNUM_QUAL_GID='ULE.ULE_TRANSPORT_CONDITION'
		
		) AS																																					TRANSPORT_CONDITION,
		NVL(ORLS.EQUIPMENT_GROUP_GID,'-')																														EQUIPMENT_GR,
		(SELECT SH_TEMP.SERVPROV_GID
		FROM SHIPMENT SH_TEMP
		WHERE VORLS.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
		
		)	AS																																					SERVPROV_ID,
		(SELECT SERVPROV_TEMP.LOCATION_NAME
		FROM SHIPMENT SH_TEMP,
				LOCATION SERVPROV_TEMP
		WHERE VORLS.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
			AND SH_TEMP.SERVPROV_GID = SERVPROV_TEMP.LOCATION_GID
		
		)	AS																																					SERVPROV_NAME,
		LTRIM(TO_CHAR(orlsl.WEIGHT_BASE*0.45,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) 																GROSS_WEIGHT_KG,
		
		(select listagg(sHS_STATUS_CANC.STATUS_VALUE_GID,'/') WITHIN GROUP (ORDER BY SHS_STATUS_CANC.SHIPMENT_GID)
				from SHIPMENT_STATUS SHS_STATUS_CANC
				where SHS_STATUS_CANC.SHIPMENT_GID = VORLS.SHIPMENT_GID 
				AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'UGO.TRANSPORT CANCELLATION'
		)																																						CANCELATION_STATUS,
		
		/* (SELECT CASE WHEN MAX(IESH_EVENT_DELIVER.INSERT_DATE) IS NULL THEN 'NOT CANCELLED' ELSE 'CANCELLED' END
		FROM
		SHIPMENT SH_EVENT_DELIVER 
				LEFT OUTER JOIN SS_STATUS_HISTORY SSSH_EVENT_DELIVER ON (SH_EVENT_DELIVER.SHIPMENT_GID = SSSH_EVENT_DELIVER.SHIPMENT_GID)
				LEFT OUTER JOIN IE_SHIPMENTSTATUS IESH_EVENT_DELIVER ON (SSSH_EVENT_DELIVER.I_TRANSACTION_NO = IESH_EVENT_DELIVER.I_TRANSACTION_NO 
				AND IESH_EVENT_DELIVER.STATUS_CODE_GID IN ('UGO.CA'))
				/* LEFT OUTER JOIN BS_STATUS_CODE BSSC_EVENT_DELIVER ON (IESH_EVENT_DELIVER.STATUS_CODE_GID = BSSC_EVENT_DELIVER.BS_STATUS_CODE_GID) 
		WHERE
		SH_EVENT_DELIVER.SHIPMENT_GID = VORLS.SHIPMENT_GID
		) AS																																					CANCELATION_STATUS,	 */	
				
				
				
				
		(SELECT SH_TEMP.INSERT_USER
		FROM SHIPMENT SH_TEMP
		WHERE SH_TEMP.SHIPMENT_GID = VORLS.SHIPMENT_GID
		) as																																					SH_INSERT_USER,
		(select LISTAGG(ii.INVOICE_NUMBER,'|') WITHIN GROUP (ORDER BY orls.ORDER_RELEASE_GID)
		from invoice ii 
		where ii.INVOICE_GID IN
		(SELECT ilcr.INVOICE_GID
		FROM Order_release_line ORLSL_TEMP,
			INVOICE_LINEITEM_COST_REF ilcr
			
		WHERE ORLSL_TEMP.ORDER_RELEASE_LINE_GID = ilcr.	COST_REFERENCE_GID
			AND ORLSL_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)
		
		) 																																						invoice_numbers,

				
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_BAS' OR INV_LINE.ACCESSORIAL_CODE_GID IS NULL)
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			BASE_COST_BAS,

				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_BAF')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			BAF,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DTHC')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			DTHC,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_OTHC')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			OTHC,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_INLAND_ORIGIN')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			INLAND_ORIGIN,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_INLAND_DESTINATION' OR INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DESTINATION_INLAND')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			INLAND_DESTINATION,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_FCL_FREIGHT_COST_CORRECTION')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			FCL_FREIGHTCOST_CORR,

			trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_ADDITIONAL_DISTANCE')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			additional_distance,
				
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_ALL_IN_RATE')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			UGO_ALL_IN_RATE,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_CANCELLATION_COST')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			UGO_CANCELLATION_COST,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_CONTAINER_COOLING')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			UGO_CONTAINER_COOLING,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_CREDIT_NOTE')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																																			UGO_CREDIT_NOTE,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_CUSTOM_CLEARANCE_EXPORT')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_CUSTOM_CLEARANCE_EXPORT,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_CUSTOM_CLEARANCE_IMPORT')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_CUSTOM_CLEARANCE_IMPORT,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DEMURRAGE_AT_CUSTOMS')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DEMURRAGE_AT_CUSTOMS,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DEMURRAGE_AT_TERMINAL')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DEMURRAGE_AT_TERMINAL,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DEMURRAGE_AT_THE_PORT')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DEMURRAGE_AT_THE_PORT,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DEMURRAGE_LOADING_COST')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DEMURRAGE_LOADING_COST,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DEMURRAGE_UNLOADING_COST')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DEMURRAGE_UNLOADING_COST,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DETENTION')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DETENTION,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DG_SURCHARGE')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DG_SURCHARGE,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_DOCUMENTATION_COST')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_DOCUMENTATION_COST,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_PICK_UP_FEE')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_PICK_UP_FEE,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_STORAGE_COSTS')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_STORAGE_COSTS,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID ='UGO.UGO_TERMINAL_HANDLING_COST')
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_TERMINAL_HANDLING_COST,
				trim(nvl((SELECT TO_CHAR((SUM(CASE
				WHEN INV_LINE.FREIGHT_CHARGE_GID = 'EUR' THEN INV_LINE.FREIGHT_CHARGE
				ELSE NVL2(INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 
				INV_LINE.FREIGHT_CHARGE * EXCHRATES.EXCHANGE_RATE, 0)
				END)),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
				
				
				FROM INVOICE_LINEITEM INV_LINE
				LEFT OUTER JOIN CURRENCY_EXCHANGE_RATE EXCHRATES ON (TO_CHAR(INV_LINE.INSERT_DATE, 'Q-YYYY') = TO_CHAR(EXCHRATES.EFFECTIVE_DATE, 'Q-YYYY') 
				AND INV_LINE.FREIGHT_CHARGE_GID = EXCHRATES.FROM_CURRENCY_GID 
				AND EXCHRATES.EXCHANGE_RATE_GID = 'ULE.ULE_QTY_EXCHANGE' 
				AND EXCHRATES.TO_CURRENCY_GID = 'EUR'),
				Order_release_line OR_LINE
				
				WHERE ivli.INVOICE_GID = INV_LINE.INVOICE_GID
				AND OR_LINE.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
				AND	(INV_LINE.ACCESSORIAL_CODE_GID IN ('UGO.UGO_CONTAINER_STUFFING_DESTUFFING','UGO.UGO_OVERWEIGHT_SURCHARGE'))
				GROUP BY
				INV_LINE.INVOICE_GID
				),0))																									UGO_TERMINAL_HANDLING_COST

from
order_release orls,
Order_release_line orlsl,
allocation_or_line_d aold,
VIEW_SHIPMENT_ORDER_RELEASE VORLS,
INVOICE_LINEITEM_COST_REF ilcr,
INVOICE_LINEITEM ivli


where
orls.order_release_gid=orlsl.order_release_gid
and orlsl.ORDER_RELEASE_LINE_GID = aold.ORDER_RELEASE_LINE_GID
AND VORLS.order_release_gid = ORLS.order_release_gid
and orls.domain_name='UGO'
and ORLS.TRANSPORT_MODE_GID	='UL_OCEAN'
and ilcr.COST_REFERENCE_GID = orlsl.ORDER_RELEASE_LINE_GID
and ivli.INVOICE_GID = ilcr.INVOICE_GID
/* and ivli.INVOICE_GID is not null */
and (select LISTAGG(ivsh.INVOICE_GID,'|') WITHIN GROUP (ORDER BY VORLS.shipment_gid)
		from invoice_shipment ivsh
		where ivsh.shipment_gid = VORLS.shipment_gid
		
		) is not null
/* and */
/* (select SHS_INVOICE.STATUS_VALUE_GID
from shipment_status SHS_INVOICE
where SHS_INVOICE.shipment_gid = VORLS.shipment_gid
AND SHS_INVOICE.STATUS_TYPE_GID = 'UGO.INVOICE_READY'
) <> 'ULE/PR.INVOICE_NOT_READY' */


/* and orls.insert_date>=sysdate */
/* and orls.order_release_gid in ('UGO.MSO_FR109638','UGO.MSO_FR109637') */
/* and orls.order_release_gid in ('UGO.DE2L113535','UGO.DE2L113536','UGO.DE2L113539','UGO.DE2L113537','UGO.DE2L113540',
'UGO.DE2L113542','UGO.DE2L113538','UGO.DE2L113541') */
/* and orls.order_release_gid in ('UGO.20140325-0037') */

and orls.insert_date between to_date('01-04-2014','DD-MM-YYYY') and to_date('30-05-2014','DD-MM-YYYY')

/* and vorls.shipment_gid ='UGO.10001363' */
/* and VORLS.shipment_gid in ('UGO.10001904') */
--10003984

/* allocation_or_line_d
allocation_order_release_d */
/* 10001892	
tu masz shipment gdzie bylo kilka kontenerów i do kazdego bylo zapłacone podstawowe OTHC o dodatkowy pick up :)
10001311	
tutaj są podstawowe plus doc fee :) */
--10001115 
--1sh kilka faktur :10000818
--1 order ma wiecej kosztow na fakturze  pick up i othc jest do 7 kontenerow taki sam a dodatkowo jest do jednego documentation

