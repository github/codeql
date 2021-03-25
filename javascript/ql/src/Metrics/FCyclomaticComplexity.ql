/**
 * @name Average cyclomatic complexity of files
 * @description The average cyclomatic complexity of the functions in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 * @id js/cyclomatic-complexity-per-file
 */

import javascript

from File f, float n
where
  n =
    avg(Function fun, int toAvg |
      fun.getTopLevel().getFile() = f and toAvg = fun.getCyclomaticComplexity()
    |
      toAvg
    )
select f, n
