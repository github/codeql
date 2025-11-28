import python
private import LegacyPointsTo

from ModuleMetrics mm
where mm.getNumberOfLines() > 0
select mm, 100.0 * (mm.getNumberOfLinesOfCode().(float) / mm.getNumberOfLines().(float)) as ratio
  order by ratio desc
