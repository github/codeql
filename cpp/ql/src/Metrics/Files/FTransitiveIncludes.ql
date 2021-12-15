/**
 * @name Indirect includes per file
 * @description The number of files included by the
 *              pre-processor - either directly by an `#include`
 *              directive, or indirectly (by being included by an
 *              included file).
 * @kind treemap
 * @id cpp/transitive-includes-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import cpp

from File f, int n
where
  f.fromSource() and
  n = count(File g | g = f.getAnIncludedFile+())
select f, n
