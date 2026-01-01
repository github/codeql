/**
 * @name Percentage of docstrings
 * @description The percentage of lines in a file that contain docstrings.
 * @kind treemap
 * @id py/doc-string-ratio-per-file
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 */

import python
private import LegacyPointsTo

from ModuleMetrics mm
where mm.getNumberOfLines() > 0
select mm,
  100.0 * (mm.getNumberOfLinesOfDocStrings().(float) / mm.getNumberOfLines().(float)) as ratio
  order by ratio desc
