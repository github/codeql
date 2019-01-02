/**
 * @name Deleted lines
 * @description Number of deleted lines, across the revision history in the database.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/vcs/deleted-lines-per-file
 */

import csharp
import external.VCS

from File f, int n
where
  n = sum(Commit entry, int churn |
      churn = entry.getRecentDeletionsForFile(f) and not artificialChange(entry)
    |
      churn
    )
select f, n order by n desc
