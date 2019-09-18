/**
 * @name Recent changes
 * @description Number of recent commits to this file.
 * @kind treemap
 * @id cpp/historical-number-of-recent-changes
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f, int n
where
  n = count(Commit e |
      e.getAnAffectedFile() = f and
      e.daysToNow() <= 180 and
      not artificialChange(e)
    ) and
  exists(f.getMetrics().getNumberOfLinesOfCode())
select f, n order by n desc
