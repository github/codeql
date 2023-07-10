import swift
import codeql.swift.dataflow.DataFlow
import Flow::PathGraph

module Conf implements DataFlow::StateConfigSig {
  class FlowState = Callable;

  predicate isSource(DataFlow::Node node, FlowState state) {
    // parameter of closure or function passed to withUnsafeBytes
    exists(
      CallExpr call |
      call.getStaticTarget().hasName("withUnsafeBytes(_:)") and
      state = node.(DataFlow::ParameterNode).getDeclaringFunction().getUnderlyingCallable() and
      (
        // if the declaring callable is a closure expr
        state = call.getArgument(0).getExpr()
        or
        state.(Function).getAnAccess() = call.getArgument(0).getExpr()
      )
    )
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    node.(DataFlow::InoutReturnNode).getParameter().getDeclaringFunction() = state
    or
    exists(ReturnStmt stmt |
      node.asExpr() = stmt.getResult() and
      stmt.getEnclosingCallable() = state
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    none()
  }
  predicate isBarrierIn(DataFlow::Node node) {
    none()
  }
  predicate isBarrierOut(DataFlow::Node node) {
    none()
  }
  predicate isBarrier(DataFlow::Node node, FlowState state) {
    none()
  }
  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) { none() }
  predicate isAdditionalFlowStep(DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2) {
    none()
  }

  int fieldFlowBranchLimit() { result = 2 }
  
  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) { 
    isSink(node, _) and
    c = any(DataFlow::ContentSet set)
  }
}

module Flow = DataFlow::GlobalWithState<Conf>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "This unsafe parameter may escape its invocation"
