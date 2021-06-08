/**
 * @name Lines of comments in files
 * @kind treemap
 * @description Measures the number of lines of comments in each file (including docstrings,
 *              and ignoring lines that contain only code or are blank).
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id py/lines-of-comments-in-files
 */

import python

from Module m, int n
where
  n = m.getMetrics().getNumberOfLinesOfComments() + m.getMetrics().getNumberOfLinesOfDocStrings()
select m, n order by n desc
