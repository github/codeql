private import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.Contents::Public
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as FlowSummaryImpl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.BarrierGuards
private import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2

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

bindingset[node]
pragma[inline_late]
private BasicBlock getBasicBlockFromSsa2(Ssa2::Node node) {
  result = node.(Ssa2::ExprNode).getExpr().getBasicBlock()
  or
  node.(Ssa2::SsaInputNode).isInputInto(_, result)
}

/**
 * Holds if `node` should act as a taint barrier, as it occurs after a variable has been checked to be falsy.
 *
 * For example:
 * ```js
 * if (!x) {
 *   use(x); // <-- 'x' is a varAccessBarrier
 * }
 * ```
 *
 * This is particularly important for ensuring that query-specific barrier guards work when they
 * occur after a truthiness-check:
 * ```js
 * if (x && !isSafe(x)) {
 *   throw new Error()
 * }
 * use(x); // both inputs to the phi-read for 'x' are blocked (one by varAccessBarrier, one by isSafe(x))
 * ```
 */
private predicate varAccessBarrier(DataFlow::Node node) {
  exists(ConditionGuardNode guard, Ssa2::ExprNode nodeFrom, Ssa2::Node nodeTo |
    guard.getOutcome() = false and
    guard.getTest().(VarAccess) = nodeFrom.getExpr() and
    Ssa2::localFlowStep(_, nodeFrom, nodeTo, true) and
    guard.dominates(getBasicBlockFromSsa2(nodeTo)) and
    node = getNodeFromSsa2(nodeTo)
  )
}

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
cached
predicate defaultTaintSanitizer(DataFlow::Node node) {
  node instanceof DataFlow::VarAccessBarrier or
  varAccessBarrier(node) or
  node = MakeBarrierGuard<TaintTracking::AdditionalBarrierGuard>::getABarrierNode()
}

/**
 * Holds if default taint-tracking should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, ContentSet c) {
  exists(node) and
  c = [ContentSet::promiseValue(), ContentSet::arrayElement()] and
  // Optional steps are added through isAdditionalFlowStep but we don't want the implicit reads
  not optionalStep(node, _, _)
}

private predicate isArgumentToResolvedCall(DataFlow::Node arg) {
  exists(DataFlowCall c |
    exists(viableCallable(c)) and
    isArgumentNode(arg, c, _)
  )
}

predicate speculativeTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::CallNode call |
    node1 = call.getAnArgument() and
    node2 = call and
    // A given node can appear as argument in more than one call. For example `x` in `fn.call(x)` is
    // is argument 0 of the `fn.call` call, but also the receiver of a reflective call to `fn`.
    // It is thus not enough to check if `call` has a known target; we nede to ensure that none of the calls
    // involving `node1` have a known target.
    not isArgumentToResolvedCall(node1)
  )
}
