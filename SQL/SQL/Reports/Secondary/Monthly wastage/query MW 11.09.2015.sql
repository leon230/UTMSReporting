select Functional_Region,
SOURCE_LOC,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
Pickup_Reporting_Name,
DEST_LOCATION_GID,
Delivery_Location_Name,
Delivery_City,
Delivery_Country,
Delivery_Location_Type,
Delivery_Reporting_Name,
TSP_ID,
TSP_Name,
trim(to_char(sum(to_char(Number_of_Shipments)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Number_of_Shipments,
trim(to_char(sum(to_char(Number_of_Orders)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Number_of_Orders,
trim(to_char(sum(TO_NUMBER(Total_Number_of_PFS,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Total_Number_of_PFS,
trim(to_char(sum(to_char(Calculated_Drops)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Calculated_Drops,
trim(to_char(sum(to_char(WEIGHT_DROPS)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS WEIGHT_DROPS,

(case 
   
  when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214507' then 'Y'
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214500' then 'Y'
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214513' then 'Y'
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V214511' then 'Y'
when tsp_id = 'ULE.T1124797' and source_loc = 'ULE.V214512' then 'Y'
when tsp_id = 'ULE.T1124797' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T1095551' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T1103190' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V214503' then 'Y'
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V214502' then 'Y'
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V316414' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V1108691' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V1108691' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V1108691' then 'Y'
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V1108691' then 'Y'
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T231589' and source_loc = 'ULE.V316539' then 'Y'
when tsp_id = 'ULE.T230846' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T1116776' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T230493' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T50418328' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T1083634' and source_loc = 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T4305032' and source_loc = 'ULE.V214477' then 'Y'
when tsp_id = 'ULE.T200747' and source_loc = 'ULE.V214473' then 'Y'
when tsp_id = 'ULE.T200689' and source_loc = 'ULE.V214476' then 'Y'
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V214500' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V225421' then 'Y'
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V225421' then 'Y'
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V225421' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V316539' then 'Y'
when tsp_id = 'ULE.T231589' and source_loc = 'ULE.V316540' then 'Y'
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V316540' then 'Y'
when tsp_id = 'ULE.T423047' and source_loc = 'ULE.V225412' then 'Y'
when tsp_id = 'ULE.T1044945' and source_loc = 'ULE.V1086569' then 'Y'
when tsp_id = 'ULE.T1044945' and source_loc = 'ULE.V1086570' then 'Y'
when tsp_id = 'ULE.T1095551' and source_loc= 'ULE.V214500' then 'Y'
when tsp_id = 'ULE.T1013275' and source_loc= 'ULE.V1086569' then 'Y'
when tsp_id = 'ULE.T1013275' and source_loc= 'ULE.V1086570' then 'Y'
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207479' then 'Y'
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207487' then 'Y'
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207483' then 'Y'
-- when tsp_id = 'ULE.T800998' and source_loc= 'ULE.V207493' then 'Y'
-- when tsp_id = 'ULE.T187585' and source_loc= 'ULE.V207493' then 'Y'
-- when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T328653' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207480' then 'Y'
-- when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T328653' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207503' then 'Y'
-- when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207503' then 'Y'
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T27184' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T187585' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T44674' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T1083634' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T800998' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T5562' and source_loc= 'ULE.V207484' then 'Y'
when tsp_id = 'ULE.T44674' and source_loc= 'ULE.V207481' then 'Y'
when tsp_id = 'ULE.T5562' and source_loc= 'ULE.V207481' then 'Y'
  ELSE 'N'
  END) as WEIGHT_LANE,

trim(to_char(sum(to_char(Total_Weight_Normalized)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Total_Weight_Normalized,
substr(end_time_day,1,7) as End_Time_Month,
Is_Return,
Is_Additional_DN,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_B_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_B_EUR,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_A_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_A_EUR,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_Base_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_Base_EUR,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_Access_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_Access_EUR,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_Waste_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_Waste_EUR,
trim(to_char(sum(to_NUMBER(Total_Ord_Cost_Fuel_EUR,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Total_Ord_Cost_Fuel_EUR,
Transport_Cancellation,
Shipment_Invoice_Ready,
trim(to_char(sum(to_NUMBER(Demurrage_Loading_Cost,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Demurrage_Loading_Cost,
trim(to_char(sum(to_NUMBER(Demurrage_Unloading_Cost,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Demurrage_Unloading_Cost,
trim(to_char(sum(to_NUMBER(Cancellation_Cost,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Cancellation_Cost,
trim(to_char(sum(to_NUMBER(Time_Window_Delivery,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Time_Window_Delivery,
trim(to_char(sum(to_NUMBER(Additional_Distance,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Additional_Distance,
trim(to_char(sum(to_NUMBER(City_Surcharge,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS City_Surcharge,
trim(to_char(sum(to_NUMBER(Bonus_Malus,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Bonus_Malus,
trim(to_char(sum(to_NUMBER(Weekend_Cost,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))AS Weekend_Cost,

trim(to_char(sum(to_NUMBER(REFUSAL_COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS REFUSAL_COST,
trim(to_char(sum(to_NUMBER(HANDLING_COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS HANDLING_COST,
trim(to_char(sum(to_NUMBER(SE_DRIVER_EXPRESS_DEL_COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS SE_DRIVER_EXPRESS_DEL_COST,
trim(to_char(sum(to_NUMBER(REDELIVERY_COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS REDELIVERY_COST,
trim(to_char(sum(to_NUMBER(DRIVERS_UNLOADING_COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS DRIVERS_UNLOADING_COST,


trim(to_char(sum(to_NUMBER(Other_Costs,'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''')) AS Other_Costs

from 
(
SELECT Functional_Region,
SOURCE_LOC,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
Pickup_Reporting_Name,
DEST_LOCATION_GID,
Delivery_Location_Name,
Delivery_City,
Delivery_Country,
Delivery_Location_Type,
Delivery_Reporting_Name,
TSP_ID,
TSP_Name,
Number_of_Shipments,
Number_of_Orders,
Total_Number_of_PFS,
Calculated_Drops,

ceil(SUM((case 
   
    
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214507' then Total_Weight_Normalized / 26000 
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214500' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V214513' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T3001314' and source_loc = 'ULE.V316414' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V316414' then Total_Weight_Normalized  /26000 
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V214511' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1124797' and source_loc = 'ULE.V214512' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1124797' and source_loc = 'ULE.V316414' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1095551' and source_loc = 'ULE.V316414' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1103190' and source_loc = 'ULE.V316414' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V214503' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V214502' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T200185' and source_loc = 'ULE.V316414' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V1108691' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V1108691' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V1108691' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V1108691' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T231589' and source_loc = 'ULE.V316539' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T230846' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1116776' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T230493' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T50418328' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1083634' and source_loc = 'ULE.V207484' then Total_Weight_Normalized /35000
when tsp_id = 'ULE.T4305032' and source_loc = 'ULE.V214477' then Total_Weight_Normalized /25000
when tsp_id = 'ULE.T200747' and source_loc = 'ULE.V214473' then Total_Weight_Normalized /25000
when tsp_id = 'ULE.T200689' and source_loc = 'ULE.V214476' then Total_Weight_Normalized /25000
when tsp_id = 'ULE.T222098' and source_loc = 'ULE.V214500' then Total_Weight_Normalized /26000 
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V225421' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T231617' and source_loc = 'ULE.V225421' then Total_Weight_Normalized /23500  
when tsp_id = 'ULE.T231113' and source_loc = 'ULE.V225421' then Total_Weight_Normalized /23500 
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V316539' then Total_Weight_Normalized /23500 
when tsp_id = 'ULE.T231589' and source_loc = 'ULE.V316540' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T1119521' and source_loc = 'ULE.V316540' then Total_Weight_Normalized /23500
when tsp_id = 'ULE.T423047' and source_loc = 'ULE.V225412' then Total_Weight_Normalized /26000 
when tsp_id = 'ULE.T1044945' and source_loc = 'ULE.V1086569' then Total_Weight_Normalized /24000 
when tsp_id = 'ULE.T1044945' and source_loc = 'ULE.V1086570' then Total_Weight_Normalized /24000 
when tsp_id = 'ULE.T1095551' and source_loc= 'ULE.V214500' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T1013275' and source_loc= 'ULE.V1086569' then Total_Weight_Normalized /28000
when tsp_id = 'ULE.T1013275' and source_loc= 'ULE.V1086570' then Total_Weight_Normalized /28000
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207479' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207487' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207483' then Total_Weight_Normalized /26000
-- when tsp_id = 'ULE.T800998' and source_loc= 'ULE.V207493' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T187585' and source_loc= 'ULE.V207493' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T328653' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207480' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T328653' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
-- when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207503' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T46583' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T27184' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T423047' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T187585' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T320427' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T1043592' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T44674' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T1083634' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T1055094' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T800998' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T1071630' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T1108761' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T5562' and source_loc= 'ULE.V207484' then Total_Weight_Normalized /32000
when tsp_id = 'ULE.T44674' and source_loc= 'ULE.V207481' then Total_Weight_Normalized /26000
when tsp_id = 'ULE.T5562' and source_loc= 'ULE.V207481' then Total_Weight_Normalized /26000
  ELSE 0
  END))) as WEIGHT_DROPS,

Total_Weight_Normalized,
end_time_day,
Is_Return,
Is_Additional_DN,
Total_Ord_Cost_B_EUR,
Total_Ord_Cost_A_EUR,
Total_Ord_Cost_Base_EUR,
Total_Ord_Cost_Access_EUR,
Total_Ord_Cost_Waste_EUR,
Total_Ord_Cost_Fuel_EUR,
Transport_Cancellation,
Shipment_Invoice_Ready,
Demurrage_Loading_Cost,
Demurrage_Unloading_Cost,
Cancellation_Cost,
Time_Window_Delivery,
Additional_Distance,
City_Surcharge,
Bonus_Malus,
Weekend_Cost,

REFUSAL_COST,
HANDLING_COST,
SE_DRIVER_EXPRESS_DEL_COST,
REDELIVERY_COST,
DRIVERS_UNLOADING_COST,
Other_Costs
from  

(
SELECT sh_ref1.SHIPMENT_REFNUM_VALUE as Functional_Region,
ord_rel.SOURCE_LOCATION_GID as SOURCE_LOC ,
ord_pic_loc.LOCATION_NAME as Pickup_Location_Name,
ord_pic_loc.CITY as Pickup_City,
ord_pic_loc.COUNTRY_CODE3_GID as Pickup_Country,
(select ord_pic_loc_ref.location_refnum_value
  from LOCATION_REFNUM ord_pic_loc_ref
  where ord_pic_loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE' and ord_rel.source_location_gid = ord_pic_loc_ref.location_gid and rownum = 1) as Pickup_Location_Type,
(select ord_pic_loc_ref.location_refnum_value
  from LOCATION_REFNUM ord_pic_loc_ref
  where ord_pic_loc_ref.location_refnum_qual_gid = 'ULE.ULE_REPORTING_NAME' and ord_rel.source_location_gid = ord_pic_loc_ref.location_gid and rownum = 1) as Pickup_Reporting_Name,
ord_rel.DEST_LOCATION_GID as DEST_LOCATION_GID,
ord_del_loc.LOCATION_NAME as Delivery_Location_Name,
ord_del_loc.CITY as Delivery_City,
ord_del_loc.COUNTRY_CODE3_GID as Delivery_Country,
(select ord_del_loc_ref.location_refnum_value
  from LOCATION_REFNUM ord_del_loc_ref
  where ord_del_loc_ref.location_refnum_qual_gid = 'LOCATION_TYPE' and ord_rel.dest_location_gid = ord_del_loc_ref.location_gid and rownum = 1) as Delivery_Location_Type,
(select ord_del_loc_ref.location_refnum_value
  from LOCATION_REFNUM ord_del_loc_ref
  where ord_del_loc_ref.location_refnum_qual_gid = 'ULE.ULE_REPORTING_NAME' and ord_rel.dest_location_gid = ord_del_loc_ref.location_gid and rownum = 1) as Delivery_Reporting_Name,
sh.SERVPROV_GID as TSP_ID,
tsp_loc.LOCATION_NAME as TSP_Name,
count(distinct sh.shipment_gid)  as Number_of_Shipments,
count(distinct ord_rel.order_release_gid)  as Number_of_Orders,

to_CHAR(round(sum(case when LENGTH(TRIM(TRANSLATE(ord_rel_pfs.order_release_refnum_value, ' +-.0123456789',' '))) is not null then '0'
else ord_rel_pfs.order_release_refnum_value end),2),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Number_of_PFS,

(
  ceil((to_char(round(sum
                  (case when 
                        LENGTH(TRIM(TRANSLATE(ord_rel_pfs.order_release_refnum_value, ' +-.0123456789',' '))) is not null then '0.0'
                   else 
                        ord_rel_pfs.order_release_refnum_value end),2)))/33) 
) AS Calculated_Drops ,

to_char(round(sum(CASE
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'LB' THEN ord_rel.TOTAL_WEIGHT*0.45359237
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'MTON' THEN ord_rel.TOTAL_WEIGHT*1000
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'TON' THEN ord_rel.TOTAL_WEIGHT*1000
 WHEN ord_rel.TOTAL_WEIGHT_UOM_CODE = 'GRM' THEN ord_rel.TOTAL_WEIGHT/1000
 ELSE ord_rel.TOTAL_WEIGHT
END),2),'999999999D99','NLS_NUMERIC_CHARACTERS = ''. ''') as Total_Weight_Normalized,
to_char(sh.end_time,'YYYY/MM/DD') as End_Time_Day,
case when substr(ord_rel.source_location_gid, 0, 7) = 'ULE.OTC' or substr(ord_rel.dest_location_gid, 0, 7) = 'ULE.OTC'  or exists (SELECT 1 FROM location_refnum loc_ref1 WHERE  loc_ref1.location_refnum_qual_gid = 'ULE.ULE_ONE_TIME_CUSTOMER' 
AND loc_ref1.location_gid IN (ord_rel.source_location_gid,ord_rel.dest_location_gid)) 
then 1 else 0 end as Is_One_Time_Customer,
case when substr(ord_rel.order_release_gid,0, 6) = 'ULE.29' or substr(ord_rel.order_release_gid,-2, 2)='_R' 
then 1 else 0 end as Is_Return,
case when substr(ord_rel.order_release_gid,-2, 2) = '_A'
then 1 else 0 end as Is_Additional_DN,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID = 'B' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_B_EUR,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID = 'A' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_A_EUR,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and (al_ord_rel_d1.accessorial_code_gid is null or rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid) IN ('ULE_MYTO','ULE_TOLL','ULE_FTL FREIGHT COST CORRECTION','ULE_BONUS_MALUS','ULE_LTL FREIGHT COSTS CORRECTION','HAZARDOUS','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_FREIGHT COST BASIC FTL','ULE_TANK_CHASSIS HIRE','ULE_FTL FREIGHT COST CORRECTION','ULE_LTL FREIGHT COSTS CORRECTION','ULE_FREIGHT COST BASIC FTL','ULE_FREIGHT COST BASIC LTL PER PALLET','ULE_BONUS_MALUS','ULE_TOLL'))
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_Base_EUR,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid) IN ('ULE_ADMINISTRATION FEE','ULE_PRE-BOOKING','ULE_OTHER','ULE_PALLET_REPLACEMENT','ULE_RESTACKING','ULE_CITY SURCHARGE','ULE_MULTISTOP','ULE_STORAGE COSTS','ULE_TERMINAL HANDLING COSTS','ULE_ADR TRUCK','ULE_QUANTITY_CHANGED','ULE_THERMO TRAILER FEE','ULE_INCREASED QUANTITY','ULE_CUSTOMS CLEARANCE','ULE_MINIMAL INVOICE','ULE_INVOICE FEE','ULE_LOSS OF BOOKING SLOT','ULE_DELIVERY AT NIGHT','ULE_AVISO FEE','ULE_ADDRESS CHANGE','ULE_MANUAL FREIGHT NOTE FEE','ULE_ADDITIONAL CLEANING REQUIRED','ULE_STORAGE COSTS','ULE_OTHER','ULE_HEATING COSTS','ULE_OVERWEIGHT SURCHARGE','ULE_DEMURRAGE AT CUSTOMS','ULE_DEMURRAGE AT TERMINAL','ULE_ADDRESS CHANGE','ULE_QUANTITY_CHANGED','ULE_TERMINAL HANDLING COSTS','ULE_INCREASED QUANTITY','ULE_MULTISTOP','ULE_EXCEED CAPACITY','ULE_NEW_LABEL_CREATION','ULE_CUSTOMS CLEARANCE','ULE_DELIVERY AT NIGHT','ULE_THERMO TRAILER FEE','ULE_TIME ZONE','ULE_DOCUMENTATION COST','ULE_ADMINISTRATION FEE','ULE_AVISO FEE','FSTEST','ULE_PRODUCTION_STOPPAGE_COST','ULE_REJECTED_LOAD_CHARGE')
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_Access_EUR,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid) IN ('ULE_DEMURRAGE UNLOADING COST','ULE_REFUSAL SHIPMENT CHARGES','ULE_TIME WINDOW DELIVERY','ULE_HANDLING','ULE_ADDITIONAL DISTANCE','ULE_SECOND DRIVER EXPRESS DELIVERY','ULE_REDELIVERY','ULE_WEEKEND COST','ULE_DRIVERS UNLOADING','ULE_DEMURRAGE LOADING COST','ULE_
COST','ULE_SEPARATE DELIVERY-CUSTOMER REQUIREMENT','ULE_DEMURRAGE UNLOADING COST','ULE_DEMURRAGE LOADING COST','ULE_CANCELLATION COST','ULE_ADDITIONAL DISTANCE','ULE_SECOND DRIVER EXPRESS DELIVERY','ULE_WEEKEND COST','ULE_REDELIVERY','ULE_DISPOSAL_COSTS','ULE_TIME WINDOW DELIVERY','ULE_HANDLING','ULE_REFUSAL SHIPMENT CHARGES','ULE_DRIVERS UNLOADING')
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_Waste_EUR,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and instr(al_ord_rel_d1.accessorial_code_gid,'FUEL')>0
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Total_Ord_Cost_Fuel_EUR,
(case when sh.domain_name='ULE/SE' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/SE.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/SE.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
when sh.domain_name='ULE/PR' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/PR.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/PR.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
when sh.domain_name='UGO' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='UGO.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='UGO.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
end ) as Transport_Cancellation,
case when sh.domain_name='ULE/SE' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.INVOICE_READY' and sh_stat1.status_value_gid='ULE/SE.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.INVOICE_READY' and sh_stat1.status_value_gid='ULE/SE.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end)
when sh.domain_name='ULE/PR' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.INVOICE_READY' and sh_stat1.status_value_gid='ULE/PR.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.INVOICE_READY' and sh_stat1.status_value_gid='ULE/PR.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end) 
when sh.domain_name='UGO' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.INVOICE_READY' and sh_stat1.status_value_gid='UGO.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.INVOICE_READY' and sh_stat1.status_value_gid='UGO.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end) 
end as Shipment_Invoice_Ready,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_DEMURRAGE LOADING COST'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Demurrage_Loading_Cost,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_DEMURRAGE UNLOADING COST'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Demurrage_Unloading_Cost,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_CANCELLATION COST'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Cancellation_Cost,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_TIME WINDOW DELIVERY'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Time_Window_Delivery,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_ADDITIONAL DISTANCE'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Additional_Distance,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_CITY SURCHARGE'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as City_Surcharge,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_BONUS_MALUS'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Bonus_Malus,
to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_WEEKEND COST'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Weekend_Cost,

to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_REFUSAL SHIPMENT CHARGES'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as REFUSAL_COST,


to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_HANDLING'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as HANDLING_COST,


to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_SECOND DRIVER EXPRESS DELIVERY'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as SE_DRIVER_EXPRESS_DEL_COST,


to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_REDELIVERY'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as REDELIVERY_COST,


to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_DRIVERS UNLOADING'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as DRIVERS_UNLOADING_COST,


to_char(sum(nvl(round((select sum(CASE
    WHEN al_ord_rel_d1.COST_CURRENCY_GID = 'EUR' THEN al_ord_rel_d1.COST
    ELSE al_ord_rel_d1.COST * UNILEVER.EBS_PROCEDURES_ULE.GET_QUARTERLY_EX_RATE(al_ord_rel_d1.INSERT_DATE,al_ord_rel_d1.COST_CURRENCY_GID,'EUR')
   END) from allocation_order_release_d al_ord_rel_d1
WHERE al_ord_rel_d1.COST_TYPE_GID <> 'O' and al_ord_rel_d1.order_release_gid = ord_rel.order_release_gid and rpt_general.f_remove_domain(al_ord_rel_d1.accessorial_code_gid)='ULE_OTHER'
group by al_ord_rel_d1.order_release_gid),2),0)),'999999999D99','NLS_NUMERIC_CHARACTERS = '', ''') as Other_Costs
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
-- sh.END_TIME >= To_Date('2015-05-01','yyyy-mm-dd') and
-- sh.END_TIME <= To_Date('2015-08-31','yyyy-mm-dd')
and
case when sh.SHIPMENT_TYPE_GID ='TRANSPORT' then 1 else 0 end =1
and
case when sh.domain_name='ULE/SE' or exists (select 1
  from SHIPMENT_REFNUM sh_ref1
  where sh_ref1.shipment_refnum_qual_gid='ULE.ULE_SHIPMENT_STREAM' and sh_ref1.shipment_refnum_value='SECONDARY' and sh.shipment_gid = sh_ref1.shipment_gid) then 1 else 0 end =1
GROUP BY

to_char(sh.end_time,'YYYY/MM/DD'),
sh.SERVPROV_GID,
tsp_loc.LOCATION_NAME,
(case when sh.domain_name='ULE/SE' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/SE.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/SE.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
when sh.domain_name='ULE/PR' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/PR.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='ULE/PR.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
when sh.domain_name='UGO' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='UGO.NOT CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Cancelled'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.TRANSPORT CANCELLATION' and sh_stat1.status_value_gid='UGO.CANCELLED' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Cancelled' 
      else 'Unknown'
    end) 
end ),
case when sh.domain_name='ULE/SE' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.INVOICE_READY' and sh_stat1.status_value_gid='ULE/SE.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/SE.INVOICE_READY' and sh_stat1.status_value_gid='ULE/SE.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end) 
when sh.domain_name='ULE/PR' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.INVOICE_READY' and sh_stat1.status_value_gid='ULE/PR.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='ULE/PR.INVOICE_READY' and sh_stat1.status_value_gid='ULE/PR.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end) 
when sh.domain_name='UGO' then
    (case 
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.INVOICE_READY' and sh_stat1.status_value_gid='UGO.INVOICE_NOT_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Not Ready'
      when exists(select 1 from SHIPMENT_STATUS sh_stat1 where sh_stat1.status_type_gid='UGO.INVOICE_READY' and sh_stat1.status_value_gid='UGO.INVOICE_READY' and sh.shipment_gid = sh_stat1.shipment_gid) then 'Ready' 
      else 'Unknown'
    end) 
end,
sh_ref1.SHIPMENT_REFNUM_VALUE,
ord_rel.SOURCE_LOCATION_GID,
ord_pic_loc.LOCATION_NAME,
ord_pic_loc.CITY,
ord_pic_loc.COUNTRY_CODE3_GID,
ord_rel.DEST_LOCATION_GID,
ord_del_loc.LOCATION_NAME,
ord_del_loc.CITY,
ord_del_loc.COUNTRY_CODE3_GID,
case when substr(ord_rel.source_location_gid, 0, 7) = 'ULE.OTC' or substr(ord_rel.dest_location_gid, 0, 7) = 'ULE.OTC'  or exists (SELECT 1 FROM location_refnum loc_ref1 WHERE  loc_ref1.location_refnum_qual_gid = 'ULE.ULE_ONE_TIME_CUSTOMER' 
AND loc_ref1.location_gid IN (ord_rel.source_location_gid,ord_rel.dest_location_gid)) 
then 1 else 0 end,
case when substr(ord_rel.order_release_gid,0, 6) = 'ULE.29' or substr(ord_rel.order_release_gid,-2, 2)='_R' 
then 1 else 0 end,
case when substr(ord_rel.order_release_gid,-2, 2) = '_A'
then 1 else 0 end)

group by
Functional_Region,
SOURCE_LOC,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
Pickup_Reporting_Name,
DEST_LOCATION_GID,
Delivery_Location_Name,
Delivery_City,
Delivery_Country,
Delivery_Location_Type,
Delivery_Reporting_Name,
TSP_ID,
TSP_Name,
Number_of_Shipments,
Number_of_Orders,
Total_Number_of_PFS,
Calculated_Drops,



Total_Weight_Normalized,
end_time_day,
Is_Return,
Is_Additional_DN,
Total_Ord_Cost_B_EUR,
Total_Ord_Cost_A_EUR,
Total_Ord_Cost_Base_EUR,
Total_Ord_Cost_Access_EUR,
Total_Ord_Cost_Waste_EUR,
Total_Ord_Cost_Fuel_EUR,
Transport_Cancellation,
Shipment_Invoice_Ready,
Demurrage_Loading_Cost,
Demurrage_Unloading_Cost,
Cancellation_Cost,
Time_Window_Delivery,
Additional_Distance,
City_Surcharge,
Bonus_Malus,
Weekend_Cost,

REFUSAL_COST,
HANDLING_COST,
SE_DRIVER_EXPRESS_DEL_COST,
REDELIVERY_COST,
DRIVERS_UNLOADING_COST,
Other_Costs)




group by
Functional_Region,
SOURCE_LOC,
Pickup_Location_Name,
Pickup_City,
Pickup_Country,
Pickup_Reporting_Name,
DEST_LOCATION_GID,
Delivery_Location_Name,
Delivery_City,
Delivery_Country,
Delivery_Location_Type,
Delivery_Reporting_Name,
TSP_ID,
TSP_Name,
substr(end_time_day,1,7),
Transport_Cancellation,
Shipment_Invoice_Ready,
Is_Return,
Is_Additional_DN