/**
 * @name Modules
 * @description The number of modules in the snapshot.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/modules
 */

import javascript
import CallGraphQuality

select projectRoot(), count(Module mod)
