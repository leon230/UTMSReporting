SELECT DISTINCT SH.SHIPMENT_GID AS																														SH_ID,
		ORLS.ORDER_RELEASE_GID	AS																														OR_ID,
		TO_CHAR(UTC.GET_LOCAL_DATE(SH.START_TIME,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI:SS') AS													SH_START_TIME,
		TO_CHAR(UTC.GET_LOCAL_DATE(SH.END_TIME,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI:SS') AS 														SH_END_TIME,
		
		(SELECT LISTAGG(SHR_RA.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_RA.SHIPMENT_GID)																										
		FROM SHIPMENT_REFNUM SHR_RA 
		WHERE (SHR_RA.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_RA.SHIPMENT_REFNUM_QUAL_GID='ULE/PR.ULE_OR_REL_ATR')
		) AS 																																			RELEASE_ATTR,
		ORLS.INDICATOR AS 																																OR_INDICATOR,
		(
		SELECT LISTAGG(SHR_REGION.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SH_REGION.SHIPMENT_GID)
		FROM SHIPMENT SH_REGION
				LEFT OUTER JOIN SHIPMENT_REFNUM SHR_REGION ON (SH_REGION.SHIPMENT_GID = SHR_REGION.SHIPMENT_GID 
				AND SHR_REGION.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION')
		WHERE
			SH_REGION.DOMAIN_NAME ='ULE/PR'
			AND	SH_REGION.SHIPMENT_GID = SH.SHIPMENT_GID
		) 	AS 																																			REGION,	
			
			
		ORLS.SOURCE_LOCATION_GID AS																														SOURCE_LOC_ID,
		LOC_SOURCE.CITY AS 																																SOURCE_CITY,
		LOC_SOURCE.LOCATION_NAME AS 																													SOURCE_NAME,
		ORLS.DEST_LOCATION_GID	AS																														DEST_LOC_ID,
		LOC_DEST.CITY AS 																																DESTINATION_CITY,
		LOC_DEST.LOCATION_NAME AS 																														DEST_NAME,
		(SH.SERVPROV_GID) AS 																															SERVICE_PROVIDER,
		(SELECT LOC_TSP.LOCATION_NAME
		FROM SHIPMENT SH_SERVPROV
		LEFT OUTER JOIN LOCATION LOC_TSP ON (LOC_TSP.LOCATION_GID = SH_SERVPROV.SERVPROV_GID)
		WHERE
			SH_SERVPROV.SHIPMENT_GID = SH.SHIPMENT_GID
		)AS 																																			SERVICE_PROVIDER_NAME,
		SU.TRANSPORT_HANDLING_UNIT_GID AS 																												TRANSPORT_HANDLING_UNIT,
		TO_CHAR(SU.SHIP_UNIT_COUNT,'9,999,999.99') AS 																									NUMBER_OF_PALLETS,
		LTRIM(TO_CHAR(SU.TOTAL_GROSS_WEIGHT_BASE*0.45359237,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS 											GROSS_WEIGHT,
		(
		SELECT LISTAGG(SH_COND.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SH_COND.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SH_COND
		
		WHERE SH_COND.SHIPMENT_GID = SH.SHIPMENT_GID 
		AND SH_COND.SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_TRANSPORT_CONDITION'
		
		
		) AS 																																			TRANSPORT_COND,
		(
		SELECT LISTAGG(SH_CAT.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SH_CAT.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SH_CAT
		
		WHERE SH_CAT.SHIPMENT_GID = SH.SHIPMENT_GID 
		AND SH_CAT.SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_MATERIAL_CATEGORY'
		
		
		) AS 																																			CATEGORY,
		SH.IS_HAZARDOUS AS 																																HAZARDOUS,
		(
		SELECT LISTAGG(ORLSR_SPEC.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY ORLSR_SPEC.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM ORLSR_SPEC
		
		WHERE ORLS.ORDER_RELEASE_GID = ORLSR_SPEC.ORDER_RELEASE_GID 
				AND ORLSR_SPEC.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_SPECIAL_ORDER')
		
		
		) AS 																																			SPECIAL_ORDER,
		(SELECT LISTAGG(SHR_STAND.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_STAND.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SHR_STAND
		WHERE SHR_STAND.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_STAND.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_STANDBY_TRAILER'
		
		) AS 																																			STAND_TRAILER,
		(
		SELECT LISTAGG(ORLSR_EXP.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY ORLSR_EXP.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM ORLSR_EXP
		
		WHERE ORLS.ORDER_RELEASE_GID = ORLSR_EXP.ORDER_RELEASE_GID 
				AND ORLSR_EXP.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_EXPRESS_BY_CUSTOMER')
		
		
		) AS 																																			EXPRESS,
		SH.INCO_TERM_GID AS 																															INCOTERM,	
		(
		SELECT LISTAGG(ORLSR_MULTI.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY ORLSR_MULTI.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM ORLSR_MULTI
		
		WHERE ORLS.ORDER_RELEASE_GID = ORLSR_MULTI.ORDER_RELEASE_GID 
				AND ORLSR_MULTI.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_MULTISTOP')
		
		
		) AS 																																			IS_MULTISTOP,

		(
		SELECT LISTAGG(ORS_STATUS.STATUS_VALUE_GID,'|') WITHIN GROUP (ORDER BY ORS_STATUS.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_STATUS ORS_STATUS
		
		WHERE ORLS.ORDER_RELEASE_GID = ORS_STATUS.ORDER_RELEASE_GID 
				AND ORS_STATUS.STATUS_TYPE_GID IN ('ULE/PR.PLANNING')
		
		
		) AS 																																			STATUS,
		ORLS.INSERT_USER AS 																															ORLS_INSERT_USER,
		ORLS.DOMAIN_NAME AS																																ORLS_DOMAIN_NAME,
		SH.INDICATOR AS 																																SH_INDICATOR,
		(
		SELECT LISTAGG(SHS_SECURE.STATUS_VALUE_GID,'|') WITHIN GROUP (ORDER BY SHS_SECURE.SHIPMENT_GID)
		FROM SHIPMENT_STATUS SHS_SECURE
		
		WHERE SH.SHIPMENT_GID = SHS_SECURE.SHIPMENT_GID 
				AND SHS_SECURE.STATUS_TYPE_GID IN ('ULE/PR.SECURE RESOURCES')
		
		
		) AS 																																			SECURE_RES_STATUS,
		'"'||(
		SELECT LISTAGG(ORLSR_PO.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY ORLSR_PO.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM ORLSR_PO 
		
		WHERE ORLS.ORDER_RELEASE_GID = ORLSR_PO.ORDER_RELEASE_GID 
				AND ORLSR_PO.ORDER_RELEASE_REFNUM_QUAL_GID IN ('PO','ULE.ULE_PO_NUMBER','ULE.ULE_SAP_PO_NUMBER','CUST_PO','ULE.ULE_FINANCE_PO_NUMBER')
		
		
		)||'"' AS 																																		OR_PO_NUM,
		'"'||(
		SELECT LISTAGG(ORLSR_DN_ULE.ORDER_RELEASE_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY ORLSR_DN_ULE.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM ORLSR_DN_ULE 
		
		WHERE ORLS.ORDER_RELEASE_GID = ORLSR_DN_ULE.ORDER_RELEASE_GID 
				AND ORLSR_DN_ULE.ORDER_RELEASE_REFNUM_QUAL_GID IN ('ULE.ULE_DN_NUMBER','UL_SAP_DN')
		
		
		)||'"' AS 																																		OR_DN_NUM,
		'"'||(SELECT LISTAGG(SHR_PO.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_PO.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SHR_PO 
		WHERE SHR_PO.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_PO.SHIPMENT_REFNUM_QUAL_GID = 'ULE.PO'
		)||'"' AS 																																		SH_PO,
		'"'||(SELECT LISTAGG(SHR_DN.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_DN.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SHR_DN
		WHERE SHR_DN.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_DN.SHIPMENT_REFNUM_QUAL_GID = 'ULE.DN'
		)||'"' AS 																																		SH_DN,
		'"'||(SELECT LISTAGG(SHR_PLATE.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_PLATE.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SHR_PLATE 
		WHERE SHR_PLATE.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_PLATE.SHIPMENT_REFNUM_QUAL_GID = 'ULE.TRUCK PLATE'
		
		)||'"' AS 																																		TRUCK_PLATE,
		'"'||(SELECT LISTAGG(SHR_TRAILER.SHIPMENT_REFNUM_VALUE,'|') WITHIN GROUP (ORDER BY SHR_TRAILER.SHIPMENT_GID)
		FROM SHIPMENT_REFNUM SHR_TRAILER 
		WHERE (SHR_TRAILER.SHIPMENT_GID = SH.SHIPMENT_GID AND SHR_TRAILER.SHIPMENT_REFNUM_QUAL_GID = 'TRAILER')
		
		)||'"' AS 																																		TRAILER_NUMBER,
		TO_CHAR(UTC.GET_LOCAL_DATE(ORLS.EARLY_PICKUP_DATE,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI')                                               EARLY_PICKUP_DATE,
		TO_CHAR(UTC.GET_LOCAL_DATE(ORLS.LATE_PICKUP_DATE,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI')                                                LATE_PICKUP_DATE,
		TO_CHAR(UTC.GET_LOCAL_DATE(ORLS.EARLY_DELIVERY_DATE,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI')                                               EARLY_DELIVERY_DATE,
		TO_CHAR(UTC.GET_LOCAL_DATE(ORLS.LATE_DELIVERY_DATE,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI')                                                	LATE_DELIVERY_DATE,
		
		
		
		SS.STOP_NUM AS 																																	STOP_NUM,
		SS.STOP_TYPE AS																																	STOP_TYPE,
		SS.LOCATION_GID AS																																APP_LOCATION,
		(CASE WHEN SS.STOP_TYPE ='D' THEN 
		(
		SELECT LISTAGG(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		)
		WHEN SS.STOP_TYPE ='P' THEN (
		SELECT LISTAGG(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_START_TIME,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND APP_LOAD_T.INSERT_DATE = (SELECT DISTINCT 
        MAX(APP_LOAD_T_TEMP.INSERT_DATE)
        FROM APPOINTMENT APP_LOAD_T_TEMP
        WHERE APP_LOAD_T_TEMP.OBJECT_GID = APP_LOAD_T.OBJECT_GID
		AND	APP_LOAD_T_TEMP.STOP_NUM = APP_LOAD_T.STOP_NUM)
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		)
		ELSE NULL
		END
		) AS 																																			APP_START,
		
		(CASE WHEN SS.STOP_TYPE ='D' THEN 
		(
		SELECT LISTAGG(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_END_TIME,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		)
		WHEN SS.STOP_TYPE ='P' THEN (
		SELECT LISTAGG(TO_CHAR(UTC.GET_LOCAL_DATE(APP_LOAD_T.APPOINTMENT_END_TIME,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI'),'|') 
		WITHIN GROUP(ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND APP_LOAD_T.INSERT_DATE = (SELECT DISTINCT 
        MAX(APP_LOAD_T_TEMP.INSERT_DATE)
        FROM APPOINTMENT APP_LOAD_T_TEMP
        WHERE APP_LOAD_T_TEMP.OBJECT_GID = APP_LOAD_T.OBJECT_GID
		AND	APP_LOAD_T_TEMP.STOP_NUM = APP_LOAD_T.STOP_NUM)
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		)
		ELSE NULL
		END
		) AS 																																			APP_END,
		(
		SELECT LISTAGG(LR_LOAD_T.LOCATION_RESOURCE_NAME,'|') 
		WITHIN GROUP (ORDER BY SH_APP_LOAD_T.SHIPMENT_GID)
		FROM SHIPMENT SH_APP_LOAD_T
				LEFT OUTER JOIN APPOINTMENT APP_LOAD_T ON (APP_LOAD_T.OBJECT_GID = SH_APP_LOAD_T.SHIPMENT_GID)
				LEFT OUTER JOIN LOCATION_RESOURCE LR_LOAD_T ON (LR_LOAD_T.LOCATION_RESOURCE_GID = APP_LOAD_T.LOCATION_RESOURCE_GID)
		WHERE 1=1
				AND	SH_APP_LOAD_T.SHIPMENT_GID = SH.SHIPMENT_GID
				AND	APP_LOAD_T.STOP_NUM  = SS.STOP_NUM
				AND APP_LOAD_T.INSERT_DATE = (SELECT DISTINCT 
        MAX(APP_LOAD_T_TEMP.INSERT_DATE)
        FROM APPOINTMENT APP_LOAD_T_TEMP
        WHERE APP_LOAD_T_TEMP.OBJECT_GID = APP_LOAD_T.OBJECT_GID
		AND	APP_LOAD_T_TEMP.STOP_NUM = APP_LOAD_T.STOP_NUM)
				/* AND	(ORLS.SOURCE_LOCATION_GID = LR_LOAD_T.LOCATION_GID OR LR_LOAD_T.LOCATION_GID IS NULL) */
		)	AS 																																			APP_DOCK,
		TO_CHAR(UTC.GET_LOCAL_DATE(SS.PLANNED_ARRIVAL,SS.LOCATION_GID),'YYYY-MM-DD HH24:MI') AS 														PLANNED_ARRIVAL,
		(CASE WHEN SS.STOP_TYPE ='P' THEN 
		(CASE WHEN SH.START_TIME >= (SELECT ORLS_TEMP.LATE_PICKUP_DATE
		FROM ORDER_RELEASE ORLS_TEMP
		WHERE ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		) THEN TO_CHAR(UTC.GET_LOCAL_DATE(SH.START_TIME,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI')
		ELSE 
		(SELECT TO_CHAR(UTC.GET_LOCAL_DATE(ORLS_TEMP.LATE_PICKUP_DATE,ORLS.SOURCE_LOCATION_GID),'YYYY-MM-DD HH24:MI')
		FROM ORDER_RELEASE ORLS_TEMP
		WHERE ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		)
		END) 
		WHEN SS.STOP_TYPE ='D' THEN
		(CASE WHEN SH.END_TIME >= (SELECT ORLS_TEMP.LATE_DELIVERY_DATE
		FROM ORDER_RELEASE ORLS_TEMP
		WHERE ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		) THEN TO_CHAR(UTC.GET_LOCAL_DATE(SH.END_TIME,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI')
		ELSE 
		(SELECT TO_CHAR(UTC.GET_LOCAL_DATE(ORLS_TEMP.LATE_DELIVERY_DATE,ORLS.DEST_LOCATION_GID),'YYYY-MM-DD HH24:MI')
		FROM ORDER_RELEASE ORLS_TEMP
		WHERE ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		)
		END)

		END) AS																																			LATEST_PICK_DEL_DATE,
		(SELECT SHS_STATUS_CANC.STATUS_VALUE_GID
		FROM shipment_status SHS_STATUS_CANC 
		where SHS_STATUS_CANC.SHIPMENT_GID = sh.SHIPMENT_GID 
		AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		)																																				CANCELLATION_STATUS,
		
		 (SELECT DISTINCT
		listagg(TO_CHAR(UTC.GET_LOCAL_DATE(IESH_EVENT_DELIVER.EVENTDATE,ss.location_gid),'YYYY-MM-DD HH24:MI:SS'),',') within group (order by sh.shipment_gid)
        FROM   SS_STATUS_HISTORY SSH,
              IE_SHIPMENTSTATUS IESH_EVENT_DELIVER 
        WHERE  IESH_EVENT_DELIVER.STATUS_CODE_GID = 'ULE/PR.0005'
            
               AND SSH.SHIPMENT_GID = SH.SHIPMENT_GID
			   AND SSH.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER.I_TRANSACTION_NO
			   AND SSH.SHIPMENT_STOP_NUM = 1
			  
			   AND IESH_EVENT_DELIVER.INSERT_DATE = (SELECT DISTINCT MAX(IESH_EVENT_DELIVER_TEMP.INSERT_DATE)
        FROM   SS_STATUS_HISTORY SSH_TEMP,
               IE_SHIPMENTSTATUS IESH_EVENT_DELIVER_TEMP 

        WHERE  IESH_EVENT_DELIVER_TEMP.STATUS_CODE_GID =  'ULE/PR.0005' 
               AND SSH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
			   and SSH_TEMP.SHIPMENT_STOP_NUM = SS.STOP_NUM
			   
			   AND SSH_TEMP.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER_TEMP.I_TRANSACTION_NO 
			   ))  																																		REGISTRATION_IN,
		(SELECT DISTINCT
		listagg(TO_CHAR(UTC.GET_LOCAL_DATE(IESH_EVENT_DELIVER.EVENTDATE,ss.location_gid),'YYYY-MM-DD HH24:MI:SS'),',') within group (order by sh.shipment_gid)
        FROM   SS_STATUS_HISTORY SSH,
              IE_SHIPMENTSTATUS IESH_EVENT_DELIVER 
        WHERE  IESH_EVENT_DELIVER.STATUS_CODE_GID = 'ULE/PR.0008'
            
               AND SSH.SHIPMENT_GID = SH.SHIPMENT_GID
			   AND SSH.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER.I_TRANSACTION_NO
			   AND SSH.SHIPMENT_STOP_NUM = 1
			  
			   AND IESH_EVENT_DELIVER.INSERT_DATE = (SELECT DISTINCT MAX(IESH_EVENT_DELIVER_TEMP.INSERT_DATE)
        FROM   SS_STATUS_HISTORY SSH_TEMP,
               IE_SHIPMENTSTATUS IESH_EVENT_DELIVER_TEMP 

        WHERE  IESH_EVENT_DELIVER_TEMP.STATUS_CODE_GID =  'ULE/PR.0008' 
               AND SSH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
			   and SSH_TEMP.SHIPMENT_STOP_NUM = SS.STOP_NUM
			   
			   AND SSH_TEMP.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER_TEMP.I_TRANSACTION_NO 
			   ))  																																		REGISTRATION_OUT,
			   (SELECT DISTINCT
		listagg(TO_CHAR(UTC.GET_LOCAL_DATE(IESH_EVENT_DELIVER.EVENTDATE,ss.location_gid),'YYYY-MM-DD HH24:MI:SS'),',') within group (order by sh.shipment_gid)
        FROM   SS_STATUS_HISTORY SSH,
              IE_SHIPMENTSTATUS IESH_EVENT_DELIVER 
        WHERE  IESH_EVENT_DELIVER.STATUS_CODE_GID = 'ULE/PR.0006'
            
               AND SSH.SHIPMENT_GID = SH.SHIPMENT_GID
			   AND SSH.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER.I_TRANSACTION_NO
			   AND SSH.SHIPMENT_STOP_NUM = 1
			  
			   AND IESH_EVENT_DELIVER.INSERT_DATE = (SELECT DISTINCT MAX(IESH_EVENT_DELIVER_TEMP.INSERT_DATE)
        FROM   SS_STATUS_HISTORY SSH_TEMP,
               IE_SHIPMENTSTATUS IESH_EVENT_DELIVER_TEMP 

        WHERE  IESH_EVENT_DELIVER_TEMP.STATUS_CODE_GID =  'ULE/PR.0006' 
               AND SSH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
			   and SSH_TEMP.SHIPMENT_STOP_NUM = SS.STOP_NUM
			   
			   AND SSH_TEMP.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER_TEMP.I_TRANSACTION_NO 
			   ))  																																		HANDLING_START,
			   (SELECT DISTINCT
		listagg(TO_CHAR(UTC.GET_LOCAL_DATE(IESH_EVENT_DELIVER.EVENTDATE,ss.location_gid),'YYYY-MM-DD HH24:MI:SS'),',') within group (order by sh.shipment_gid)
        FROM   SS_STATUS_HISTORY SSH,
              IE_SHIPMENTSTATUS IESH_EVENT_DELIVER 
        WHERE  IESH_EVENT_DELIVER.STATUS_CODE_GID = 'ULE/PR.0007'
            
               AND SSH.SHIPMENT_GID = SH.SHIPMENT_GID
			   AND SSH.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER.I_TRANSACTION_NO
			   AND SSH.SHIPMENT_STOP_NUM = 1
			  
			   AND IESH_EVENT_DELIVER.INSERT_DATE = (SELECT DISTINCT MAX(IESH_EVENT_DELIVER_TEMP.INSERT_DATE)
        FROM   SS_STATUS_HISTORY SSH_TEMP,
               IE_SHIPMENTSTATUS IESH_EVENT_DELIVER_TEMP 

        WHERE  IESH_EVENT_DELIVER_TEMP.STATUS_CODE_GID =  'ULE/PR.0007' 
               AND SSH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
			   and SSH_TEMP.SHIPMENT_STOP_NUM = SS.STOP_NUM
			   
			   AND SSH_TEMP.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER_TEMP.I_TRANSACTION_NO 
			   ))  																																		HANDLING_end

		
FROM
	SHIPMENT_STOP SS,
	SHIPMENT SH,
	SHIPMENT_STOP_D SSD,
	S_SHIP_UNIT SSU,
	S_SHIP_UNIT_LINE SSUL,
	ORDER_RELEASE ORLS,
	LOCATION LOC_SOURCE,
	LOCATION LOC_DEST,
	/* SHIP_UNIT_EQUIP_REF_UNIT_JOIN SUERUJ_PALLET, */
	SHIP_UNIT SU

WHERE 1=1
	AND SH.DOMAIN_NAME IN ('ULE/PR','SERVPROV','ULE','UGO')
	AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)
	AND	SH.SHIPMENT_TYPE_GID IN ('TRANSPORT')
	
	AND	SS.SHIPMENT_GID = SH.SHIPMENT_GID
	AND SSD.SHIPMENT_GID = SS.SHIPMENT_GID
	AND SSD.STOP_NUM = SS.STOP_NUM
	AND SSD.S_SHIP_UNIT_GID = SSU.S_SHIP_UNIT_GID
	AND SSU.S_SHIP_UNIT_GID = SSUL.S_SHIP_UNIT_GID
	AND SSUL.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
	
	/* AND	SU.SHIP_UNIT_GID = SUERUJ_PALLET.SHIP_UNIT_GID */
	AND	SU.SHIP_UNIT_GID = SSU.SHIP_UNIT_GID
	
	AND	LOC_SOURCE.LOCATION_GID = ORLS.SOURCE_LOCATION_GID
	AND	LOC_DEST.LOCATION_GID = ORLS.DEST_LOCATION_GID
	
	
	/* AND	SH.INSERT_DATE BETWEEN TO_DATE('2013-09-01','YYYY-MM-DD') AND TO_DATE('2013-09-30','YYYY-MM-DD') */
	/* AND ORLS.SOURCE_LOCATION_GID = 'ULE.V50281550' */
	/* AND	SH.SHIPMENT_GID LIKE '%ULE.KLOG_18/12_ND2%' */

	
/* 	
	AND	SH.START_TIME BETWEEN TO_DATE(NVL(:START_TIME, TO_CHAR(TRUNC((TRUNC(SYSDATE,'MM')-1),'MM'),:P_DATE_TIME_FORMAT)),:P_DATE_TIME_FORMAT) AND 
	TO_DATE(NVL(:END_TIME,TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE,1))+1),:P_DATE_TIME_FORMAT)),:P_DATE_TIME_FORMAT) */
	
	-- AND SS.LOCATION_GID = NVL(:APP_LOC,SS.LOCATION_GID)
	
	AND NOT EXISTS(SELECT 1
	FROM shipment_refnum
	WHERE shipment_gid = Sh.shipment_gid
	AND shipment_refnum_qual_gid = 'ULE.ULE_SHIPMENT_STREAM'
	AND shipment_refnum_value = 'SECONDARY')
	AND TRUNC(SH.START_TIME) BETWEEN TO_DATE('2015-11-16','YYYY-MM-DD') AND TO_DATE('2015-11-30','YYYY-MM-DD')
	-- AND	SH.START_TIME >= TRUNC(SYSDATE) - 14
	-- AND	SH.START_TIME <= TRUNC(SYSDATE) + 5
