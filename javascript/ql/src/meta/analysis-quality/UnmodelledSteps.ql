/**
 * @name Unmodeled step
 * @description A potential step from an argument to a return that has no data/taint step.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/unmodeled-step
 */

import javascript
private import Expressions.ExprHasNoEffect
import meta.internal.TaintMetrics

predicate unmodeled(API::Node callee, API::CallNode call, DataFlow::Node pred, DataFlow::Node succ) {
  callee.getACall() = call and
  pred = call.getAnArgument() and
  succ = call and
  not inVoidContext(succ.asExpr()) and // void calls are irrelevant
  not call.getAnArgument() = relevantTaintSink() and // calls with sinks are considered modeled
  // we assume taint to the return value means the call is modeled
  not (
    TaintTracking::sharedTaintStep(_, succ)
    or
    DataFlow::SharedFlowStep::step(_, succ)
    or
    DataFlow::SharedFlowStep::loadStep(_, succ, _)
    or
    DataFlow::SharedFlowStep::storeStep(_, succ, _)
    or
    DataFlow::SharedFlowStep::loadStoreStep(_, succ, _, _)
    or
    DataFlow::SharedFlowStep::loadStoreStep(_, succ, _)
  ) and
  not pred.getFile() instanceof IgnoredFile and
  not succ.getFile() instanceof IgnoredFile
}

select projectRoot(), count(DataFlow::Node pred, DataFlow::Node succ | unmodeled(_, _, pred, succ))
