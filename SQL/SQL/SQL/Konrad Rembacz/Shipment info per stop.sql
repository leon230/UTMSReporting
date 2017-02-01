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
loc_rek11.PHONE1 "Contact Telephone Number_1",


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
loc_rek22.PHONE1 "Contact Telephone Number_2",

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
loc_rek33.PHONE1 "Contact Telephone Number_3",

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
loc_rek44.PHONE1 "Contact Telephone Number_4",


-------------------------------------------------------------------

sh_stop5.stop_num "Stop Num_5",
substr(sh_stop5.location_gid,5) "Location Xid_5",
loc5.LOCATION_NAME "Pickup Location Name_5",
loc_add_5.ADDRESS_LINE||','||loc5.POSTAL_CODE||','||LOC5.CITY "Addres_5",
loc5.COUNTRY_CODE3_GID "Location Country_5",
loc5.LAT "LAT_5",
loc5.lon "LON_5",
to_char(sh_stop5.PLANNED_ARRIVAL,'YYYY-MM-DD HH25:MI:SS') PLANNED_ARRIVAL_5,
to_char(sh_stop5.PLANNED_DEPARTURE,'YYYY-MM-DD HH25:MI:SS') PLANNED_DEPARTURE_5,
to_char(sh_stop5.ACTUAL_ARRIVAL,'YYYY-MM-DD HH25:MI:SS') ACTUAL_ARRIVAL_5,
to_char(app5.appointment_start_time,'YYYY-MM-DD HH25:MI:SS') appointment_start_time_5,
to_char(app5.appointment_end_time,'YYYY-MM-DD HH25:MI:SS') appointment_end_time_5,
LOC_RES5.LOCATION_RESOURCE_NAME												DOCK_NAME_5,
sh_stop5.stop_type														STOP_TYPE_5,
sh_stop_ref5.shipment_stop_refnum_value "PO Number_5",
sh_stop_ref55.shipment_stop_refnum_value "DN Number_5",
'"'||replace(loc_rek5.remark_text,chr(11),null)||'"' "Safety Remarks_5",
'"'||loc_rek55.EMAIL_ADDRESS||'"' "Contact Name_5",
loc_rek55.PHONE1 "Contact Telephone Number_5",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop6.stop_num "Stop Num_6",
substr(sh_stop6.location_gid,5) "Location Xid_6",
loc6.LOCATION_NAME "Pickup Location Name_6",
loc_add_6.ADDRESS_LINE||','||loc6.POSTAL_CODE||','||LOC6.CITY "Addres_6",
loc6.COUNTRY_CODE3_GID "Location Country_6",
loc6.LAT "LAT_6",
loc6.lon "LON_6",
to_char(sh_stop6.PLANNED_ARRIVAL,'YYYY-MM-DD HH26:MI:SS') PLANNED_ARRIVAL_6,
to_char(sh_stop6.PLANNED_DEPARTURE,'YYYY-MM-DD HH26:MI:SS') PLANNED_DEPARTURE_6,
to_char(sh_stop6.ACTUAL_ARRIVAL,'YYYY-MM-DD HH26:MI:SS') ACTUAL_ARRIVAL_6,
to_char(app6.appointment_start_time,'YYYY-MM-DD HH26:MI:SS') appointment_start_time_6,
to_char(app6.appointment_end_time,'YYYY-MM-DD HH26:MI:SS') appointment_end_time_6,
LOC_RES6.LOCATION_RESOURCE_NAME												DOCK_NAME_6,
sh_stop6.stop_type														STOP_TYPE_6,
sh_stop_ref6.shipment_stop_refnum_value "PO Number_6",
sh_stop_ref66.shipment_stop_refnum_value "DN Number_6",
'"'||replace(loc_rek6.remark_text,chr(11),null)||'"' "Safety Remarks_6",
'"'||loc_rek66.EMAIL_ADDRESS||'"' "Contact Name_6",
loc_rek66.PHONE1 "Contact Telephone Number_6",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop7.stop_num "Stop Num_7",
substr(sh_stop7.location_gid,5) "Location Xid_7",
loc7.LOCATION_NAME "Pickup Location Name_7",
loc_add_7.ADDRESS_LINE||','||loc7.POSTAL_CODE||','||LOC7.CITY "Addres_7",
loc7.COUNTRY_CODE3_GID "Location Country_7",
loc7.LAT "LAT_7",
loc7.lon "LON_7",
to_char(sh_stop7.PLANNED_ARRIVAL,'YYYY-MM-DD HH27:MI:SS') PLANNED_ARRIVAL_7,
to_char(sh_stop7.PLANNED_DEPARTURE,'YYYY-MM-DD HH27:MI:SS') PLANNED_DEPARTURE_7,
to_char(sh_stop7.ACTUAL_ARRIVAL,'YYYY-MM-DD HH27:MI:SS') ACTUAL_ARRIVAL_7,
to_char(app7.appointment_start_time,'YYYY-MM-DD HH27:MI:SS') appointment_start_time_7,
to_char(app7.appointment_end_time,'YYYY-MM-DD HH27:MI:SS') appointment_end_time_7,
LOC_RES7.LOCATION_RESOURCE_NAME												DOCK_NAME_7,
sh_stop7.stop_type														STOP_TYPE_7,
sh_stop_ref7.shipment_stop_refnum_value "PO Number_7",
sh_stop_ref77.shipment_stop_refnum_value "DN Number_7",
'"'||replace(loc_rek7.remark_text,chr(11),null)||'"' "Safety Remarks_7",
'"'||loc_rek77.EMAIL_ADDRESS||'"' "Contact Name_7",
loc_rek77.PHONE1 "Contact Telephone Number_7",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop8.stop_num "Stop Num_8",
substr(sh_stop8.location_gid,5) "Location Xid_8",
loc8.LOCATION_NAME "Pickup Location Name_8",
loc_add_8.ADDRESS_LINE||','||loc8.POSTAL_CODE||','||LOC8.CITY "Addres_8",
loc8.COUNTRY_CODE3_GID "Location Country_8",
loc8.LAT "LAT_8",
loc8.lon "LON_8",
to_char(sh_stop8.PLANNED_ARRIVAL,'YYYY-MM-DD HH28:MI:SS') PLANNED_ARRIVAL_8,
to_char(sh_stop8.PLANNED_DEPARTURE,'YYYY-MM-DD HH28:MI:SS') PLANNED_DEPARTURE_8,
to_char(sh_stop8.ACTUAL_ARRIVAL,'YYYY-MM-DD HH28:MI:SS') ACTUAL_ARRIVAL_8,
to_char(app8.appointment_start_time,'YYYY-MM-DD HH28:MI:SS') appointment_start_time_8,
to_char(app8.appointment_end_time,'YYYY-MM-DD HH28:MI:SS') appointment_end_time_8,
LOC_RES8.LOCATION_RESOURCE_NAME												DOCK_NAME_8,
sh_stop8.stop_type														STOP_TYPE_8,
sh_stop_ref8.shipment_stop_refnum_value "PO Number_8",
sh_stop_ref88.shipment_stop_refnum_value "DN Number_8",
'"'||replace(loc_rek8.remark_text,chr(11),null)||'"' "Safety Remarks_8",
'"'||loc_rek88.EMAIL_ADDRESS||'"' "Contact Name_8",
loc_rek88.PHONE1 "Contact Telephone Number_8",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop9.stop_num "Stop Num_9",
substr(sh_stop9.location_gid,5) "Location Xid_9",
loc9.LOCATION_NAME "Pickup Location Name_9",
loc_add_9.ADDRESS_LINE||','||loc9.POSTAL_CODE||','||LOC9.CITY "Addres_9",
loc9.COUNTRY_CODE3_GID "Location Country_9",
loc9.LAT "LAT_9",
loc9.lon "LON_9",
to_char(sh_stop9.PLANNED_ARRIVAL,'YYYY-MM-DD HH29:MI:SS') PLANNED_ARRIVAL_9,
to_char(sh_stop9.PLANNED_DEPARTURE,'YYYY-MM-DD HH29:MI:SS') PLANNED_DEPARTURE_9,
to_char(sh_stop9.ACTUAL_ARRIVAL,'YYYY-MM-DD HH29:MI:SS') ACTUAL_ARRIVAL_9,
to_char(app9.appointment_start_time,'YYYY-MM-DD HH29:MI:SS') appointment_start_time_9,
to_char(app9.appointment_end_time,'YYYY-MM-DD HH29:MI:SS') appointment_end_time_9,
LOC_RES9.LOCATION_RESOURCE_NAME												DOCK_NAME_9,
sh_stop9.stop_type														STOP_TYPE_9,
sh_stop_ref9.shipment_stop_refnum_value "PO Number_9",
sh_stop_ref99.shipment_stop_refnum_value "DN Number_9",
'"'||replace(loc_rek9.remark_text,chr(11),null)||'"' "Safety Remarks_9",
'"'||loc_rek99.EMAIL_ADDRESS||'"' "Contact Name_9",
loc_rek99.PHONE1 "Contact Telephone Number_9",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop10.stop_num "Stop Num_10",
substr(sh_stop10.location_gid,5) "Location Xid_10",
loc10.LOCATION_NAME "Pickup Location Name_10",
loc_add_10.ADDRESS_LINE||','||loc10.POSTAL_CODE||','||LOC10.CITY "Addres_10",
loc10.COUNTRY_CODE3_GID "Location Country_10",
loc10.LAT "LAT_10",
loc10.lon "LON_10",
to_char(sh_stop10.PLANNED_ARRIVAL,'YYYY-MM-DD HH210:MI:SS') PLANNED_ARRIVAL_10,
to_char(sh_stop10.PLANNED_DEPARTURE,'YYYY-MM-DD HH210:MI:SS') PLANNED_DEPARTURE_10,
to_char(sh_stop10.ACTUAL_ARRIVAL,'YYYY-MM-DD HH210:MI:SS') ACTUAL_ARRIVAL_10,
to_char(app10.appointment_start_time,'YYYY-MM-DD HH210:MI:SS') appointment_start_time_10,
to_char(app10.appointment_end_time,'YYYY-MM-DD HH210:MI:SS') appointment_end_time_10,
LOC_RES10.LOCATION_RESOURCE_NAME												DOCK_NAME_10,
sh_stop10.stop_type														STOP_TYPE_10,
sh_stop_ref10.shipment_stop_refnum_value "PO Number_10",
sh_stop_ref1010.shipment_stop_refnum_value "DN Number_10",
'"'||replace(loc_rek10.remark_text,chr(11),null)||'"' "Safety Remarks_10",
'"'||loc_rek1010.EMAIL_ADDRESS||'"' "Contact Name_10",
loc_rek1010.PHONE1 "Contact Telephone Number_10",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop11.stop_num "Stop Num_11",
substr(sh_stop11.location_gid,5) "Location Xid_11",
loc11.LOCATION_NAME "Pickup Location Name_11",
loc_add_11.ADDRESS_LINE||','||loc11.POSTAL_CODE||','||LOC11.CITY "Addres_11",
loc11.COUNTRY_CODE3_GID "Location Country_11",
loc11.LAT "LAT_11",
loc11.lon "LON_11",
to_char(sh_stop11.PLANNED_ARRIVAL,'YYYY-MM-DD HH211:MI:SS') PLANNED_ARRIVAL_11,
to_char(sh_stop11.PLANNED_DEPARTURE,'YYYY-MM-DD HH211:MI:SS') PLANNED_DEPARTURE_11,
to_char(sh_stop11.ACTUAL_ARRIVAL,'YYYY-MM-DD HH211:MI:SS') ACTUAL_ARRIVAL_11,
to_char(app11.appointment_start_time,'YYYY-MM-DD HH211:MI:SS') appointment_start_time_11,
to_char(app11.appointment_end_time,'YYYY-MM-DD HH211:MI:SS') appointment_end_time_11,
LOC_RES11.LOCATION_RESOURCE_NAME												DOCK_NAME_11,
sh_stop11.stop_type														STOP_TYPE_11,
sh_stop_ref11.shipment_stop_refnum_value "PO Number_11",
sh_stop_ref1111.shipment_stop_refnum_value "DN Number_11",
'"'||replace(loc_rek11.remark_text,chr(11),null)||'"' "Safety Remarks_11",
'"'||loc_rek1111.EMAIL_ADDRESS||'"' "Contact Name_11",
loc_rek1111.PHONE1 "Contact Telephone Number_11",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop12.stop_num "Stop Num_12",
substr(sh_stop12.location_gid,5) "Location Xid_12",
loc12.LOCATION_NAME "Pickup Location Name_12",
loc_add_12.ADDRESS_LINE||','||loc12.POSTAL_CODE||','||LOC12.CITY "Addres_12",
loc12.COUNTRY_CODE3_GID "Location Country_12",
loc12.LAT "LAT_12",
loc12.lon "LON_12",
to_char(sh_stop12.PLANNED_ARRIVAL,'YYYY-MM-DD HH212:MI:SS') PLANNED_ARRIVAL_12,
to_char(sh_stop12.PLANNED_DEPARTURE,'YYYY-MM-DD HH212:MI:SS') PLANNED_DEPARTURE_12,
to_char(sh_stop12.ACTUAL_ARRIVAL,'YYYY-MM-DD HH212:MI:SS') ACTUAL_ARRIVAL_12,
to_char(app12.appointment_start_time,'YYYY-MM-DD HH212:MI:SS') appointment_start_time_12,
to_char(app12.appointment_end_time,'YYYY-MM-DD HH212:MI:SS') appointment_end_time_12,
LOC_RES12.LOCATION_RESOURCE_NAME												DOCK_NAME_12,
sh_stop12.stop_type														STOP_TYPE_12,
sh_stop_ref12.shipment_stop_refnum_value "PO Number_12",
sh_stop_ref1212.shipment_stop_refnum_value "DN Number_12",
'"'||replace(loc_rek12.remark_text,chr(11),null)||'"' "Safety Remarks_12",
'"'||loc_rek1212.EMAIL_ADDRESS||'"' "Contact Name_12",
loc_rek1212.PHONE1 "Contact Telephone Number_12",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop13.stop_num "Stop Num_13",
substr(sh_stop13.location_gid,5) "Location Xid_13",
loc13.LOCATION_NAME "Pickup Location Name_13",
loc_add_13.ADDRESS_LINE||','||loc13.POSTAL_CODE||','||LOC13.CITY "Addres_13",
loc13.COUNTRY_CODE3_GID "Location Country_13",
loc13.LAT "LAT_13",
loc13.lon "LON_13",
to_char(sh_stop13.PLANNED_ARRIVAL,'YYYY-MM-DD HH213:MI:SS') PLANNED_ARRIVAL_13,
to_char(sh_stop13.PLANNED_DEPARTURE,'YYYY-MM-DD HH213:MI:SS') PLANNED_DEPARTURE_13,
to_char(sh_stop13.ACTUAL_ARRIVAL,'YYYY-MM-DD HH213:MI:SS') ACTUAL_ARRIVAL_13,
to_char(app13.appointment_start_time,'YYYY-MM-DD HH213:MI:SS') appointment_start_time_13,
to_char(app13.appointment_end_time,'YYYY-MM-DD HH213:MI:SS') appointment_end_time_13,
LOC_RES13.LOCATION_RESOURCE_NAME												DOCK_NAME_13,
sh_stop13.stop_type														STOP_TYPE_13,
sh_stop_ref13.shipment_stop_refnum_value "PO Number_13",
sh_stop_ref1313.shipment_stop_refnum_value "DN Number_13",
'"'||replace(loc_rek13.remark_text,chr(11),null)||'"' "Safety Remarks_13",
'"'||loc_rek1313.EMAIL_ADDRESS||'"' "Contact Name_13",
loc_rek1313.PHONE1 "Contact Telephone Number_13",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop14.stop_num "Stop Num_14",
substr(sh_stop14.location_gid,5) "Location Xid_14",
loc14.LOCATION_NAME "Pickup Location Name_14",
loc_add_14.ADDRESS_LINE||','||loc14.POSTAL_CODE||','||LOC14.CITY "Addres_14",
loc14.COUNTRY_CODE3_GID "Location Country_14",
loc14.LAT "LAT_14",
loc14.lon "LON_14",
to_char(sh_stop14.PLANNED_ARRIVAL,'YYYY-MM-DD HH214:MI:SS') PLANNED_ARRIVAL_14,
to_char(sh_stop14.PLANNED_DEPARTURE,'YYYY-MM-DD HH214:MI:SS') PLANNED_DEPARTURE_14,
to_char(sh_stop14.ACTUAL_ARRIVAL,'YYYY-MM-DD HH214:MI:SS') ACTUAL_ARRIVAL_14,
to_char(app14.appointment_start_time,'YYYY-MM-DD HH214:MI:SS') appointment_start_time_14,
to_char(app14.appointment_end_time,'YYYY-MM-DD HH214:MI:SS') appointment_end_time_14,
LOC_RES14.LOCATION_RESOURCE_NAME												DOCK_NAME_14,
sh_stop14.stop_type														STOP_TYPE_14,
sh_stop_ref14.shipment_stop_refnum_value "PO Number_14",
sh_stop_ref1414.shipment_stop_refnum_value "DN Number_14",
'"'||replace(loc_rek14.remark_text,chr(11),null)||'"' "Safety Remarks_14",
'"'||loc_rek1414.EMAIL_ADDRESS||'"' "Contact Name_14",
loc_rek1414.PHONE1 "Contact Telephone Number_14",

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------

