/**
 * @name Number of co-committed files
 * @description The average number of other files that are touched whenever a file is affected by a commit
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max
 * @id cs/vcs/co-commits-per-file
 */

import csharp
import external.VCS

int committedFiles(Commit commit) { result = count(commit.getAnAffectedFile()) }

from File f
select f, avg(Commit commit | commit.getAnAffectedFile() = f | committedFiles(commit) - 1)
