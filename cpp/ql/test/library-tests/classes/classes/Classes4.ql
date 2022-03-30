import cpp

from NestedClass f, NestedClass g
where
  f.hasName("F") and
  g.hasName("G") and
  f.getABaseClass() = g
select f, g
