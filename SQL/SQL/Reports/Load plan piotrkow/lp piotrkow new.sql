SELECT DISTINCT
  ' ' Numer_Trasy,
  rpt_general.f_remove_domain(orls.order_release_gid) Order_Release_ID,
  NVL(rpt_general.f_remove_domain(sh.shipment_gid),'n/a') Shipment_ID,
	ss.stop_num																					stop_num,
  SUBSTR(dest_loc.location_xid,2) 																Destination_Location_ID,
  CONVERT(dest_loc.LOCATION_NAME,'US7ASCII','AL32UTF8') 										Destination_Location_Name,
  CONVERT(dest_loc.CITY,'US7ASCII','AL32UTF8') 													Destination_City,
  (
    SELECT
      CASE
        WHEN TO_CHAR(From_tz(CAST(ss_2.PLANNED_ARRIVAL AS TIMESTAMP), 'GMT') AT
          TIME ZONE source_loc.time_zone_gid, 'YYYY-MM-DD') IS NULL
        THEN 'n/a'
        ELSE TO_CHAR(From_tz(CAST(ss_2.PLANNED_ARRIVAL AS TIMESTAMP), 'GMT') AT
          TIME ZONE source_loc.time_zone_gid, 'YYYY-MM-DD')
          END
    FROM
      shipment_stop ss_2
    WHERE
      ss_2.SHIPMENT_GID = sh.SHIPMENT_GID
    AND ss_2.STOP_NUM   = 1
    AND ss_2.STOP_TYPE  = 'P'
  )
																									Planned_Arrival,
  CASE
    WHEN TO_CHAR(From_tz(CAST(orls.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT
      TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI') IS NULL
    THEN 'n/a'
    ELSE NVL(TO_CHAR(From_tz(CAST(orls.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT'
      ) AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI'),'n/a')
      END 																						Early_Delivery_Date,
  CASE
    WHEN TO_CHAR(From_tz(CAST(orls.LATE_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT
      TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI') IS NULL
    THEN 'n/a'
    ELSE NVL(TO_CHAR(From_tz(CAST(orls.LATE_DELIVERY_DATE AS TIMESTAMP), 'GMT')
      AT TIME ZONE source_loc.time_zone_gid, 'DD.MM.YYYY HH24:MI'),'n/a')
      END 																						Late_Delivery_Date,
	  CONVERT(NVL(
  (
    SELECT
      listagg(or_rem_1.REMARK_TEXT,'; ') WITHIN GROUP (
    ORDER BY
      or_rem_1.REMARK_TEXT)
    FROM
      ORDER_RELEASE_REMARK or_rem_1
    WHERE
      orls.ORDER_RELEASE_GID     = or_rem_1.ORDER_RELEASE_GID
    AND or_rem_1.REMARK_QUAL_GID = 'ULE.ULE_DELIVERY_TEXT'
  )
  ,'n/a'),'US7ASCII','AL32UTF8') 																	Delivery_Text
  ,RTRIM( LTRIM( NVL(
  (
    SELECT
      TO_CHAR(REPLACE(or_ref_3.order_release_refnum_value,',','.'),
      '999999999D99', 'NLS_NUMERIC_CHARACTERS = '', ''')
    FROM
      order_release_refnum or_ref_3
    WHERE
      orls.order_release_gid                   = or_ref_3.order_release_gid
    AND or_ref_3.order_release_refnum_qual_gid = 'ULE.ULE_ESTIMATED_PFS'
  )
  , 'n/a'))) 																						ORDER_RELEASE_ESTIMATED_PFS,
  orls.TOTAL_PACKAGING_UNIT_COUNT 																Package_Count,
  NVL(
  (
    /*SELECT
      TO_CHAR(SUM(shu_temp.PACKAGING_UNIT_COUNT),'999999999D99',
      'NLS_NUMERIC_CHARACTERS = '', ''')
    FROM
      SHIP_UNIT sh_unit_tmp_1,
      SHIP_UNIT_LINE shu_temp
    WHERE
      orls.ORDER_RELEASE_GID        = sh_unit_tmp_1.ORDER_RELEASE_GID
    AND sh_unit_tmp_1.SHIP_UNIT_GID = shu_temp.SHIP_UNIT_GID
    AND sh_unit_tmp_1.TRANSPORT_HANDLING_UNIT_GID LIKE '%ULE_%_MIXED%' */

	/* New Logic as per CR069 */
	SELECT OR_REF.ORDER_RELEASE_REFNUM_VALUE
  FROM ORDER_RELEASE_REFNUM OR_REF
  WHERE OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
  AND OR_REF.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_MIXED_CASES_VALUE'

  )
  ,'n/a') 																							Mixed_Cases,
  ltrim(TO_CHAR(orls.TOTAL_WEIGHT_BASE*0.45359237,'999999999D99',
  'NLS_NUMERIC_CHARACTERS = '', '''))
  ||' '
  ||'KG' 																							Order_Gross_Weight,

  /*added for CEE Retrofit*/
  RTRIM( LTRIM( NVL(
  (
    SELECT
      TO_CHAR(REPLACE(sh_ref_2.shipment_refnum_value,',','.'), '999999999D99',
      'NLS_NUMERIC_CHARACTERS = '', ''')
    FROM
      shipment_refnum sh_ref_2
    WHERE
      sh.shipment_gid                     = sh_ref_2.shipment_gid
    AND sh_ref_2.shipment_refnum_qual_gid = 'ULE.ULE_ESTIMATED_PFS'
  )
  , 'n/a'))) SHIPMENT_ESTIMATED_PFS,
  '' 																		miej_pal_rab
  ,''																		prop_godz
  ,''																		czas_zaladunku
  ,''																		ilosc_miejsc_pal
  ,''																		data_kompletacji
  ,''																		godz_zak_kompl
  ,''																		data_zgloszenia_kier
  ,''																		godz_zglo_kier
  ,''																		data_rozp_zal
  ,''																		godz_rozp_zal
  ,''																		data_zak_zal
  ,''																		godz_zak_zal,
  carrier_loc.location_xid Service_Provider_ID,
  carrier_loc.location_name Service_Provider_Name
  ,''																		nr_rej_sam
  ,''																		dzien
  ,''																		godz
  ,''																		dzien2
  ,''																		godzina2
  ,CONVERT(NVL(
  (
    SELECT
      listagg(or_rem_3.REMARK_TEXT,'; ') WITHIN GROUP (
    ORDER BY
      or_rem_3.REMARK_TEXT)
    FROM
      ORDER_RELEASE_REMARK or_rem_3
    WHERE
      orls.ORDER_RELEASE_GID     = or_rem_3.ORDER_RELEASE_GID
    AND or_rem_3.REMARK_QUAL_GID = 'ULE.ULE_SHIPPING_INSTRUCTIONS'
  )
  ,'n/a'),'US7ASCII','AL32UTF8') 												Shipping_Instructions,
  (
    SELECT
      listagg(PROD_CAT_TMP.PROD_CAT_VAL_TMP,'; ') WITHIN GROUP (
    ORDER BY
      PROD_CAT_TMP.PROD_CAT_VAL_TMP)
    FROM
      (
        SELECT DISTINCT
          iref_cat.ITEM_REFNUM_VALUE PROD_CAT_VAL_TMP,
          su_cat.ORDER_RELEASE_GID PROD_CAT_ORLS_TMP
        FROM
          SHIP_UNIT su_cat,
          SHIP_UNIT_LINE sul_cat,
          ORDER_RELEASE_LINE orl_cat,
          PACKAGED_ITEM pi_cat,
          ITEM i_cat,
          ITEM_REFNUM iref_cat
        WHERE
          su_cat.SHIP_UNIT_GID             = sul_cat.SHIP_UNIT_GID
        AND sul_cat.ORDER_RELEASE_LINE_GID = orl_cat.ORDER_RELEASE_LINE_GID
        AND orl_cat.PACKAGED_ITEM_GID      = pi_cat.PACKAGED_ITEM_GID
        AND pi_cat.ITEM_GID                = i_cat.ITEM_GID
        AND i_cat.ITEM_GID                 = iref_cat.ITEM_GID
        AND ITEM_REFNUM_QUAL_GID           = 'ULE.ULE_MATERIAL_CATEGORY'
      )
      PROD_CAT_TMP
    WHERE
      PROD_CAT_TMP.PROD_CAT_ORLS_TMP = orls.ORDER_RELEASE_GID
  )																				Product_Category,
  (SELECT OR_REF.ORDER_RELEASE_REFNUM_VALUE
  FROM ORDER_RELEASE_REFNUM OR_REF
  WHERE OR_REF.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID
  AND OR_REF.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_DELIVERY_WINDOW'


  )																				DELIVERY_WINDOW
  ,NVL(
  (
    SELECT
      or_ref_4.ORDER_RELEASE_REFNUM_VALUE
    FROM
      ORDER_RELEASE_REFNUM or_ref_4
    WHERE
      orls.ORDER_RELEASE_GID                   = or_ref_4.ORDER_RELEASE_GID
    AND or_ref_4.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.CUSTOMER ORDER NO'
  )
  ,'n/a') 																	CUSTOMER_ORDER_NO,
  -- to_char(SS.PLANNED_ARRIVAL - 2/24,'YYYY-MM-DD HH24:MI')				najp_godz_wyjazdu
  (
    SELECT
      CASE
        WHEN TO_CHAR(From_tz(CAST(ss_2.PLANNED_ARRIVAL - 2/24 AS TIMESTAMP), 'GMT') AT
          TIME ZONE source_loc.time_zone_gid, 'YYYY-MM-DD HH24:MI') IS NULL
        THEN 'n/a'
        ELSE TO_CHAR(From_tz(CAST(ss_2.PLANNED_ARRIVAL - 2/24 AS TIMESTAMP), 'GMT') AT
          TIME ZONE source_loc.time_zone_gid, 'YYYY-MM-DD HH24:MI')
          END
    FROM
      shipment_stop ss_2
    WHERE
      ss_2.SHIPMENT_GID = sh.SHIPMENT_GID
    AND ss_2.STOP_NUM   = 1
    AND ss_2.STOP_TYPE  = 'P'
  )																						najp_godz_wyjazdu



  ,(SELECT sh_ref.shipment_refnum_value
  FROM shipment_refnum sh_ref
  WHERE sh_ref.shipment_refnum_qual_gid = 'ULE.ULE_LIMITED_QUANTITY_WEIGHT'
  AND sh_ref.shipment_gid = sh.shipment_gid

  )																								SHIPMENT_ADR_KG
  ,(SELECT loc_ref.location_refnum_value
  FROM location_refnum loc_ref
  WHERE loc_ref.location_gid = orls.dest_location_gid
  AND loc_ref.location_refnum_qual_gid = 'ULE.ULE_LOCATION_INFORMATION'

  )																									ADDITIONAL_LOC_INFO
   ,''                                                                       as send
  ,''																		as IN_FILE
  ,''																		as Przyczyna_rezerwacji



FROM
  SHIPMENT_STOP ss,
  shipment sh,
  order_movement om,
  -- shipment_stop_d ssd,
  -- s_ship_unit ssu,
  -- s_ship_unit_line ssul,
  order_release orls,
  ORDER_RELEASE_REFNUM or_ref,
  location source_loc,
  location dest_loc,
  location carrier_loc
WHERE
--  orls.ORDER_RELEASE_TYPE_GID            = 'SALES_ORDER'
 ss.shipment_gid                      = sh.shipment_gid
AND sh.DOMAIN_NAME                       = 'ULE/PR'
AND orls.DOMAIN_NAME                     = 'ULE'

-- AND ssd.SHIPMENT_GID                     = ss.SHIPMENT_GID
-- AND ssd.stop_num                         = ss.stop_num
-- AND ssd.S_SHIP_UNIT_GID                  = ssu.S_SHIP_UNIT_GID
-- AND ssu.S_SHIP_UNIT_GID                  = ssul.S_SHIP_UNIT_GID
-- AND ssul.order_release_gid               = orls.order_release_gid
 AND OM.SHIPMENT_GID = SH.SHIPMENT_GID
 AND OM.ORDER_RELEASE_GID = ORLS.ORDER_RELEASE_GID

AND or_ref.ORDER_RELEASE_GID             = orls.ORDER_RELEASE_GID
AND or_ref.ORDER_RELEASE_REFNUM_QUAL_GID = 'ULE.ULE_STREAM'
AND or_ref.ORDER_RELEASE_REFNUM_VALUE    = 'SECONDARY'
AND source_loc.LOCATION_GID              = orls.SOURCE_LOCATION_GID
AND source_loc.LOCATION_GID <>'ULE.V447382'
AND dest_loc.LOCATION_GID                = orls.DEST_LOCATION_GID
AND sh.SERVPROV_GID                      = carrier_loc.location_gid
--AND SS.LOCATION_GID = ORLS.DEST_LOCATION_GID
--AND sh.shipment_gid = 'ULE/PR.102090361'

--AND ','
--  ||NVL(:P_SHIPMENT_ID,SH.SHIPMENT_XID)
--  ||',' LIKE '%,'
--  ||SH.SHIPMENT_XID
--  ||',%'
--AND ','
--  ||NVL(:P_ORDER_RELEASE_ID,orls.ORDER_RELEASE_XID)
--  ||',' LIKE '%,'
--  ||orls.ORDER_RELEASE_XID
--  ||',%'

--AND CAST(( From_tz(CAST( orls.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT TIME
--  ZONE source_loc.time_zone_gid) AS DATE) >=
--  CASE
--    WHEN :EARLY_DELIVERY_TIME_FROM IS NULL
--    THEN CAST((From_tz( CAST( ORLS.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT
--      TIME ZONE source_loc.time_zone_gid) AS DATE)
--    ELSE to_date(:EARLY_DELIVERY_TIME_FROM,:P_DATE_TIME_FORMAT)
--  END
--AND CAST((From_tz(CAST( orls.EARLY_DELIVERY_DATE AS TIMESTAMP),'GMT') AT TIME
--  ZONE source_loc.time_zone_gid) AS DATE) <=
--  CASE
--    WHEN :EARLY_DELIVERY_TIME_TO IS NULL
--    THEN CAST((From_tz(CAST( ORLS.EARLY_DELIVERY_DATE AS TIMESTAMP), 'GMT') AT
--      TIME ZONE source_loc.time_zone_gid) AS DATE)
--    ELSE to_date(:EARLY_DELIVERY_TIME_TO,:P_DATE_TIME_FORMAT)
--  END
--AND
--  (
--    source_loc.location_gid = :SOURCE_LOCATION_ID
--  OR dest_loc.location_gid  = :SOURCE_LOCATION_ID
--  )
--AND
--  (
--    (
--      sh.SERVPROV_GID = NVL(:SERVICE_PROVIDER_ID, sh.SERVPROV_GID)
--    )
--  OR
--    (
--      sh.SERVPROV_GID IS NULL
--    )
--  )
--AND ','
--  ||NVL(:BULK_PLAN_ID,rpt_general.f_remove_domain(sh.BULK_PLAN_GID))
--  ||',' LIKE '%,'
--  ||rpt_general.f_remove_domain(sh.BULK_PLAN_GID)
--  ||',%'
AND ss.STOP_TYPE = 'D'

--AND 1            =
--  CASE
--    WHEN :SOURCE_LOCATION_ID      IS NOT NULL
--    AND :EARLY_DELIVERY_TIME_FROM IS NOT NULL
--    AND :EARLY_DELIVERY_TIME_TO   IS NOT NULL
--    THEN 1
--    WHEN :BULK_PLAN_ID IS NOT NULL
--    THEN 1
--    WHEN :P_SHIPMENT_ID IS NOT NULL
--    THEN 1
--    WHEN :P_ORDER_RELEASE_ID IS NOT NULL
--    THEN 1
--    ELSE 0
--  END

AND SH.SHIPMENT_GID = 'ULE/PR.102125755'

ORDER BY 40 asc, NVL(rpt_general.f_remove_domain(sh.shipment_gid),'n/a'), ss.stop_num












