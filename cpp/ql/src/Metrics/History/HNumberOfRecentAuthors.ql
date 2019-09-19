/**
 * @name Number of recent authors
 * @description Number of distinct authors that have recently made
 *              changes.
 * @kind treemap
 * @id cpp/historical-number-of-recent-authors
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f
where exists(f.getMetrics().getNumberOfLinesOfCode())
select f,
  count(Author author |
    exists(Commit e |
      e = author.getACommit() and
      f = e.getAnAffectedFile() and
      e.daysToNow() <= 180 and
      not artificialChange(e)
    )
  )
