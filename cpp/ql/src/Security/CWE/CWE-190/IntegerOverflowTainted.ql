/**
 * @name Potential integer arithmetic overflow
 * @description A user-controlled integer arithmetic expression
 *              that is not validated can cause overflows.
 * @kind problem
 * @id cpp/integer-overflow-tainted
 * @problem.severity warning
 * @security-severity 8.1
 * @precision low
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.ir.dataflow.internal.DefaultTaintTrackingImpl

/** Holds if `expr` might overflow. */
predicate outOfBoundsExpr(Expr expr, string kind) {
  if convertedExprMightOverflowPositively(expr)
  then kind = "overflow"
  else
    if convertedExprMightOverflowNegatively(expr)
    then kind = "overflow negatively"
    else none()
}

from Expr use, Expr origin, string kind
where
  not use.getUnspecifiedType() instanceof PointerType and
  outOfBoundsExpr(use, kind) and
  tainted(origin, use) and
  origin != use and
  not inSystemMacroExpansion(use) and
  // Avoid double-counting: don't include all the conversions of `use`.
  not use instanceof Conversion
select use, "$@ flows an expression which might " + kind + ".", origin, "User-provided value"
