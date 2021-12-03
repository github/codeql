/**
 * @name Lines of comments in files
 * @description The number of lines of comment in a file.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/lines-of-comments-in-files
 * @tags maintainability
 *       documentation
 */

import java

from File f, int n
where n = f.getNumberOfCommentLines()
select f, n order by n desc
