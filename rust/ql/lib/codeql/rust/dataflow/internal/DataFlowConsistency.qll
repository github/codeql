import codeql.rust.dataflow.DataFlow::DataFlow as DataFlow
private import rust
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.internal.Splitting
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.rust.dataflow.internal.Node as Node
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, RustDataFlow> {
  predicate uniqueNodeLocationExclude(RustDataFlow::Node n) {
    // Exclude nodes where the missing location can be explained by the
    // underlying AST node not having a location.
    not exists(n.asExpr().getLocation())
  }

  predicate postWithInFlowExclude(RustDataFlow::Node n) {
    n instanceof Node::FlowSummaryNode
    or
    // We allow flow into post-update node for receiver expressions (from the
    // synthetic post receiever node).
    n.(Node::PostUpdateNode).getPreUpdateNode().asExpr() = any(Node::ReceiverNode r).getReceiver()
    or
    n.(Node::PostUpdateNode).getPreUpdateNode().asExpr() = getPostUpdateReverseStep(_, _)
    or
    FlowSummaryImpl::Private::Steps::sourceLocalStep(_, n, _)
  }

  predicate missingLocationExclude(RustDataFlow::Node n) { not exists(n.asExpr().getLocation()) }

  predicate multipleArgumentCallExclude(Node::ArgumentNode arg, DataFlowCall call) {
    // An argument such as `x` in `if !x { ... }` has two successors (and hence
    // two calls); one for each Boolean outcome of `x`.
    exists(CfgNodes::ExprCfgNode n |
      arg.isArgumentOf(call, _) and
      n = call.asCallCfgNode() and
      arg.asExpr().getASuccessor(any(ConditionalSuccessor c)).getASuccessor*() = n and
      n.getASplit() instanceof ConditionalCompletionSplitting::ConditionalCompletionSplit
    )
  }
}

import MakeConsistency<Location, RustDataFlow, RustTaintTracking, Input>
private import codeql.rust.dataflow.internal.ModelsAsData
