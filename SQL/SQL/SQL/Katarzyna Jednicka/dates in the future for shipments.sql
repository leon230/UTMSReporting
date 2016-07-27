SELECT ss.shipment_gid
,TO_CHAR(SS.ACTUAL_ARRIVAL,'YYYY-MM-DD')
,ss.stop_num
,(SELECT sh_ref_1.shipment_refnum_value
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		AND sh_ref_1.shipment_gid = ss.shipment_gid)							stream
,(SELECT sh_ref.shipment_refnum_value
FROM shipment_refnum sh_ref
WHERE sh_ref.shipment_gid = ss.shipment_gid
AND sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_FUNCTIONAL_REGION'
)																						region




FROM SHIPMENT_STOP SS

WHERE
SS.actual_arrival >= trunc(sysdate)