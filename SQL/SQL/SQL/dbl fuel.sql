select shipment_gid,count(shipment_gid),ACCESSORIAL_CODE_GID,

(select sh_st.STATUS_VALUE_GID
from shipment_status sh_st
where sh_st.STATUS_TYPE_GID = 'ULE/PR.SHIPMENT_COST'

and sh_st.shipment_gid = sc.shipment_gid
) status

from shipment_cost sc 


where 1=1
and sc.COST_TYPE = 'A'
and sc.ACCESSORIAL_CODE_GID like '%FUEL%'





group by shipment_gid,ACCESSORIAL_CODE_GID
having count(shipment_gid)>1
/* and sh_st.STATUS_VALUE_GID = 'ULE/PR.SC_NO CHANGES ALLOWED' */