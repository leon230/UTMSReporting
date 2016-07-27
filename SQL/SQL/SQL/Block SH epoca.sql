SELECT sh.SHIPMENT_GID "Shipment GID",
sh.SOURCE_LOCATION_GID "Pickup Location ID",
pic_loc.CITY "Pickup City",
sh.DEST_LOCATION_GID "Delivery Location ID",
del_loc.LOCATION_NAME "Delivery Location Name",
sh_stat.STATUS_VALUE_GID "STATUS ENROUTE",
sh_stat1.STATUS_VALUE_GID "STATUS FINANCE",
sh_stat2.STATUS_VALUE_GID "STATUS INVOICE",
sh.START_TIME "Shipment Start Time",
sh.END_TIME "Shipment End Time",
sh.SERVPROV_GID "TSP ID",
tsp_loc.LOCATION_NAME "TSP Name",
sh_ref.SHIPMENT_REFNUM_VALUE "Shipment Refnum"

FROM

SHIPMENT sh

  join LOCATION pic_loc on sh.source_location_gid = pic_loc.location_gid
  join LOCATION del_loc on sh.dest_location_gid = del_loc.location_gid
  join LOCATION tsp_loc on sh.servprov_gid = tsp_loc.location_gid

left outer join SHIPMENT_STATUS sh_stat on sh.shipment_gid = sh_stat.shipment_gid and sh_stat.STATUS_TYPE_GID = 'ULE/PR.ENROUTE'
left outer join SHIPMENT_STATUS sh_stat1 on sh.shipment_gid = sh_stat1.shipment_gid and sh_stat1.STATUS_TYPE_GID = 'ULE/PR.FINANCE'
left outer join SHIPMENT_STATUS sh_stat2 on sh.shipment_gid = sh_stat2.shipment_gid and sh_stat2.STATUS_TYPE_GID = 'ULE/PR.INVOICE_READY'

  join ORDER_MOVEMENT ord_mov on sh.shipment_gid = ord_mov.shipment_gid
  join ORDER_RELEASE ord_rel on ord_mov.order_release_gid = ord_rel.order_release_gid
  join ORDER_RELEASE_REFNUM ord_rel_STR on ord_rel.order_release_gid = ord_rel_STR.order_release_gid and ord_rel_STR.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM' and ord_rel_STR.ORDER_RELEASE_REFNUM_VALUE = 'SECONDARY'
  join SHIPMENT_REFNUM sh_ref on sh.shipment_gid = sh_ref.shipment_gid and sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_SHIPMENT_STREAM'
  
where 

pic_loc.COUNTRY_CODE3_GID = 'ITA'
and
del_loc.COUNTRY_CODE3_GID = 'ITA'
and
trunc(sh.START_TIME) > to_date('2015-10-18','YYYY-MM-DD')
and 
sh.SERVPROV_GID in ('ULE.T50283698','ULE.T204767','ULE.T216130','ULE.T18833','ULE.T1105438','ULE.T201601')
