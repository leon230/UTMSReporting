with used_locations as (
select loc from (
select orls.source_location_gid loc from order_release orls
union all
select orls.dest_location_gid loc from order_release orls
union all
select orls.plan_from_location_gid loc from order_release orls
union all
select orls.plan_to_location_gid loc from order_release orls
union all
select shs.location_gid from shipment_stop shs
union all
select x.source_location_gid from x_lane x
union all
select x.dest_location_gid from x_lane x
) location_data
where loc is not null
)
select distinct loca.location_gid
,loca.POSTAL_CODE
,loca.COUNTRY_CODE3_GID
,loca.CITY
,loca.LOCATION_NAME
,ul.loc
,cc.COUNTRY_NAME
,cc.COUNTRY_NUMBER
,cc.COUNTRY_ZONE_GID
,cc.COUNTRY_CODE_FIPS
,cc.COUNTRY_CODE2

-- ,to_char(nvl(loca.update_date,loca.insert_date),'YYYY-MM') INSERT_DATE
-- ,to_char(loca.update_date,'YYYY-MM') update_DATE
,to_char(loca.insert_date,'YYYY-MM') INSERT_DATE

from
location loca
left join used_locations ul on (loca.location_gid = ul.loc)
left join country_code cc on (cc.COUNTRY_CODE3_GID = loca.COUNTRY_CODE3_GID)

where
-- loca.insert_date >= to_date(:P_FROM,:P_DATE_TIME_FORMAT)
-- and loca.insert_date <= to_date(:P_TO,:P_DATE_TIME_FORMAT)

not exists(
select 1
from servprov s
where s.servprov_gid = loca.location_gid
--and loca.location_gid not in ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837')
)
AND ul.loc is not null


-- and loca.location_gid not like 'ULE.OTC%'
-- and loca.location_gid not like 'ULE.OTD%'
AND (
loca.location_gid like 'ULE.C%'
or loca.location_gid like 'ULE.V%'
)
and loca.location_gid not like 'ULE.VPD%'