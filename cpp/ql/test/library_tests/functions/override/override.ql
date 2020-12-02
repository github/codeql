import cpp

from VirtualFunction f
select f.getDeclaringType(), f, count(VirtualFunction g | f = g and g.isOverrideExplicit())
