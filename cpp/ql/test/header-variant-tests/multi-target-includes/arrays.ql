import cpp

from Variable v, ArrayType t
where v.getType() = t
select v, t.toString()
