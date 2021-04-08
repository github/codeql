/**
 * @name Number of recent authors
 * @description Number of distinct authors that have recently made changes
 * @kind treemap
 * @id py/historical-number-of-recent-authors
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 */

import python
import external.VCS

from Module m
where exists(m.getMetrics().getNumberOfLinesOfCode())
select m,
  count(Author author |
    exists(Commit e |
      e = author.getACommit() and
      m.getFile() = e.getAnAffectedFile() and
      e.daysToNow() <= 180 and
      not artificialChange(e)
    )
  )
