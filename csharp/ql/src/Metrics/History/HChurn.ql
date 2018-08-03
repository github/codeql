/**
 * @name Churned lines
 * @description Number of churned lines, across the revision history in the database.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/vcs/churn-per-file
 */
import csharp
import external.VCS

from File f, int n
where n = sum(Commit entry, int churn | churn = entry.getRecentChurnForFile(f) and not artificialChange(entry) | churn)
select f, n
order by n desc
