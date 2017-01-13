SELECT temp.source_location_gid
,temp.dest_location_gid
,temp.month
,temp.year
,count(temp.SHIPMENT_GID) as sh_number
FROM (
  SELECT
    sh.shipment_gid,
    sh.SERVPROV_GID                 servprov_id,
    sh.source_location_gid
    ,sh.dest_location_gid
    ,to_char(sh.START_TIME, 'YYYY')  year,
    to_char(sh.START_TIME, 'MM')    month,
    case when sh_ref_reg.SHIPMENT_REFNUM_VALUE = 'INBOUND' THEN loc_ref_d.LOCATION_REFNUM_VALUE else loc_ref_s.LOCATION_REFNUM_VALUE end as  category

  FROM SHIPMENT sh
    LEFT JOIN shipment_refnum sh_ref_reg ON (sh.SHIPMENT_GID = sh_ref_reg.SHIPMENT_GID AND
                                             sh_ref_reg.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION')
    , location loc_s
    LEFT JOIN LOCATION_REFNUM loc_ref_s
      ON (loc_ref_s.LOCATION_GID = loc_s.LOCATION_GID AND loc_ref_s.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY')
    , location loc_d
    LEFT JOIN LOCATION_REFNUM loc_ref_d
      ON (loc_ref_d.LOCATION_GID = loc_d.LOCATION_GID AND loc_ref_d.LOCATION_REFNUM_QUAL_GID = 'ULE.ULE_CATEGORY')

  WHERE loc_s.LOCATION_GID = sh.SOURCE_LOCATION_GID
        AND loc_d.LOCATION_GID = sh.DEST_LOCATION_GID
        and 'ICE CREAM' =
        CASE WHEN  sh_ref_reg.SHIPMENT_REFNUM_VALUE = 'INBOUND' THEN loc_ref_d.LOCATION_REFNUM_VALUE
        else loc_ref_s.LOCATION_REFNUM_VALUE end


        AND NOT EXISTS
  (SELECT
     /*+ FIRST_ROWS(1)*/ 1
   FROM shipment_refnum sh_ref_1
   WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
         AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
         AND sh_ref_1.shipment_gid = sh.shipment_gid)
        AND sh.START_TIME >= to_date('2015-01-01', 'YYYY-MM-DD')
         AND sh.START_TIME < to_date('2016-12-01', 'YYYY-MM-DD')
--        AND sh.START_TIME < to_date('2015-03-01', 'YYYY-MM-DD')
) TEMP

group by
temp.source_location_gid
,temp.dest_location_gid
,temp.month
,temp.year