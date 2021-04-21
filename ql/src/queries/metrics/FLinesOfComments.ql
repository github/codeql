/**
 * @name Lines of comments in files
 * @kind metric
 * @description Files with few lines of comment might not have sufficient documentation to make them understandable.
 * @metricType file
 * @id rb/lines-of-comments-in-files
 * @tags documentation
 */

import ruby

from File f, int n
where n = f.getNumberOfLinesOfComments()
select f, n order by n desc
