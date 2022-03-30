/**
 * @name Number of functions in files
 * @description The number of functions in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id js/functions-per-file
 */

import javascript

from File f, int n
where n = count(Function fun | fun.getTopLevel().getFile() = f)
select f, n order by n desc
