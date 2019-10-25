/**
 * @name Called functions
 * @description The number of functions for which a call site was found.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/called-functions
 */

import javascript
import CallGraphQuality

select projectRoot(), count(FunctionWithCallers f)
