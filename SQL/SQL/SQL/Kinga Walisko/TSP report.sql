select SC.*


        from shipment sh
        join shipment_cost sc on (sc.SHIPMENT_GID = sh.SHIPMENT_GID)

        where
        SH.SERVPROV_GID = 'ULE.T58010'

        AND SH.START_TIME >= TO_DATE('2016-01-01','YYYY-MM-DD')

        and exists(
        select 1
        from shipment_cost sc2
        where sc2.SHIPMENT_GID = sh.SHIPMENT_GID
        and SC2.ACCESSORIAL_CODE_GID = 'ULE/PR.ULE_HANDLING'

        )