sh_stop15.stop_num "Stop Num_15",
substr(sh_stop15.location_gid,5) "Location Xid_15",
loc15.LOCATION_NAME "Pickup Location Name_15",
loc_add_15.ADDRESS_LINE||','||loc15.POSTAL_CODE||','||LOC15.CITY "Addres_15",
loc15.COUNTRY_CODE3_GID "Location Country_15",
loc15.LAT "LAT_15",
loc15.lon "LON_15",
to_char(sh_stop15.PLANNED_ARRIVAL,'YYYY-MM-DD HH215:MI:SS') PLANNED_ARRIVAL_15,
to_char(sh_stop15.PLANNED_DEPARTURE,'YYYY-MM-DD HH215:MI:SS') PLANNED_DEPARTURE_15,
to_char(sh_stop15.ACTUAL_ARRIVAL,'YYYY-MM-DD HH215:MI:SS') ACTUAL_ARRIVAL_15,
to_char(app15.appointment_start_time,'YYYY-MM-DD HH215:MI:SS') appointment_start_time_15,
to_char(app15.appointment_end_time,'YYYY-MM-DD HH215:MI:SS') appointment_end_time_15,
LOC_RES15.LOCATION_RESOURCE_NAME												DOCK_NAME_15,
sh_stop15.stop_type														STOP_TYPE_15,
sh_stop_ref15.shipment_stop_refnum_value "PO Number_15",
sh_stop_ref1515.shipment_stop_refnum_value "DN Number_15",
'"'||replace(loc_rek15.remark_text,chr(11),null)||'"' "Safety Remarks_15",
'"'||loc_rek1515.EMAIL_ADDRESS||'"' "Contact Name_15",
loc_rek1515.PHONE1 "Contact Telephone Number_15"

