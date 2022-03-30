/**
 * @name Number of re-commits for each file
 * @description A re-commit is taken to mean a commit to a file that was touched less than five days ago.
 * @kind treemap
 * @id py/historical-number-of-re-commits
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 */

import python
import external.VCS

predicate inRange(Commit first, Commit second) {
  first.getAnAffectedFile() = second.getAnAffectedFile() and
  first != second and
  exists(int n |
    n = first.getDate().daysTo(second.getDate()) and
    n >= 0 and
    n < 5
  )
}

int recommitsForFile(File f) {
  result =
    count(Commit recommit |
      f = recommit.getAnAffectedFile() and
      exists(Commit prev | inRange(prev, recommit))
    )
}

from Module m
where exists(m.getMetrics().getNumberOfLinesOfCode())
select m, recommitsForFile(m.getFile())
