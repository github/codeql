/**
 * @name Cyclomatic complexity of functions
 * @description The number of possible execution paths through a method or constructor.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @id java/cyclomatic-complexity-per-function
 * @tags testability
 *       complexity
 *       maintainability
 */

import java

from Callable c
where c.fromSource()
select c, c.getMetrics().getCyclomaticComplexity() as n order by n desc
