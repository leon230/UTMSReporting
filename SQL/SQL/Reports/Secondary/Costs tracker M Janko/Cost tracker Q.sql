select sh.shipment_gid,
		orls.order_release_gid,
		rfrj.RATE_FACTOR_RULE_GID,
		
		




from

shipment sh,
order_release orls,
view_shipment_order_release vorls,
shipment_cost shc,
shipment sh_fuel
left outer join RATE_FACTOR_RULE_JOIN rfrj on (rfrj.RATE_GEO_GID = sh_fuel.RATE_GEO_GID),
shipment sh_base
-- left outer join RATE_GEO RG on (RG.RATE_GEO_GID = sh_base.rate_geo_gid)
left outer join RATE_GEO_COST RGC on (RGC.RATE_GEO_COST_GROUP_GID = sh_base.RATE_GEO_GID)
-- left outer join RATE_OFFERING RO on (RO.RATE_OFFERING_GID = RG.RATE_OFFERING_GID)











where 1=1

and sh.shipment_gid = vorls.shipment_gid
and orls.order_release_gid = vorls.order_release_gid
and shc.shipment_gid = sh.shipment_gid
and sh_fuel.shipment_gid = sh.shipment_gid
and sh_base.shipment_gid = sh.shipment_gid