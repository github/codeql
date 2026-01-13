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
private import LegacyPointsTo

from FunctionMetrics func, int complexity
where complexity = func.getCyclomaticComplexity()
select func, complexity order by complexity desc
