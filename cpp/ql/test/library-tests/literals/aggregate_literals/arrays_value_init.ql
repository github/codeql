import cpp

from ArrayType a, ArrayAggregateLiteral al, int i
where
  a = al.getType() and
  i = [0 .. al.getUnspecifiedType().(ArrayType).getArraySize()] and
  al.isValueInitialized(i)
select al, a, i
