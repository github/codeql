/**
 * @name Recently changed files
 * @description Number of files recently edited.
 * @kind treemap
 * @id cpp/historical-number-of-recent-changed-files
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f
where
  exists(Commit e |
    e.getAnAffectedFile() = f and
    e.daysToNow() <= 180 and
    not artificialChange(e)
  ) and
  exists(f.getMetrics().getNumberOfLinesOfCode())
select f, 1
