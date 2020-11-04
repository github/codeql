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
    any(TaintTracking::AdditionalTaintStep dts).step(pred, succ)
    or
    any(DataFlow::AdditionalFlowStep cfg).step(pred, succ)
    or
    any(DataFlow::AdditionalFlowStep cfg).step(pred, succ, _, _)
    or
    any(DataFlow::AdditionalFlowStep cfg).loadStep(pred, succ, _)
    or
    any(DataFlow::AdditionalFlowStep cfg).storeStep(pred, succ, _)
    or
    any(DataFlow::AdditionalFlowStep cfg).loadStoreStep(pred, succ, _, _)
    or
    any(DataFlow::AdditionalFlowStep cfg).loadStoreStep(pred, succ, _)
  ) and
  not pred.getFile() instanceof IgnoredFile and
  not succ.getFile() instanceof IgnoredFile
}

select projectRoot(), count(DataFlow::Node pred, DataFlow::Node succ | relevantStep(pred, succ))
