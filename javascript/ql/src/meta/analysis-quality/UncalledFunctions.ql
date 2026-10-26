/**
 * @name Uncalled functions
 * @description The number of functions for which no call site could be found.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/uncalled-functions
 */

import javascript
import CallGraphQuality

select projectRoot(), count(FunctionWithoutCallers f)
