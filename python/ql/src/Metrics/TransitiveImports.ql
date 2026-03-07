/**
 * @name Indirect imports per file
 * @description The number of modules imported by this file - either directly by an import statement,
 *              or indirectly (by being imported by an imported module).
 * @kind treemap
 * @id py/transitive-imports-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags modularity
 */

import python
private import semmle.python.dataflow.new.internal.ImportResolution

from Module m, int n
where n = count(Module imp | ImportResolution::imports+(m, imp) and imp != m)
select m, n
