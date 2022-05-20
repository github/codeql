/**
 * @name Class response
 * @description The number of unique methods or constructors that can be called by all the methods
 *              or constructors of a class.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/response-per-type
 * @tags maintainability
 *       complexity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getResponse() as n order by n desc
