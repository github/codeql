import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.internal.TaintTrackingUtil
import semmle.code.java.dataflow.internal.DataFlowNodes::Private
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

predicate taintFlowThrough(DataFlow::ParameterNode p) {
  exists(ReturnNode ret | localTaint(p, ret))
}

predicate taintFlowUpdate(DataFlow::ParameterNode p1, DataFlow::ParameterNode p2) {
  exists(DataFlow::PostUpdateNode ret | localTaint(p1, ret) | ret.getPreUpdateNode() = p2)
}

from DataFlow::Node src, DataFlow::Node sink
where
  (
    localAdditionalTaintStep(src, sink) or
    FlowSummaryImpl::Private::Steps::summaryThroughStep(src, sink, false)
  ) and
  not FlowSummaryImpl::Private::Steps::summaryLocalStep(src, sink, false) and
  not FlowSummaryImpl::Private::Steps::summaryReadStep(src, _, sink) and
  not FlowSummaryImpl::Private::Steps::summaryStoreStep(src, _, sink)
  or
  exists(ArgumentNode arg, MethodAccess call, DataFlow::ParameterNode p, int i |
    src = arg and
    p.isParameterOf(call.getMethod().getSourceDeclaration(), i) and
    arg.argumentOf(any(DataFlowCall c | c.asCall() = call), i)
  |
    sink.asExpr() = call and
    taintFlowThrough(p)
    or
    exists(DataFlow::ParameterNode p2, int j |
      sink.(DataFlow::PostUpdateNode)
          .getPreUpdateNode()
          .(ArgumentNode)
          .argumentOf(any(DataFlowCall c | c.asCall() = call), j) and
      taintFlowUpdate(p, p2) and
      p2.isParameterOf(_, j)
    )
  )
select src, sink
