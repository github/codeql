/**
 * @name Lossy function result cast
 * @description Finds function calls whose result type is a floating point type, and which are casted to an integral type.
 *              Includes only expressions with implicit cast and excludes function calls to ceil, floor and round.
 * @kind problem
 * @id cpp/lossy-function-result-cast
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

predicate whitelist(Function f) {
  f.getName() =
    [
      "ceil", "ceilf", "ceill", "floor", "floorf", "floorl", "nearbyint", "nearbyintf",
      "nearbyintl", "rint", "rintf", "rintl", "round", "roundf", "roundl", "trunc", "truncf",
      "truncl"
    ] or
  f.getName().matches("\\_\\_builtin\\_%")
}

predicate whitelistPow(FunctionCall fc) {
  fc.getTarget().getName() = ["pow", "powf", "powl"] and
  exists(float value |
    value = fc.getArgument(0).getValue().toFloat() and
    (value.floor() - value).abs() < 0.001
  )
}

predicate whiteListWrapped(FunctionCall fc) {
  whitelist(fc.getTarget())
  or
  whitelistPow(fc)
  or
  exists(Expr e, ReturnStmt rs |
    whiteListWrapped(e) and
    DataFlow::localExprFlow(e, rs.getExpr()) and
    fc.getTarget() = rs.getEnclosingFunction()
  )
}

from FunctionCall c, FloatingPointType t1, IntegralType t2
where
  pragma[only_bind_into](t1) = c.getTarget().getType().getUnderlyingType() and
  t2 = c.getActualType() and
  c.hasImplicitConversion() and
  not whiteListWrapped(c)
select c,
  "Return value of type " + t1.toString() + " is implicitly converted to " + t2.toString() + "."
