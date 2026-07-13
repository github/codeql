/**
 * @name Unreachable statement
 * @description Unreachable statements are often indicative of missing code or latent bugs
 *              and should be avoided.
 * @kind problem
 * @problem.severity warning
 * @id go/unreachable-statement
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/**
 * Holds if `s` is reachable, that is, the control-flow graph contains a node for it.
 *
 * The shared control-flow library does not create control-flow nodes for dead code, so an
 * unreachable statement has no first control-flow node.
 */
predicate isReachable(Stmt s) { exists(s.getFirstControlFlowNode()) }

/** Gets the statement immediately preceding `s` in a statement list, if any. */
Stmt getPreviousStmt(Stmt s) {
  exists(BlockStmt b, int i | s = b.getStmt(i) and result = b.getStmt(i - 1))
  or
  exists(CaseClause c, int i | s = c.getStmt(i) and result = c.getStmt(i - 1))
  or
  exists(CommClause c, int i | s = c.getStmt(i) and result = c.getStmt(i - 1))
}

/**
 * Holds if `s` is unreachable but the code that would precede it in the control-flow graph is
 * reachable, so that `s` is the first unreachable statement in a run of dead code.
 */
predicate firstUnreachableStmt(Stmt s) {
  not isReachable(s) and
  not s instanceof EmptyStmt and
  (
    // a statement whose preceding statement in the same list is reachable
    isReachable(getPreviousStmt(s))
    or
    // the post statement of a `for` loop whose body is entered
    exists(ForStmt f | s = f.getPost() and isReachable(f.getBody().getAStmt()))
  )
}

/**
 * Matches if `retval` is a constant or a struct composed wholly of constants.
 */
predicate isAllowedReturnValue(Expr retval) {
  exprRefersToNil(retval)
  or
  retval = Builtin::true_().getAReference()
  or
  retval = Builtin::false_().getAReference()
  or
  retval instanceof BasicLit
  or
  // Allow -1 (which parses as unary-minus-of-literal) or !true, but not &somestruct,
  // for which we would usually prefer `return nil`
  isAllowedReturnValue(retval.(UnaryExpr).getOperand()) and
  not retval.getType().getUnderlyingType() instanceof PointerType
  or
  // Allow structs composed of allowed values
  retval instanceof StructLit and
  forall(Expr element | element = retval.(StructLit).getAnElement() | isAllowedReturnValue(element))
  or
  // Allow anything of type `error`, as `abort(); return constructError(...);`
  // is preferable to insisting on a misleading `return nil` that suggests
  // successful return:
  retval.getType().getEntity() = Builtin::error()
}

/**
 * Matches if `s` is an allowed unreachable statement.
 */
predicate allowlist(Stmt s) {
  // `panic("unreachable")` and similar
  exists(CallExpr ce | ce = s.(ExprStmt).getExpr() or ce = s.(ReturnStmt).getExpr() |
    ce.getTarget().mustPanic() or ce.getCalleeName().toLowerCase() = "error"
  )
  or
  // `return nil` and similar
  exists(ReturnStmt ret | ret = s |
    forall(Expr retval | retval = ret.getAnExpr() | isAllowedReturnValue(retval))
  )
  or
  // statements deliberately made unreachable by a constant condition, such as the code
  // following `if true { return }`
  exists(getPreviousStmt(s).(IfStmt).getCond().getBoolValue())
}

from Stmt s
where
  firstUnreachableStmt(s) and
  not allowlist(s)
select s, "This statement is unreachable."
