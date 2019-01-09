/**
 * @name Recent activity
 * @description Number of recent commits to this file
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @deprecated
 */

import csharp
import external.VCS

from File f, int n
where
  n = count(Commit e | e.getAnAffectedFile() = f and e.isRecent()) and
  n > 0
select f, n order by n desc
