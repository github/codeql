import cpp

from SwitchStmt ss, Element e, string reason
where
  e = ss.getExpr() and reason = "getExpr"
  or
  e = ss.getStmt() and reason = "getStmt"
  or
  e = ss.getASwitchCase() and reason = "getASwitchCase"
  or
  e = ss.getDefaultCase() and reason = "getDefaultCase"
select ss, e.getLocation().getStartLine(), e, reason
