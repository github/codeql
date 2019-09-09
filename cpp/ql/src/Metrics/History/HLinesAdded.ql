/**
 * @name Added lines per file
 * @description Number of added lines per file, across the revision
 *              history in the database.
 * @kind treemap
 * @id cpp/historical-lines-added
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f, int n
where
  n = sum(Commit entry, int churn |
      churn = entry.getRecentAdditionsForFile(f) and
      not artificialChange(entry)
    |
      churn
    ) and
  exists(f.getMetrics().getNumberOfLinesOfCode())
select f, n order by n desc
