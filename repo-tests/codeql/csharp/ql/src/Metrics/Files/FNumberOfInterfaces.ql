/**
 * @name Number of interfaces
 * @description Files with more than one interface might cause problems when changed because the interfaces are poorly compartmentalized.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/interfaces-per-file
 */

import csharp

from SourceFile f, int n
where n = count(Interface i | i.getFile() = f and i.isSourceDeclaration())
select f, n order by n desc
