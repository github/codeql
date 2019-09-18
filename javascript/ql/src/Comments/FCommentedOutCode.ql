/**
 * @name Lines of commented-out code in files
 * @description Measures the number of commented-out lines of code in each file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision high
 * @id js/lines-of-commented-out-code-in-files
 * @tags maintainability
 */

import CommentedOut

from File f
select f, sum(CommentedOutCode comment | comment.getFile() = f | comment.getNumCodeLines())
