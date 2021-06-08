import python

from Module m, ModuleMetrics mm
where mm = m.getMetrics() and mm.getNumberOfLines() > 0
select m, 100.0 * (mm.getNumberOfLinesOfCode().(float) / mm.getNumberOfLines().(float)) as ratio
  order by ratio desc
