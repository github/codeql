/**
 * @name Missing await
 * @description Using a promise without awaiting its result can cause unexpected behavior.
 * @kind problem
 * @problem.severity warning
 * @id js/missing-await
 * @tags correctness
 * @precision high
 */

import javascript

predicate isAsyncCall(DataFlow::CallNode call) {
  forex(Function callee | call.getACallee() = callee | callee.isAsync())
}

/**
 * Holds if `node` is always a promise.
 */
predicate isPromise(DataFlow::SourceNode node, boolean nullable) {
  isAsyncCall(node) and
  nullable = false
  or
  not isAsyncCall(node) and
  node.asExpr().getType() instanceof PromiseType and
  nullable = true
}

/**
 * Holds the result of `e` is used in a way that doesn't make sense for Promise objects.
 */
predicate isBadPromiseContext(Expr expr) {
  exists(BinaryExpr binary |
    expr = binary.getAnOperand() and
    not binary instanceof LogicalExpr and
    not binary instanceof InstanceofExpr
  )
  or
  expr = any(LogicalBinaryExpr e).getLeftOperand()
  or
  expr = any(UnaryExpr e).getOperand()
  or
  expr = any(UpdateExpr e).getOperand()
}

string tryGetPromiseExplanation(Expr e) {
  result = "The value '" + e.(VarAccess).getName() + "' is always a promise."
  or
  result = "The call to '" + e.(CallExpr).getCalleeName() + "' always returns a promise."
}

string getPromiseExplanation(Expr e) {
  result = tryGetPromiseExplanation(e)
  or
  not exists(tryGetPromiseExplanation(e)) and
  result = "This value is always a promise."
}

from Expr expr, boolean nullable
where
  isBadPromiseContext(expr) and
  isPromise(expr.flow().getImmediatePredecessor*(), nullable) and
  (
    nullable = false
    or
    expr.inNullSensitiveContext()
  )
select expr, "Missing await. " + getPromiseExplanation(expr)
