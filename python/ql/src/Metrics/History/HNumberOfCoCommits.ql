/**
 * @name Number of co-committed files
 * @description The average number of other files that are touched whenever a file is affected by a commit
 * @kind treemap
 * @id py/historical-number-of-co-commits
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 */

import python
import external.VCS
private import LegacyPointsTo

int committedFiles(Commit commit) { result = count(commit.getAnAffectedFile()) }

from ModuleMetrics m
where exists(m.getNumberOfLinesOfCode())
select m,
  avg(Commit commit, int toAvg |
    commit.getAnAffectedFile() = m.getFile() and toAvg = committedFiles(commit) - 1
  |
    toAvg
  )
