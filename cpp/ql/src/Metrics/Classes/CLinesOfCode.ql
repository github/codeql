/**
 * @name Lines of code per class
 * @description The number of lines of code in a class.
 * @kind treemap
 * @id cpp/lines-of-code-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Class c, int n
where
  c.fromSource() and
  n =
    c.getMetrics().getNumberOfMembers() +
      sum(Function f | c.getACanonicalMemberFunction() = f | f.getMetrics().getNumberOfLinesOfCode())
select c, n order by n desc
