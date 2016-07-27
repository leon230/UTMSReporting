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
		(CASE WHEN OM.ORDER_RELEASE_GID LIKE 'ULE.018%' THEN 'INBOUND'
		ELSE 'OUTBOUND'
		END
		)																												INB_OUTB,
		-- case when orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE <> 'MASTER_DATA_NO_AVAILABLE' then
		-- round(nvl(to_number(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE),0))
		-- else 0
		-- end 																											or_pallets,
		
		-- REGEXP_LIKE(first_name, '^Ste(v|ph)en$')
		-- (case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[A-Za-z]') then 0
		-- else 
		
		-- round(to_number(LTRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,'.',','),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end)        		or_pallets,
	
		(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))       																							or_pallets,
		-- replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,'.',',') OR_TEST,
		-- (orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE)  																									OR_PALLETS,
		 --(LTRIM(TO_CHAR(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))) pal2,
		
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
		
		
		
		
		
		-- xl_direct_price.price																												direct_price,
		trim(to_char((select temp2.price
		
		from
		(select distinct temp.SOURCE_LOCATION_GID,
							temp.DEST_LOCATION_GID,
							temp.PALLET_AMOUNT,
							round(avg(price),2) Price
							from 
							(SELECT  
									XL.SOURCE_LOCATION_GID,
									XL.DEST_LOCATION_GID,
									RG.X_LANE_GID,
									SUBSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,INSTR(RGCUB_PALLETS_1.RATE_UNIT_BREAK_GID,'_')+1) AS        PALLET_AMOUNT,
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
							temp.PALLET_AMOUNT) temp2
		where
		temp2.source_location_gid = orls_pal.source_location_gid
		and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		and temp2.PALLET_AMOUNT = 
		(ROUND(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		else 
		
		((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))
		)	/
		(select count(om1.order_release_gid)
		from order_movement om1
		where om1.order_release_gid = om.order_release_gid
		
		),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. '''))

																																					direct_price_ltl,
																																					
	-- trim(to_char((CASE WHEN 
		
		-- (ROUND(TO_NUMBER((case when REGEXP_LIKE(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE, '[^0-9 \.,]') then '0'
		-- else 
		
		-- ((TRIM(TO_CHAR(replace(orl_ref_pal.ORDER_RELEASE_REFNUM_VALUE,'.','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
		-- '999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')))	> 25 
		-- THEN 
		
		-- (select temp2.price
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							
							-- round(avg(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									
									-- (CASE WHEN rgc_temp.CHARGE_AMOUNT IS NULL THEN 0 ELSE (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

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
							-- temp.DEST_LOCATION_GID) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		-- )
		-- END),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. '''))																					PRICE_FTL,
		-------------------------------------------------------------------------------------------------------------------------------------------------
		-- (select temp2.price
		
		-- from
		-- (select distinct temp.SOURCE_LOCATION_GID,
							-- temp.DEST_LOCATION_GID,
							
							-- round(avg(price),2) Price
							-- from 
							-- (SELECT  
									-- XL.SOURCE_LOCATION_GID,
									-- XL.DEST_LOCATION_GID,
									-- RG.X_LANE_GID,
									
									-- (CASE WHEN rgc_temp.CHARGE_AMOUNT IS NULL THEN 0 ELSE (rgc_temp.CHARGE_AMOUNT) END) AS PRICE

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
							-- temp.DEST_LOCATION_GID) temp2
		-- where
		-- temp2.source_location_gid = orls_pal.source_location_gid
		-- and temp2.dest_LOCATION_GID = orls_pal.dest_location_gid
		
		-- )																																	PRICE_FTL,
		
		
		
		-- SSUL.OR_LINE_GID,
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
		(SELECT LISTAGG(RG_TEMP.X_LANE_GID,'/') WITHIN GROUP (ORDER BY XL.X_LANE_GID)
		FROM X_LANE XL,
		RATE_GEO RG_TEMP
		WHERE XL.SOURCE_LOCATION_GID = orls_pal.SOURCE_LOCATION_GID
		AND RG_TEMP.X_LANE_GID = XL.X_LANE_GID
		AND XL.DEST_LOCATION_GID = orls_pal.DEST_LOCATION_GID
		AND XL.DOMAIN_NAME = 'ULE/PR'
		
		)																																		MATCHING_XL,
		
		
		
		
		
		
		
		
		
		
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
		

		(SELECT LOC.LOCATION_NAME
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		SOURCE_LOC_NAME,
		(SELECT LOC.LOCATION_NAME
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		DEST_LOC_NAME,
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		SOURCE_LOC_CITY,
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		DEST_LOC_CITY,
		TO_CHAR(sh.end_time,'YYYY') AS 				SH_END_YEAR,
		TO_CHAR(sh.end_time,'MM') AS 				SH_END_MONTH,
		TO_CHAR(end_time,'WW') AS 				SH_END_WEEK
		
		
		
		


FROM shipment sh,
	order_movement om,
	order_release orls_pal
	left outer join order_release_refnum orl_ref_pal on (orls_pal.order_release_gid = orl_ref_pal.order_release_gid and 
	orl_ref_pal.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS')
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
		   
		   
and TO_CHAR(sh.end_time,'YYYY') IN ('2015')
-- and TO_CHAR(sh.end_time,'MM') = '08'
-- and sh.shipment_gid in ('ULE/PR.100661104')
AND SH.SHIPMENT_TYPE_GID IN ('TRANSPORT','HANDLING')

and exists 
(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = om.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
and (SELECT SH_STATUS.STATUS_VALUE_GID
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		)='ULE/PR.NOT CANCELLED'
-- AND OM.ORDER_RELEASE_GID in ('ULE.4217649043','ULE.4217649044')