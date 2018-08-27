import cpp

from ArrayType a, ArrayAggregateLiteral al, int i
where a = al.getType()
  and al.isValueInitialized(i)
select al, a, i
