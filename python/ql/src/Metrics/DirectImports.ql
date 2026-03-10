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
private import LegacyPointsTo

from ModuleValue m, int n
where n = count(ModuleValue imp | imp = m.getAnImportedModule())
select m.getScope(), n
