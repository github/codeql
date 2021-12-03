/**
 * @name Resolvable call candidates
 * @description The number of (relevant) calls in the program.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id py/meta/resolvable-call-candidates
 */

import python
import CallGraphQuality

select projectRoot(), count(RelevantCall call)
