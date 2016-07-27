select orls.order_release_gid
,sh.shipment_gid



from order_release orls
,view_shipment_order_release vorls
,shipment sh
/* where  orls.insert_date > sysdate -60 */
WHERE 
-- to_char(orls.insert_date,'YYYY') = '2016'
orls.insert_date >= sysdate -1
and vorls.order_release_gid = orls.order_release_gid
and sh.shipment_gid = vorls.shipment_gid

and(

exists
(select 1
from shipment_status ss
where  SS.STATUS_TYPE_GID = 'ULE/PR.FINANCE'
AND SS.STATUS_VALUE_GID <> 'ULE/PR.FINANCE_READY'
and ss.shipment_gid = sh.shipment_gid
)
or 
exists
(select 1
from shipment_status ss
where SS.STATUS_TYPE_GID = 'ULE/PR.INVOICE_READY'
AND SS.STATUS_VALUE_GID <> 'ULE/PR.INVOICE_READY'
and ss.shipment_gid = sh.shipment_gid
)
)

AND EXISTS(SELECT 1
	FROM order_release_refnum
	WHERE ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
	AND ORDER_RELEASE_REFNUM_QUAL_GID like '%PRELIMINARY%')



