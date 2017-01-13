select temp.SOURCE_LOCATION_GID
,s_loc.location_name s_location_name
,s_loc_ref.LOCATION_REFNUM_VALUE s_location_type
,temp.DEST_LOCATION_GID
,d_loc.location_name   d_location_name
,d_loc_ref.LOCATION_REFNUM_VALUE d_location_type
,temp.MATERIAL_TYPE
,temp.COST_CENTER
,temp.GLN
,temp.PAYER
,temp.IS_BULK
,temp.table_name


from(
select SOURCE_LOCATION_GID
,DEST_LOCATION_GID
,MATERIAL_TYPE
,COST_CENTER
,GLN
,PAYER
,IS_BULK
,'ULE_COST_ALLOC_ROAD_EXCEPTION' as table_name
from ULE_COST_ALLOC_ROAD_EXCEPTION

UNION ALL

select ''
,DEST_LOC
,MATERIAL_TYPE
,COST_CENTER
,GL_CODE
,''
,''
,'ULE_COST_ALLOC_ROAD'


from ULE_COST_ALLOC_ROAD

UNION ALL

select ''
,DEST_LOC
,MATERIAL_TYPE
,COST_CENTER
,GL_CODE
,''
,''
,'ULE_COST_ALLOC_ROAD_BULK'


from ULE_COST_ALLOC_ROAD_BULK

UNION ALL

select SOURCE_LOC
,DEST_LOC
,''
,''
,''
,PAYER
,''
,'ULE_COST_ALLOC_ROAD_P'
from ULE_COST_ALLOC_ROAD_P

UNION ALL

select SOURCE_LOCATION_GID
,DEST_LOCATION_GID
,MATERIAL_TYPE
,COST_CENTER
,GLN
,PAYER
,''
,'ULE_COST_ALLOC_ROAD_2Y_EXCE'
from ULE_COST_ALLOC_ROAD_2Y_EXCE

UNION ALL

select ORIGIN_LOCATION
,''
,MATERIAL_TYPE
,COST_CENTER
,GL_CODE
,''
,''
,'ULE_COST_ALLOC_ROAD_2Y'
from ULE_COST_ALLOC_ROAD_2Y

UNION ALL

select ORIGIN_COUNTRY
,DESTINATION_COUNTRY
,''
,''
,''
,PAYER
,''
,'ULE_COST_ALLOC_ROAD_2Y_P'
from ULE_COST_ALLOC_ROAD_2Y_P
) temp
left outer join location s_loc on (s_loc.location_gid = temp.SOURCE_LOCATION_GID)
left outer join location d_loc on (d_loc.location_gid = temp.DEST_LOCATION_GID)
left outer join location_refnum s_loc_ref on (s_loc_ref.location_gid = temp.SOURCE_LOCATION_GID and s_loc_ref.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE')
left outer join location_refnum d_loc_REF on (d_loc_REF.location_gid = temp.DEST_LOCATION_GID and d_loc_REF.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE')

where temp.table_name = nvl(:P_TABLE, TEMP.table_name)