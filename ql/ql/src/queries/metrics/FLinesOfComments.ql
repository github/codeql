/**
 * @name Lines of comments in files
 * @kind metric
 * @description Measures the number of lines of comments in each file.
 * @metricType file
 * @id ql/lines-of-comments-in-files
 */

import ql

from File f, int n
where n = f.getNumberOfLinesOfComments()
select f, n order by n desc
