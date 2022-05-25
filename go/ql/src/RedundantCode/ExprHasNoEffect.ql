/**
 * @name Expression has no effect
 * @description An expression that has no effect and is used in a void context is most
 *              likely redundant and may indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id go/useless-expression
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/**
 * Holds if `e` appears in a syntactic context where its value is discarded.
 */
predicate inVoidContext(Expr e) {
  e = any(ExprStmt es).getExpr()
  or
  exists(LogicalBinaryExpr logical | e = logical.getRightOperand() and inVoidContext(logical))
}

/**
 * Holds if `ce` is a call to a stub function with an empty body.
 */
predicate callToStubFunction(CallExpr ce) { ce.getTarget().getBody().getNumStmt() = 0 }

from Expr e
where
  not e.mayHaveOwnSideEffects() and
  inVoidContext(e) and
  // don't flag calls to functions with an empty body
  not callToStubFunction(e)
select e, "This expression has no effect."
