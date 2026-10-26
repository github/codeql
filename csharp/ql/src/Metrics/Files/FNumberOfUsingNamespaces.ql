/**
 * @name Number of using namespace directives
 * @description Files that use a large number of other namespaces might be brittle.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/using-namespaces-per-file
 */

import csharp

from SourceFile f, int n
where n = count(UsingNamespaceDirective u | u.getFile() = f)
select f, n order by n desc
