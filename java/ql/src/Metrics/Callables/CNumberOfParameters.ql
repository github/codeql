/**
 * @name Number of parameters to methods
 * @description The number of parameters of a method or constructor.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @id java/parameters-per-function
 * @tags testability
 *       complexity
 *       maintainability
 */

import java

from Callable c
where c.fromSource()
select c, c.getMetrics().getNumberOfParameters() as n order by n desc
