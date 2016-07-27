SELECT distinct
		' '																		Numer_Trasy,
		--NVL(MH_TABLE.eru_sum,'0') SHIPMENT_ESTIMATED_PFS,
		--MH_TABLE.mh1, 
		--NVL(MH1_TABLE.eru1,'0') ORDER_RELEASE_ESTIMATED_PFS,
		nvl(rpt_general.f_remove_domain(sh.shipment_gid),'n/a')					Shipment_ID,    
		rpt_general.f_remove_domain(orls.order_release_gid)						Order_Release_ID,    
		nvl(( SELECT or_ref_1.ORDER_RELEASE_REFNUM_VALUE
			  FROM ORDER_RELEASE_REFNUM or_ref_1
			  WHERE orls.ORDER_RELEASE_GID = or_ref_1.ORDER_RELEASE_GID
			  AND or_ref_1.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_SHIPPING_CONDITION'),
			'n/a')																Shipping_Condition,
		dest_loc.location_xid													Destination_Location_ID,
		CONVERT(dest_loc.LOCATION_NAME,'US7ASCII','AL32UTF8')					Destination_Location_Name,    
		CONVERT(dest_loc.CITY,'US7ASCII','AL32UTF8')							Destination_City,
		/*1-14-2015*/
		CONVERT(dest_loc.COUNTRY_CODE3_GID,'US7ASCII','AL32UTF8')				Country_Code,
		/*1-14-2015*/
		nvl(( SELECT adr.address_line
			  FROM location_address adr
			  WHERE dest_loc.location_gid = adr.location_gid),
		    'n/a')																Address_line,  -- Jaffa_W1 Reqt
		case
			when to_char(From_tz(cast(orls.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT')
									AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI')
				is null
				then 'n/a'
			else nvl(to_char(From_tz(cast(orls.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT')
										AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI'),'n/a')
/* START OF DELETE by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
				 --||' '
				 --||source_loc.TIME_ZONE_GID
/* END OF DELETE by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
		end																		Early_Delivery_Date,        
		case
			when to_char(From_tz(cast(orls.LATE_DELIVERY_DATE AS TIMESTAMP), 'GMT')
							AT TIME ZONE source_loc.time_zone_gid,'DD.MM.YYYY HH24:MI')
				is null
				then 'n/a'
			else nvl(to_char(From_tz(cast(orls.LATE_DELIVERY_DATE AS TIMESTAMP),'GMT')
								AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI'),
							 'n/a')
/* START OF DELETE by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
				 --||' '
				 --||source_loc.TIME_ZONE_GID
/* END OF DELETE by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
		end																		Late_Delivery_Date,
/* START OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
/*		nvl(( SELECT or_ref_3.ORDER_RELEASE_REFNUM_VALUE
			  FROM ORDER_RELEASE_REFNUM or_ref_3
			  WHERE orls.ORDER_RELEASE_GID = or_ref_3.ORDER_RELEASE_GID
			--AND or_ref_3.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS'),'n/a') Order_Release_Original_PFS,
			  AND or_ref_3.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_ESTIMATED_PFS'),
			'n/a')																ORDER_RELEASE_ESTIMATED_PFS,  -- Jaffa_W1 Reqt

		nvl(( SELECT sh_ref_2.SHIPMENT_REFNUM_VALUE
			  FROM shipment_refnum sh_ref_2
			  WHERE sh.shipment_gid = sh_ref_2.shipment_gid
			--AND sh_ref_2.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_ORIGINAL_PFS'),'n/a') Shipment_Original_PFS,    
			--AND sh_ref_2.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_UPDATED_ESTIMATED_PFS'),'n/a') SHIPMENT_UPDATED_ESTIMATED_PFS,    -- Jaffa_W1 Reqt
			  AND sh_ref_2.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_ESTIMATED_PFS'),
			'n/a')																SHIPMENT_ESTIMATED_PFS,*/
		RTRIM(
			LTRIM(
				TO_CHAR(
					(nvl(
						   (SELECT or_ref_3.order_release_refnum_value
							FROM order_release_refnum or_ref_3
							WHERE orls.order_release_gid = or_ref_3.order_release_gid
							AND or_ref_3.order_release_refnum_qual_gid = 'ULE.ULE_ESTIMATED_PFS'),
						'n/a')),
					'999999999D99',
					'NLS_NUMERIC_CHARACTERS = '', '''))) 						ORDER_RELEASE_ESTIMATED_PFS,
		RTRIM(
			LTRIM(
				TO_CHAR(
					(nvl(
						   (SELECT sh_ref_2.shipment_refnum_value
							FROM shipment_refnum sh_ref_2
							WHERE sh.shipment_gid = sh_ref_2.shipment_gid
							AND sh_ref_2.shipment_refnum_qual_gid = 'ULE.ULE_ESTIMATED_PFS'),
						'n/a')),
					'999999999D99',
					'NLS_NUMERIC_CHARACTERS = '', '''))) 						SHIPMENT_ESTIMATED_PFS,
/* END OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */			
		--TAG_1_SUM.TAG_SUM SHIPMENT_UPDATED_ESTIMATED_PFS, --added 0804
		orls.TOTAL_PACKAGING_UNIT_COUNT											Package_Count,        
		nvl(( SELECT to_char(sum(shu_temp.PACKAGING_UNIT_COUNT),
								'999999999D99',
								'NLS_NUMERIC_CHARACTERS = '', ''')
			  FROM SHIP_UNIT sh_unit_tmp_1,
				   SHIP_UNIT_LINE shu_temp
			  WHERE orls.ORDER_RELEASE_GID = sh_unit_tmp_1.ORDER_RELEASE_GID
			  AND sh_unit_tmp_1.SHIP_UNIT_GID  = shu_temp.SHIP_UNIT_GID
			  AND sh_unit_tmp_1.TRANSPORT_HANDLING_UNIT_GID like '%ULE_%_MIXED%'),
			'n/a')																Mixed_Cases,        
		ltrim(to_char( orls.TOTAL_WEIGHT_BASE*0.45359237,
					   '999999999D99',
					   'NLS_NUMERIC_CHARACTERS = '', '''))
		||' '
		||'KG'																	Order_Gross_Weight,
		nvl(( SELECT or_ref_2.ORDER_RELEASE_REFNUM_VALUE
			  FROM ORDER_RELEASE_REFNUM or_ref_2
			  WHERE orls.ORDER_RELEASE_GID = or_ref_2.ORDER_RELEASE_GID
			  AND or_ref_2.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MTO'),
			'n/a')																MTO,
		( SELECT
			case
				when to_char(From_tz(cast(ss_2.PLANNED_ARRIVAL AS TIMESTAMP), 'GMT')
							 AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI')
					is null then 'n/a'
				else to_char(From_tz(cast(ss_2.PLANNED_ARRIVAL AS TIMESTAMP), 'GMT')
							 AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI')
							 ||' '
							 ||source_loc.TIME_ZONE_GID
			end     
		  FROM shipment_stop ss_2
		  WHERE ss_2.SHIPMENT_GID = sh.SHIPMENT_GID
		  AND ss_2.STOP_NUM = 1
		  AND ss_2.STOP_TYPE = 'P')												Planned_Arrival,
		( SELECT case
					when to_char(From_tz(cast(ss_1.APPOINTMENT_PICKUP AS TIMESTAMP), 'GMT')
								 AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI')
						is null
						then 'n/a'
					else to_char(From_tz(cast(ss_1.APPOINTMENT_PICKUP AS TIMESTAMP), 'GMT')
					             AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI')
								 ||' '
								 ||source_loc.TIME_ZONE_GID
				end     
		  FROM shipment_stop ss_1
		  WHERE ss_1.SHIPMENT_GID = sh.SHIPMENT_GID
		  AND ss_1.STOP_NUM = 1
		  AND ss_1.STOP_TYPE = 'P') 											Loading_Date_Time,
		carrier_loc.location_xid 												Service_Provider_ID,
		nvl(( SELECT sh_ref_1.SHIPMENT_REFNUM_VALUE
			  FROM shipment_refnum sh_ref_1
			  WHERE sh.shipment_gid = sh_ref_1.shipment_gid
			  AND sh_ref_1.SHIPMENT_REFNUM_QUAL_GID = 'ULE.TRUCK PLATE'),
			'n/a')																Truck_Plate,    
		CONVERT(nvl(( SELECT listagg(or_rem_1.REMARK_TEXT,'; ')
						WITHIN GROUP (ORDER BY or_rem_1.REMARK_TEXT)
					  FROM ORDER_RELEASE_REMARK or_rem_1
					  WHERE orls.ORDER_RELEASE_GID = or_rem_1.ORDER_RELEASE_GID
					  AND or_rem_1.REMARK_QUAL_GID = 'ULE.ULE_DELIVERY_TEXT'),
					'n/a'),'US7ASCII','AL32UTF8')								Delivery_Text,    
		CONVERT(nvl(( SELECT listagg(or_rem_2.REMARK_TEXT,'; ')
						WITHIN GROUP (ORDER BY or_rem_2.REMARK_TEXT)
					  FROM ORDER_RELEASE_REMARK or_rem_2
					  WHERE orls.ORDER_RELEASE_GID = or_rem_2.ORDER_RELEASE_GID
					  AND or_rem_2.REMARK_QUAL_GID = 'ULE.ULE_DRIVER_INSTRUCTIONS'),
					'n/a'),'US7ASCII','AL32UTF8')								Driver_Instructions,            
		CONVERT(nvl(( SELECT listagg(or_rem_3.REMARK_TEXT,'; ')
						WITHIN GROUP (ORDER BY or_rem_3.REMARK_TEXT)
					  FROM ORDER_RELEASE_REMARK or_rem_3
					  WHERE orls.ORDER_RELEASE_GID = or_rem_3.ORDER_RELEASE_GID
					  AND or_rem_3.REMARK_QUAL_GID = 'ULE.ULE_SHIPPING_INSTRUCTIONS'),
					'n/a'),'US7ASCII','AL32UTF8')								Shipping_Instructions,                
		ss.STOP_NUM 															Drop_Sequence,
		nvl(( SELECT to_char(sum(sh_unit_tmp_2.SHIP_UNIT_COUNT),
								'999999999D99',
								'NLS_NUMERIC_CHARACTERS = '', ''')
			  FROM SHIP_UNIT sh_unit_tmp_2
			  WHERE orls.ORDER_RELEASE_GID = sh_unit_tmp_2.ORDER_RELEASE_GID
			  AND sh_unit_tmp_2.TRANSPORT_HANDLING_UNIT_GID like '%ULE_%_MIXED%'),
			'n/a')																Mixed_Pallets,
		( SELECT listagg(PROD_CAT_TMP.PROD_CAT_VAL_TMP,'; ')
					WITHIN GROUP (ORDER BY PROD_CAT_TMP.PROD_CAT_VAL_TMP)
		  FROM ( SELECT DISTINCT iref_cat.ITEM_REFNUM_VALUE PROD_CAT_VAL_TMP,
								su_cat.ORDER_RELEASE_GID PROD_CAT_ORLS_TMP
				 FROM 			SHIP_UNIT su_cat,
								SHIP_UNIT_LINE sul_cat,
								ORDER_RELEASE_LINE orl_cat,
								PACKAGED_ITEM pi_cat,
								ITEM i_cat,
								ITEM_REFNUM iref_cat        
				 WHERE 			su_cat.SHIP_UNIT_GID  = sul_cat.SHIP_UNIT_GID
				 AND sul_cat.ORDER_RELEASE_LINE_GID = orl_cat.ORDER_RELEASE_LINE_GID
				 AND orl_cat.PACKAGED_ITEM_GID = pi_cat.PACKAGED_ITEM_GID
				 AND pi_cat.ITEM_GID = i_cat.ITEM_GID
				 AND i_cat.ITEM_GID = iref_cat.ITEM_GID
				 AND ITEM_REFNUM_QUAL_GID = 'ULE.ULE_MATERIAL_CATEGORY')
					PROD_CAT_TMP
		  WHERE PROD_CAT_TMP.PROD_CAT_ORLS_TMP = orls.ORDER_RELEASE_GID) 		Product_Category,        
		nvl(( SELECT dest_loc_ref.LOCATION_REFNUM_VALUE
			  FROM LOCATION_REFNUM dest_loc_ref
			  WHERE dest_loc.LOCATION_GID = dest_loc_ref.LOCATION_GID
			  AND dest_loc_ref.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_LOADPLAN_PALLET')
			,'n/a') 															Pallet_Type,        
		CONVERT(nvl(( SELECT listagg(dest_loc_addr.ADDRESS_LINE,'; ')
						WITHIN GROUP (ORDER BY dest_loc_addr.ADDRESS_LINE)
					  FROM LOCATION_ADDRESS dest_loc_addr
					  WHERE dest_loc.LOCATION_GID = dest_loc_addr.LOCATION_GID),'n/a'),
				'US7ASCII','AL32UTF8')                       Destination_Address,
		--||', '														--fix INC000095512111
		--||dest_loc.POSTAL_CODE										--fix INC000095512111
		--||', '														--fix INC000095512111
		--||CONVERT(dest_loc.CITY,'US7ASCII','AL32UTF8')			Destination_Address,    --fix INC000095512111        
		case
			when lpad(rpt_general.f_remove_domain(orls.order_release_gid),3) = '290'
				Then 'YES'
			else 'NO'
		end																		Returns_Flag,                
		CONVERT(nvl(( SELECT listagg(or_rem_4.REMARK_TEXT,';')
						WITHIN GROUP (ORDER BY or_rem_4.REMARK_TEXT)
					  FROM ORDER_RELEASE_REMARK or_rem_4
					  WHERE orls.ORDER_RELEASE_GID = or_rem_4.ORDER_RELEASE_GID
					  AND or_rem_4.REMARK_QUAL_GID = 'ADD_INFOS'),
				'n/a'),'US7ASCII','AL32UTF8')									Add_Infos,            
		source_loc.location_xid													Source_Location_ID,
		CONVERT(source_loc.LOCATION_NAME,'US7ASCII','AL32UTF8')					Source_Location_Name,
		nvl(( SELECT or_ref_4.ORDER_RELEASE_REFNUM_VALUE
			  FROM ORDER_RELEASE_REFNUM or_ref_4
			  WHERE orls.ORDER_RELEASE_GID = or_ref_4.ORDER_RELEASE_GID
			  AND or_ref_4.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.CUSTOMER ORDER NO')
			,'n/a')																CUSTOMER_ORDER_NO,
/* START OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
		--dest_loc.postal_code													Postal_code, --  French Column
		''''||dest_loc.postal_code||''''										Postal_code,
/* END OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
		carrier_loc.location_name												Service_Provider_Name, --  French Column
/* START OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */
		--to_char(sh.insert_date,:P_DATE_FORMAT)								S_INSERT_DATE,-- German
		--to_char(sh.insert_date, :P_TIME_FORMAT) 								S_INSERT_TIME,-- German
		--to_char(orls.insert_date,:P_DATE_FORMAT) 								O_INSERT_DATE,-- German
		--to_char(orls.insert_date,:P_TIME_FORMAT) 								O_INSERT_TIME,-- German
		--Shipment
		CASE
			WHEN TO_CHAR(FROM_TZ(CAST(sh.insert_date AS TIMESTAMP), 'GMT')
							AT TIME ZONE depVendorLoc.time_zone_gid,'DD.MM.YYYY')
				IS NULL
				THEN 'n/a'
			ELSE NVL(TO_CHAR(FROM_TZ(CAST(sh.insert_date AS TIMESTAMP),'GMT')
								AT TIME ZONE depVendorLoc.time_zone_gid, 'DD.MM.YYYY'),
							 'n/a')
		END																		S_INSERT_DATE,
		CASE
			WHEN TO_CHAR(FROM_TZ(CAST(sh.insert_date AS TIMESTAMP), 'GMT')
							AT TIME ZONE depVendorLoc.time_zone_gid,'HH24:MI')
					IS NULL
					THEN 'n/a'
			ELSE NVL(TO_CHAR(FROM_TZ(CAST(sh.insert_date AS TIMESTAMP),'GMT')
								AT TIME ZONE depVendorLoc.time_zone_gid, 'HH24:MI'),
							 'n/a')
		END																		S_INSERT_TIME,
		--Order Release
		CASE
			WHEN TO_CHAR(FROM_TZ(CAST(orls.insert_date AS TIMESTAMP), 'GMT')
							AT TIME ZONE source_loc.time_zone_gid,'DD.MM.YYYY')
				IS NULL
				THEN 'n/a'
			ELSE NVL(TO_CHAR(FROM_TZ(CAST(orls.insert_date AS TIMESTAMP),'GMT')
								AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY'),
							 'n/a')
		END																		O_INSERT_DATE,
		CASE
			WHEN TO_CHAR(FROM_TZ(CAST(orls.insert_date AS TIMESTAMP), 'GMT')
							AT TIME ZONE source_loc.time_zone_gid,'HH24:MI')
				IS NULL
				THEN 'n/a'
			ELSE NVL(TO_CHAR(FROM_TZ(CAST(orls.insert_date AS TIMESTAMP),'GMT')
								AT TIME ZONE source_loc.time_zone_gid, 'HH24:MI'),
							 'n/a')
		END																		O_INSERT_TIME,
/* END OF MODIFY by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 18/MAR/2015 */		
		NVL(( SELECT OR_REF_5.ORDER_RELEASE_REFNUM_VALUE
			  FROM ORDER_RELEASE_REFNUM OR_REF_5 
			  WHERE OR_REF_5.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID 
			  AND ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STANDARD'),
			'N/A')																ULE_STANDARD, -- Added for Switzerland
			
		nvl(( SELECT or_org.order_release_refnum_value
			  FROM ORDER_RELEASE_REFNUM or_org
			  WHERE or_org.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
			  AND or_org.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_SALES_ORG')
			,'n/a')																ORG,
		la.address_line															Destination_Street,
		ltrim( to_char( orls.TOTAL_WEIGHT_BASE*0.45359237,
						'999999999D99',
						'NLS_NUMERIC_CHARACTERS = '', '''))						Order_Gross_Weight_1,-- German
		'KG'	 																Order_Gross_Weight_2,-- German
		case
			when lpad(rpt_general.f_remove_domain(orls.order_release_gid),3) = '290'
				Then 'oui'
			else 'non'
		end 																	Returns_Flag_French,
/* START OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */
		NVL(( SELECT   or_ref_1.order_release_refnum_value
			  FROM   order_release_refnum or_ref_1
			  WHERE   orls.order_release_gid = or_ref_1.order_release_gid
			  AND or_ref_1.order_release_refnum_qual_gid = 'ULE.ULE_DG_ORDER')
			 ,'n/a')															hazardous,
		sh.shipment_type_gid													shipmentType,
		-- Shipment Departure Vendor Address Details
		depVendorLoc.location_xid												departure_VendorSH,
		depVendorLoc.country_code3_gid											departure_CountryCodeSH,
		depVendorLoc.location_name												departure_LocationNameSH,
		''''||depVendorLoc.postal_code||''''									departure_PostalCodeSH,
		depVendorLoc.city														departure_CitySH,
		depVendorAdd.address_line												departure_StreetSH,
		-- Shipment Destination Vendor Address Details
		desVendorLoc.location_xid												destination_VendorSH,
		desVendorLoc.country_code3_gid											destination_CountryCodeSH,
		desVendorLoc.location_name												destination_LocationNameSH,
		''''||desVendorLoc.postal_code||''''									destination_PostalCodeSH,
		desVendorLoc.city														destination_CitySH,
		desVendorAdd.address_line												destination_StreetSH,
		-- Swiss Source Vendor Requirements
		''''||source_loc.postal_code||''''										source_PostalCodeOR,
		source_loc.city															source_CityOR,
		sourceAdd.address_line													source_StreetOR
/* END OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */
FROM 	SHIPMENT_STOP ss,      
		shipment sh,
		shipment_stop_d ssd,
		s_ship_unit ssu,
		s_ship_unit_line ssul,
		order_release orls,
		ORDER_RELEASE_REFNUM or_ref,
		location source_loc,
		location dest_loc,
		location carrier_loc,
		location_address la,
/* START OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */
		location depVendorLoc,
		location_address depVendorAdd,
		location desVendorLoc,
		location_address desVendorAdd,
		location_address sourceAdd
/* END OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */	

WHERE 	orls.ORDER_RELEASE_TYPE_GID = 'SALES_ORDER'    
AND 	ss.shipment_gid = sh.shipment_gid
AND 	sh.DOMAIN_NAME = 'ULE/PR'
AND 	orls.DOMAIN_NAME = 'ULE'
AND 	ssd.SHIPMENT_GID = ss.SHIPMENT_GID
AND 	ssd.stop_num = ss.stop_num
AND 	ssd.S_SHIP_UNIT_GID = ssu.S_SHIP_UNIT_GID
AND 	ssu.S_SHIP_UNIT_GID = ssul.S_SHIP_UNIT_GID
AND 	ssul.order_release_gid = orls.order_release_gid
AND 	or_ref.ORDER_RELEASE_GID = orls.ORDER_RELEASE_GID
AND 	or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
AND 	or_ref.ORDER_RELEASE_REFNUM_VALUE = 'SECONDARY'      
AND 	la.location_gid (+) = dest_loc.location_gid
AND 	source_loc.LOCATION_GID = orls.SOURCE_LOCATION_GID 
AND 	dest_loc.LOCATION_GID = orls.DEST_LOCATION_GID
/* START OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */
AND		sourceAdd.location_gid (+) = source_loc.location_gid
AND 	depVendorAdd.location_gid (+) = depVendorLoc.location_gid
AND 	depVendorLoc.location_gid = sh.source_location_gid
AND 	desVendorAdd.location_gid (+) = desVendorLoc.location_gid
AND 	desVendorLoc.location_gid = sh.dest_location_gid
/* END OF INSERT by Melvin Luis, CR035 - W1_German  Swiss Load Plan, 07/MAR/2015 */	
AND 	sh.SERVPROV_GID = carrier_loc.location_gid
AND 	','||nvl(:P_SHIPMENT_ID,SH.SHIPMENT_XID)||',' LIKE '%,'||SH.SHIPMENT_XID||',%'
AND 	','||nvl(:P_ORDER_RELEASE_ID,orls.ORDER_RELEASE_XID)||',' LIKE '%,'||orls.ORDER_RELEASE_XID||',%'
AND 	cast(( From_tz(cast( orls.EARLY_DELIVERY_DATE AS TIMESTAMP),
						    'GMT')
			   AT TIME ZONE source_loc.time_zone_gid) as date) >=
				CASE
					WHEN :EARLY_DELIVERY_TIME_FROM IS NULL
						THEN CAST((From_tz( cast( ORLS.EARLY_DELIVERY_DATE AS TIMESTAMP),
											  'GMT') AT TIME ZONE source_loc.time_zone_gid) as date)
					ELSE to_date(:EARLY_DELIVERY_TIME_FROM,:P_DATE_TIME_FORMAT)
				 END
AND		cast((From_tz(cast( orls.EARLY_DELIVERY_DATE AS TIMESTAMP),
							'GMT')
				AT TIME ZONE source_loc.time_zone_gid) as date) <= 
					CASE
						WHEN :EARLY_DELIVERY_TIME_TO IS NULL
							THEN CAST((From_tz(cast( ORLS.EARLY_DELIVERY_DATE AS TIMESTAMP),
													 'GMT') AT TIME ZONE source_loc.time_zone_gid) as date)
						ELSE to_date(:EARLY_DELIVERY_TIME_TO,:P_DATE_TIME_FORMAT)
					END
AND 	(source_loc.location_gid = :SOURCE_LOCATION_ID OR dest_loc.location_gid = :SOURCE_LOCATION_ID)
AND 	((sh.SERVPROV_GID = nvl(:SERVICE_PROVIDER_ID, sh.SERVPROV_GID)) OR (sh.SERVPROV_GID is null))
AND 	','||nvl(:BULK_PLAN_ID,rpt_general.f_remove_domain(sh.BULK_PLAN_GID))||',' LIKE '%,'||rpt_general.f_remove_domain(sh.BULK_PLAN_GID)||',%'
AND 	ss.STOP_TYPE = 'D'
AND 	1 = CASE
				WHEN :SOURCE_LOCATION_ID IS NOT NULL AND :EARLY_DELIVERY_TIME_FROM IS NOT NULL AND :EARLY_DELIVERY_TIME_TO IS NOT NULL THEN 1
				WHEN :BULK_PLAN_ID IS NOT NULL THEN 1
				WHEN :P_SHIPMENT_ID IS NOT NULL THEN 1
				WHEN :P_ORDER_RELEASE_ID IS NOT NULL THEN 1
				ELSE 0
			END        
Order By nvl(rpt_general.f_remove_domain(sh.shipment_gid),'n/a') asc, ss.STOP_NUM asc