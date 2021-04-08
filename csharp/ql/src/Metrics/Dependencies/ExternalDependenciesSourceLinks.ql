/**
 * @deprecated
 * @name External dependency source links
 * @kind source-link
 * @metricType externalDependency
 * @id cs/dependency-source-links
 */

import semmle.code.csharp.metrics.ExternalDependencies

from File file, int num, string encodedDependency
where externalDependencies(file, encodedDependency, num)
select encodedDependency, file
