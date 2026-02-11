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

predicate relevantStep(DataFlow::Node pred, DataFlow::Node succ) {
  (
    TaintTracking::sharedTaintStep(pred, succ)
    or
    DataFlow::SharedFlowStep::step(pred, succ)
    or
    DataFlow::SharedFlowStep::loadStep(pred, succ, _)
    or
    DataFlow::SharedFlowStep::storeStep(pred, succ, _)
    or
    DataFlow::SharedFlowStep::loadStoreStep(pred, succ, _, _)
    or
    DataFlow::SharedFlowStep::loadStoreStep(pred, succ, _)
  ) and
  not pred.getFile() instanceof IgnoredFile and
  not succ.getFile() instanceof IgnoredFile
}

select projectRoot(), count(DataFlow::Node pred, DataFlow::Node succ | relevantStep(pred, succ))
