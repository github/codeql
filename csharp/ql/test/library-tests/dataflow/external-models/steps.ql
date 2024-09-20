import csharp
import DataFlow
import semmle.code.csharp.dataflow.internal.ExternalFlow
import ModelValidation
import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

query predicate summaryThroughStep(
  DataFlow::Node node1, DataFlow::Node node2, boolean preservesValue
) {
  FlowSummaryImpl::Private::Steps::summaryThroughStepValue(node1, node2, _) and
  preservesValue = true
  or
  FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2, _) and
  preservesValue = false
}

query predicate summaryGetterStep(DataFlow::Node arg, DataFlow::Node out, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryGetterStep(arg, c, out, _)
}

query predicate summarySetterStep(DataFlow::Node arg, DataFlow::Node out, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summarySetterStep(arg, c, out, _)
}
