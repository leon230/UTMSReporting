select temp.source_country,
temp.dest_country,
temp.SH_STREAM,
temp.in_out,
COUNT(DISTINCT TEMP.shipment_gid)				SH_COUNT,
COUNT(DISTINCT TEMP.OR_ID)				OR_COUNT,
SUM(temp.cost_sum)						cost_eur


from(
select sh.shipment_gid,
ORLS.ORDER_RELEASE_GID OR_ID,
to_char(sh.end_time,'YYYY-MM-DD')  SH_END_TIME,
orls.source_location_gid,


(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.source_location_gid

)																source_country,
orls.order_release_gid,
orls.dest_location_gid,

(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.dest_location_gid

)																dest_country,

(SELECT sh_ref_1.SHIPMENT_Refnum_Value
		FROM SHIPMENT_REFNUM sh_ref_1
		WHERE sh_ref_1.SHIPMENT_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)															SH_STREAM,
case when		   
(SELECT sh_ref_1.SHIPMENT_Refnum_Value
		FROM SHIPMENT_REFNUM sh_ref_1
		WHERE sh_ref_1.SHIPMENT_Refnum_Qual_Gid = 'ULE.ULE_FUNCTIONAL_REGION'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)	= 'INBOUND' THEN 'INBOUND'
		   
		   ELSE 'OUTBOUND'
		   END AS 																									in_out,
		   
		   
(SELECT sum(CASE
				WHEN (ORL_TEMP.COST_CURRENCY_GID = 'EUR' or ORL_TEMP.COST_CURRENCY_GID is null) THEN ORL_TEMP.COST
				when ORL_TEMP.COST_CURRENCY_GID <> 'EUR' then ORL_TEMP.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE((SH.END_TIME),ORL_TEMP.COST_CURRENCY_GID,'EUR')
				ELSE 0
				END)
		FROM ALLOCATION_ORDER_RELEASE_D ORL_TEMP,
			ALLOCATION_BASE AB
		WHERE ORL_TEMP.order_release_gid = orls.order_release_gid
			AND AB.ALLOC_SEQ_NO = ORL_TEMP.ALLOC_SEQ_NO
	
		AND AB.SHIPMENT_GID = SH.SHIPMENT_GID
		
		)																																				cost_sum




	


from shipment sh,
		order_release orls,
		order_movement om
		
		
where
orls.order_release_gid = om.order_release_gid
and sh.shipment_gid = om.shipment_gid

AND TRUNC(SH.END_TIME) >= TO_DATE('2015-01-01','YYYY-MM-DD')
AND TRUNC(SH.END_TIME) < TO_DATE('2016-01-01','YYYY-MM-DD')
and	not exists
		 (SELECT 
			1
		FROM 
			shipment_refnum sh_ref_1
		WHERE 
			sh.shipment_gid = sh_ref_1.shipment_gid
			AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_XLS_UPLD_SHIPMENT_REF_NO')				
) temp
				
GROUP BY

temp.source_country,
temp.dest_country,
temp.SH_STREAM,
temp.in_out

 
 
 