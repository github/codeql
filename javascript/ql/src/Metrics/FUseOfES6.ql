/**
 * @name Use of ECMAScript 2015 (and later) features in files
 * @kind treemap
 * @description Measures the number of uses of language features introduced in
 *              ECMAScript 2015 or later in files.
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id js/es20xx-features-per-file
 */

import ES20xxFeatures

from File f
select f, count(ASTNode nd | nd.getFile() = f and isES20xxFeature(nd, _, _)) as n order by n desc
