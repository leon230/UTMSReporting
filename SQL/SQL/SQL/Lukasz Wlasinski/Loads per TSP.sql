SELECT count(distinct TEMP.SHIPMENT_GID) AS 																										NUMBER_OF_sh,
		TO_CHAR(SUM(TEMP.TOTAL_COST_OR_EUR),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')																												TOTAL_COST_OR_EUR,
		TO_CHAR(SUM(TEMP.TOTAL_COST_ACC_OR_EUR),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')																												TOTAL_COST_ACC_OR_EUR,
		TO_CHAR(SUM(TEMP.TOTAL_COST_FUEL_EUR),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')																												TOTAL_COST_FUEL_EUR,

		TEMP.SERVPROV_GID																																				SERVPROV_GID,
		temp.stream																																		stream


FROM	
(SELECT distinct ORLS.ORDER_RELEASE_GID,

		SH.SHIPMENT_GID,

		(select(SUM(CASE
				WHEN (alloc_d.COST_CURRENCY_GID = 'EUR' or alloc_d.COST_CURRENCY_GID is null) THEN alloc_d.COST
				when alloc_d.COST_CURRENCY_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(to_date(ORLS.LATE_DELIVERY_DATE,'DD.MM.YYYY'),alloc_d.COST_CURRENCY_GID,'EUR')
				END)
			)
			from allocation_order_release_d alloc_d
			where alloc_d.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			and alloc_d.ACCESSORIAL_CODE_GID IS NULL 
			)																																	TOTAL_COST_OR_EUR,
			
			
		(select(SUM(CASE
				WHEN (alloc_d.COST_CURRENCY_GID = 'EUR' or alloc_d.COST_CURRENCY_GID is null) THEN alloc_d.COST
				when alloc_d.COST_CURRENCY_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(to_date(ORLS.LATE_DELIVERY_DATE,'DD.MM.YYYY'),alloc_d.COST_CURRENCY_GID,'EUR')
				END)
			)
			from allocation_order_release_d alloc_d
			where alloc_d.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			and alloc_d.ACCESSORIAL_CODE_GID IS not null 
			and  alloc_d.ACCESSORIAL_CODE_GID NOT LIKE '%FUEL%' 
			AND alloc_d.COST_DESCRIPTION = 'A'
			)																																	TOTAL_COST_ACC_OR_EUR,
			
			(select(SUM(CASE
				WHEN (alloc_d.COST_CURRENCY_GID = 'EUR' or alloc_d.COST_CURRENCY_GID is null) THEN alloc_d.COST
				when alloc_d.COST_CURRENCY_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(to_date(ORLS.LATE_DELIVERY_DATE,'DD.MM.YYYY'),alloc_d.COST_CURRENCY_GID,'EUR')
				END)
			)
			from allocation_order_release_d alloc_d
			where alloc_d.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			and  alloc_d.ACCESSORIAL_CODE_GID LIKE '%FUEL%' 
			)																																	TOTAL_COST_FUEL_EUR,

	
		
		(SELECT OR_REF.STATUS_VALUE_GID
		FROM
		ORDER_RELEASE_STATUS OR_REF
		WHERE
		OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		AND OR_REF.STATUS_TYPE_GID = 'ULE.CANCELLED'
		)																																								CANCELLATION,

		SH.SERVPROV_GID																																					SERVPROV_GID,
		

		(SELECT listagg(sh_ref_1.ORDER_RELEASE_Refnum_Value,',') within group (order by sh_ref_1.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM sh_ref_1
		WHERE sh_ref_1.ORDER_RELEASE_Refnum_Qual_Gid = 'ULE.ULE_STREAM'
		   AND sh_ref_1.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)																					stream	
		
		
			
			
			
			

FROM ORDER_RELEASE ORLS,
	order_movement om,
	shipment sh
WHERE 

		sh.shipment_gid = om.shipment_gid

		and om.order_release_gid = orls.order_release_gid
		AND	ORLS.DOMAIN_NAME in ('ULE/PR','ULE')

		
		and ORLS.LATE_DELIVERY_DATE >= to_date('2015-01-01','YYYY-MM-DD')
		AND SH.SERVPROV_GID = 'ULE.T9471'
		and ORLS.LATE_DELIVERY_DATE <= to_date('2015-12-31','YYYY-MM-DD')


		and not exists 
		(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)   
		and	not exists
			
	
		 (SELECT 
			1
		FROM 
			shipment_refnum sh_ref_1
		WHERE 
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_XLS_UPLD_SHIPMENT_REF_NO')																					

		



		
) TEMP

		
group by
		TEMP.SERVPROV_GID,
		temp.stream	
				


