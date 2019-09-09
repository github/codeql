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
import semmle.code.cpp.dataflow.DataFlow

predicate whitelist(Function f) {
  exists(string fName |
    fName = f.getName() and
    (
      fName = "ceil" or
      fName = "ceilf" or
      fName = "ceill" or
      fName = "floor" or
      fName = "floorf" or
      fName = "floorl" or
      fName = "nearbyint" or
      fName = "nearbyintf" or
      fName = "nearbyintl" or
      fName = "rint" or
      fName = "rintf" or
      fName = "rintl" or
      fName = "round" or
      fName = "roundf" or
      fName = "roundl" or
      fName = "trunc" or
      fName = "truncf" or
      fName = "truncl" or
      fName.matches("__builtin_%")
    )
  )
}

predicate whitelistPow(FunctionCall fc) {
  (
    fc.getTarget().getName() = "pow" or
    fc.getTarget().getName() = "powf" or
    fc.getTarget().getName() = "powl"
  ) and
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
  t1 = c.getTarget().getType().getUnderlyingType() and
  t2 = c.getActualType() and
  c.hasImplicitConversion() and
  not whiteListWrapped(c)
select c,
  "Return value of type " + t1.toString() + " is implicitly converted to " + t2.toString() +
    " here."
