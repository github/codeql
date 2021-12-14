/**
 * @name Iteration depth
 * @description The maximum number of nested loops in each function.
 * @kind treemap
 * @id cpp/iteration-nesting-depth-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags maintainability
 *       complexity
 */

import cpp

int iterationDepth(Stmt l) { result = count(Loop other | l.getParent*() = other) }

from Function f, int depth
where
  depth = max(Stmt s | s.getEnclosingFunction() = f | iterationDepth(s)) and
  strictcount(f.getEntryPoint()) = 1
select f, depth order by depth desc
