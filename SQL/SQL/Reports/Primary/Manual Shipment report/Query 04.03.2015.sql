select sh.source_location_gid,
		
		sh.shipment_gid,
		(SELECT loc.location_name
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.SOURCE_LOCATION_GID
		) AS 																																		source_location_name,
		(SELECT loc.CITY
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.SOURCE_LOCATION_GID
		) AS 																																		source_CITY,
		(SELECT loc.COUNTRY_CODE3_GID
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.SOURCE_LOCATION_GID
		) AS 																																		source_country,
		
		sh.dest_location_gid,
		(SELECT loc.location_name
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.dest_location_gid
		) AS 																																		dest_location_name,
		(SELECT loc.CITY
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.dest_location_gid
		) AS 																																		dest_CITY,
		(SELECT loc.COUNTRY_CODE3_GID
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.dest_location_gid
		) AS 																																		dest_country,
		(select sh_ref.SHIPMENT_REFNUM_VALUE
		from shipment_refnum sh_ref
		where sh_ref.SHIPMENT_GID = sh.SHIPMENT_GID
		and sh_ref.SHIPMENT_REFNUM_QUAL_GID = 'ULE.ULE_FUNCTIONAL_REGION'
		
		
		)																																			REGION,
		
		SH.INSERT_USER,
		SH.SERVPROV_GID,
		TO_CHAR(SH.START_TIME,'YYYY-MM-DD') 																										SH_START_TIME,
		TO_CHAR(SH.END_TIME,'YYYY-MM-DD') 																											SH_END_TIME,
		case
		when 
			(((SELECT DISTINCT
				TENDER_TYPE
			FROM
				TENDER_COLLABORATION TEN_COL_TMP
			WHERE
				TEN_COL_TMP.SHIPMENT_GID = SH.SHIPMENT_GID
				AND TEN_COL_TMP.TENDER_TYPE = 'Spot Bid') is not null) 
			AND sh.RATE_GEO_GID	is null) Then 'Y'
		else 'N'
	end 																																				IS_Spotsource,
	SH.NUM_STOPS																																		STOPS_NUMBER,
	
	(SELECT LISTAGG(S_EQ.EQUIPMENT_GROUP_GID,'/') WITHIN GROUP (ORDER BY SH.SHIPMENT_GID)
	FROM SHIPMENT_S_EQUIPMENT_JOIN S_EQJ,
	S_EQUIPMENT S_EQ
	WHERE S_EQJ.SHIPMENT_GID = SH.SHIPMENT_GID
	AND S_EQ.S_EQUIPMENT_GID  = S_EQJ.S_EQUIPMENT_GID
	
	)																																					EQUIPMENT,
	trim(to_char(SH_C.COST,'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))																																			COST,
	SH_C.COST_GID																																		CURRENCY,
	SH_C.ACCESSORIAL_CODE_GID																															ACCESSORIAL_NAME,
	SH_C.INSERT_USER																																	ACCESSORIAL_INSERT_USER,
	case when 
	(SELECT loc.COUNTRY_CODE3_GID
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.SOURCE_LOCATION_GID
		) =
		(SELECT loc.COUNTRY_CODE3_GID
				FROM LOCATION loc
				WHERE loc.LOCATION_GID = SH.dest_LOCATION_GID
		) then 'N' else 'Y'	end as																															INTERNATIONAL,
		(SELECT LISTAGG(L_REF.LANE_ATTRIBUTE_VALUE,'/') WITHIN GROUP (ORDER BY L_REF.X_LANE_GID)
				FROM LANE_ATTRIBUTE L_REF
				WHERE L_REF.LANE_ATTRIBUTE_DEF_GID = 'ULE.ULE_TRANSPORT_MODE'
				AND L_REF.X_LANE_GID = 
				(SELECT RG.X_LANE_GID
				from RATE_GEO RG
				WHERE RG.RATE_GEO_GID = SH.RATE_GEO_GID)
				
				) 																																			TRANSPORT_MODE,
		(SELECT listagg(BSRC.DESCRIPTION,'|') within group (order by sh.shipment_gid)
		
		FROM 	SS_STATUS_HISTORY SSSH_EVENT_DELIVER,
					IE_SHIPMENTSTATUS IESH_EVENT_DELIVER,
					BS_REASON_CODE BSRC
				
		WHERE 1=1
				 AND SSSH_EVENT_DELIVER.SHIPMENT_GID = SH.SHIPMENT_GID
				 and SSSH_EVENT_DELIVER.I_TRANSACTION_NO = IESH_EVENT_DELIVER.I_TRANSACTION_NO
				 and BSRC.BS_REASON_CODE_GID = IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID
				 AND IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID in ('ULE/PR.0024','ULE/PR.0025','ULE/PR.0026','ULE/PR.0027','ULE/PR.0028','ULE/PR.0029','ULE/PR.0030','ULE/PR.0047')

				 
				 AND IESH_EVENT_DELIVER.INSERT_DATE = (SELECT DISTINCT MAX(IESH_EVENT_DELIVER_TEMP.INSERT_DATE)
        FROM   SS_STATUS_HISTORY SSH_TEMP,
               IE_SHIPMENTSTATUS IESH_EVENT_DELIVER_TEMP
        WHERE  IESH_EVENT_DELIVER_TEMP.STATUS_REASON_CODE_GID = IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID 
               AND SSH_TEMP.SHIPMENT_GID = SH.SHIPMENT_GID 
			   AND SSH_TEMP.I_TRANSACTION_NO = 
                                 IESH_EVENT_DELIVER_TEMP.I_TRANSACTION_NO
			 
								 )

				and IESH_EVENT_DELIVER.SS_CONTACT_NAME is null
		) AS 																																				DELAY_RC,
		sh.RATE_GEO_GID																																		Rate_record


from shipment sh,
shipment sh_fuel
LEFT OUTER JOIN SHIPMENT_COST SH_C ON (sh_fuel.SHIPMENT_GID = SH_C.SHIPMENT_GID and sh_c.COST_TYPE <> 'B')
 /* and sh_c.ACCESSORIAL_CODE_GID like '%FUEL%') */



where 1=1
and sh.domain_name not in ('ULE/SE','UGO')
AND sh_fuel.SHIPMENT_GID = sh.SHIPMENT_GID
AND NOT EXISTS
	(SELECT 1
	 FROM shipment_refnum sh_ref_1
	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
		   AND sh_ref_1.SHIPMENT_GID = SH.SHIPMENT_GID)
/* and sh.RATE_GEO_GID is null */
and to_char(sh.end_time,'MM') = :P_MONTH
and to_char(sh.end_time,'YYYY') = :P_YEAR

/* AND SH.INSERT_DATE >= TO_DATE('2015-01-01','YYYY-MM-DD') */