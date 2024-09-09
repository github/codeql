private import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.Contents::Public
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as FlowSummaryImpl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.BarrierGuards

cached
predicate defaultAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  TaintTracking::AdditionalTaintStep::step(node1, node2)
  or
  FlowSummaryPrivate::Steps::summaryLocalStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode(), false, _) // TODO: preserve 'model' parameter
  or
  // Convert steps into and out of array elements to plain taint steps
  FlowSummaryPrivate::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(),
    ContentSet::arrayElement(), node2.(FlowSummaryNode).getSummaryNode())
  or
  FlowSummaryPrivate::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(),
    ContentSet::arrayElement(), node2.(FlowSummaryNode).getSummaryNode())
  or
  // If the spread argument itself is tainted (not inside a content), store it into the dynamic argument array.
  exists(InvokeExpr invoke, Content c |
    node1 = TValueNode(invoke.getAnArgument().stripParens().(SpreadElement).getOperand()) and
    node2 = TDynamicArgumentStoreNode(invoke, c) and
    c.isUnknownArrayElement()
  )
  or
  // If the array in an .apply() call is tainted (not inside a content), box it in an array element (similar to the case above).
  exists(ApplyCallTaintNode taintNode |
    node1 = taintNode.getArrayNode() and
    node2 = taintNode
  )
}

predicate defaultAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2, string model) {
  defaultAdditionalTaintStep(node1, node2) and model = "" // TODO: set model
}

private class SanitizerGuardAdapter extends DataFlow::Node instanceof TaintTracking::AdditionalSanitizerGuardNode
{
  // Note: avoid depending on DataFlow::FlowLabel here as it will cause these barriers to be re-evaluated
  predicate blocksExpr(boolean outcome, Expr e) { super.sanitizes(outcome, e) }
}

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
cached
predicate defaultTaintSanitizer(DataFlow::Node node) {
  node instanceof DataFlow::VarAccessBarrier or
  node = MakeBarrierGuard<SanitizerGuardAdapter>::getABarrierNode()
}

/**
 * Holds if default taint-tracking should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, ContentSet c) {
  exists(node) and
  c = [ContentSet::promiseValue(), ContentSet::arrayElement()]
}
