/**
 * @name Percentage of comments
 * @description The percentage of lines in a file that contain comments. Note that docstrings are
 *              reported by a separate metric.
 * @kind treemap
 * @id py/comment-ratio-per-file
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 */

import python

from Module m, ModuleMetrics mm
where mm = m.getMetrics() and mm.getNumberOfLines() > 0
select m, 100.0 * (mm.getNumberOfLinesOfComments().(float) / mm.getNumberOfLines().(float)) as ratio
  order by ratio desc
