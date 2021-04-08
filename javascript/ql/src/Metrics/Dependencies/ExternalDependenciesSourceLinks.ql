/**
 * @deprecated
 * @name External dependency source links
 * @kind source-link
 * @metricType externalDependency
 * @id js/dependency-source-links
 */

import ExternalDependencies

from File f, string entity
where externalDependencies(f, _, entity, _)
select entity, f
