/**
 * @name Number of classes per file
 * @kind treemap
 * @id cpp/number-of-classes-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 *       modularity
 */

import cpp

from File f, int n
where
  f.fromSource() and
  n = count(Class c | c.getAFile() = f)
select f, n order by n desc
