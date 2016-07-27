select temp.insert_user,
	temp.insert_date,
	temp.STREAM,
	count(temp.shipment_gid)		count_sh,
	sum(temp.cost_sum_eur)					cost_eur


from (
select sh.shipment_gid,
		sh.insert_user,
		to_char(sh.insert_date,'YYYY-MM') insert_date,
	(
	SELECT sh_ref_1.SHIPMENT_REFNUM_VALUE
		FROM 
			shipment_refnum sh_ref_1
		WHERE 
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
	
	)																				STREAM,
	
	
			(select (SUM(CASE
				WHEN (SH_TEMP.COST_GID = 'EUR' or SH_TEMP.COST_GID is null) THEN SH_TEMP.COST
				when SH_TEMP.COST_GID <> 'EUR' then SH_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sysdate,SH_TEMP.COST_GID,'EUR')
				else 0 END)
			)
			from SHIPMENT_COST SH_TEMP
			where SH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID
			and SH_TEMP.COST_TYPE IN ('B','A')
			and sh_temp.IS_WEIGHTED = 'N'
			)														cost_sum_eur


from shipment sh

where
sh.PLANNED_RATE_GEO_GID is null

and exists

 (SELECT 1
		FROM 
			shipment_refnum sh_ref_1
		WHERE 
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_XLS_UPLD_SHIPMENT_REF_NO')

			AND SH.INSERT_DATE >SYSDATE -50
			-- and TO_CHAR(SH.insert_date,'YYYY') = '2015'
) temp
group by
temp.insert_user,
	temp.insert_date,
	temp.STREAM