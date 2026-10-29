import cpp

from Class d, NestedClass e, NestedClass f
where
  not d instanceof NestedClass and
  d.isTopLevel() and
  e.getDeclaringType() = d and
  f.getDeclaringType() = e and
  f.hasName("F")
select d, e, f
