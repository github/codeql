/**
 * @name Cyclomatic complexity of functions
 * @description The Cyclomatic complexity (an indication of how many
 *              tests are necessary, based on the number of branching
 *              statements) per function.
 * @kind treemap
 * @id cpp/cyclomatic-complexity-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @tags testability
 *       maintainability
 *       complexity
 */

import cpp

from Function f
where strictcount(f.getEntryPoint()) = 1
select f, f.getMetrics().getCyclomaticComplexity()
