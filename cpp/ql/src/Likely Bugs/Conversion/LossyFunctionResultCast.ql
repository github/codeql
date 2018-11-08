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

from FunctionCall c, FloatingPointType t1, IntegralType t2
where t1 = c.getTarget().getType().getUnderlyingType() and
      t2 = c.getActualType() and
      c.hasImplicitConversion() and
      not c.getTarget().getName() = "ceil" and
      not c.getTarget().getName() = "floor" and
      not c.getTarget().getName() = "round"
select c, "Return value of type " + t1.toString() + " is implicitly converted to " + t2.toString() + " here."
