/**
 * @name Deleted lines per file
 * @description Number of deleted lines per file, across the revision history in the database.
 * @kind treemap
 * @id py/historical-lines-deleted
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */

import python
import external.VCS

from Module m, int n
where
  n =
    sum(Commit entry, int churn |
      churn = entry.getRecentDeletionsForFile(m.getFile()) and not artificialChange(entry)
    |
      churn
    ) and
  exists(m.getMetrics().getNumberOfLinesOfCode())
select m, n order by n desc
