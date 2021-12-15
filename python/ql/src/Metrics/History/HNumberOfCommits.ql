/**
 * @name Number of commits
 * @description Number of commits
 * @kind treemap
 * @id py/historical-number-of-commits
 * @treemap.warnOn highValues
 * @metricType commit
 * @metricAggregate sum
 */

import python
import external.VCS

from Commit c
where not artificialChange(c)
select c.getRevisionName(), 1
