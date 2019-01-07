/**
 * @name Lines of comments in files
 * @description Files with few lines of comment might not have sufficient documentation to make them understandable.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id js/lines-of-comments-in-files
 * @tags documentation
 */

import javascript

from File f
select f, f.getNumberOfLinesOfComments() as n order by n desc
