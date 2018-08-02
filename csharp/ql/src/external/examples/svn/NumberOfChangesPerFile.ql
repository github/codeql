/**
 * @name Number of commits
 * @description Number of commits for each file
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @deprecated
 */
import csharp
import external.VCS

from File f, int n
where n = count(Commit svn | f = svn.getAnAffectedFile())
  and n > 1
select f, n
order by n desc
