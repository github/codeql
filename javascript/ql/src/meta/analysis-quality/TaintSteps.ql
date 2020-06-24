/**
 * @name Taint steps
 * @description The number of default taint steps.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/taint-steps
 */

import javascript
import CallGraphQuality

class BasicTaintConfiguration extends TaintTracking::Configuration {
  BasicTaintConfiguration() { this = "BasicTaintConfiguration" }
}

predicate relevantStep(DataFlow::Node pred, DataFlow::Node succ) {
  any(BasicTaintConfiguration cfg).isAdditionalFlowStep(pred, succ) and
  not pred.getFile() instanceof IgnoredFile and
  not succ.getFile() instanceof IgnoredFile
}

select projectRoot(), count(DataFlow::Node pred, DataFlow::Node succ | relevantStep(pred, succ))
