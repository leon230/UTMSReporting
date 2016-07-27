select sh.shipment_gid,
to_char(sh.end_time,'YYYY-MM-DD')  SH_END_TIME,
orls.source_location_gid,
(select loc.location_name
from location loc
where loc.location_gid = orls.source_location_gid

)																source_name,
(select loc.city
from location loc
where loc.location_gid = orls.source_location_gid

)																source_city,
(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.source_location_gid

)																source_country,
orls.order_release_gid,
orls.dest_location_gid,
(select loc.location_name
from location loc
where loc.location_gid = orls.dest_location_gid

)																dest_name,
(select loc.city
from location loc
where loc.location_gid = orls.dest_location_gid

)																dest_city,
(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.dest_location_gid

)																dest_country,

NVL((SELECT LISTAGG(OREF_2.ORDER_RELEASE_REFNUM_VALUE,';') WITHIN GROUP (ORDER BY OREF_2.ORDER_RELEASE_REFNUM_VALUE)
	FROM ORDER_RELEASE_REFNUM OREF_2
	WHERE OREF_2.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
		  AND OREF_2.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_TRANSPORT_CONDITION'),'-')														ORLS_TRANSPORT_CONDITION,
SH.TRANSPORT_MODE_GID 	 																													SH_TRANSPORT_MODE,
NVL((SELECT LISTAGG(RPT_GENERAL.F_REMOVE_DOMAIN(S_EQ.EQUIPMENT_GROUP_GID),'; ') WITHIN GROUP (ORDER BY RPT_GENERAL.F_REMOVE_DOMAIN(S_EQ.EQUIPMENT_GROUP_GID))
	FROM SHIPMENT_S_EQUIPMENT_JOIN SH_EQ_J,
		 S_EQUIPMENT S_EQ
	WHERE SH_EQ_J.S_EQUIPMENT_GID = S_EQ.S_EQUIPMENT_GID
		  AND SH.SHIPMENT_GID = SH_EQ_J.SHIPMENT_GID),'-')																						SH_EQUIPMENT_TYPE,
sh.servprov_gid,
(select loc.location_name
from location loc
where loc.location_gid = sh.servprov_gid

)																servprov_name,
NVL(TRIM(TO_CHAR(ORLS.TOTAL_WEIGHT_BASE*0.45359237,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'-')									ORLS_TOTAL_WEIGHT_KG,
(SELECT 
		listagg(or_ref_3.ORDER_RELEASE_REFNUM_VALUE,'/') within group (order by orls.order_release_gid)
	FROM 
		ORDER_RELEASE_REFNUM or_ref_3
	WHERE 
		orls.ORDER_RELEASE_GID = or_ref_3.ORDER_RELEASE_GID
		AND or_ref_3.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS')																	ORDER_RELEASE_ORIGINAL_PFS,
(SELECT SH_PALLET.SHIPMENT_REFNUM_VALUE
	 FROM SHIPMENT_REFNUM SH_PALLET
	 WHERE SH_PALLET.SHIPMENT_GID=SH.SHIPMENT_GID
	      AND SH_PALLET.SHIPMENT_REFNUM_QUAL_GID ='ULE.ULE_ORIGINAL_PFS'
	)																																			SH_PFS_EUR,		
	
-- SH.NUM_ORDER_RELEASES 	 																													ORDERS_IN_SHIPMENT,
(select count(om.order_release_gid)
from order_movement om1
where om1.shipment_gid = sh.shipment_gid
)																																					ORDERS_IN_SHIPMENT,
(select sum((CASE
				WHEN (alloc_d.COST_CURRENCY_GID = 'EUR' or alloc_d.COST_CURRENCY_GID is null) THEN alloc_d.COST
				when alloc_d.COST_CURRENCY_GID <> 'EUR' then alloc_d.COST * 
				unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(to_date(nvl(sh.start_time,sysdate-30),'DD.MM.YYYY'),alloc_d.COST_CURRENCY_GID,'EUR')
				END)
			)
			from allocation_order_release_d alloc_d
			where alloc_d.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			and alloc_d.COST_DESCRIPTION in ('A','B')
			
			)																																	TOTAL_COST_OR_EUR,
			
			
			(SELECT SHS_STATUS_CANC.STATUS_VALUE_GID
	 FROM SHIPMENT_STATUS SHS_STATUS_CANC
	 WHERE SH.SHIPMENT_GID = SHS_STATUS_CANC.SHIPMENT_GID 
		   AND SHS_STATUS_CANC.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
	)																																			CANCELLATION_STATUS,
	
	(SELECT SHS_INVOICE.STATUS_VALUE_GID
	 FROM SHIPMENT_STATUS SHS_INVOICE
	 WHERE SHS_INVOICE.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
		--AND SHS_INVOICE.STATUS_VALUE_GID <> 'ULE/PR.SC_NO CHANGES ALLOWED'
		AND SH.SHIPMENT_GID = SHS_INVOICE.SHIPMENT_GID)																										COST_STATUS
	
			
-- (select 
-- sum(CASE
				-- WHEN (sc_temp.COST_GID = 'EUR' or sc_temp.COST_GID is null) THEN sc_temp.COST
				-- when sc_temp.COST_GID <> 'EUR' then sc_temp.COST * 
				-- unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sysdate-30,sc_temp.COST_GID,'EUR')
				-- END	)																								cost
				
		-- from 
				-- shipment_cost sc_temp

		-- where sc_temp.shipment_gid = sh.shipment_gid
				-- AND (sc_temp.COST_TYPE  in ('B','A'))
		-- AND SC_TEMP.IS_WEIGHTED = 'N'
-- )																																	TOTAL_COST_EUR




from shipment sh,
		order_release orls,
		order_movement om
		
		
where
orls.order_release_gid = om.order_release_gid
and sh.shipment_gid = om.shipment_gid

AND TRUNC(SH.END_TIME) >= TO_DATE('2015-04-01','YYYY-MM-DD')
AND TRUNC(SH.END_TIME) < TO_DATE('2015-07-01','YYYY-MM-DD')

and 
(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.source_location_gid

)<>
(select loc.country_code3_gid
from location loc
where loc.location_gid = orls.dest_location_gid

)					


-- AND ORLS.DEST_LOCATION_GID IN ('ULE.V162510','ULE.V218322','ULE.V316442','ULE.V316415','ULE.V50474879','ULE.V218340','ULE.V218348','ULE.V218346','ULE.V207484')
 and EXISTS
		(SELECT 1
		FROM ORDER_RELEASE_REFNUM sh_ref_1
		WHERE sh_ref_1.ORDER_RELEASE_Refnum_Qual_Gid = 'ULE.ULE_STREAM'
		   AND sh_ref_1.ORDER_RELEASE_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID)	
 
 
 