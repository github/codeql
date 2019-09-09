/**
 * @name Number of file-level changes
 * @description The number of file-level changes made (by version
 *              control history).
 * @kind treemap
 * @id cpp/historical-number-of-changes
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @tags external-data
 * @deprecated
 */

import cpp
import external.VCS

from File f
where exists(f.getMetrics().getNumberOfLinesOfCode())
select f, count(Commit svn | f = svn.getAnAffectedFile() and not artificialChange(svn))
