select FUNCTIONAL_REGION,
SOURCE_LOC,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
substr(end_time_day,1,7),
to_char(sum(Number_of_Shipments),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Number_of_Shipments,
to_char(sum(Total_Number_of_PFS),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Number_of_PFS,
to_char(sum(Total_Weight_Normalized),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Weight_Normalized,
to_char(sum(Total_Ord_Cost_B_EUR),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_B_EUR,
to_char(sum(Total_Ord_Cost_Base_EUR),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_Base_EUR,
WEIGHT_LANE






from
(



select
(case 
   
    
when sh.SERVPROV_GID = 'ULE.T3001314' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214507' then 'Y'
when sh.SERVPROV_GID = 'ULE.T3001314' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214500' then 'Y'
when sh.SERVPROV_GID = 'ULE.T3001314' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214513' then 'Y'
when sh.SERVPROV_GID = 'ULE.T3001314' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T222098' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T222098' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214511' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1124797' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214512' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1124797' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1095551' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1103190' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T200185' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214503' then 'Y'
when sh.SERVPROV_GID = 'ULE.T200185' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214502' then 'Y'
when sh.SERVPROV_GID = 'ULE.T200185' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316414' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1108691' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1108691' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231617' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1108691' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231617' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231113' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1108691' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231113' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231589' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316539' then 'Y'
when sh.SERVPROV_GID = 'ULE.T230846' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1116776' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T230493' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T50418328' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1083634' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T4305032' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214477' then 'Y'
when sh.SERVPROV_GID = 'ULE.T200747' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214473' then 'Y'
when sh.SERVPROV_GID = 'ULE.T200689' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214476' then 'Y'
when sh.SERVPROV_GID = 'ULE.T222098' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V214500' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225421' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231617' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225421' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231113' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225421' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316539' then 'Y'
when sh.SERVPROV_GID = 'ULE.T231589' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316540' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1119521' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V316540' then 'Y'
when sh.SERVPROV_GID = 'ULE.T423047' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V225412' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1044945' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1086569' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1044945' and ord_rel.SOURCE_LOCATION_GID = 'ULE.V1086570' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1095551' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V214500' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1013275' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V1086569' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1013275' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V1086570' then 'Y'
when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207479' then 'Y'
when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207487' then 'Y'
when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207483' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T800998' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207493' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T187585' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207493' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T423047' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T320427' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1043592' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T328653' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1055094' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1071630' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1108761' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207480' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T423047' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T320427' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1043592' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T328653' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1055094' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1071630' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
-- when sh.SERVPROV_GID = 'ULE.T1108761' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207503' then 'Y'
when sh.SERVPROV_GID = 'ULE.T46583' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T27184' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T423047' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T187585' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T320427' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1043592' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T44674' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1083634' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1055094' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T800998' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1071630' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T1108761' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T5562' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207484' then 'Y'
when sh.SERVPROV_GID = 'ULE.T44674' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207481' then 'Y'
when sh.SERVPROV_GID = 'ULE.T5562' and ord_rel.SOURCE_LOCATION_GID= 'ULE.V207481' then 'Y'      
  ELSE 'N'
  END) as WEIGHT_LANE,
  
  
 sh_ref1.shipment_refnum_value																																				FUNCTIONAL_REGION,
		
		
		
		
ord_rel.SOURCE_LOCATION_GID as SOURCE_LOC,

ord_pic_loc.LOCATION_NAME as Pickup_Location_Name,

ord_pic_loc.CITY as Pickup_City,

ord_pic_loc.COUNTRY_CODE3_GID as Pickup_Country,

to_char(sh.end_time,'YYYY/MM/DD') as End_Time_Day,

count(distinct sh.shipment_gid)  as Number_of_Shipments,

round(sum(case when LENGTH(TRIM(TRANSLATE(ord_rel_pfs.order_release_refnum_value, ' +-.0123456789',' '))) is not null then '0'
else ord_rel_pfs.order_release_refnum_value end),2) as Total_Number_of_PFS,


round(sum(CASE
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'LB' THEN ord_rel.TOTAL_WEIGHT*0.45359237
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'MTON' THEN ord_rel.TOTAL_WEIGHT*1000
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'TON' THEN ord_rel.TOTAL_WEIGHT*1000
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'GRM' THEN ord_rel.TOTAL_WEIGHT/1000
 ELSE ord_rel.TOTAL_WEIGHT
END),2) as Total_Weight_Normalized,


sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and (al_ord_rel_d1.accessorial_code_gid is null or rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid) IN ('ULE_MYTO','ULE_TOLL','ULE_FTL FREIGHT COST CORRECTION','ULE_BONUS_MALUS','ULE_LTL FREIGHT COSTS CORRECTION','HAZARDOUS','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_FREIGHT COST BASIC FTL','ULE_TANK_CHASSIS HIRE','ULE_FTL FREIGHT COST CORRECTION','ULE_LTL FREIGHT COSTS CORRECTION','ULE_FREIGHT COST BASIC FTL','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_BONUS_MALUS','ULE_TOLL'))
group by al_ord_rel_d1.order_release_gid),2),0))as Total_Ord_Cost_Base_EUR,

sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID = 'B' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and (al_ord_rel_d1.accessorial_code_gid is null or rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid) IN ('ULE_MYTO','ULE_TOLL','ULE_FTL FREIGHT COST CORRECTION','ULE_BONUS_MALUS','ULE_LTL FREIGHT COSTS CORRECTION','HAZARDOUS','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_FREIGHT COST BASIC FTL','ULE_TANK_CHASSIS HIRE','ULE_FTL FREIGHT COST CORRECTION','ULE_LTL FREIGHT COSTS CORRECTION','ULE_FREIGHT COST BASIC FTL','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_BONUS_MALUS','ULE_TOLL'))
group by al_ord_rel_d1.order_release_gid),2),0))as Total_Ord_Cost_B_EUR


