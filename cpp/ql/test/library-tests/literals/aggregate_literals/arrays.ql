import cpp

from ArrayType a, ArrayAggregateLiteral al, int i
where a = al.getType()
select al, a, i, al.getAnElementExpr(i)
