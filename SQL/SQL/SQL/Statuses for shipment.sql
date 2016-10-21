SELECT SH_EVENT_DELIVER.SHIPMENT_GID,
IESH_EVENT_DELIVER.STATUS_CODE_GID,
IESH_EVENT_DELIVER.I_TRANSACTION_NO,
IESH_EVENT_DELIVER.INSERT_DATE,
IESH_EVENT_DELIVER.EVENTDATE,
--SSSH_EVENT_DELIVER.INSERT_DATE,
IESH_EVENT_DELIVER.INSERT_USER,
SSSH_EVENT_DELIVER.REPORTING_METHOD,
SSSH_EVENT_DELIVER.SERVPROV_GID				SERVPROV_ID,
SSSH_EVENT_DELIVER.REPORTING_GLUSER,
IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID as RC_id,
SSSH_EVENT_DELIVER.EVENT_LOCATION_GID as event_loc_gid,
SSSH_EVENT_DELIVER.SHIPMENT_STOP_NUM as stop_num,
BSSC_EVENT_DELIVER.description STATUS_DESCRIPTION,
BS_RC.DESCRIPTION RC_DESCRIPTION


FROM

SHIPMENT SH_EVENT_DELIVER
			LEFT OUTER JOIN SS_STATUS_HISTORY SSSH_EVENT_DELIVER ON (SH_EVENT_DELIVER.SHIPMENT_GID = SSSH_EVENT_DELIVER.SHIPMENT_GID)-- AND SSSH_EVENT_DELIVER.SHIPMENT_STOP_NUM = SS_EVENT_DELIVER.STOP_NUM)
			LEFT OUTER JOIN IE_SHIPMENTSTATUS IESH_EVENT_DELIVER ON (SSSH_EVENT_DELIVER.I_TRANSACTION_NO = IESH_EVENT_DELIVER.I_TRANSACTION_NO)--D1
			LEFT OUTER JOIN BS_STATUS_CODE BSSC_EVENT_DELIVER ON (IESH_EVENT_DELIVER.STATUS_CODE_GID = BSSC_EVENT_DELIVER.BS_STATUS_CODE_GID )
			LEFT OUTER JOIN BS_REASON_CODE BS_RC ON (IESH_EVENT_DELIVER.STATUS_REASON_CODE_GID = BS_RC.BS_REASON_CODE_GID)

WHERE

-- SSSH_EVENT_DELIVER.INSERT_DATE >= TO_DATE('2015-08-01','YYYY-MM-DD')
  SH_EVENT_DELIVER.SHIPMENT_GID in ('ULE/PR.10001424')


-- /* AND SSSH_EVENT_DELIVER.INSERT_USER LIKE '%SERVPROV%' */
-- AND NOT EXISTS
--	(SELECT 1
--	 FROM shipment_refnum sh_ref_1
--	 WHERE sh_ref_1.Shipment_Refnum_Qual_Gid = 'ULE.ULE_SHIPMENT_STREAM'
--		   AND sh_ref_1.Shipment_Refnum_Value = 'SECONDARY'
--		   AND sh_ref_1.SHIPMENT_GID = SH_EVENT_DELIVER.SHIPMENT_GID)

