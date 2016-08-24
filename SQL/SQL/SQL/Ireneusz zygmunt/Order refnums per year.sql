select * from (with p_data as(
SELECT OR_REF.order_release_refnum_qual_gid
,COUNT(OR_REF.order_release_gid)      num_or
,max(insert_date)               max_date

FROM
order_release_refnum or_ref


WHERE
or_ref.insert_date >= to_date('2016-01-01','YYYY-MM-DD')
GROUP BY OR_REF.order_release_refnum_qual_gid
)
select pd.order_release_refnum_qual_gid

,pd.num_or
,pd.max_date
,(
select distinct or_ref_t.insert_user
from order_release_refnum or_ref_t
where or_ref_t.insert_date = pd.max_date
and or_ref_t.order_release_refnum_qual_gid = pd.order_release_refnum_qual_gid
)                                                                                         ins_user
from p_data pd
)