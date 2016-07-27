SELECT vorls.order_release_gid,
vorls.shipment_gid,
(SELECT SS.STATUS_VALUE_GID
FROM SHIPMENT_STATUS SS
WHERE SS.shipment_gid = VORLS.shipment_gid
AND SS.STATUS_TYPE_GID = 'ULE/PR.ENROUTE'

)

FROM VIEW_SHIPMENT_ORDER_RELEASE VORLS

WHERE VORLS.ORDER_RELEASE_GID IN ('ULE.0180655362','ULE.0180670430','ULE.4216637304','ULE.4217751163','ULE.4217751167','ULE.0180663569','ULE.0180667211','ULE.0180668072','ULE.4218337568','ULE.4218340877','ULE.4218587152','ULE.0180669895','ULE.0180670240','ULE.0180677998','ULE.0180663564','ULE.0180663565','ULE.0180669750','ULE.0180672048','ULE.0180674495','ULE.0180678234','ULE.0180671166','ULE.0180675224','ULE.0180687151','ULE.0180671133','ULE.0180634646','ULE.0180670030','ULE.0180670247','ULE.0180674331','ULE.0180674478','ULE.0180675480','ULE.0180684812','ULE.4218270713','ULE.0180642317','ULE.0180642480','ULE.0180681690','ULE.4216971434','ULE.4218318215','ULE.0180669787','ULE.0180670231','ULE.0180674613','ULE.4218327375','ULE.0180676753','ULE.4218577548','ULE.0180652227','ULE.0180663572','ULE.0180664102','ULE.0180671043','ULE.0180674228','ULE.0180676828','ULE.4217908036','ULE.0180677876','ULE.4218465107','ULE.0180663578','ULE.0180663566','ULE.0180669635','ULE.4218463838','ULE.0180668090','ULE.4218318810','ULE.0180666296','ULE.0180669777','ULE.0180674181','ULE.4218327111','ULE.0180674436','ULE.0180569142','ULE.0180662657','ULE.0180670561','ULE.0180673736','ULE.0180674513','ULE.0180684623','ULE.4218270657','ULE.4218337775','ULE.4218582409','ULE.0180663584','ULE.0180690579','ULE.4217905699','ULE.0180674488','ULE.0180661836','ULE.0180659013','ULE.0180670544','ULE.0180671138','ULE.0180674640','ULE.0180688111','ULE.4218270638','ULE.4218479381','ULE.4218586707','ULE.0180668074','ULE.0180670898','ULE.0180674486','ULE.0180682625','ULE.0180663547','ULE.0180674511','ULE.4218338027','ULE.4218327394','ULE.20141105-0226','ULE.0180612618','ULE.0180669685','ULE.0180674509','ULE.4216321944','ULE.4218372731','ULE.4218465029','ULE.0180668065','ULE.4217826601','ULE.4218577054','ULE.0180671045','ULE.0180681295','ULE.20141105-0168','ULE.4218338274','ULE.0180670242','ULE.0180670999','ULE.0180672102','ULE.0180675566','ULE.0180676633'

)




SELECT * FROM ORDER_RELEASE_REFNUM


WHERE ORDER_RELEASE_GID IN ('ULE.0180655362','ULE.0180670430','ULE.4216637304','ULE.4217751163','ULE.4217751167','ULE.0180663569','ULE.0180667211','ULE.0180668072','ULE.4218337568','ULE.4218340877','ULE.4218587152','ULE.0180669895','ULE.0180670240','ULE.0180677998','ULE.0180663564','ULE.0180663565','ULE.0180669750','ULE.0180672048','ULE.0180674495','ULE.0180678234','ULE.0180671166','ULE.0180675224','ULE.0180687151','ULE.0180671133','ULE.0180634646','ULE.0180670030','ULE.0180670247','ULE.0180674331','ULE.0180674478','ULE.0180675480','ULE.0180684812','ULE.4218270713','ULE.0180642317','ULE.0180642480','ULE.0180681690','ULE.4216971434','ULE.4218318215','ULE.0180669787','ULE.0180670231','ULE.0180674613','ULE.4218327375','ULE.0180676753','ULE.4218577548','ULE.0180652227','ULE.0180663572','ULE.0180664102','ULE.0180671043','ULE.0180674228','ULE.0180676828','ULE.4217908036','ULE.0180677876','ULE.4218465107','ULE.0180663578','ULE.0180663566','ULE.0180669635','ULE.4218463838','ULE.0180668090','ULE.4218318810','ULE.0180666296','ULE.0180669777','ULE.0180674181','ULE.4218327111','ULE.0180674436','ULE.0180569142','ULE.0180662657','ULE.0180670561','ULE.0180673736','ULE.0180674513','ULE.0180684623','ULE.4218270657','ULE.4218337775','ULE.4218582409','ULE.0180663584','ULE.0180690579','ULE.4217905699','ULE.0180674488','ULE.0180661836','ULE.0180659013','ULE.0180670544','ULE.0180671138','ULE.0180674640','ULE.0180688111','ULE.4218270638','ULE.4218479381','ULE.4218586707','ULE.0180668074','ULE.0180670898','ULE.0180674486','ULE.0180682625','ULE.0180663547','ULE.0180674511','ULE.4218338027','ULE.4218327394','ULE.20141105-0226','ULE.0180612618','ULE.0180669685','ULE.0180674509','ULE.4216321944','ULE.4218372731','ULE.4218465029','ULE.0180668065','ULE.4217826601','ULE.4218577054','ULE.0180671045','ULE.0180681295','ULE.20141105-0168','ULE.4218338274','ULE.0180670242','ULE.0180670999','ULE.0180672102','ULE.0180675566','ULE.0180676633'

)

