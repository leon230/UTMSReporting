select temp.SOURCE_LOC
,s_loc.location_name s_location_name
,s_loc_ref.LOCATION_REFNUM_VALUE s_location_type
,temp.DEST_LOC
,d_loc.location_name   d_location_name
,d_loc_ref.LOCATION_REFNUM_VALUE d_location_type
,temp.MATERIAL_TYPE
,temp.COST_CENTER
,temp.GL_CODE
,temp.PAYER
,temp.table_name


from(
select SOURCE_LOC
,DEST_LOC
,MATERIAL_TYPE
,COST_CENTER
,GL_CODE
,'' as PAYER
,'ULE_COST_ALLOC_OCEAN' as table_name
from ULE_COST_ALLOC_OCEAN

union all

select SOURCE_LOC
,DEST_LOC
,''
,''
,''
,PAYER as PAYER
,'ULE_COST_ALLOC_OCEAN_P' as table_name
from ULE_COST_ALLOC_OCEAN_P

union all

select SOURCE_LOC
,''
,''
,''
,''
,PAYER as PAYER
,'UGO_COST_ALLOC_INLAND_SOURCE_P' as table_name
from UGO_COST_ALLOC_INLAND_SOURCE_P

union all

select ''
,DEST_LOC
,''
,''
,''
,PAYER as PAYER
,'UGO_COST_ALLOC_INLAND_DEST_P' as table_name
from UGO_COST_ALLOC_INLAND_DEST_P




) temp
left outer join location s_loc on (s_loc.location_gid = temp.SOURCE_LOC)
left outer join location d_loc on (d_loc.location_gid = temp.DEST_LOC)
left outer join location_refnum s_loc_ref on (s_loc_ref.location_gid = temp.SOURCE_LOC and s_loc_ref.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE')
left outer join location_refnum d_loc_REF on (d_loc_REF.location_gid = temp.DEST_LOC and d_loc_REF.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE')

where temp.table_name = nvl(:P_TABLE, TEMP.table_name)