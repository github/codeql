/**
 * @name Recently changed files
 * @description Number of files recently edited
 * @kind treemap
 * @id py/historical-number-of-recent-changed-files
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 */

import python
import external.VCS

from Module m
where
  exists(Commit e |
    e.getAnAffectedFile() = m.getFile() and e.daysToNow() <= 180 and not artificialChange(e)
  ) and
  exists(m.getMetrics().getNumberOfLinesOfCode())
select m, 1
