import cpp
import semmle.code.cpp.ir.internal.ASTValueNumbering

from GVN g
where strictcount(g.getAnExpr()) > 1
select g,
  strictconcat(Location loc |
    loc = g.getAnExpr().getLocation()
  |
    loc.getStartLine() + ":c" + loc.getStartColumn() + "-c" + loc.getEndColumn(), " "
  )
