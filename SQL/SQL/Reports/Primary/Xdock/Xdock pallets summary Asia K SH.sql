select distinct temp.X_dock,
		temp.x_dock_name,
		temp.x_dock_city,
	    temp.LATE_DELIVERY_MONTH,
		temp.LATE_DELIVERY_WEEK,
		TEMP.TRANSPORT_HANDLING_UNIT_GID,
		sum(temp.pallets_in)									pallets_in,
		sum(temp.pallets_out)									pallets_out,
		sum(temp.pallets_in)+	sum(temp.pallets_out)						TOTAL_SHIP_UNIT_COUNT,
		count(temp.shipment_gid)							SH_count
		

from (
SELECT sh.shipment_gid,
	   om.order_release_gid,
		sh.SOURCE_LOCATION_GID,
		sh.DEST_LOCATION_GID,
		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end																								X_dock,
		(select loc.location_name
		from location loc
		where loc.location_gid =
		(case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end)
		)																														x_dock_name,
		(select loc.city
		from location loc
		where loc.location_gid =
		(case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		sh.SOURCE_LOCATION_GID
		else
		sh.dest_LOCATION_GID end)
		)																														x_dock_city,

		case when sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		su.SHIP_UNIT_COUNT
		else 0
		end as 														pallets_out,	
		case when sh.dest_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837') then
		su.SHIP_UNIT_COUNT
		else 0
		end as 														pallets_in,	
		SU.SHIP_UNIT_GID,
		SU.TRANSPORT_HANDLING_UNIT_GID,
		SU.SHIP_UNIT_COUNT,

		(SELECT LOC.LOCATION_NAME
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		SOURCE_LOC_NAME,
		(SELECT LOC.LOCATION_NAME
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		DEST_LOC_NAME,
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.SOURCE_LOCATION_GID)		SOURCE_LOC_CITY,
		(SELECT LOC.CITY
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = sh.DEST_LOCATION_GID)		DEST_LOC_CITY,
		TO_CHAR(sh.end_time,'MM') AS 				LATE_DELIVERY_MONTH,
		TO_CHAR(end_time,'WW') AS 				LATE_DELIVERY_WEEK


FROM shipment sh,
	order_movement om,
	 SHIP_UNIT SU

WHERE
 SU.ORDER_RELEASE_GID = om.ORDER_RELEASE_GID
and om.shipment_gid = sh.shipment_gid
and (sh.SOURCE_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837')
OR sh.DEST_LOCATION_GID IN ('ULE.V50360873','ULE.V50413833','ULE.V50413835','ULE.V50413836','ULE.V50413837'))

and NOT EXISTS
		(SELECT 1
		FROM shipment_refnum sh_ref_1
		WHERE sh_ref_1.shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.shipment_gid = sh.shipment_gid)	
		   
		   
and TO_CHAR(sh.end_time,'YYYY') = '2015'
-- and TO_CHAR(sh.end_time,'MM') = '05'
-- and sh.shipment_gid in ('ULE/PR.100661104')
AND SH.SHIPMENT_TYPE_GID IN ('TRANSPORT')

and exists 
(SELECT ORLS_TEMP.order_release_gid
			FROM SHIPMENT SH_TEMP,
			order_movement VORLS_TEMP,
				ORDER_RELEASE ORLS_TEMP
				
			WHERE 1=1
			AND SH_TEMP.SHIPMENT_GID = VORLS_TEMP.SHIPMENT_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = VORLS_TEMP.ORDER_RELEASE_GID
			AND ORLS_TEMP.ORDER_RELEASE_GID = om.ORDER_RELEASE_GID
			AND SH_TEMP.SHIPMENT_TYPE_GID = 'HANDLING'
				
			)
and (SELECT SH_STATUS.STATUS_VALUE_GID
		FROM
		SHIPMENT_STATUS SH_STATUS
		WHERE
		SH_STATUS.SHIPMENT_GID = SH.SHIPMENT_GID
		AND SH_STATUS.STATUS_TYPE_GID = 'ULE/PR.TRANSPORT CANCELLATION'
		)='ULE/PR.NOT CANCELLED'

) temp

group by

		temp.X_dock,
		temp.x_dock_name,
		temp.x_dock_city,
	    temp.LATE_DELIVERY_MONTH,
		temp.LATE_DELIVERY_WEEK,
		TEMP.TRANSPORT_HANDLING_UNIT_GID