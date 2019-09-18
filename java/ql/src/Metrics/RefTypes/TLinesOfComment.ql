/**
 * @name Lines of comment in types
 * @description The number of lines of comment in a type.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/lines-of-comments-per-type
 * @tags maintainability
 *       documentation
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getNumberOfCommentLines() as n order by n desc
