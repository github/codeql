/**
 * @name Unclear validation of array index
 * @description Accessing an array without first checking
 *              that the index is within the bounds of the array can
 *              cause undefined behavior and can also be a security risk.
 * @kind problem
 * @id cpp/unclear-array-index-validation
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-129
 */

import cpp
import semmle.code.cpp.controlflow.Guards
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.security.TaintTracking

predicate hasUpperBound(VariableAccess offsetExpr) {
  exists(BasicBlock controlled, StackVariable offsetVar, SsaDefinition def |
    controlled.contains(offsetExpr) and
    linearBoundControls(controlled, def, offsetVar) and
    offsetExpr = def.getAUse(offsetVar)
  )
}

pragma[noinline]
predicate linearBoundControls(BasicBlock controlled, SsaDefinition def, StackVariable offsetVar) {
  exists(GuardCondition guard, boolean branch |
    guard.controls(controlled, branch) and
    cmpWithLinearBound(guard, def.getAUse(offsetVar), Lesser(), branch)
  )
}

from Expr origin, ArrayExpr arrayExpr, VariableAccess offsetExpr
where
  tainted(origin, offsetExpr) and
  offsetExpr = arrayExpr.getArrayOffset() and
  not hasUpperBound(offsetExpr)
select offsetExpr,
  "$@ flows to here and is used in an array indexing expression, potentially causing an invalid access.",
  origin, "User-provided value"
