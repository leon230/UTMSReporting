select sh_ref.shipment_refnum_qual_gid
,count(sh_ref.shipment_gid)             sh_count

from shipment_refnum sh_ref


where sh_ref.insert_date >= to_date('2017-01-01','YYYY-MM-DD')

group by
sh_ref.shipment_refnum_qual_gid


/
select sh_ref.shipment_refnum_qual_gid
,count(distinct sh_ref.shipment_gid)             sh_count
,count(sh_ref.shipment_gid)             refnum_usage

from shipment_refnum sh_ref


where sh_ref.insert_date >= to_date('2017-01-01','YYYY-MM-DD')

group by
sh_ref.shipment_refnum_qual_gid
