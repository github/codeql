/**
 * @name Lines of comment in methods
 * @description The number of comment lines in a method.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @id java/lines-of-comment-per-function
 * @tags maintainability
 *       documentation
 */

import java

from Callable c
where c.fromSource()
select c, c.getMetrics().getNumberOfCommentLines() as n order by n desc
