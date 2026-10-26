/**
 * @name Average cyclomatic complexity of files
 * @description The average cyclomatic complexity of the methods in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/average-cyclomatic-complexity-per-file
 * @tags testability
 *       complexity
 */

import java

from CompilationUnit f, float n
where
  n =
    avg(Callable c, int toAvg |
      c.getCompilationUnit() = f and toAvg = c.getMetrics().getCyclomaticComplexity()
    |
      toAvg
    )
select f, n
