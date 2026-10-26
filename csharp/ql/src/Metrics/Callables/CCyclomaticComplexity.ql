/**
 * @name Cyclomatic complexity of functions
 * @description Methods with a large number of possible execution paths might be difficult to understand.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @tags testability
 *       complexity
 *       maintainability
 * @id cs/cyclomatic-complexity-per-function
 */

import csharp

from Callable c
where c.isSourceDeclaration()
select c, c.getCyclomaticComplexity() as n order by n desc
