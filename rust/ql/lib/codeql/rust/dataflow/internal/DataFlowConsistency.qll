import codeql.rust.dataflow.DataFlow::DataFlow as DataFlow
private import rust
private import codeql.rust.dataflow.internal.DataFlowImpl
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
  }

  predicate missingLocationExclude(RustDataFlow::Node n) { not exists(n.asExpr().getLocation()) }
}

import MakeConsistency<Location, RustDataFlow, RustTaintTracking, Input>
