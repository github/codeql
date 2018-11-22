/**
 * @name External dependencies
 * @description Count the number of dependencies a C/C++ source file has on external libraries.
 * @kind metric
 * @treemap.warnOn highValues
 * @metricType externalDependency
 * @precision medium
 * @id cpp/external-dependencies
 */

import ExternalDependencies

from File file, int num, string encodedDependency
where
  encodedDependencies(file, encodedDependency, num)
select
  encodedDependency, num
order by num desc
