/**
 * @name Number of statements per class
 * @description The number of statements in the member functions of a class.
 *              For template functions, only the statements in the template
 *              itself, not in the instantiations, are counted.
 * @kind treemap
 * @id cpp/statements-per-type
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Class c, int n
where
  c.fromSource() and
  n = count(Stmt s | s.getEnclosingFunction() = c.getACanonicalMemberFunction())
select c, n
