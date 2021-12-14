/**
 * @name Number of parameters per method/constructor/operator
 * @description Methods with lots of parameters are difficult to call correctly and might be taking on too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags testability
 *       complexity
 *       maintainability
 * @id cs/parameters-per-function
 */

import csharp

from Callable c
where c.isSourceDeclaration()
select c, c.getNumberOfParameters() as n order by n desc
