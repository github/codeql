import cpp

from Variable v
select v, v.getType().explain(), v.getUnspecifiedType().explain()
