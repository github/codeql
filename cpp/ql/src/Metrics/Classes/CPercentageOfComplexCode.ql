/**
 * @name Percentage of complex code per class
 * @description The percentage of the code in a class that is part of
 *              a complex member function.
 * @kind treemap
 * @id cpp/percentage-of-complex-code-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags complexity
 */

import cpp

from Class c, int ccLoc, int loc
where
  c.fromSource() and
  ccLoc =
    sum(Function f |
      c.getACanonicalMemberFunction() = f and
      f.getMetrics().getCyclomaticComplexity() > 18
    |
      f.getMetrics().getNumberOfLinesOfCode()
    ) and
  loc =
    sum(Function f | c.getACanonicalMemberFunction() = f | f.getMetrics().getNumberOfLinesOfCode()) +
      c.getMetrics().getNumberOfMembers() and
  loc != 0
select c, (ccLoc * 100).(float) / loc as n order by n desc
