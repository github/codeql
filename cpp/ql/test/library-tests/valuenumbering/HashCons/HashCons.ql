import cpp
import semmle.code.cpp.valuenumbering.HashCons

from HC h
where strictcount(h.getAnExpr()) > 1
select
  h,
  strictconcat(Location loc
  | loc = h.getAnExpr().getLocation()
  | loc.getStartLine() +
    ":c" + loc.getStartColumn() + "-c" + loc.getEndColumn()
  , " ")