FROM
SHIPMENT sh
  join LOCATION tsp_loc on sh.servprov_gid = tsp_loc.location_gid
 left outer join SHIPMENT_REFNUM  sh_ref1 on sh.shipment_gid = sh_ref1.shipment_gid and sh_ref1.shipment_refnum_qual_gid='ULE.ULE_FUNCTIONAL_REGION'
  join ORDER_MOVEMENT ord_mov on sh.shipment_gid = ord_mov.shipment_gid
  join ORDER_RELEASE ord_rel on ord_mov.order_release_gid = ord_rel.order_release_gid
 left outer join ORDER_RELEASE_REFNUM ord_rel_pfs on ord_rel.order_release_gid = ord_rel_pfs.order_release_gid and ord_rel_pfs.order_release_refnum_qual_gid='ULE.ULE_ORIGINAL_PFS'
 join LOCATION ord_pic_loc on ord_rel.source_location_gid = ord_pic_loc.location_gid
  join LOCATION ord_del_loc on ord_rel.dest_location_gid = ord_del_loc.location_gid
WHERE
sh.END_TIME >= to_date(:P_DATE_FROM,:P_DATE_TIME_FORMAT)
AND sh.END_TIME <= to_date(:P_DATE_TO,:P_DATE_TIME_FORMAT)
-- sh.END_TIME >= To_Date('2015-01-01','yyyy-mm-dd')
-- and sh.END_TIME <= To_Date('2015-08-31','yyyy-mm-dd')
and
case when sh.SHIPMENT_TYPE_GID ='TRANSPORT' then 1 else 0 end =1
and
case when sh.domain_name='ULE/SE' or exists (select 1
  from SHIPMENT_REFNUM sh_ref1
  where sh_ref1.shipment_refnum_qual_gid='ULE.ULE_SHIPMENT_STREAM' and sh_ref1.shipment_refnum_value='SECONDARY' and sh.shipment_gid = sh_ref1.shipment_gid) then 1 else 0 end =1
  
  group by
sh.SERVPROV_GID,
ord_rel.SOURCE_LOCATION_GID ,
ord_pic_loc.LOCATION_NAME ,
ord_pic_loc.CITY ,
ord_pic_loc.COUNTRY_CODE3_GID,
 sh_ref1.shipment_refnum_value,
to_char(sh.end_time,'YYYY/MM/DD'))

group by 
SOURCE_LOC,
WEIGHT_LANE,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
FUNCTIONAL_REGION,
substr(end_time_day,1,7)