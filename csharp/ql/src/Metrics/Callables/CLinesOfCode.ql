/**
 * @name Lines of code per method
 * @description Long methods are difficult to read and understand. This means it is also more difficult to find defects in them.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 *       complexity
 * @id cs/lines-of-code-per-function
 */

import csharp

from Callable c
where c.isSourceDeclaration()
select c, c.getNumberOfLinesOfCode() as n order by n desc
