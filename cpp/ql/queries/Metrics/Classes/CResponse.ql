/**
 * @name Response per class
 * @description The number of different member functions or
 *              constructors that can be executed by a class.
 * @kind treemap
 * @id cpp/response-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags maintainability
 *       complexity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getResponse()
