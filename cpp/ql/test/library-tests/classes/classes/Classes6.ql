import cpp

from NestedClass f, NestedClass g
where
  g.getADerivedClass() = f and
  g.getDeclaringType().getAMember() = f
select f, g
