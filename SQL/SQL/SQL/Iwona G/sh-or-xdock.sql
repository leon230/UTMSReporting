SELECT 
sh_l1.SHIPMENT_GID "Leg 1 Shipment GID",
(SELECT 
sh_l1.SHIPMENT_GID "Leg 2 Shipment GID"

FROM
SHIPMENT sh_l1
left outer join view_shipment_order_release ord_mov_l1 on ord_mov_l1.SHIPMENT_GID = sh_l1.SHIPMENT_GID
left outer join LOCATION_ROLE_PROFILE loc_rp on loc_rp.location_gid = sh_l1.SOURCE_location_gid
left outer join order_release ord_rel2 on ord_mov_l1.order_release_gid = ord_rel2.order_release_gid
where 
  loc_rp.location_role_gid = 'XDOCK'
  and sh_l1.SHIPMENT_TYPE_GID = 'TRANSPORT'
  and sh_l1.source_location_gid <> sh_l1.dest_location_gid
  and ord_rel2.order_release_gid = ord_rel.order_release_gid 
  )																"Leg 2 Shipment GID",		
(SELECT 
sh_l1.SHIPMENT_GID "Handling Shipment GID"
FROM
SHIPMENT sh_l1
left outer join view_shipment_order_release ord_mov_l1 on ord_mov_l1.SHIPMENT_GID = sh_l1.SHIPMENT_GID
left outer join LOCATION_ROLE_PROFILE loc_rp on loc_rp.location_gid = sh_l1.SOURCE_location_gid
left outer join order_release ord_rel3 on ord_mov_l1.order_release_gid = ord_rel3.order_release_gid

where 
  loc_rp.location_role_gid = 'XDOCK'
  and sh_l1.SHIPMENT_TYPE_GID = 'HANDLING'

  and sh_l1.source_location_gid = sh_l1.dest_location_gid
and ord_rel3.order_release_gid = ord_rel.order_release_gid   ) "handling Shipment GID",

ord_rel.order_release_gid "Order Release"



FROM
SHIPMENT sh_l1
left outer join view_shipment_order_release ord_mov_l1 on ord_mov_l1.SHIPMENT_GID = sh_l1.SHIPMENT_GID
left outer join LOCATION_ROLE_PROFILE loc_rp on loc_rp.location_gid = sh_l1.dest_location_gid
left outer join order_release ord_rel on ord_mov_l1.order_release_gid = ord_rel.order_release_gid

where 
	ord_rel.order_release_gid in ('ULE.0180538318')

 and  loc_rp.location_role_gid = 'XDOCK'

  and sh_l1.SHIPMENT_TYPE_GID = 'TRANSPORT'
  -- and sh_l1.SHIPMENT_GID = 'ULE/PR.100374922'
  and sh_l1.source_location_gid <> sh_l1.dest_location_gid
