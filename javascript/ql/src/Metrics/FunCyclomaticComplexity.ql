/**
 * @name Cyclomatic complexity of functions
 * @description The cyclomatic complexity of a function.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @precision very-high
 * @tags testability
 * @id js/cyclomatic-complexity-per-function
 */

import javascript

from Function func, int complexity
where complexity = func.getCyclomaticComplexity()
select func, complexity order by complexity desc
