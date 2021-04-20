/**
 * @name Lines of comments in files
 * @kind treemap
 * @description Files with few lines of comment might not have sufficient documentation to make them understandable.
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id rb/lines-of-comments-in-files
 * @tags documentation
 */

import ruby

from File f, int n
where n = f.getMetrics().getNumberOfLinesOfComments()
select f, n order by n desc
