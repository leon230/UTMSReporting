 SELECT ule_final_billing_number,
       servprov,
       servprov_name,
       currency_gid,
       payer
FROM   (SELECT ORR.order_release_refnum_value as ULE_FINAL_BILLING_NUMBER,
               SP.location_name as  SERVPROV_NAME,
               s.servprov_gid as  servprov,
               S.currency_gid,
               (SELECT OR1.order_release_refnum_value
                FROM   order_release_refnum OR1
                WHERE  OR1.order_release_gid = orr.order_release_gid
                       AND OR1.order_release_refnum_qual_gid in ('ULE.ULE_PAYER'))
               PAYER
        FROM   order_release_refnum ORR,
               order_movement VSOR,
               shipment S,
               location SP
        WHERE  VSOR.order_release_gid = ORR.order_release_gid
               AND VSOR.shipment_gid = S.shipment_gid
               AND SP.location_gid = S.servprov_gid
               AND ORR.order_release_refnum_qual_gid in ('ULE.ULE_FINAL_BILLING_NUMBER')
               AND Trunc(ORR.insert_date) = To_date(:PO_SUMBIT, 'YYYY-MM-DD'))
       b
GROUP  BY ule_final_billing_number,
          servprov,
          servprov_name,
          currency_gid,
          payer
ORDER  BY b.ule_final_billing_number  