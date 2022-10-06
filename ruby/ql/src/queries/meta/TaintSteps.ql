/**
 * @name Taint steps
 * @description The number of default taint steps.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id rb/meta/taint-steps
 */

import ruby
import internal.TaintMetrics
import codeql.ruby.dataflow.internal.TaintTrackingPublic

predicate relevantStep(DataFlow::Node pred, DataFlow::Node succ) { localTaintStep(pred, succ) }

select projectRoot(), count(DataFlow::Node pred, DataFlow::Node succ | relevantStep(pred, succ))
