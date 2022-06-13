/**
 * @name Lines of comments in files
 * @description Files with few lines of comment might not have sufficient documentation
 *              to make them understandable.
 * @kind metric
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id go/lines-of-comments-in-files
 * @tags documentation
 */

import go

from File f
select f, f.getNumberOfLinesOfComments() as n order by n desc
