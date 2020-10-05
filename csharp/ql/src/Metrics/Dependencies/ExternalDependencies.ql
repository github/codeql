/**
 * @deprecated
 * @name External dependencies
 * @description Count the number of dependencies a C# source file has on assembly files.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType externalDependency
 * @precision medium
 * @id cs/external-dependencies
 */

import semmle.code.csharp.metrics.ExternalDependencies

from File file, int num, string encodedDependency
where externalDependencies(file, encodedDependency, num)
select encodedDependency, num order by num desc
