/**
 * @name Lines of commented-out code in files
 * @description The number of lines of commented-out code in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision high
 * @id java/lines-of-commented-out-code-in-files
 * @tags maintainability
 *       documentation
 */

import Violations_of_Best_Practice.Comments.CommentedCode

from File f, int n
where n = sum(CommentedOutCode comment | comment.getFile() = f | comment.getCodeLines())
select f, n order by n desc