-------------------------------------------------------------------------------------------


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
	left outer join SHIPMENT_STOP sh_stop5 on sh_stop5.shipment_gid = sh.shipment_gid and sh_stop5.stop_num =5
	left outer join SHIPMENT_STOP sh_stop6 on sh_stop6.shipment_gid = sh.shipment_gid and sh_stop6.stop_num =6
	left outer join SHIPMENT_STOP sh_stop7 on sh_stop7.shipment_gid = sh.shipment_gid and sh_stop7.stop_num =7
	left outer join SHIPMENT_STOP sh_stop8 on sh_stop8.shipment_gid = sh.shipment_gid and sh_stop8.stop_num =8
	left outer join SHIPMENT_STOP sh_stop9 on sh_stop9.shipment_gid = sh.shipment_gid and sh_stop9.stop_num =9
	left outer join SHIPMENT_STOP sh_stop10 on sh_stop10.shipment_gid = sh.shipment_gid and sh_stop10.stop_num =10
	left outer join SHIPMENT_STOP sh_stop11 on sh_stop11.shipment_gid = sh.shipment_gid and sh_stop11.stop_num =11
	left outer join SHIPMENT_STOP sh_stop12 on sh_stop12.shipment_gid = sh.shipment_gid and sh_stop12.stop_num =12
	left outer join SHIPMENT_STOP sh_stop13 on sh_stop13.shipment_gid = sh.shipment_gid and sh_stop13.stop_num =13
	left outer join SHIPMENT_STOP sh_stop14 on sh_stop14.shipment_gid = sh.shipment_gid and sh_stop14.stop_num =14
	left outer join SHIPMENT_STOP sh_stop15 on sh_stop15.shipment_gid = sh.shipment_gid and sh_stop15.stop_num =15


	left outer join LOCATION loc1 on sh_stop1.location_gid = loc1.location_gid
	left outer join LOCATION loc2 on sh_stop2.location_gid = loc2.location_gid
	left outer join LOCATION loc3 on sh_stop3.location_gid = loc3.location_gid
	left outer join LOCATION loc4 on sh_stop4.location_gid = loc4.location_gid
	left outer join LOCATION loc5 on sh_stop5.location_gid = loc5.location_gid
	left outer join LOCATION loc6 on sh_stop6.location_gid = loc6.location_gid
	left outer join LOCATION loc7 on sh_stop7.location_gid = loc7.location_gid
	left outer join LOCATION loc8 on sh_stop8.location_gid = loc8.location_gid
	left outer join LOCATION loc9 on sh_stop9.location_gid = loc9.location_gid
	left outer join LOCATION loc10 on sh_stop10.location_gid = loc10.location_gid
	left outer join LOCATION loc11 on sh_stop11.location_gid = loc11.location_gid
	left outer join LOCATION loc12 on sh_stop12.location_gid = loc12.location_gid
	left outer join LOCATION loc13 on sh_stop13.location_gid = loc13.location_gid
	left outer join LOCATION loc14 on sh_stop14.location_gid = loc14.location_gid
	left outer join LOCATION loc15 on sh_stop15.location_gid = loc15.location_gid



	left outer join APPOINTMENT app1 on app1.object_gid=sh_stop1.shipment_gid and app1.stop_num=sh_stop1.stop_num
	left outer join APPOINTMENT app2 on app2.object_gid=sh_stop2.shipment_gid and app2.stop_num=sh_stop2.stop_num
	left outer join APPOINTMENT app3 on app3.object_gid=sh_stop3.shipment_gid and app3.stop_num=sh_stop3.stop_num
	left outer join APPOINTMENT app4 on app4.object_gid=sh_stop4.shipment_gid and app4.stop_num=sh_stop4.stop_num
	left outer join APPOINTMENT app5 on app5.object_gid=sh_stop5.shipment_gid and app5.stop_num=sh_stop5.stop_num
	left outer join APPOINTMENT app6 on app6.object_gid=sh_stop6.shipment_gid and app6.stop_num=sh_stop6.stop_num
	left outer join APPOINTMENT app7 on app7.object_gid=sh_stop7.shipment_gid and app7.stop_num=sh_stop7.stop_num
	left outer join APPOINTMENT app8 on app8.object_gid=sh_stop8.shipment_gid and app8.stop_num=sh_stop8.stop_num
	left outer join APPOINTMENT app9 on app9.object_gid=sh_stop9.shipment_gid and app9.stop_num=sh_stop9.stop_num
	left outer join APPOINTMENT app10 on app10.object_gid=sh_stop10.shipment_gid and app10.stop_num=sh_stop10.stop_num
	left outer join APPOINTMENT app11 on app11.object_gid=sh_stop11.shipment_gid and app11.stop_num=sh_stop11.stop_num
	left outer join APPOINTMENT app12 on app12.object_gid=sh_stop12.shipment_gid and app12.stop_num=sh_stop12.stop_num
	left outer join APPOINTMENT app13 on app13.object_gid=sh_stop13.shipment_gid and app13.stop_num=sh_stop13.stop_num
	left outer join APPOINTMENT app14 on app14.object_gid=sh_stop14.shipment_gid and app14.stop_num=sh_stop14.stop_num
	left outer join APPOINTMENT app15 on app15.object_gid=sh_stop15.shipment_gid and app15.stop_num=sh_stop15.stop_num


	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1 on sh_stop_ref1.shipment_gid = sh_stop1.shipment_gid and sh_stop1.stop_num = sh_stop_ref1.stop_num and sh_stop_ref1.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop1.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref11 on sh_stop_ref11.shipment_gid = sh_stop1.shipment_gid and sh_stop1.stop_num = sh_stop_ref11.stop_num and sh_stop_ref11.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop1.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref2 on sh_stop_ref2.shipment_gid = sh_stop2.shipment_gid and sh_stop2.stop_num = sh_stop_ref2.stop_num and sh_stop_ref2.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop2.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref22 on sh_stop_ref22.shipment_gid = sh_stop2.shipment_gid and sh_stop2.stop_num = sh_stop_ref22.stop_num and sh_stop_ref22.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop2.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref3 on sh_stop_ref3.shipment_gid = sh_stop3.shipment_gid and sh_stop3.stop_num = sh_stop_ref3.stop_num and sh_stop_ref3.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop3.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref33 on sh_stop_ref33.shipment_gid = sh_stop3.shipment_gid and sh_stop3.stop_num = sh_stop_ref33.stop_num and sh_stop_ref33.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop3.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref4 on sh_stop_ref4.shipment_gid = sh_stop4.shipment_gid and sh_stop4.stop_num = sh_stop_ref4.stop_num and sh_stop_ref4.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop4.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref44 on sh_stop_ref44.shipment_gid = sh_stop4.shipment_gid and sh_stop4.stop_num = sh_stop_ref44.stop_num and sh_stop_ref44.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop4.stop_type='D'


	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref5 on sh_stop_ref5.shipment_gid = sh_stop5.shipment_gid and sh_stop5.stop_num = sh_stop_ref5.stop_num and sh_stop_ref5.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop5.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref55 on sh_stop_ref55.shipment_gid = sh_stop5.shipment_gid and sh_stop5.stop_num = sh_stop_ref55.stop_num and sh_stop_ref55.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop5.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref6 on sh_stop_ref6.shipment_gid = sh_stop6.shipment_gid and sh_stop6.stop_num = sh_stop_ref6.stop_num and sh_stop_ref6.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop6.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref66 on sh_stop_ref66.shipment_gid = sh_stop6.shipment_gid and sh_stop6.stop_num = sh_stop_ref66.stop_num and sh_stop_ref66.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop6.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref7 on sh_stop_ref7.shipment_gid = sh_stop7.shipment_gid and sh_stop7.stop_num = sh_stop_ref7.stop_num and sh_stop_ref7.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop7.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref77 on sh_stop_ref77.shipment_gid = sh_stop7.shipment_gid and sh_stop7.stop_num = sh_stop_ref77.stop_num and sh_stop_ref77.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop7.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref8 on sh_stop_ref8.shipment_gid = sh_stop8.shipment_gid and sh_stop8.stop_num = sh_stop_ref8.stop_num and sh_stop_ref8.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop8.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref88 on sh_stop_ref88.shipment_gid = sh_stop8.shipment_gid and sh_stop8.stop_num = sh_stop_ref88.stop_num and sh_stop_ref88.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop8.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref9 on sh_stop_ref9.shipment_gid = sh_stop9.shipment_gid and sh_stop9.stop_num = sh_stop_ref9.stop_num and sh_stop_ref9.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop9.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref99 on sh_stop_ref99.shipment_gid = sh_stop9.shipment_gid and sh_stop9.stop_num = sh_stop_ref99.stop_num and sh_stop_ref99.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop9.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref10 on sh_stop_ref10.shipment_gid = sh_stop10.shipment_gid and sh_stop10.stop_num = sh_stop_ref10.stop_num and sh_stop_ref10.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop10.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1010 on sh_stop_ref1010.shipment_gid = sh_stop10.shipment_gid and sh_stop10.stop_num = sh_stop_ref1010.stop_num and sh_stop_ref1010.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop10.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref11 on sh_stop_ref11.shipment_gid = sh_stop11.shipment_gid and sh_stop11.stop_num = sh_stop_ref11.stop_num and sh_stop_ref11.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop11.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1111 on sh_stop_ref1111.shipment_gid = sh_stop11.shipment_gid and sh_stop11.stop_num = sh_stop_ref1111.stop_num and sh_stop_ref1111.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop11.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref12 on sh_stop_ref12.shipment_gid = sh_stop12.shipment_gid and sh_stop12.stop_num = sh_stop_ref12.stop_num and sh_stop_ref12.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop12.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1212 on sh_stop_ref1212.shipment_gid = sh_stop12.shipment_gid and sh_stop12.stop_num = sh_stop_ref1212.stop_num and sh_stop_ref1212.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop12.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref13 on sh_stop_ref13.shipment_gid = sh_stop13.shipment_gid and sh_stop13.stop_num = sh_stop_ref13.stop_num and sh_stop_ref13.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop13.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1313 on sh_stop_ref1313.shipment_gid = sh_stop13.shipment_gid and sh_stop13.stop_num = sh_stop_ref1313.stop_num and sh_stop_ref1313.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop13.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref14 on sh_stop_ref14.shipment_gid = sh_stop14.shipment_gid and sh_stop14.stop_num = sh_stop_ref14.stop_num and sh_stop_ref14.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop14.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1414 on sh_stop_ref1414.shipment_gid = sh_stop14.shipment_gid and sh_stop14.stop_num = sh_stop_ref1414.stop_num and sh_stop_ref1414.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop14.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref15 on sh_stop_ref15.shipment_gid = sh_stop15.shipment_gid and sh_stop15.stop_num = sh_stop_ref15.stop_num and sh_stop_ref15.shipment_stop_refnum_qual_gid='ULE.ULE_PO_NUMBER' --and sh_stop15.stop_type='D'
	left outer join SHIPMENT_STOP_REFNUM sh_stop_ref1515 on sh_stop_ref1515.shipment_gid = sh_stop15.shipment_gid and sh_stop15.stop_num = sh_stop_ref1515.stop_num and sh_stop_ref1515.shipment_stop_refnum_qual_gid='ULE.ULE_DN_NUMBER' --and sh_stop15.stop_type='D'

	left outer join location_remark loc_rek1 on loc_rek1.location_gid = sh_stop1.location_gid and loc_rek1.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek11 on loc_rek11.CONTACT_GID = sh_stop1.location_gid


	left outer join location_remark loc_rek2 on loc_rek2.location_gid = sh_stop2.location_gid and loc_rek2.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek22 on loc_rek22.CONTACT_GID = sh_stop2.location_gid


	left outer join location_remark loc_rek3 on loc_rek3.location_gid = sh_stop3.location_gid and loc_rek3.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek33 on loc_rek33.CONTACT_GID = sh_stop3.location_gid


	left outer join location_remark loc_rek4 on loc_rek4.location_gid = sh_stop4.location_gid and loc_rek4.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek44 on loc_rek44.CONTACT_GID = sh_stop4.location_gid


	left outer join location_remark loc_rek5 on loc_rek5.location_gid = sh_stop5.location_gid and loc_rek5.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek55 on loc_rek55.CONTACT_GID = sh_stop5.location_gid
	left outer join location_remark loc_rek6 on loc_rek6.location_gid = sh_stop6.location_gid and loc_rek6.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek66 on loc_rek66.CONTACT_GID = sh_stop6.location_gid
	left outer join location_remark loc_rek7 on loc_rek7.location_gid = sh_stop7.location_gid and loc_rek7.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek77 on loc_rek77.CONTACT_GID = sh_stop7.location_gid
	left outer join location_remark loc_rek8 on loc_rek8.location_gid = sh_stop8.location_gid and loc_rek8.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek88 on loc_rek88.CONTACT_GID = sh_stop8.location_gid
	left outer join location_remark loc_rek9 on loc_rek9.location_gid = sh_stop9.location_gid and loc_rek9.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek99 on loc_rek99.CONTACT_GID = sh_stop9.location_gid
	left outer join location_remark loc_rek10 on loc_rek10.location_gid = sh_stop10.location_gid and loc_rek10.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1010 on loc_rek1010.CONTACT_GID = sh_stop10.location_gid
	left outer join location_remark loc_rek11 on loc_rek11.location_gid = sh_stop11.location_gid and loc_rek11.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1111 on loc_rek1111.CONTACT_GID = sh_stop11.location_gid
	left outer join location_remark loc_rek12 on loc_rek12.location_gid = sh_stop12.location_gid and loc_rek12.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1212 on loc_rek1212.CONTACT_GID = sh_stop12.location_gid
	left outer join location_remark loc_rek13 on loc_rek13.location_gid = sh_stop13.location_gid and loc_rek13.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1313 on loc_rek1313.CONTACT_GID = sh_stop13.location_gid
	left outer join location_remark loc_rek14 on loc_rek14.location_gid = sh_stop14.location_gid and loc_rek14.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1414 on loc_rek1414.CONTACT_GID = sh_stop14.location_gid
	left outer join location_remark loc_rek15 on loc_rek15.location_gid = sh_stop15.location_gid and loc_rek15.remark_qual_gid IN ('ULE.ULE_BULK_HEALTH_SAFETY_RULES','ULE.ULE_HEALTH_SAFETY_RULES')
	left outer join contact loc_rek1515 on loc_rek1515.CONTACT_GID = sh_stop15.location_gid


	left outer join LOCATION_ADDRESS loc_add_1 on sh_stop1.location_gid = loc_add_1.LOCATION_GID and loc_add_1.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_2 on sh_stop2.location_gid = loc_add_2.LOCATION_GID and loc_add_2.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_3 on sh_stop3.location_gid = loc_add_3.LOCATION_GID and loc_add_3.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_4 on sh_stop4.location_gid = loc_add_4.LOCATION_GID and loc_add_4.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_5 on sh_stop5.location_gid = loc_add_5.LOCATION_GID and loc_add_5.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_6 on sh_stop6.location_gid = loc_add_6.LOCATION_GID and loc_add_6.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_7 on sh_stop7.location_gid = loc_add_7.LOCATION_GID and loc_add_7.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_8 on sh_stop8.location_gid = loc_add_8.LOCATION_GID and loc_add_8.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_9 on sh_stop9.location_gid = loc_add_9.LOCATION_GID and loc_add_9.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_10 on sh_stop10.location_gid = loc_add_10.LOCATION_GID and loc_add_10.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_11 on sh_stop11.location_gid = loc_add_11.LOCATION_GID and loc_add_11.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_12 on sh_stop12.location_gid = loc_add_12.LOCATION_GID and loc_add_12.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_13 on sh_stop13.location_gid = loc_add_13.LOCATION_GID and loc_add_13.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_14 on sh_stop14.location_gid = loc_add_14.LOCATION_GID and loc_add_14.LINE_SEQUENCE=1
	left outer join LOCATION_ADDRESS loc_add_15 on sh_stop15.location_gid = loc_add_15.LOCATION_GID and loc_add_15.LINE_SEQUENCE=1






	LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES1 ON (LOC_RES1.LOCATION_RESOURCE_GID = app1.LOCATION_RESOURCE_GID)
	LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES2 ON (LOC_RES2.LOCATION_RESOURCE_GID = app2.LOCATION_RESOURCE_GID)
	LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES3 ON (LOC_RES3.LOCATION_RESOURCE_GID = app3.LOCATION_RESOURCE_GID)
	LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES4 ON (LOC_RES4.LOCATION_RESOURCE_GID = app4.LOCATION_RESOURCE_GID)
	LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES5 ON (LOC_RES5.LOCATION_RESOURCE_GID = app5.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES6 ON (LOC_RES6.LOCATION_RESOURCE_GID = app6.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES7 ON (LOC_RES7.LOCATION_RESOURCE_GID = app7.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES8 ON (LOC_RES8.LOCATION_RESOURCE_GID = app8.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES9 ON (LOC_RES9.LOCATION_RESOURCE_GID = app9.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES10 ON (LOC_RES10.LOCATION_RESOURCE_GID = app10.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES11 ON (LOC_RES11.LOCATION_RESOURCE_GID = app11.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES12 ON (LOC_RES12.LOCATION_RESOURCE_GID = app12.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES13 ON (LOC_RES13.LOCATION_RESOURCE_GID = app13.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES14 ON (LOC_RES14.LOCATION_RESOURCE_GID = app14.LOCATION_RESOURCE_GID)
LEFT OUTER JOIN LOCATION_RESOURCE LOC_RES15 ON (LOC_RES15.LOCATION_RESOURCE_GID = app15.LOCATION_RESOURCE_GID)








   
  where rownum <501
  AND sh.shipment_gid = NVL(:P_SH_ID,SH.SHIPMENT_GID)
  AND SH.START_TIME BETWEEN NVL(TO_DATE(:P_DATE_FROM,:P_DATE_TIME_FORMAT),SH.START_TIME) AND NVL(TO_DATE(:P_DATE_TO,:P_DATE_TIME_FORMAT),SH.START_TIME)
  AND SH.SOURCE_LOCATION_GID = NVL(:P_SOURCE_LOC,SH.SOURCE_LOCATION_GID)
  AND SH.SERVPROV_GID = NVL(:P_SERVPROV_ID,SH.SERVPROV_GID)
  
  --sh srart time, source location, carrier id
  
  
