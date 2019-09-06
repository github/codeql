/**
 * @name Called function candidates
 * @description The number of functions for which finding call sites is relevant
 *               for analysis quality.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/called-function-candidates
 */

import javascript
import CallGraphQuality

select projectRoot(), count(RelevantFunction f)
