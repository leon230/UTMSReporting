SELECT   IR.I_TRANSMISSION_NO,
         IR.CREATE_DATE,
         IR.IS_INBOUND,
                ITR.TRANSACTION_CODE,
                ITR.OBJECT_GID,
         IR.SENDER_TRANSMISSION_ID,
         IR.STATUS,
                  IR.LOG_PROCESS_ID,
         '"'||IL.I_MESSAGE_CODE||'"',
                  '"'||ITR.ELEMENT_NAME||'"',

                  
                  
                 '"'||REGEXP_REPLACE(IL.I_MESSAGE_TEXT,'[^a-zA-Z 0-9 \.,&\/() '']','')||'"'  testaa



FROM   I_TRANSMISSION IR, I_LOG IL, I_TRANSACTION ITR
WHERE       IR.I_TRANSMISSION_NO = IL.I_TRANSMISSION_NO
AND ITR.I_TRANSMISSION_NO=IR.I_TRANSMISSION_NO
         AND IR.STATUS = 'ERROR'
         AND IR.DOMAIN_NAME = 'ULE'
         AND IL.I_MESSAGE_TEXT IS NOT NULL
         AND TRUNC (IR.CREATE_DATE) >= TO_DATE(:P_CREATION_FROM,:P_DATE_TIME_FORMAT)--TRUNC(to_date('2016-01-01 00:01:00','YYYY-MM-DD HH24:MI:SS'))
                AND TRUNC (IR.CREATE_DATE) <= TO_DATE(:P_CREATION_TO,:P_DATE_TIME_FORMAT)---TRUNC(to_date('2016-05-01 23:59:00','YYYY-MM-DD HH24:MI:SS'))
         and ITR.ELEMENT_NAME!='TransmissionHeader'
         AND (IR.SENDER_TRANSMISSION_ID like 'BTF%')
