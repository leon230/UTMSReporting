SELECT distinct SH_INV.SHIPMENT_GID,
orls.order_release_gid,
(select shipment_refnum_value from
shipment_refnum sr_region 
where
((SH.shipment_gid = sr_region.shipment_gid) 
AND sr_region.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION') ) as 																						SH_REGION,
	SH.SERVPROV_GID																																				CARRIER_ID,
	TO_CHAR(SH.START_TIME,'DD-MM-YYYY HH24:MI:SS') AS 																											START_TIME,
	TO_CHAR(SH.END_TIME,'DD-MM-YYYY HH24:MI:SS') AS 																											END_TIME, 
	orls.SOURCE_LOCATION_GID																																	SOURCE_LOCATION_GID,
	sh.SOURCE_LOCATION_GID																																		SH_SOURCE_LOC_GID,
	SOURCE_LOC.LOCATION_NAME AS 																																SOURCE_NAME,
	SOURCE_LOC.COUNTRY_CODE3_GID 																																SOURCE_COUNTRY_CODE,
	orls.DEST_LOCATION_GID 																																		DEST_LOCATION_GID,
	sh.DEST_LOCATION_GID																																		SH_DEST_LOC_GID,
	DEST_LOC.LOCATION_NAME AS 																																	DEST_NAME,
	DEST_LOC.COUNTRY_CODE3_GID  																																Dest_Country_code,
	
	(SELECT
		CAR_LOC.LOCATION_NAME
	FROM
		LOCATION CAR_LOC
	WHERE
		SH.SERVPROV_GID = CAR_LOC.location_gid) 																												CARRIER_NAME,
		
		SH.INSERT_USER AS 																																		SHIPMENT_INSERT_USER,
				(SELECT LISTAGG(CON.EMAIL_ADDRESS,';') WITHIN GROUP (ORDER BY CON.LOCATION_GID)
				FROM CONTACT CON
				WHERE CON.LOCATION_GID = SH.SERVPROV_GID AND CON.JOB_TITLE = 'PRIMARY'
				) AS																																			PRIMARY_CONTACT,
				(SELECT LISTAGG(SHS_STATUS_CANC.STATUS_VALUE_GID,';') WITHIN GROUP (ORDER BY SHS_STATUS_CANC.ORDER_RELEASE_GID)
				FROM ORDER_RELEASE_STATUS SHS_STATUS_CANC
				WHERE SHS_STATUS_CANC.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
				AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE.CANCELLED'
				)																																				OR_CANCELATION_STATUS,
				(SELECT SH_STATUS.STATUS_VALUE_GID
				FROM SHIPMENT_STATUS SH_STATUS
				WHERE SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
				AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.SECURE RESOURCES'
				) AS																																			SECURE_RES,
				(SELECT CASE WHEN 
							MAX(SHC_TEMP.COST) > 0 THEN 'YES'
							ELSE 'NO' END
				FROM SHIPMENT_COST SHC_TEMP
				WHERE SHC_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
				AND SHC_TEMP.ACCESSORIAL_CODE_GID ='ULE/PR.ULE_CANCELLATION COST'
						
				)  AS																																			CANCEL_COST,
			trim((select TO_CHAR((SUM(CASE
				WHEN (alloc_d.COST_CURRENCY_GID = 'EUR' or alloc_d.COST_CURRENCY_GID is null) THEN alloc_d.COST
				when alloc_d.COST_CURRENCY_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(to_date(SH.END_TIME,'DD.MM.YYYY'),alloc_d.COST_CURRENCY_GID,'EUR')
				END)
			),'999999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')
			from allocation_order_release_d alloc_d
			where alloc_d.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			and alloc_d.COST_DESCRIPTION <>'O'
			

			))																																					TOTAL_COST_OR_EUR,	
			case WHEN (SELECT listagG(SH_TEMP.SHIPMENT_GID,'/') within group (order by sh.shipment_gid)
			FROM SHIPMENT SH_TEMP,
			VIEW_SHIPMENT_ORDER_RELEASE VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
			is not null then 'Y' else 'N' end as																											XDOCK_SHIPMENT,
				
				
		
	SH_INV.SHIPMENT_COST,
	SH_INV.FINANCE,
	SH_INV.INVOICE,
	SH_INV.MISMACTH_CURRENCY,
	SH_INV.MISSING_ALLOCATION,
	SH_INV.MISSING_ACTUAL,
	SH_INV.MISSING_BASE_COST,
	SH_INV.IS_PRE_FINAL_BILLING_REFNUM,
	SH_INV.MISSING_OR_TEMPLATE_ORDERS,
	SH_INV.MISMACTH_CURRENCY_COST_B_A,
	SH_INV.MISSING_FINANCE_CONTACT,
	SH_INV.DOUBLE_FINANCE_REFNUM,
	SH_INV.MISSING_FINANCE_REFNUM,
	
	nvl((SELECT 
		or_ref_1.ORDER_RELEASE_REFNUM_VALUE
	FROM 
		ORDER_RELEASE_REFNUM or_ref_1
	WHERE 
		orls.ORDER_RELEASE_GID = or_ref_1.ORDER_RELEASE_GID
		AND or_ref_1.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_TYPE'),'n/a')		MATERIAL_TYPE,
		
	nvl((SELECT 
		or_ref_2.ORDER_RELEASE_REFNUM_VALUE
	FROM 
		ORDER_RELEASE_REFNUM or_ref_2
	WHERE 
		orls.ORDER_RELEASE_GID = or_ref_2.ORDER_RELEASE_GID
		AND or_ref_2.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_CATEGORY'),'n/a')	MATERIAL_CATEGORY,
    
    orr.order_release_refnum_value STREAM,
	SH_INV.BTF_NOT_READY,
	SH.SHIPMENT_TYPE_GID
    
   
	

FROM
	ULE_VIEW_INVOICE_STATUS 	SH_INV,
	SHIPMENT 					SH,
	LOCATION 					SOURCE_LOC,
	LOCATION 					DEST_LOC,
	SHIPMENT_STOP 				ss,
	shipment_stop_d 			ssd,
	s_ship_unit 				ssu,
	s_ship_unit_line 			ssul,
	order_release 				orls,
ORDER_RELEASE_REFNUM ORR
  
WHERE
	SH_INV.SHIPMENT_GID = SH.SHIPMENT_GID
	AND ss.shipment_gid = SH.shipment_gid
	AND ssd.SHIPMENT_GID = ss.SHIPMENT_GID
	AND ssd.stop_num = ss.stop_num
	AND ssd.S_SHIP_UNIT_GID = ssu.S_SHIP_UNIT_GID
	AND ssu.S_SHIP_UNIT_GID = ssul.S_SHIP_UNIT_GID
	AND ssul.order_release_gid = orls.order_release_gid
	AND SH.SERVPROV_GID <> 'ULE.SPOT'
	AND SH_INV.INVOICE <> 'ULE/PR.INVOICE_READY'
	and SH_INV.EXCLUDED = 'N'
	AND trunc(SH.END_TIME)  < to_date(:P_END_DATE,:P_DATE_TIME_FORMAT)
	/* AND trunc(SH.END_TIME)  < to_date('2015-03-01','YYYY-MM-DD') */
	AND SOURCE_LOC.LOCATION_GID = orls.SOURCE_LOCATION_GID
	AND	DEST_LOC.LOCATION_GID = orls.DEST_LOCATION_GID
 AND orls.ORDER_RELEASE_GID = ORR.ORDER_RELEASE_GID
AND ORR.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
and orr.order_release_refnum_value = case when :P_STREAM = 'ALL' then orr.order_release_refnum_value
                                     else :P_STREAM end
/* and orr.order_release_refnum_value = 'PRIMARY'							 */
and SH.domain_name in ('ULE/PR','ULE')
and SH.SHIPMENT_TYPE_GID = case when :P_SHIPMENT_TYPE = 'ALL' then SH.SHIPMENT_TYPE_GID
                                     else :P_SHIPMENT_TYPE end




