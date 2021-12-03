/**
 * @name Resolvable call site candidates
 * @description The number of non-external calls in the program.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/resolvable-call-candidates
 */

import javascript
import CallGraphQuality

select projectRoot(), count(RelevantInvoke call)
