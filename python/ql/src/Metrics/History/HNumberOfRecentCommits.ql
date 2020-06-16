/**
 * @name Recent changes
 * @description Number of recent commits
 * @kind treemap
 * @id py/historical-number-of-recent-commits
 * @treemap.warnOn highValues
 * @metricType commit
 * @metricAggregate sum
 */

import python
import external.VCS

from Commit c
where c.daysToNow() <= 180 and not artificialChange(c)
select c.getRevisionName(), 1
