SELECT LOCATION_GID,REMARK_SEQUENCE,REMARK_QUAL_GID,DOMAIN_NAME,	INSERT_USER,UPDATE_USER,
'"'||replace(REMARK_TEXT,chr(34),'')||'"' as           remark_text
,instr(replace(REMARK_TEXT,chr(34),''),chr(10))          first_occurence
,instr(replace(REMARK_TEXT,chr(34),''),chr(10),instr(replace(REMARK_TEXT,chr(34),''),chr(10))+1)          second_occurence
,instr(replace(REMARK_TEXT,chr(34),''),chr(10),instr(replace(REMARK_TEXT,chr(34),''),chr(10),instr(replace(replace(REMARK_TEXT,chr(34),''),chr(34),''),chr(10))+1)+1)          third_occurence



--,chr(10)

FROM LOCATION_REMARK

WHERE
--LOCATION_GID = 'ULE.V90144'
--instr(REMARK_TEXT,chr(10))> 0
/