SELECT * 

FROM SHIPMENT_STATUS SS


WHERE
SHIPMENT_GID IN ('ULE/PR.100815262','ULE/PR.100815013','ULE/PR.100878997','ULE/PR.100878976','ULE/PR.100885190','ULE/PR.100875946','ULE/PR.100886672','ULE/PR.100882326','ULE/PR.100882432','ULE/PR.100878997','ULE/PR.100661415','ULE/PR.100633226','ULE/PR.100764492','ULE/PR.100878520','ULE/PR.100878517','ULE/PR.100913770','ULE/PR.100934302','ULE/PR.100715983','ULE/PR.100815261','ULE/PR.100865524','ULE/PR.100866251','ULE/PR.100882326','ULE/PR.100882326','ULE/PR.100875353','ULE/PR.100916618','ULE/PR.100916618','ULE/PR.100539585','ULE/PR.100931644','ULE/PR.100934300','ULE/PR.100934304','ULE/PR.100815261','ULE/PR.100815261','ULE/PR.100866250','ULE/PR.100866251','ULE/PR.100878976','ULE/PR.100875353','ULE/PR.100882326','ULE/PR.100579823','ULE/PR.100778077','ULE/PR.100882382','ULE/PR.100903197','ULE/PR.100912319','ULE/PR.100931642','ULE/PR.100815261','ULE/PR.100815013','ULE/PR.100878976','ULE/PR.100866250','ULE/PR.100866251','ULE/PR.100882382','ULE/PR.100882326','ULE/PR.100875353','ULE/PR.100900808','ULE/PR.100661164','ULE/PR.100539587','ULE/PR.100633225','ULE/PR.100887834','ULE/PR.100912319','ULE/PR.100931642','ULE/PR.100931642','ULE/PR.100710158','ULE/PR.100865524','ULE/PR.100878976','ULE/PR.100865524','ULE/PR.100866027','ULE/PR.100866250','ULE/PR.100885190','ULE/PR.100882382','ULE/PR.100882382','ULE/PR.100579822','ULE/PR.100795176','ULE/PR.100795177','ULE/PR.100878518','ULE/PR.100882380','ULE/PR.100884741','ULE/PR.100912319','ULE/PR.100931642','ULE/PR.100774602','ULE/PR.100774606','ULE/PR.100815262','ULE/PR.100815013','ULE/PR.100888664','ULE/PR.100866027','ULE/PR.100865524','ULE/PR.100865524','ULE/PR.100866027','ULE/PR.100882382','ULE/PR.100890323','ULE/PR.100874921','ULE/PR.100885190','ULE/PR.100874921','ULE/PR.100861335','ULE/PR.100863987','ULE/PR.100882382','ULE/PR.100882326','ULE/PR.100875353','ULE/PR.100903197','ULE/PR.100916618','ULE/PR.100884740','ULE/PR.100912319','ULE/PR.100931642','ULE/PR.100774604','ULE/PR.100815262','ULE/PR.100815262','ULE/PR.100866027','ULE/PR.100866027','ULE/PR.100878976','ULE/PR.100885417','ULE/PR.100875353','ULE/PR.100882326','ULE/PR.100882432','ULE/PR.100928386','ULE/PR.100661164','ULE/PR.100539586','ULE/PR.100774606','ULE/PR.100884739','ULE/PR.100913770','ULE/PR.100913770','ULE/PR.100710157','ULE/PR.100815013','ULE/PR.100866027','ULE/PR.100865524','ULE/PR.100882326','ULE/PR.100882326','ULE/PR.100882326','ULE/PR.100885417','ULE/PR.100903197','ULE/PR.100909398','ULE/PR.100579821','ULE/PR.100778078','ULE/PR.100794417','ULE/PR.100882380','ULE/PR.100912327','ULE/PR.100934304'
)