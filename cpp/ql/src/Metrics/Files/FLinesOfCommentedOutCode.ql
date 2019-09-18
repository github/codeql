/**
 * @name Lines of commented-out code in files
 * @description The number of lines of commented-out code in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision high
 * @id cpp/lines-of-commented-out-code-in-files
 * @tags documentation
 */

import Documentation.CommentedOutCode

from File f, int n
where n = sum(CommentedOutCode comment | comment.getFile() = f | comment.numCodeLines())
select f, n order by n desc
