private import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.Contents::Public
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as FlowSummaryImpl

cached
predicate defaultAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  FlowSummaryImpl::Private::Steps::summaryLocalStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode(), false)
}

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
cached
predicate defaultTaintSanitizer(DataFlow::Node node) {
  node instanceof DataFlow::VarAccessBarrier or
}
/**
 * Holds if default taint-tracking should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, ContentSet c) {
  exists(node) and
  c = ContentSet::promiseValue()
}
