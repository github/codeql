/**
 * @name Number of fields
 * @description The number of fields in a class, excluding enum constants.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/fields-per-type
 * @tags maintainability
 *       complexity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getNumberOfExplicitFields() as n order by n desc
