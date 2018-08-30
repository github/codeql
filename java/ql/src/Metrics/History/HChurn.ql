/**
 * @name Churned lines
 * @description The number of churned lines of a file (by version control history).
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/vcs/churn-per-file
 */
import java
import external.VCS

from File f, int n
where n = sum(Commit entry, int churn |
        churn = entry.getRecentChurnForFile(f) and not artificialChange(entry) |
        churn
      )
select f, n
order by n desc
