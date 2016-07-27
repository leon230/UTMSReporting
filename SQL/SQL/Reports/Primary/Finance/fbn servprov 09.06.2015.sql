SELECT ORDER_RELEASE_GID,ule_final_billing_number,
		ULE_FINAL_BILLING_NUMBER_NAME,
       servprov,
       servprov_name,
       currency_gid,
       payer,
	   ULE_LEG1_PAYER,
	   ULE_LEG2_PAYER,
	   ULE_HANDLING_PAYER,
	   ULE_SOURCELEG_PAYER,
	   ULE_DESTLEG_PAYER,
	   ULE_TRANSLEG_PAYER
FROM   (SELECT ORR.ORDER_RELEASE_GID,

ORR.order_release_refnum_value as ULE_FINAL_BILLING_NUMBER,
ORR.order_release_refnum_qual_gid AS ULE_FINAL_BILLING_NUMBER_NAME,
               SP.location_name as  SERVPROV_NAME,
               s.servprov_gid as  servprov,
               S.currency_gid,
			   
               (SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_PAYER')) PAYER,
				
				(SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_LEG1_PAYER')) ULE_LEG1_PAYER,
				
				(SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_LEG2_PAYER')) ULE_LEG2_PAYER,
					   
				 (SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_HANDLING_PAYER')) ULE_HANDLING_PAYER,
					   
				
				 (SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_SOURCELEG_PAYER')) ULE_SOURCELEG_PAYER,
				
				(SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_DESTLEG_PAYER')) ULE_DESTLEG_PAYER,
					   
				(SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_TRANSLEG_PAYER')) ULE_TRANSLEG_PAYER
					   
				
					   

				
        FROM   order_release_refnum ORR,
               order_movement VSOR,
               shipment S,
               location SP
        WHERE  VSOR.order_release_gid = ORR.order_release_gid
               AND VSOR.shipment_gid = S.shipment_gid
               AND SP.location_gid = S.servprov_gid
               AND ORR.order_release_refnum_qual_gid in ('ULE.ULE_FINAL_BILLING_NUMBER','ULE.ULE_FINAL_BILLING_NUMBER_HANDLING','ULE.ULE_FINAL_BILLING_NUMBER_DESTLEG','ULE.ULE_FINAL_BILLING_NUMBER_LEG1','ULE.ULE_FINAL_BILLING_NUMBER_LEG2',
			   'ULE.ULE_FINAL_BILLING_NUMBER_SOURCELEG')
               AND Trunc(ORR.insert_date) = To_date('2015-06-08', 'YYYY-MM-DD'))
       b
GROUP  BY ule_final_billing_number,
          servprov,
          servprov_name,
          currency_gid,
          payer,
		  ULE_LEG1_PAYER,
		  ULE_LEG2_PAYER,
	   ULE_HANDLING_PAYER,
	   ULE_SOURCELEG_PAYER,
	   ULE_DESTLEG_PAYER,
	   ULE_TRANSLEG_PAYER,
	   ORDER_RELEASE_GID,
	   ULE_FINAL_BILLING_NUMBER_NAME
ORDER  BY b.ule_final_billing_number  