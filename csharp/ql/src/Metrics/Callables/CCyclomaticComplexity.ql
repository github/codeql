/**
 * @name Cyclomatic complexity of functions
 * @description Methods with a large number of possible execution paths might be difficult to understand.
 * @kind table
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max sum
 * @tags testability
 *       complexity
 *       maintainability
 * @deprecated
 */
import csharp

from Callable c
where c.isSourceDeclaration()
select c, c.getCyclomaticComplexity() as n
order by n desc
