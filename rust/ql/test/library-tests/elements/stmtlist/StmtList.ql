import rust
import TestUtils

from StmtList sl, string tail
where
  toBeTested(sl) and
  if sl.hasTailExpr() then tail = "hasTailExpr" else tail = ""
select sl, sl.getNumberOfStatements(), tail,
  concat(int i, AstNode n |
    n = sl.getStmtOrExpr(i)
  |
    i.toString() + ":" + n.toString(), ", " order by i
  )
