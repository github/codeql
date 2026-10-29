import cpp

from ReturnStmt r
select r, r.getEnclosingFunction(), r.getExpr().getValue()
