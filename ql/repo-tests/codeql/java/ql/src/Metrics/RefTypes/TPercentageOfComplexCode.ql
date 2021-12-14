/**
 * @name Percentage of complex code in types
 * @description The percentage of a type's code that is part of a complex method.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/complex-code-ratio-per-type
 * @tags testability
 *       complexity
 */

import java

pragma[noopt]
int complexCallableLines(MetricCallable c, RefType owner) {
  c.getDeclaringType() = owner and
  exists(int cc | c.getCyclomaticComplexity() = cc and cc > 18) and
  result = c.getNumberOfLinesOfCode()
}

from MetricRefType t, int ccLoc, int loc
where
  t.fromSource() and
  not t instanceof GeneratedClass and
  ccLoc = sum(Callable c, int cLoc | cLoc = complexCallableLines(c, t) | cLoc) and
  loc = t.getNumberOfLinesOfCode() and
  loc != 0
select t, (ccLoc.(float) * 100) / loc as n order by n desc
