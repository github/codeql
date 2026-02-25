/**
 * @name Direct imports per file
 * @description The number of modules directly imported by this file.
 * @kind treemap
 * @id py/direct-imports-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags modularity
 *       maintainability
 */

import python
private import semmle.python.dataflow.new.internal.ImportResolution

from Module m, int n
where n = count(Module imp | ImportResolution::imports(m, imp))
select m, n
