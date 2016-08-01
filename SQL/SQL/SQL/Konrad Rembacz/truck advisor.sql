SELECT sh.SHIPMENT_GID "Shipment GID",
sh.shipment_xid "Shipment XID",
sh.TRANSPORT_MODE_GID,
TRIM(to_char(sh.LOADED_DISTANCE,'9999990D99')) LOADED_DISTANCE,
sh.LOADED_DISTANCE_UOM_CODE ,
SUBSTR(sh.SOURCE_LOCATION_GID,5,LENGTH(sh.SOURCE_LOCATION_GID)) "Pickup Location ID",
SUBSTR(sh.DEST_LOCATION_GID,5,LENGTH(sh.DEST_LOCATION_GID)) "Delivery Location ID",
to_char(sh.START_TIME,'YYYY-MM-DD HH24:MI:SS') "Shipment Start Time",
to_char(sh.END_TIME,'YYYY-MM-DD HH24:MI:SS') "Shipment End Time",
SUBSTR(sh.SERVPROV_GID,5,LENGTH(sh.DEST_LOCATION_GID)) "TSP ID",
tsp_loc.LOCATION_NAME "TSP Name",
TRIM(to_char(sh.TOTAL_WEIGHT,'99999990D99')) "Total Weight",
sh.TOTAL_WEIGHT_UOM_CODE ,
sh.TOTAL_PACKAGING_UNIT_COUNT ,
sh.IS_HAZARDOUS ,
sh.IS_TEMPERATURE_CONTROL ,
sh.NUM_ORDER_RELEASES ,
sh.NUM_STOPS ,
sh.FIRST_EQUIPMENT_GROUP_GID "Equipment",
TRIM(to_char(sh.WEIGHT_UTILIZATION,'99999990D99')) WEIGHT_UTILIZATION,
TRIM(to_char(sh.VOLUME_UTILIZATION ,'99999990D99')) VOLUME_UTILIZATION,
TRIM(to_char(sh.EQUIP_REF_UNIT_UTILIZATION,'99999990D99')) EQUIP_REF_UNIT_UTILIZATION,
sh_ref_org_pfs.SHIPMENT_REFNUM_VALUE "ULE_ORIGINAL_PFS",
sh_ref_col450.SHIPMENT_REFNUM_VALUE "Truck Plate",
sh_ref_col451.SHIPMENT_REFNUM_VALUE "Temperature Condition",
sh_ref_str.SHIPMENT_REFNUM_VALUE "Shipment Stream",
sh_ref_col452.SHIPMENT_REFNUM_VALUE "Driver Instruction",
sh_ref_col453.SHIPMENT_REFNUM_VALUE "DRIVER_ASSIGNED",
sh_ref_reg.SHIPMENT_REFNUM_VALUE "Functional Region",


