/**
 * @name Nesting depth
 * @description The maximum number of nested statements (for example,
 *              `if`, `for`, `while`, etc.). Blocks are not counted.
 * @kind treemap
 * @id cpp/statement-nesting-depth
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags maintainability
 *       complexity
 */

import cpp

from MetricFunction f, int depth
where
  depth = f.getNestingDepth() and
  strictcount(f.getEntryPoint()) = 1
select f, depth order by depth desc
