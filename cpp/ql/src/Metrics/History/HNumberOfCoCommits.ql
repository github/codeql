/**
 * @name Number of co-committed files
 * @description The average number of other files that are touched
 *              whenever a file is affected by a commit.
 * @kind treemap
 * @id cpp/historical-number-of-co-commits
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

int committedFiles(Commit commit) { result = count(commit.getAnAffectedFile()) }

from File f
where exists(f.getMetrics().getNumberOfLinesOfCode())
select f, avg(Commit commit | commit.getAnAffectedFile() = f | committedFiles(commit) - 1)
