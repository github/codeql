/**
 * @name Lines of code in types
 * @description The number of lines of code in a type.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/lines-of-code-per-type
 * @tags maintainability
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getNumberOfLinesOfCode() as n order by n desc
