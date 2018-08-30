/**
 * @name Number of recent file changes
 * @description Number of recent commits to a file (by version control history).
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @id java/vcs/recent-commits-per-file
 */
import java
import external.VCS

from File f, int n
where n = count(Commit e |
        e.getAnAffectedFile() = f and
        e.daysToNow() <= 180 and
        not artificialChange(e)
      )
select f, n
order by n desc
