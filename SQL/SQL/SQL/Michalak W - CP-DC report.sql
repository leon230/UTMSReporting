select temp.SOURCE_LOCATION_GID,
temp.SOURCE_REPORTING_NAME,
temp.SOURCE_COUNTRY,
temp.SOURCE_CITY,
temp.source_CATEGORY,
temp.DEST_LOCATION_GID,
temp.dest_REPORTING_NAME,
temp.dest_COUNTRY,
temp.dest_CITY,
temp.dest_CATEGORY,
temp.Month_name,
temp.tt,
count(temp.shipment_gid)			"Number_of_shipments"


from(
SELECT 
sh.shipment_gid,
SH.SOURCE_LOCATION_GID,
(
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.SOURCE_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_REPORTING_NAME'
)																	SOURCE_REPORTING_NAME,
(
select lr.COUNTRY_CODE3_GID
from LOCATION lr
where lr.LOCATION_GID = sh.SOURCE_LOCATION_GID
)																	SOURCE_COUNTRY,
(
select lr.CITY
from LOCATION lr
where lr.LOCATION_GID = sh.SOURCE_LOCATION_GID
)																	SOURCE_CITY,
(
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.SOURCE_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY'
)																	SOURCE_CATEGORY,

SH.DEST_LOCATION_GID,
(
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.DEST_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_REPORTING_NAME'
)																	DEST_REPORTING_NAME,
(
select lr.COUNTRY_CODE3_GID
from LOCATION lr
where lr.LOCATION_GID = sh.DEST_LOCATION_GID
)																	DEST_COUNTRY,
(
select lr.CITY
from LOCATION lr
where lr.LOCATION_GID = sh.DEST_LOCATION_GID
)																	DEST_CITY,
(
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.DEST_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY'
)																	DEST_CATEGORY,
TO_CHAR(SH.END_TIME,'MON')			Month_name,
round((sh.end_time-sh.start_time)*24,0)		TT

FROM SHIPMENT SH

WHERE 

TO_CHAR(SH.END_TIME,'YYYY')= '2015'
and (
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.SOURCE_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE'
) in ('3P','CP')
and  
(
select lr.LOCATION_REFNUM_VALUE
from LOCATION_REFNUM lr
where lr.LOCATION_GID = sh.DEST_LOCATION_GID
and lr.LOCATION_REFNUM_QUAL_GID = 'LOCATION_TYPE'
) = 'DC'
AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)
	
		   
) temp
group by
temp.SOURCE_LOCATION_GID,
temp.SOURCE_REPORTING_NAME,
temp.SOURCE_COUNTRY,
temp.SOURCE_CITY,
temp.source_CATEGORY,
temp.DEST_LOCATION_GID,
temp.dest_REPORTING_NAME,
temp.dest_COUNTRY,
temp.dest_CITY,
temp.dest_CATEGORY,
temp.Month_name,
temp.tt