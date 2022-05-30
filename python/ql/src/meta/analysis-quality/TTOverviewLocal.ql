// this version can be run locally, which will allow you to dig into shared/missing/new
// results without running a new query. (but does not work for MRVA).
import python
import CallGraphQuality
import ArgumentPassing

query predicate call_graph_shared(CallNode call, Target target) {
  target.isRelevant() and
  call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
  call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
}

query predicate call_graph_new(CallNode call, Target target) {
  target.isRelevant() and
  not call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
  call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
}

query predicate call_graph_missing(CallNode call, Target target) {
  target.isRelevant() and
  call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
  not call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
}

query predicate argument_passing_shared(ControlFlowNode arg, Parameter param) {
  PointsToArgumentPassing::argumentPassing(arg, param) and
  TypeTrackingArgumentPassing::argumentPassing(arg, param)
}

query predicate argument_passing_new(ControlFlowNode arg, Parameter param) {
  not PointsToArgumentPassing::argumentPassing(arg, param) and
  TypeTrackingArgumentPassing::argumentPassing(arg, param)
}

query predicate argument_passing_missing(ControlFlowNode arg, Parameter param) {
  PointsToArgumentPassing::argumentPassing(arg, param) and
  not TypeTrackingArgumentPassing::argumentPassing(arg, param)
}

from string part, string tag, int c
where
  part = "call-graph" and
  (
    tag = "SHARED" and
    c = count(CallNode call, Target target | call_graph_shared(call, target))
    or
    tag = "NEW" and
    c = count(CallNode call, Target target | call_graph_new(call, target))
    or
    tag = "MISSING" and
    c = count(CallNode call, Target target | call_graph_missing(call, target))
  )
  or
  part = "argument-passing" and
  (
    tag = "SHARED" and
    c = count(ControlFlowNode arg, Parameter param | argument_passing_shared(arg, param))
    or
    tag = "NEW" and
    c = count(ControlFlowNode arg, Parameter param | argument_passing_new(arg, param))
    or
    tag = "MISSING" and
    c = count(ControlFlowNode arg, Parameter param | argument_passing_missing(arg, param))
  )
select part + " | " + tag as msg, c order by msg desc
