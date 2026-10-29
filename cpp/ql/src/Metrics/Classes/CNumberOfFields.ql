/**
 * @name Number of fields per class
 * @description The number of fields in a class.
 * @kind treemap
 * @id cpp/fields-per-type
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getNumberOfFields() as n order by n desc
