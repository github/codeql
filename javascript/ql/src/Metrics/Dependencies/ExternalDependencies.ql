/**
 * @deprecated
 * @name External dependencies
 * @description Count the number of dependencies a JavaScript source file has on
 *              NPM packages or framework libraries.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType externalDependency
 * @precision medium
 * @id js/external-dependencies
 */

import ExternalDependencies

from File f, Dependency dep, string entity, int n
where externalDependencies(f, dep, entity, n)
select entity, n order by n desc
