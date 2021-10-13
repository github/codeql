/**
 * @name Lines of commented-out code in files
 * @description The number of lines of commented out code per file
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @tags maintainability
 * @id py/lines-of-commented-out-code-in-files
 */

import python
import Lexical.CommentedOutCode
import python

from File f, int n
where n = count(CommentedOutCodeLine c | not c.maybeExampleCode() and c.getLocation().getFile() = f)
select f, n order by n desc
