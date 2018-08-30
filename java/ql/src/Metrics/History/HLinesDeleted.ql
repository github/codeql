/**
 * @name Deleted lines
 * @description The number of deleted lines of a file (by version control history).
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/vcs/deleted-lines-per-file
 */
import java
import external.VCS

from File f, int n
where n = sum(Commit entry, int churn | churn = entry.getRecentDeletionsForFile(f) and not artificialChange(entry) | churn)
select f, n
order by n desc