sh_stop1.stop_num "Stop Num_1",
substr(sh_stop1.location_gid,5) "Location Xid_1",
loc1.LOCATION_NAME "Pickup Location Name_1",
loc_add_1.ADDRESS_LINE||','||loc1.POSTAL_CODE||','||LOC1.CITY "Addres_1",
loc1.COUNTRY_CODE3_GID "Location Country_1",
loc1.LAT "LAT_1",
loc1.lon "LON_1",
to_char(sh_stop1.PLANNED_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') PLANNED_ARRIVAL_1,
to_char(sh_stop1.PLANNED_DEPARTURE,'YYYY-MM-DD HH24:MI:SS') PLANNED_DEPARTURE_1,
to_char(sh_stop1.ACTUAL_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') ACTUAL_ARRIVAL_1,
to_char(app1.appointment_start_time,'YYYY-MM-DD HH24:MI:SS') appointment_start_time_1,
to_char(app1.appointment_end_time,'YYYY-MM-DD HH24:MI:SS') appointment_end_time_1,
LOC_RES1.LOCATION_RESOURCE_NAME												DOCK_NAME_1,
sh_stop1.stop_type														stop_type_1,
sh_stop_ref1.shipment_stop_refnum_value "PO Number_1",
sh_stop_ref11.shipment_stop_refnum_value "DN Number_1",
'"'||replace(loc_rek1.remark_text,chr(11),null)||'"' "Safety Remarks_1",
'"'||loc_rek11.EMAIL_ADDRESS||'"' "Contact Name_1",
loc_rek111.PHONE1 "Contact Telephone Number_1",


sh_stop2.stop_num "Stop Num_2",
substr(sh_stop2.location_gid,5) "Location Xid_2",
loc2.LOCATION_NAME "Pickup Location Name_2",
loc_add_2.ADDRESS_LINE||','||loc2.POSTAL_CODE||','||LOC2.CITY "Addres_2",
loc2.COUNTRY_CODE3_GID "Location Country_2",
loc2.LAT "LAT_2",
loc2.lon "LON_2",
to_char(sh_stop2.PLANNED_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') PLANNED_ARRIVAL_2,
to_char(sh_stop2.PLANNED_DEPARTURE,'YYYY-MM-DD HH24:MI:SS') PLANNED_DEPARTURE_2,
to_char(sh_stop2.ACTUAL_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') ACTUAL_ARRIVAL_2,
to_char(app2.appointment_start_time,'YYYY-MM-DD HH24:MI:SS') appointment_start_time_2,
to_char(app2.appointment_end_time,'YYYY-MM-DD HH24:MI:SS') appointment_end_time_2,
LOC_RES2.LOCATION_RESOURCE_NAME												DOCK_NAME_2,
sh_stop2.stop_type 														ASTOP_TYPE_2,
sh_stop_ref2.shipment_stop_refnum_value "PO Number_2",
sh_stop_ref22.shipment_stop_refnum_value "DN Number_2",
'"'||replace(loc_rek2.remark_text,chr(11),null)||'"' "Safety Remarks_2",
'"'||loc_rek22.EMAIL_ADDRESS||'"' "Contact Name_2",
loc_rek222.PHONE1 "Contact Telephone Number_2",

sh_stop3.stop_num "Stop Num_3",
substr(sh_stop3.location_gid,5) "Location Xid_3",
loc3.LOCATION_NAME "Pickup Location Name_3",
loc_add_3.ADDRESS_LINE||','||loc3.POSTAL_CODE||','||LOC3.CITY "Addres_3",
loc3.COUNTRY_CODE3_GID "Location Country_3",
loc3.LAT "LAT_3",
loc3.lon "LON_3",
to_char(sh_stop3.PLANNED_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') PLANNED_ARRIVAL_3,
to_char(sh_stop3.PLANNED_DEPARTURE,'YYYY-MM-DD HH24:MI:SS') PLANNED_DEPARTURE_3,
to_char(sh_stop3.ACTUAL_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') ACTUAL_ARRIVAL_3,
to_char(app3.appointment_start_time,'YYYY-MM-DD HH24:MI:SS') appointment_start_time_3,
to_char(app3.appointment_end_time,'YYYY-MM-DD HH24:MI:SS') appointment_end_time_3,
LOC_RES3.LOCATION_RESOURCE_NAME												DOCK_NAME_3,
sh_stop3.stop_type 														stop_type_3,
sh_stop_ref3.shipment_stop_refnum_value "PO Number_3",
sh_stop_ref33.shipment_stop_refnum_value "DN Number_3",
'"'||replace(loc_rek3.remark_text,chr(11),null)||'"' "Safety Remarks_3",
'"'||loc_rek33.EMAIL_ADDRESS||'"' "Contact Name_3",
loc_rek333.PHONE1 "Contact Telephone Number_3",

sh_stop4.stop_num "Stop Num_4",
substr(sh_stop4.location_gid,5) "Location Xid_4",
loc4.LOCATION_NAME "Pickup Location Name_4",
loc_add_4.ADDRESS_LINE||','||loc4.POSTAL_CODE||','||LOC4.CITY "Addres_4",
loc4.COUNTRY_CODE3_GID "Location Country_4",
loc4.LAT "LAT_4",
loc4.lon "LON_4",
to_char(sh_stop4.PLANNED_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') PLANNED_ARRIVAL_4,
to_char(sh_stop4.PLANNED_DEPARTURE,'YYYY-MM-DD HH24:MI:SS') PLANNED_DEPARTURE_4,
to_char(sh_stop4.ACTUAL_ARRIVAL,'YYYY-MM-DD HH24:MI:SS') ACTUAL_ARRIVAL_4,
to_char(app4.appointment_start_time,'YYYY-MM-DD HH24:MI:SS') appointment_start_time_4,
to_char(app4.appointment_end_time,'YYYY-MM-DD HH24:MI:SS') appointment_end_time_4,
LOC_RES4.LOCATION_RESOURCE_NAME												DOCK_NAME_4,
sh_stop4.stop_type														STOP_TYPE_4,
sh_stop_ref4.shipment_stop_refnum_value "PO Number_4",
sh_stop_ref44.shipment_stop_refnum_value "DN Number_4",
'"'||replace(loc_rek4.remark_text,chr(11),null)||'"' "Safety Remarks_4",
'"'||loc_rek44.EMAIL_ADDRESS||'"' "Contact Name_4",
loc_rek444.PHONE1 "Contact Telephone Number_4"




FROM
SHIPMENT sh

  left outer join LOCATION tsp_loc on sh.servprov_gid = tsp_loc.location_gid
  left outer join SHIPMENT_REFNUM sh_ref_reg on sh.shipment_gid = sh_ref_reg.shipment_gid and sh_ref_reg.shipment_refnum_qual_gid='ULE.ULE_FUNCTIONAL REGION'
  left outer join SHIPMENT_REFNUM sh_ref_col453 on sh.shipment_gid = sh_ref_col453.shipment_gid and sh_ref_col453.shipment_refnum_qual_gid='DRIVER_ASSIGNED'
  left outer join SHIPMENT_REFNUM sh_ref_col452 on sh.shipment_gid = sh_ref_col452.shipment_gid and sh_ref_col452.shipment_refnum_qual_gid='ULE.ULE_DRIVER_INSTRUCTIONS'
  left outer join SHIPMENT_REFNUM sh_ref_col451 on sh.shipment_gid = sh_ref_col451.shipment_gid and sh_ref_col451.shipment_refnum_qual_gid='ULE.ULE_TRANSPORT_CONDITION'
 left outer join SHIPMENT_REFNUM sh_ref_col450 on sh.shipment_gid = sh_ref_col450.shipment_gid and sh_ref_col450.shipment_refnum_qual_gid='ULE.TRUCK PLATE'
 left outer join SHIPMENT_REFNUM sh_ref_org_pfs on sh.shipment_gid = sh_ref_org_pfs.shipment_gid and sh_ref_org_pfs.shipment_refnum_qual_gid='ULE.ULE_ORIGINAL_PFS'
  left outer join SHIPMENT_REFNUM sh_ref_str on sh.shipment_gid = sh_ref_str.shipment_gid and sh_ref_str.shipment_refnum_qual_gid='ULE.ULE_SHIPMENT_STREAM'
  left outer join SHIPMENT_STOP sh_stop1 on sh_stop1.shipment_gid = sh.shipment_gid and sh_stop1.stop_num =1
  left outer join SHIPMENT_STOP sh_stop2 on sh_stop2.shipment_gid = sh.shipment_gid and sh_stop2.stop_num =2
  left outer join SHIPMENT_STOP sh_stop3 on sh_stop3.shipment_gid = sh.shipment_gid and sh_stop3.stop_num =3
   left outer join SHIPMENT_STOP sh_stop4 on sh_stop4.shipment_gid = sh.shipment_gid and sh_stop4.stop_num =4
  left outer join LOCATION loc1 on sh_stop1.location_gid = loc1.location_gid
  left outer join LOCATION loc2 on sh_stop2.location_gid = loc2.location_gid
  left outer join LOCATION loc3 on sh_stop3.location_gid = loc3.location_gid
  left outer join LOCATION loc4 on sh_stop4.location_gid = loc4.location_gid
  left outer join APPOINTMENT app1 on app1.object_gid=sh_stop1.shipment_gid and app1.stop_num=sh_stop1.stop_num
   left outer join APPOINTMENT app2 on app2.object_gid=sh_stop2.shipment_gid and app2.stop_num=sh_stop2.stop_num
   left outer join APPOINTMENT app3 on app3.object_gid=sh_stop3.shipment_gid and app3.stop_num=sh_stop3.stop_num
   left outer join APPOINTMENT app4 on app4.object_gid=sh_stop4.shipment_gid and app4.stop_num=sh_stop4.stop_num
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1 on sh_stop_ref1.shipment_gid = sh_stop1.shipment_gid and sh_stop1.stop_num = sh_stop_ref1.stop_num and sh_stop_ref1.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop1.stop_type='D'
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref11 on sh_stop_ref11.shipment_gid = sh_stop1.shipment_gid and sh_stop1.stop_num = sh_stop_ref11.stop_num and sh_stop_ref11.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop1.stop_type='D'
   left outer join SHIPMENT_STOP_REFNUM sh_stop_ref2 on sh_stop_ref2.shipment_gid = sh_stop2.shipment_gid and sh_stop2.stop_num = sh_stop_ref2.stop_num and sh_stop_ref2.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop2.stop_type='D'
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref22 on sh_stop_ref22.shipment_gid = sh_stop2.shipment_gid and sh_stop2.stop_num = sh_stop_ref22.stop_num and sh_stop_ref22.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop2.stop_type='D'
 left outer join SHIPMENT_STOP_REFNUM sh_stop_ref3 on sh_stop_ref3.shipment_gid = sh_stop3.shipment_gid and sh_stop3.stop_num = sh_stop_ref3.stop_num and sh_stop_ref3.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop3.stop_type='D'
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref33 on sh_stop_ref33.shipment_gid = sh_stop3.shipment_gid and sh_stop3.stop_num = sh_stop_ref33.stop_num and sh_stop_ref33.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop3.stop_type='D'
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref4 on sh_stop_ref4.shipment_gid = sh_stop4.shipment_gid and sh_stop4.stop_num = sh_stop_ref4.stop_num and sh_stop_ref4.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop4.stop_type='D'
  left outer join SHIPMENT_STOP_REFNUM sh_stop_ref44 on sh_stop_ref44.shipment_gid = sh_stop4.shipment_gid and sh_stop4.stop_num = sh_stop_ref44.stop_num and sh_stop_ref44.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop4.stop_type='D'



 left outer join location_remark loc_rek1 on loc_rek1.location_gid = sh_stop1.location_gid and loc_rek1.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
 left outer join contact loc_rek11 on loc_rek11.CONTACT_GID = sh_stop1.location_gid
 left outer join contact loc_rek111 on loc_rek111.CONTACT_GID = sh_stop1.location_gid
 left outer join location_remark loc_rek2 on loc_rek2.location_gid = sh_stop2.location_gid and loc_rek2.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
 left outer join contact loc_rek22 on loc_rek22.CONTACT_GID = sh_stop2.location_gid
 left outer join contact loc_rek222 on loc_rek222.CONTACT_GID = sh_stop2.location_gid
  left outer join location_remark loc_rek3 on loc_rek3.location_gid = sh_stop3.location_gid and loc_rek3.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
 left outer join contact loc_rek33 on loc_rek33.CONTACT_GID = sh_stop3.location_gid
 left outer join contact loc_rek333 on loc_rek333.CONTACT_GID = sh_stop3.location_gid
 left outer join location_remark loc_rek4 on loc_rek4.location_gid = sh_stop4.location_gid and loc_rek4.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
 left outer join contact loc_rek44 on loc_rek44.CONTACT_GID = sh_stop4.location_gid
 left outer join contact loc_rek444 on loc_rek444.CONTACT_GID = sh_stop4.location_gid
  left outer join LOCATION_ADDRESS loc_add_1 on sh_stop1.location_gid = loc_add_1.LOCATION_GID and loc_add_1.LINE_SEQUENCE=1
  left outer join LOCATION_ADDRESS loc_add_2 on sh_stop2.location_gid = loc_add_2.LOCATION_GID and loc_add_2.LINE_SEQUENCE=1
   left outer join LOCATION_ADDRESS loc_add_3 on sh_stop3.location_gid = loc_add_3.LOCATION_GID and loc_add_3.LINE_SEQUENCE=1
   left outer join LOCATION_ADDRESS loc_add_4 on sh_stop4.location_gid = loc_add_4.LOCATION_GID and loc_add_4.LINE_SEQUENCE=1
   LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES1 ON (LOC_RES1.LOCATION_RESOURCE_GID = app1.LOCATION_RESOURCE_GID)
   LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES2 ON (LOC_RES2.LOCATION_RESOURCE_GID = app2.LOCATION_RESOURCE_GID)
   LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES3 ON (LOC_RES3.LOCATION_RESOURCE_GID = app3.LOCATION_RESOURCE_GID)
   LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES4 ON (LOC_RES4.LOCATION_RESOURCE_GID = app4.LOCATION_RESOURCE_GID)

  where rownum <501

--  AND SH.SHIPMENT_GID = 'UGO.10062062'

  AND sh.shipment_gid = NVL(:P_SH_ID,SH.SHIPMENT_GID)
  AND SH.START_TIME BETWEEN NVL(TO_DATE(:P_DATE_FROM,:P_DATE_TIME_FORMAT),SH.START_TIME) AND NVL(TO_DATE(:P_DATE_TO,:P_DATE_TIME_FORMAT),SH.START_TIME)
  AND SH.SOURCE_LOCATION_GID = NVL(:P_SOURCE_LOC,SH.SOURCE_LOCATION_GID)
  AND SH.SERVPROV_GID = NVL(:P_SERVPROV_ID,SH.SERVPROV_GID)

  --sh srart time, source location, carrier id


