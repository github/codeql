import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import ModelValidation
import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

query predicate summaryThroughStep(
  DataFlow::Node node1, DataFlow::Node node2, boolean preservesValue
) {
  FlowSummaryImpl::Private::Steps::summaryThroughStepValue(node1, node2,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc)) and
  preservesValue = true
  or
  FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc)) and
  preservesValue = false
}

query predicate summaryGetterStep(DataFlow::Node arg, DataFlow::Node out, Content c) {
  FlowSummaryImpl::Private::Steps::summaryGetterStep(arg, c, out,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc))
}

query predicate summarySetterStep(DataFlow::Node arg, DataFlow::Node out, Content c) {
  FlowSummaryImpl::Private::Steps::summarySetterStep(arg, c, out,
    any(DataFlowDispatch::DataFlowSummarizedCallable sc))
}
