select sh.shipment_gid,
		-- BSRC.BS_REASON_CODE_GID AS RC_ID,
		-- BSRC.DESCRIPTION AS RC_DESC,
		-- BSSC_EVENT_DELIVER.DESCRIPTION AS EVENT_DESC,
		/* SSSH_EVENT_DELIVER.INSERT_USER, */
		-- IESH_EVENT_DELIVER.INSERT_USER,
		-- TO_CHAR(IESH_EVENT_DELIVER.INSERT_DATE,'YYYY-MM-DD HH24:MI:SS')   										SPOT_DATE,
		tcs.I_TRANSACTION_NO,
		TO_CHAR(UTC.GET_LOCAL_DATE(tcs.INSERT_DATE,TCS.SERVPROV_GID),'YYYY-MM-DD HH24:MI:SS') AS													SPOT_DATE,
		TO_CHAR(UTC.GET_LOCAL_DATE(TC.EXPECTED_RESPONSE,TCS.SERVPROV_GID),'YYYY-MM-DD HH24:MI:SS') AS													EXPECTED_RESPONSE_TIME,
		-- SS.STATUS_VALUE_GID																																SECURE_RESOURCES_STATUS,
		-- TO_CHAR(UTC.GET_LOCAL_DATE(SS.UPDATE_DATE,TCS.SERVPROV_GID),'YYYY-MM-DD HH24:MI:SS') AS													SECURE_RESOURCES_UPDATE_DATE,
		-- TO_CHAR(From_tz(cast(SS.UPDATE_DATE AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET','YYYY-MM-DD HH24:MI:SS')											SECURE_RESOURCES_UPDATE_DATE,
		
		-- (select TO_CHAR(From_tz(cast(tcs2.insert_date AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET','YYYY-MM-DD HH24:MI:SS')
		-- from TENDER_COLLABORATION_STATUS tcs2,
		-- SHIP_TENDER_COLLAB_BOV SH_T_COLL_BOV
		-- where tcs2.I_TRANSACTION_NO = tcs.I_TRANSACTION_NO
		-- and SH_T_COLL_BOV.TENDER_TRANSACTION_NO = tcs2.I_TRANSACTION_NO
		-- and tcs2.STATUS_TYPE_GID = 'ULE/PR.TENDER.SECURE RESOURCES'
		-- and tcs2.STATUS_VALUE_GID = 'ULE/PR.TENDER.SECURE RESOURCES_ACCEPTED'
		
		-- )																																				SECURE_RESOURCES_UPDATE_DATE2,			
		
		(
		SELECT
			TO_CHAR(From_tz(cast(T_COLL_STAT.insert_date AS TIMESTAMP), 'GMT') AT TIME ZONE 'CET','YYYY-MM-DD HH24:MI:SS')
			FROM
			SHIP_TENDER_COLLAB_BOV SH_T_COLL_BOV,
			TENDER_COLLABORATION_STATUS T_COLL_STAT,
			TENDER_COLLABORATION T_COLL

			WHERE
			SH_T_COLL_BOV.TENDER_TRANSACTION_NO = T_COLL_STAT.I_TRANSACTION_NO
			--AND T_COLL_STAT.STATUS_TYPE_GID = 'ULE/PR.TENDER.SECURE RESOURCES'
			--AND T_COLL_STAT.STATUS_VALUE_GID = 'ULE/PR.TENDER.SECURE RESOURCES_ACCEPTED'
			AND T_COLL.I_TRANSACTION_NO = SH_T_COLL_BOV.TENDER_TRANSACTION_NO
			AND SH_T_COLL_BOV.SHIPMENT_gID = sh.shipment_gid
			and T_COLL_STAT.STATUS_TYPE_GID = 'ULE/PR.TENDER.SECURE RESOURCES'
			and T_COLL_STAT.STATUS_VALUE_GID = 'ULE/PR.TENDER.SECURE RESOURCES_ACCEPTED'
		
		)																																		SPOT_CLOSE_DATE,
		tcs.SERVPROV_GID,
		(SELECT LOC.LOCATION_NAME
		FROM LOCATION LOC
		WHERE LOC.LOCATION_GID = TCS.SERVPROV_GID)															SPOT_SERVPROV_NAME,
		SH.SERVPROV_GID																						SH_SERVPROV,
		
		
		
		
		
		tcs.BID_AMOUNT,
		tcs.BID_AMOUNT_CURRENCY_GID,
		CASE WHEN tcs.SERVPROV_GID = SH.SERVPROV_GID THEN 'YES' ELSE 'NO' END AS												IS_WINNER,
		-- TO_CHAR(tcs.update_date,'YYYY-MM-DD HH24:MI:SS')   										BID_ENTRY_DATE
		TO_CHAR(UTC.GET_LOCAL_DATE(tcs.update_date,TCS.SERVPROV_GID),'YYYY-MM-DD HH24:MI:SS') AS													BID_ENTRY_DATE
		,tcs.insert_user																																bid_insert_user
		,tcs.update_user																																bid_update_user
		,tcs.RESPONDING_GL_USER_GID
		-- ,tc.insert_user																																bid_insert_user2
		-- ,tc.update_user																																bid_update_user2
		-- TO_CHAR(UTC.GET_LOCAL_DATE(tc.EXPECTED_RESPONSE,TCS.SERVPROV_GID),'YYYY-MM-DD HH24:MI:SS') AS													EXPECTED_RESPONSE
		
		/* BSSC_EVENT_DELIVER.INSERT_USER, */
		/* BSRC.INSERT_USER */
		,case when sh.PLANNED_RATE_GEO_GID is not null then
        to_char(
         CASE WHEN (tcs.BID_AMOUNT_CURRENCY_GID = 'EUR' or tcs.BID_AMOUNT_CURRENCY_GID is null) THEN tcs.BID_AMOUNT
                         when tcs.BID_AMOUNT_CURRENCY_GID <> 'EUR' then tcs.BID_AMOUNT *
                         unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sh.start_time,tcs.BID_AMOUNT_CURRENCY_GID,'EUR')
                         END -
        CASE
                WHEN (sh.PLANNED_COST_CURRENCY_GID = 'EUR' or sh.PLANNED_COST_CURRENCY_GID is null) THEN sh.PLANNED_COST
                when sh.PLANNED_COST_CURRENCY_GID <> 'EUR' then sh.PLANNED_COST *
                unilever.ebs_procedures_ule.GET_QUARTERLY_EX_RATE(sh.start_time,sh.PLANNED_COST_CURRENCY_GID,'EUR')
                END
        )
        else 'No planned rate record'
        end                                                                                                                             sh_base_vs_planned_eur


--        ,(select coalesce(CEIL((TO_NUMBER((case when REGEXP_LIKE(sh_ref_pal.shipment_REFNUM_VALUE, '[^0-9 \.,]') then '0'
--        		else
--
--        		((TRIM(TO_CHAR(replace(sh_ref_pal.shipment_REFNUM_VALUE,',','.'),'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))))  end),
--        		'999999999D99','NLS_NUMERIC_CHARACTERS = '', '''))),sh.total_ship_unit_count)
--           from
--           shipment_refnum sh_ref_pal
--           where sh_ref_pal.shipment_gid = sh.shipment_gid
--           and sh_ref_pal.SHIPMENT_REFNUM_QUAL_GID  = 'ULE.ULE_ORIGINAL_PFS'
--         )                                                                                                                                                  pfs

from
shipment sh,
-- SS_STATUS_HISTORY SSSH_EVENT_DELIVER
				-- LEFT OUTER JOIN IE_SHIPMENTSTATUS IESH_EVENT_DELIVER ON (SSSH_EVENT_DELIVER.I_TRANSACTION_NO = IESH_EVENT_DELIVER.I_TRANSACTION_NO)
				-- LEFT OUTER JOIN BS_STATUS_CODE BSSC_EVENT_DELIVER ON (IESH_EVENT_DELIVER.STATUS_CODE_GID = BSSC_EVENT_DELIVER.BS_STATUS_CODE_GID)
				-- LEFT OUTER JOIN  BS_REASON_CODE BSRC ON (BSRC.BS_REASON_CODE_GID = IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID),
tender_collaboration tc,
tender_collab_servprov tcs
-- SHIPMENT_STATUS SS
				
where			
-- SSSH_EVENT_DELIVER.SHIPMENT_GID = SH.SHIPMENT_GID
-- and SSSH_EVENT_DELIVER.SHIPMENT_GID = tc.shipment_gid 
 tcs.I_TRANSACTION_NO = tc.I_TRANSACTION_NO
and tc.shipment_gid = sh.shipment_gid
and tc.TENDER_TYPE = 'Spot Bid'
--AND SH.shipment_gid = 'ULE/PR.101903846'
and tcs.BID_AMOUNT is not null
and sh.shipment_gid = :P_SH_ID
-- AND SS.SHIPMENT_GID = SH.SHIPMENT_GID
-- AND SS.STATUS_TYPE_GID = 'ULE/PR.SECURE RESOURCES'
	-- AND BSRC.BS_REASON_CODE_GID IN ('ULE/PR.0026')
	-- AND tcs.INSERT_DATE >= TO_DATE('2015-10-01','YYYY-MM-DD')
	-- AND tcs.INSERT_DATE < TO_DATE('2016-01-01','YYYY-MM-DD')
				-- -- and sh.shipment_gid='ULE/PR.101375412'
-- AND SH.SERVPROV_GID = 'ULE.T1108188'