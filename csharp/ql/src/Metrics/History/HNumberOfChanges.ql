/**
 * @name Number of file-level changes
 * @description The number of file-level changes made (by version control history).
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg min max sum
 * @deprecated
 */
import csharp
import external.VCS

from File f
select f, count(Commit svn | f = svn.getAnAffectedFile() and not artificialChange(svn))
