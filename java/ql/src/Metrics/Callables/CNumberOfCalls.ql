/**
 * @name Number of calls in methods
 * @description The number of calls that is made by a method or constructor.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @id java/calls-per-function
 * @tags testability
 *       complexity
 *       maintainability
 */

import java

from Callable c, int n
where
  c.fromSource() and
  n = count(Call call | call.getEnclosingCallable() = c)
select c, n order by n desc
