/**
 * @name Number of functions per class
 * @description The number of member functions in a class.
 * @kind treemap
 * @id cpp/number-of-functions-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getNumberOfMemberFunctions() as n order by n desc
