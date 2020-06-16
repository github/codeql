/**
 * @name Statement nesting depth
 * @description The maximum nesting depth of statements in a function.
 * @kind treemap
 * @id py/statement-nesting-depth-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags maintainability
 *       complexity
 */

import python

from FunctionMetrics func
select func, func.getStatementNestingDepth() as n order by n desc
