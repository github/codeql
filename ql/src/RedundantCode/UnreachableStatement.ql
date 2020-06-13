/**
 * @name Unreachable statement
 * @description Unreachable statements are often indicative of missing code or latent bugs
 *              and should be avoided.
 * @kind problem
 * @problem.severity warning
 * @id go/unreachable-statement
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

ControlFlow::Node nonGuardPredecessor(ControlFlow::Node nd) {
  exists(ControlFlow::Node pred | pred = nd.getAPredecessor() |
    if pred instanceof ControlFlow::ConditionGuardNode
    then result = nonGuardPredecessor(pred)
    else result = pred
  )
}

predicate allowlist(Stmt s) {
  // `panic("unreachable")` and similar
  exists(CallExpr ce | ce = s.(ExprStmt).getExpr() or ce = s.(ReturnStmt).getExpr() |
    ce.getTarget().mustPanic() or ce.getCalleeName().toLowerCase() = "error"
  )
  or
  // `return nil` and similar
  exists(ReturnStmt ret | ret = s |
    forall(Expr retval | retval = ret.getAnExpr() |
      retval = Builtin::nil().getAReference() or
      retval instanceof BasicLit or
      retval.(UnaryExpr).getOperand() instanceof BasicLit
    )
  )
  or
  // statements in an `if false { ... }` and similar
  exists(IfStmt is, ControlFlow::ConditionGuardNode iffalse, Expr cond, boolean b |
    iffalse.getCondition() = is.getCond() and
    iffalse = s.getFirstControlFlowNode().getAPredecessor() and
    cond.getBoolValue() = b and
    iffalse.ensures(DataFlow::exprNode(cond), b.booleanNot())
  )
}

from Stmt s, ControlFlow::Node fst
where
  fst = s.getFirstControlFlowNode() and
  not exists(nonGuardPredecessor(fst)) and
  not allowlist(s)
select s, "This statement is unreachable."
