/**
 * @name Cyclomatic complexity of functions
 * @description The cyclomatic complexity per function (an indication of how many tests are necessary,
 *              based on the number of branching statements).
 * @kind treemap
 * @id py/cyclomatic-complexity-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @tags testability
 *       complexity
 *       maintainability
 */

import python

from Function func, int complexity
where complexity = func.getMetrics().getCyclomaticComplexity()
select func, complexity order by complexity desc
