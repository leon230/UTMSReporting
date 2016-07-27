SELECT DISTINCT sh.shipment_gid,
	   om.order_release_gid,
		sh.SOURCE_LOCATION_GID,
		sh.DEST_LOCATION_GID,
		(select or_temp.source_location_gid
		from order_release or_temp
		where or_temp.order_release_gid = om.order_release_gid
		)																												or_source_loc,
		(select or_temp.dest_location_gid
		from order_release or_temp
		where or_temp.order_release_gid = om.order_release_gid
		)																												or_dest_loc,
		SH.SHIPMENT_TYPE_GID,
		
		(case when (sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') and sh.SHIPMENT_TYPE_GID <> 'HANDLING') THEN 'OUTBOUND'
				when sh.SHIPMENT_TYPE_GID = 'HANDLING' then ''
			ELSE 'INBOUND'
		END 
		
		)																																	INB_OUTB,
		
		

	
		(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))       																							or_pallets,

		
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='B'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)																																				BASE_cost_sum,
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='A'
		AND ORL_TEMP.ACCESSORIAL_CODE_GID  LIKE '%FUEL%'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)																																				FUEL_SUM_EUR,
		
		
		
		
		
		-- xl_direct_price.price	direct_price,
		case when
		trim(to_char((select min(temp2.price)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		)	/
		(select count(om1.order_release_gid)
		from order_movement om1
		where om1.order_release_gid = om.order_release_gid
		
		),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL') <> '_LTL' then 
		
		trim(to_char((select min(temp2.price)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		)	/
		(select count(om1.order_release_gid)
		from order_movement om1
		where om1.order_release_gid = om.order_release_gid
		
		),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL')
		else
		
		
		trim(to_char((CASE WHEN 
		
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25
		THEN 
		
		(select min(temp2.price)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							
							round(MIN(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.X_LANE_GID,
									
									(CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									FROM rate_geo_cost rgc_temp,
									RATE_GEO RG,
									RATE_GEO_COST_GROUP RGCG,
									X_LANE XL
									WHERE 
									RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									AND rgc_temp.CHARGE_ACTION = 'A'
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE
							) temp2
							
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		)/(select count(om1.order_release_gid)
		from order_movement om1
		where om1.order_release_gid = om.order_release_gid
		
		)
		END),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_FTL')
end as		
																																											direct_price_min,
																																											
																																											
																																											-- case when
		-- trim(to_char((select min(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- temp.source_city,
							-- temp.dest_city,
							-- round(min(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.source_location_gid) source_city,
								-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.DEST_LOCATION_GID) dest_city,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.source_city,
							-- temp.dest_city) temp2
		-- where
		-- temp2.source_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.source_location_gid
		-- )
		
		-- and temp2.dest_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.DEST_LOCATION_GID
		-- )
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		-- )	/
		-- (select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- ),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL') <> '_LTL' then 
		
		-- trim(to_char((select min(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- temp.source_city,
							-- temp.dest_city,
							-- round(min(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.source_location_gid) source_city,
								-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.DEST_LOCATION_GID) dest_city,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- temp.source_city,
							-- temp.dest_city,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.source_location_gid
		-- )
		
		-- and temp2.dest_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.DEST_LOCATION_GID
		-- )
		
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		-- )	/
		-- (select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- ),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL')
		-- else 
		
		
		-- trim(to_char((CASE WHEN 
		
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25
		-- THEN 
		
		-- (select min(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.source_city,
							-- temp.dest_city,
							
							-- round(MIN(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.source_location_gid) source_city,
								-- (SELECT LOC.CITY
								-- FROM LOCATION LOC
								-- WHERE LOC.LOCATION_GID = xl.DEST_LOCATION_GID) dest_city,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- RG.X_LANE_GID,
									
									-- (CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									-- FROM rate_geo_cost rgc_temp,
									-- RATE_GEO RG,
									-- RATE_GEO_COST_GROUP RGCG,
									-- X_LANE XL
									-- WHERE 
									-- RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									-- AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									-- AND rgc_temp.CHARGE_ACTION = 'A'
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.source_city,
							-- temp.dest_city
							-- ) temp2
							
		-- where
		-- temp2.source_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.source_location_gid
		-- )
		
		-- and temp2.dest_city = 
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = ORLS.DEST_LOCATION_GID
		-- )
		
		
		
		
		-- -- temp2.source_location_gid = orls_pal.source_location_gid
		-- -- and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- -- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		-- )/(select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- )
		-- END),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_FTL')
-- end as		
																																											-- direct_price_miN_ALL,
																																											
																																											
(																																									
SELECT distinct RFRJ.RATE_FACTOR_RULE_GID
-- ||'__'||RF.FACTOR_VALUE
FROM RATE_FACTOR_RULE_JOIN RFRJ
-- RATE_FACTOR RF
WHERE 
-- RF.RATE_FACTOR_SOURCE_GID = RFRJ.RATE_FACTOR_RULE_GID
-- and trunc(sh.start_time) between rf.EFFECTIVE_DATE and rf.EXPIRATION_DATE
RFRJ.RATE_GEO_GID =(

case when
		trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							TEMP.RATE_GEO_GID,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.RATE_GEO_GID,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							TEMP.RATE_GEO_GID,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		AND ROWNUM = 1 
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- ORDER BY TEMP2.PRICE ASC
		
		)||'_LTL') <> '_LTL' then 
		
		trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							TEMP.RATE_GEO_GID,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.RATE_GEO_GID,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							TEMP.RATE_GEO_GID,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		AND ROWNUM = 1 
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- ORDER BY TEMP2.PRICE ASC
		
		))
		else
		
		
		trim((CASE WHEN 
		
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25
		THEN 
		
		(select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.rate_geo_gid,
							
							round(MIN(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.X_LANE_GID,
									rg.rate_geo_gid,
									
									(CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									FROM rate_geo_cost rgc_temp,
									RATE_GEO RG,
									RATE_GEO_COST_GROUP RGCG,
									X_LANE XL
									WHERE 
									RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									AND rgc_temp.CHARGE_ACTION = 'A'
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.rate_geo_gid
							) temp2
							
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		AND ROWNUM = 1 
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		)
		END))
end 		
																																											)) FUEL_POLICY,	
(																																									
SELECT
XL.LANE_ATTRIBUTE_VALUE
 FROM
RATE_GEO RG,
 LANE_ATTRIBUTE XL
WHERE
XL.X_LANE_GID = RG.X_LANE_GID
AND XL.LANE_ATTRIBUTE_DEF_GID LIKE '%POLICY%'

AND  RG.RATE_GEO_GID =(

case when
		trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							TEMP.RATE_GEO_GID,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.RATE_GEO_GID,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							TEMP.RATE_GEO_GID,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		AND ROWNUM = 1 
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- ORDER BY TEMP2.PRICE ASC
		
		)||'_LTL') <> '_LTL' then 
		
		trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.PALLET_AMOUNT,
							TEMP.RATE_GEO_GID,
							round(min(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.RATE_GEO_GID,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									(CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									(CASE
									WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									END)
									) END) AS PRICE
											FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									RATE_GEO RG,
									X_LANE XL
											WHERE 
									RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							temp.EFFECTIVE_DATE,
							TEMP.RATE_GEO_GID,
							temp.EXPIRATION_DATE) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		AND ROWNUM = 1 
		and temp2.PALLET_AMOUNT = 
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- ORDER BY TEMP2.PRICE ASC
		
		))
		else
		
		
		trim((CASE WHEN 
		
		(CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25
		THEN 
		
		(select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.rate_geo_gid,
							
							round(MIN(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									rg.EFFECTIVE_DATE,
									rg.EXPIRATION_DATE,
									RG.X_LANE_GID,
									rg.rate_geo_gid,
									
									(CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									FROM rate_geo_cost rgc_temp,
									RATE_GEO RG,
									RATE_GEO_COST_GROUP RGCG,
									X_LANE XL
									WHERE 
									RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									AND rgc_temp.CHARGE_ACTION = 'A'
									AND XL.X_LANE_GID = RG.X_LANE_GID
									and xl.domain_name = 'ULE/PR'
											) temp
							group by 
							temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.EFFECTIVE_DATE,
							temp.EXPIRATION_DATE,
							temp.rate_geo_gid
							) temp2
							
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		AND ROWNUM = 1 
		and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		)
		END))
end 		
																																											)) REIMBURSMENT_APPLICABLE,																																												

-- (

-- case when
		-- trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- TEMP.RATE_GEO_GID,
							-- round(min(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- RG.RATE_GEO_GID,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- TEMP.RATE_GEO_GID,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		-- AND ROWNUM = 1 
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- -- ORDER BY TEMP2.PRICE ASC
		
		-- )||'_LTL') <> '_LTL' then 
		
		-- trim((select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- TEMP.RATE_GEO_GID,
							-- round(min(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- RG.RATE_GEO_GID,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- TEMP.RATE_GEO_GID,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		-- AND ROWNUM = 1 
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		
		-- -- ORDER BY TEMP2.PRICE ASC
		
		-- ))
		-- else
		
		
		-- trim((CASE WHEN 
		
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25
		-- THEN 
		
		-- (select listagg(TEMP2.RATE_GEO_GID,'/') within group (order by TEMP2.RATE_GEO_GID)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.rate_geo_gid,
							
							-- round(MIN(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- RG.X_LANE_GID,
									-- rg.rate_geo_gid,
									
									-- (CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									-- FROM rate_geo_cost rgc_temp,
									-- RATE_GEO RG,
									-- RATE_GEO_COST_GROUP RGCG,
									-- X_LANE XL
									-- WHERE 
									-- RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									-- AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									-- AND rgc_temp.CHARGE_ACTION = 'A'
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.rate_geo_gid
							-- ) temp2
							
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- AND ROWNUM = 1 
		-- and trunc(sh.start_time) between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		-- )
		-- END))
-- end 		
																																											-- ) FUEL_RR,	



																																											
																																											
																																											
																																										
																																											
																																											
																																											
																																											
																																											
																																											-- case when
		-- trim(to_char((select max(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- round(max(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_')+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and sh.start_time between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		-- )	/
		-- (select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- ),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL') <> '_LTL' then 
		
		-- trim(to_char((select max(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- round(max(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_',-1)+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and sh.start_time between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		-- )	/
		-- (select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- ),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_LTL')
		-- else
		
		
		-- trim(to_char((CASE WHEN 
		
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25 
		-- THEN 
		
		-- (select max(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							
							-- round(max(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- RG.X_LANE_GID,
									
									-- (CASE WHEN rgc_temp.CHARGE_AMOUNT IS NOT NULL THEN (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

									-- FROM rate_geo_cost rgc_temp,
									-- RATE_GEO RG,
									-- RATE_GEO_COST_GROUP RGCG,
									-- X_LANE XL
									-- WHERE 
									-- RG.RATE_GEO_GID = RGCG.RATE_GEO_GID
									-- AND RGCG.RATE_GEO_COST_GROUP_GID = rgc_temp.RATE_GEO_COST_GROUP_GID
									-- AND rgc_temp.CHARGE_ACTION = 'A'
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE
							-- ) temp2
							
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and sh.start_time between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		-- )/(select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- )
		-- END),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')||'_FTL')
-- end as		
																																											-- direct_price_max,

																																											
																																											
																																											
																																											


		((select 
		avg(sum(CASE
				WHEN (sc_temp.COST_GID = 'EUR' or sc_temp.COST_GID is null) THEN sc_temp.COST
				when sc_temp.COST_GID <> 'EUR' then sc_temp.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sysdate-30,sc_temp.COST_GID,'EUR')
				END	))						cost
				
		from shipment sh_temp,
				shipment_cost sc_temp
				
		where sc_temp.shipment_gid = sh_temp.shipment_gid
		and sh_temp.source_location_gid = orls.source_location_gid
		and sh_temp.dest_LOCATION_GID = orls.dest_LOCATION_GID
		and trunc(sh_temp.insert_date) >= sysdate - 90
		AND (sc_temp.COST_TYPE ='B' or sc_temp.ACCESSORIAL_CODE_GID like '%FUEL%')
		AND SC_TEMP.IS_WEIGHTED = 'N'
		
		
		
		and not exists 
		(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP2,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP2.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND SH_TEMP2.SHIPMENT_GID = SH_TEMP.SHIPMENT_GID
			AND SH_TEMP2.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
		
		and NOT EXISTS
		(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.shipment_gid = sh_temp.shipment_gid)	
		
		
		
		
		group by sh_temp.shipment_gid
		
		
		
		
		
		)/(select count(om1.order_release_gid)
		from order_movement om1
		where om1.order_release_gid = om.order_release_gid
		
		)) 																														median_TRANSPORT_COSTS,
																															
																																		
		-- nvl(trim(to_char((select min(temp2.price)
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE,
							-- temp.PALLET_AMOUNT,
							-- round(min(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- rg.EFFECTIVE_DATE,
									-- rg.EXPIRATION_DATE,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_')+1) AS        PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NOT NULL THEN (
									-- (CASE
									-- WHEN (RGCUB_PALLETS_1.CHARGE_AMOUNT_GID	 = 'EUR' or RGCUB_PALLETS_1.CHARGE_AMOUNT_GID is null) THEN RGCUB_PALLETS_1.CHARGE_AMOUNT
									-- when RGCUB_PALLETS_1.CHARGE_AMOUNT_GID <> 'EUR' then RGCUB_PALLETS_1.CHARGE_AMOUNT * 
									-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SYSDATE),RGCUB_PALLETS_1.CHARGE_AMOUNT_GID,'EUR')
									-- END)
									-- ) END) AS PRICE
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
											-- WHERE 
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- temp.EFFECTIVE_DATE,
							-- temp.EXPIRATION_DATE) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and sh.start_time between temp2.EFFECTIVE_DATE and temp2.EXPIRATION_DATE
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		-- and temp2.PALLET_AMOUNT = 
		-- (CEIL(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		-- )	/
		-- (select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- ),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''')),'No direct price')																							Direct_price_flag,

		-- ((select 
		-- min(sum(CASE
				-- WHEN (sc_temp.COST_GID = 'EUR' or sc_temp.COST_GID is null) THEN sc_temp.COST
				-- when sc_temp.COST_GID <> 'EUR' then sc_temp.COST * 
				-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sysdate-30,sc_temp.COST_GID,'EUR')
				-- END	))						cost
				
		-- from shipment sh_temp,
				-- shipment_cost sc_temp
				
		-- where sc_temp.shipment_gid = sh_temp.shipment_gid
		-- and sh_temp.source_location_gid = orls.source_location_gid
		-- and sh_temp.dest_LOCATION_GID = orls.dest_LOCATION_GID
		-- and trunc(sh_temp.insert_date) >= sysdate - 60
		-- AND sc_temp.ACCESSORIAL_CODE_GID LIKE '%FUEL%REIMBURSEMENT%'
		-- AND SC_TEMP.IS_WEIGHTED = 'N'
		-- -- and rownum = 1
		
		
		-- group by sh_temp.shipment_gid
		-- -- order by sc_temp.insert_date desc
		
		
		
		
		
		
		
		-- )/(select count(om1.order_release_gid)
		-- from order_movement om1
		-- where om1.order_release_gid = om.order_release_gid
		
		-- )) 																														FUEL_REIMBURSMENT,
		
		
		-------------------------------------------------------------------------------------------------------------------------------------------------


		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') 
		AND SH.SHIPMENT_TYPE_GID <> 'HANDLING' then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='B'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end as 																																		BASE_COST_OUT,
		
		
		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') 
		AND SH.SHIPMENT_TYPE_GID <> 'HANDLING' then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='A'
		AND ORL_TEMP.ACCESSORIAL_CODE_GID NOT LIKE '%FUEL%'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end as 																																ACC_COST_OUT,
		case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') 
		AND SH.SHIPMENT_TYPE_GID <> 'HANDLING' then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='B'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end as 																																BASE_COST_IN,
		
		case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') 
		AND SH.SHIPMENT_TYPE_GID <> 'HANDLING'then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION ='A'
		AND ORL_TEMP.ACCESSORIAL_CODE_GID NOT LIKE '%FUEL%'
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end as 																																ACC_COST_IN,
		(case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837')
		AND SH.SHIPMENT_TYPE_GID ='HANDLING'  then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION in ('B')
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end) as																												HANDLING_COST_BASE,
		(case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837')
		AND SH.SHIPMENT_TYPE_GID ='HANDLING'  then
		(SELECT SUM(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = om.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
		AND ORL_TEMP.COST_DESCRIPTION in ('A')
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)
		else 0
		end) as																												HANDLING_COST_ACC,
		-- (SELECT LISTAGG(RG_TEMP.X_LANE_GID,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
		-- FROM X_LANE XL,
		-- RATE_GEO RG_TEMP
		-- WHERE XL.SOURCE_LOCATION_GID = orls_pal.SOURCE_LOCATION_GID
		-- AND RG_TEMP.X_LANE_GID = XL.X_LANE_GID
		-- and sh.end_time between RG_TEMP.EFFECTIVE_DATE and RG_TEMP.EXPIRATION_DATE
		-- AND XL.DEST_LOCATION_GID = orls_pal.DEST_LOCATION_GID
		-- AND XL.DOMAIN_NAME = 'ULE/PR'
		
		-- )																																		MATCHING_XL,
		
		
		
		
		
		
		
		
		
		
		
		
		
		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end																								X_dock,
		(select loc.location_name
		from location loc
		where loc.location_gid =
		(case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end)
		)																														x_dock_name,
		(select loc.city
		from location loc
		where loc.location_gid =
		(case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end)
		)																														x_dock_city,

		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE
		else '0'
		end as 														pallets_out,	
		case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE
		else '0'
		end as 														pallets_in,	
		-- SU.SHIP_UNIT_GID,
		-- SU.TRANSPORT_HANDLING_UNIT_GID,
		-- SU.SHIP_UNIT_COUNT,
		

		-- (SELECT LOC.LOCATION_NAME
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		sh_SOURCE_LOC_NAME,
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		sh_SOURCE_LOC_CITY,
		-- (SELECT LOC.COUNTRY_CODE3_GID
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		sh_SOURCE_LOC_COUNTRY,
		-- (SELECT LOC.LOCATION_NAME
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		sh_DEST_LOC_NAME,
		
		-- (SELECT LOC.CITY
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		sh_DEST_LOC_CITY,
		-- (SELECT LOC.COUNTRY_CODE3_GID
		-- FROM LOCATION LOC
		-- WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		sh_DEST_LOC_COUNTRY,
		
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = orls.SOURCE_LOCATION_GID)		orls_SOURCE_LOC_CITY,
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = orls.DEST_LOCATION_GID)		orls_DEST_LOC_CITY,
		
		
		case when (SELECT LOC.COUNTRY_CODE3_GID
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = orls.SOURCE_LOCATION_GID) = 
		(SELECT LOC.COUNTRY_CODE3_GID
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = orls.DEST_LOCATION_GID)then 'National'
		else 'International'
		end as												international_national,
		
		
		TO_CHAR(sh.end_time,'YYYY') AS 				SH_END_YEAR,
		TO_CHAR(sh.end_time,'MM') AS 				SH_END_MONTH,
		TO_CHAR(end_time,'WW') AS 				SH_END_WEEK,
		(select LISTAGG(SHR_CONDITION.ORDER_RELEASE_REFNUM_VALUE,'/') WITHIN GROUP (ORDER BY SHR_CONDITION.ORDER_RELEASE_GID)
		FROM ORDER_RELEASE_REFNUM SHR_CONDITION 
		WHERE  SHR_CONDITION.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
		AND SHR_CONDITION.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'
		
		)																																			CONDITION
		
		
		
		


FROM shipment sh,
	order_movement om,
	order_release orls_pal
	left outer join order_release_refnum orl_ref_pal on (orls_pal.order_release_gid = orl_ref_pal.order_release_gid and 
	orl_ref_pal.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS'),
	ORDER_RELEASE ORLS
	-- order_release orl_direct_price
	-- left outer join (select temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT,
							-- round(avg(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									-- --RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID,
									-- --RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,
									-- SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_')+1) AS                                         PALLET_AMOUNT,
									-- (CASE WHEN RGCUB_PALLETS_1.CHARGE_AMOUNT IS NULL THEN 0 ELSE (RGCUB_PALLETS_1.CHARGE_AMOUNT) END) AS PRICE
									
											-- FROM RATE_GEO_COST_UNIT_BREAK RGCUB_PALLETS_1,
									-- RATE_GEO RG,
									-- X_LANE XL
									
									
											-- WHERE 
									
									-- RG.RATE_GEO_GID = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID
									-- --and 'ULE/PR.ULE_RR_T97929-A-RD-LTL-201126_EBS' = RGCUB_PALLETS_1.RATE_GEO_COST_GROUP_GID 
									-- AND XL.X_LANE_GID = RG.X_LANE_GID
									-- and xl.domain_name = 'ULE/PR'
											-- ) temp
							-- group by 
							-- temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							-- temp.PALLET_AMOUNT) xl_direct_price
		-- on (xl_direct_price.SOURCE_LOCATION_GID = orl_direct_price.SOURCE_LOCATION_GID and xl_direct_price.dest_LOCATION_GID = orl_direct_price.dest_LOCATION_GID )
	
	
	
	 -- SHIP_UNIT SU,
	 -- SHIP_UNIT_LINE SUL,
	 -- S_SHIP_UNIT_LINE SSUL

WHERE
 -- SU.ORDER_RELEASE_GID = om.ORDER_RELEASE_GID
 -- AND SUL.SHIP_UNIT_GID = SU.SHIP_UNIT_GID
 -- AND SSUL.SHIP_UNIT_GID = SUL.SHIP_UNIT_GID
om.shipment_gid = sh.shipment_gid
AND ORLS.ORDER_RELEASE_GID = OM.ORDER_RELEASE_GID
-- and orl_direct_price.order_release_gid = om.order_release_gid
and orls_pal.order_release_gid = om.order_release_gid
and (sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837')
OR sh.DEST_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837'))

and NOT EXISTS
		(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.shipment_gid = sh.shipment_gid)	
		   
-- AND SH.SHIPMENT_GID = 'ULE/PR.101358116'		   
and TO_CHAR(sh.end_time,'YYYY') IN ('2015')
 and TO_CHAR(sh.end_time,'MM') in ('10','11','12')
 -- and TO_CHAR(sh.end_time,'MM') in ('01','02','03')
-- and sh.shipment_gid in ('ULE/PR.100661104')
AND SH.SHIPMENT_TYPE_GID IN ('TRANSPORT','HANDLING')

-- and exists 
-- (
-- SELECT SH2.SHIPMENT_GID FROM 
-- ORDER_MOVEMENT SH2
-- WHERE SH2.ORDER_RELEASE_GID IN (
-- SELECT VORLS_TEMP.order_release_gid
			-- FROM SHIPMENT SH_TEMP,
			-- order_movement VORLS_TEMP
				-- -- ORDER_RELEASE ORLS_TEMP
				
			-- WHERE 1=1
			-- AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			-- -- AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			-- AND VORLS_TEMP.ORDER_RELEASE_GID = om.ORDER_RELEASE_GID
			-- AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING')
			-- )
and exists			
(select 1

from shipment_stop ss,
LOCATION_ROLE_PROFILE lrp,
view_shipment_order_release vorls
where vorls.shipment_gid  = ss.shipment_gid
and vorls.order_release_gid = orls.order_release_gid
and lrp.LOCATION_GID = ss.location_gid
and lrp.LOCATION_ROLE_GID = 'XDOCK'
)			
			
			
			
			
and (SELECT SH_STATUS.STATUS_VALUE_GID
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		)='ULE/PR.NOT CANCELLED'
AND OM.ORDER_RELEASE_GID in ('ULE.4217619934')




------add only no changes allowed