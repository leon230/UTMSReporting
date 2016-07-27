 Select count(*)
       from ( select rownum rnum
               from all_objects
             where rownum <= to_date('07-10-2015','DD-MM-YYYY') - 
    to_date('30-09-2015','DD-MM-YYYY')+1 )
         where to_char( to_date('30-09-2015','DD-MM-YYYY')+rnum-1, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH' )
                      not in ( 'MON', 'TUE','WED','THU','FRI' )
                      
                      /
                      select to_date('07-10-2015','DD-MM-YYYY') - to_date('30-09-2015','DD-MM-YYYY') from dual