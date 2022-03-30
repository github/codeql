/**
 * @name Indirect source includes per file
 * @description The number of source files included by the
 *              pre-processor - either directly by an `#include`
 *              directive, or indirectly (by being included by an
 *              included file). This metric excludes included files
 *              that aren't part of the main code base (like system
 *              headers).
 * @kind treemap
 * @id cpp/transitive-source-includes-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import cpp

predicate isInCodebase(File f) {
  exists(string prefix | sourceLocationPrefix(prefix) |
    f.getAbsolutePath().prefix(prefix.length()) = prefix
  )
}

from File f, int n
where
  f.fromSource() and
  n = count(File g | g = f.getAnIncludedFile+() and isInCodebase(g))
select f, n
