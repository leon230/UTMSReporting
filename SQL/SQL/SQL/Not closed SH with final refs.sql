select ref1.ORDER_RELEASE_GID,
SHS.SHIPMENT_GID,
SHS.STATUS_VALUE_GID,
 ref1.ORDER_RELEASE_REFNUM_QUAL_GID, ref1.ORDER_RELEASE_REFNUM_VALUE, ref1.DOMAIN_NAME,
to_char(shs.insert_date,'YYYY-MM-DD') 										status_insert,
	TO_CHAR(shs.update_date,'YYYY-MM-DD')														status_update,
	TO_CHAR(ref1.insert_date,'YYYY-MM-DD')														REF_INSERT_DATE,
	TO_CHAR(ref1.update_date,'YYYY-MM-DD')														REF_UPDATE_DATE,
	REF1.INSERT_USER																			REF_INSERT_USER,
	SHS.UPDATE_USER																				STATUS_UPDATE_USER,
	(select orl_stream.ORDER_RELEASE_REFNUM_value
from order_release_refnum orl_stream
WHERE
orl_stream.order_release_gid = REF1.order_release_gid 
and 
orl_stream.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
)																								OR_STREAM,
(select count(om1.shipment_gid)
from order_movement om1
where om1.order_release_gid = ref1.order_release_gid
)																								num_sh
	
	
from
order_release_refnum  ref1,
ORDER_MOVEMENT OM,
	SHIPMENT_STATUS SHS
	
	
	


where 
OM.ORDER_RELEASE_GID = REF1.ORDER_RELEASE_GID
AND OM.SHIPMENT_GID = SHS.SHIPMENT_GID
AND SHS.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
AND SHS.STATUS_VALUE_GID <> 'ULE/PR.SC_NO CHANGES ALLOWED'

and ref1.ORDER_RELEASE_REFNUM_QUAL_GID iN ('ULE.ULE_FINAL_BILLING_NUMBER','ULE.ULE_FINANCE_PO_NUMBER')
and REF1.insert_date > to_date('2014-01-01','YYYY-MM-DD')

and not exists 
(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = ref1.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
			
AND NOT EXISTS
(select 1
from
order_release_refnum  ref3,
order_release ref2

where ref3.order_release_gid = ref2.order_release_gid
AND REF3.order_release_gid = REF1.order_release_gid
and ref3.insert_user = ref2.insert_user
and ref3.ORDER_RELEASE_REFNUM_QUAL_GID in	('ULE.ULE_FINAL_BILLING_NUMBER','ULE.ULE_FINANCE_PO_NUMBER')
and ref2.insert_date > to_date('2014-01-01','YYYY-MM-DD'))
			
			
			
			
