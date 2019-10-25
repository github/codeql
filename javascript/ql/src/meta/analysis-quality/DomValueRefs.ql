/**
 * @name DOM value references
 * @description The number of references to a DOM value.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/dom-value-refs
 */

import javascript
import CallGraphQuality

select projectRoot(), count(DOM::domValueRef())
