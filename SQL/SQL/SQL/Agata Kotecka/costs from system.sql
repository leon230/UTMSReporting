select SH.shipment_gid,


TRIM(TO_CHAR((select(SUM(CASE
				WHEN (alloc_d.COST_GID = 'EUR' or alloc_d.COST_GID is null) THEN alloc_d.COST
				when alloc_d.COST_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(SH.START_TIME,alloc_d.COST_GID,'EUR')
				END)
			)
			from shipment_cost alloc_d
			where alloc_d.shipment_gid = SH.shipment_gid
			and  alloc_d.COST_TYPE = 'B'
				and alloc_d.IS_WEIGHTED = 'N'
			),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. '''))																													TOTAL_COST_BASE,
			
			
			TRIM(TO_CHAR((select(SUM(CASE
				WHEN (alloc_d.COST_GID = 'EUR' or alloc_d.COST_GID is null) THEN alloc_d.COST
				when alloc_d.COST_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(SH.START_TIME,alloc_d.COST_GID,'EUR')
				END)
			)
			from shipment_cost alloc_d
			where alloc_d.shipment_gid = SH.shipment_gid
			and  alloc_d.COST_TYPE = 'A'
				and alloc_d.IS_WEIGHTED = 'N'
				AND alloc_d.ACCESSORIAL_CODE_GID like '%FUEL%'
				
			),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. '''))																									TOTAL_COST_FUEL,
			TRIM(TO_CHAR((select(SUM(CASE
				WHEN (alloc_d.COST_GID = 'EUR' or alloc_d.COST_GID is null) THEN alloc_d.COST
				when alloc_d.COST_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(SH.START_TIME,alloc_d.COST_GID,'EUR')
				END)
			)
			from shipment_cost alloc_d
			where alloc_d.shipment_gid = SH.shipment_gid
			and  alloc_d.COST_TYPE = 'A'
				and alloc_d.IS_WEIGHTED = 'N'
				AND alloc_d.ACCESSORIAL_CODE_GID not like '%FUEL%'
				
			),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. '''))																											TOTAL_COST_accessorial
			
			
			



from shipment SH

WHERE to_char(sh.start_time,'YYYY-MM') IN ('2015-01') 
