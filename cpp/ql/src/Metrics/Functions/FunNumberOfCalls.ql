/**
 * @name Number of function calls per function
 * @description The number of C/C++ function calls per function.
 * @kind treemap
 * @id cpp/number-of-calls-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 *       complexity
 */

import cpp

predicate callToOperator(FunctionCall fc) {
  fc.getTarget() instanceof Operator or
  fc.getTarget() instanceof ConversionOperator
}

from Function f, int n, int o
where
  strictcount(f.getEntryPoint()) = 1 and
  o =
    count(FunctionCall c |
      c.getEnclosingFunction() = f and
      not c.isInMacroExpansion() and
      not c.isCompilerGenerated() and
      not callToOperator(c)
    ) and
  n = o / count(f.getBlock())
select f, n
