import cpp

from Class c
select c, count(VirtualFunction f | f.getDeclaringType() = c),
  count(PureVirtualFunction f | f.getDeclaringType() = c)
