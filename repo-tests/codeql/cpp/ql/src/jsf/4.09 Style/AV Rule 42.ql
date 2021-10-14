/**
 * @name AV Rule 42
 * @description Each expression-statement will be on a separate line.
 * @kind problem
 * @id cpp/jsf/av-rule-42
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate exprInStmtContext(Expr e, Location l, File f) {
  e.getParent() instanceof ExprStmt and
  l = e.getLocation() and
  f = l.getFile()
}

predicate overlappingExprs(Expr e1, Expr e2) {
  exists(Location l1, File f, Location l2 |
    exprInStmtContext(e1, l1, f) and
    exprInStmtContext(e2, l2, f) and
    e1 != e2 and
    l1.getEndLine() >= l2.getStartLine() and
    l1.getStartLine() <= l2.getEndLine()
  )
}

from Expr e
where overlappingExprs(e, _) and not e.isInMacroExpansion()
select e, "AV Rule 42: Each expression-statement will be on a separate line."
