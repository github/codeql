import cpp

from Variable v
select v, v.getName(), v.getType() as t, t.getSize()
