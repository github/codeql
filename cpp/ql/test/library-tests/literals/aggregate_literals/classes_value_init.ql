import cpp

from Class c, ClassAggregateLiteral al, Field f
where
  c = al.getType() and
  al.isValueInitialized(f)
select al, c, f
