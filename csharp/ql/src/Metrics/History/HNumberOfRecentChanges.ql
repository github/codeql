/**
 * @name Number of recent file changes
 * @description Number of recent commits to this file
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @id cs/vcs/recent-commits-per-file
 */
import csharp
import external.VCS

from File f, int n
where n = count(Commit e | e.getAnAffectedFile() = f and e.daysToNow() <= 180 and not artificialChange(e))
select f, n
order by n desc
