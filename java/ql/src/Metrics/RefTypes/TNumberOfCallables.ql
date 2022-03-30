/**
 * @name Number of methods
 * @description The number of methods and constructors in a reference type.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/functions-per-type
 * @tags maintainability
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getNumberOfCallables() as n order by n desc
