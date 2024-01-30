import csharp
import DataFlow
import semmle.code.csharp.dataflow.internal.ExternalFlow
import ModelValidation
import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

/**
 * Emulate that methods with summaries do not have a body.
 * This is relevant for dataflow analysis using summaries with a generated like
 * provenance as generated summaries are only applied, if a
 * callable does not have a body.
 */
private class StepArgQualGenerated extends Method {
  StepArgQualGenerated() {
    exists(string name |
      this.hasFullyQualifiedName("My.Qltest", "C", name) and name.matches("StepArgQualGenerated%")
    )
  }

  override predicate hasBody() { none() }
}

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
