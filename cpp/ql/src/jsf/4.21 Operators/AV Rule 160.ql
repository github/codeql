/**
 * @name AV Rule 160
 * @description An assignment expression shall be used only as the expression in an expression statement.
 * @kind problem
 * @id cpp/jsf/av-rule-160
 * @problem.severity warning
 * @tags correctness
 *       readability
 *       external/jsf
 */

import cpp

predicate multipleAssignExpr(Expr e) {
  e instanceof AssignExpr
  or
  exists(CommaExpr ce | ce = e |
    multipleAssignExpr(ce.getLeftOperand()) and
    multipleAssignExpr(ce.getRightOperand())
  )
}

class MultipleAssignExpr extends Expr {
  MultipleAssignExpr() { multipleAssignExpr(this) }

  Assignment getAnAssignment() { result = this.getAChild*() }
}

class ForStmtSideEffectExpr extends Expr {
  ForStmtSideEffectExpr() {
    exists(ForStmt stmt |
      this = stmt.getUpdate() or
      this = stmt.getInitialization().getAChild().(MultipleAssignExpr).getAnAssignment()
    )
  }
}

from AssignExpr ae
where
  ae.fromSource() and
  not ae.getParent() instanceof ExprStmt and
  not ae instanceof ForStmtSideEffectExpr
select ae,
  "AV Rule 160: An assignment expression shall be used only as the exprression in an expression statement."
