select SH.SHIPMENT_GID,
	TO_CHAR(SH.INSERT_DATE,'YYYY-MM-DD') INSERT_DATE,
	TO_CHAR(SH.END_TIME,'YYYY-MM-DD') END_TIME,
	Domain_name,
	(SELECT sh_ref_1.Shipment_Refnum_Value
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID) AS STREAM


from shipment sh

where 

exists
(select 1
from shipment_status shs
where
shs.shipment_gid = sh.shipment_gid
and shs.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'
and shs.STATUS_VALUE_GID <> 'ULE/PR.SC_NO CHANGES ALLOWED'

)

AND EXISTS
(select 1
from view_shipment_order_release vorls,
order_release_refnum orls_ref
where orls_ref.order_release_gid = vorls.order_release_gid
and sh.shipment_gid = vorls.shipment_gid
and orls_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_FINAL_BILLING_NUMBER'
AND orls_ref.ORDER_RELEASE_REFNUM_VALUE IS NOT NULL


)