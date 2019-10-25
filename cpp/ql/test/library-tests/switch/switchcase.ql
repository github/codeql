import cpp

from SwitchCase sc, Element e, string reason
where
  e = sc.getExpr() and reason = "getExpr"
  or
  e = sc.getEndExpr() and reason = "getEndExpr"
  or
  e = sc.getSwitchStmt() and reason = "getSwitchStmt"
  or
  e = sc.getNextSwitchCase() and reason = "getNextSwitchCase"
  or
  e = sc.getPreviousSwitchCase() and reason = "getPreviousSwitchCase"
  or
  e = sc.getLastStmt() and reason = "getLastStmt"
  or
  e = sc and sc.terminatesInBreakStmt() and reason = "terminatesInBreakStmt()"
  or
  e = sc and sc.terminatesInReturnStmt() and reason = "terminatesInReturnStmt()"
  or
  e = sc and sc.terminatesInThrowStmt() and reason = "terminatesInThrowStmt()"
select sc, e, reason
