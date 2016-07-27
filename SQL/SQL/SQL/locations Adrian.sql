select loc.location_xid,
loc.LOCATION_NAME,
loc.CITY,
loc.POSTAL_CODE,
loc.COUNTRY_CODE3_GID,
loc_add.ADDRESS_LINE,
ac.ACTIVITY_CALENDAR_ID,
ac.ACTIVITY_GID,
ac.BEGIN,
ac.DURATION,
AC.IS_WORK_ON



from location loc,
location_address loc_add,
location loc_cal
left outer join location_role_profile lrp on (loc_cal.location_gid = lrp.location_gid)
left outer join activity_calendar ac on (ac.CALENDAR_GID = lrp.CALENDAR_GID)




where

loc_add.location_gid = loc.location_gid
and loc_cal.location_gid = loc.location_gid
AND LOC.LOCATION_XID NOT LIKE '%OTC%'
