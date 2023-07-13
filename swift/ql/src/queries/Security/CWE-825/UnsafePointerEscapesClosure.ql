/**
 * @name Unsafe pointer escapes closure
 * @description Certain functions pass a low-level pointer to a closure. If this pointer outlives the closure, unpredictable results may occur.
 * @kind path-problem
 * @id swift/unsafe-pointer-escapes-closure
 * @tags security
 *       external/cwe/cwe-825
 */

import swift
import codeql.swift.dataflow.DataFlow
import Flow::PathGraph

module Config implements DataFlow::StateConfigSig {
  class FlowState = Callable;

  additional predicate isUnsafePointerCall(CallExpr call) {
    call.getStaticTarget()
    .hasName([
        "withUnsafeBytes(_:)", "withCString(_:)", "withUnsafeMutableBytes(_:)",
        "withContiguousMutableStorageIfAvailable(_:)", "withContiguousStorageIfAvailable(_:)",
        "withUTF8(_:)", "withUnsafeBufferPointer(_:)", "withUnsafeMutableBufferPointer(_:)",
        "withMemoryRebound(to:_:)", "withUnsafeTemporaryAllocation(of:capacity:_:)",
        "withUnsafeCurrentTask(body:)", "withCheckedContinuation(function:_:)"
      ])
  }


  additional predicate isUnsafePointerClosure(ClosureExpr expr) {
    exists(CallExpr call |
      isUnsafePointerCall(call) and
      expr = call.getAnArgument().getExpr()
    )
  }

  additional predicate isUnsafePointerFunction(Function f) {
    exists(CallExpr call |
      isUnsafePointerCall(call) and
      f.getAnAccess() = call.getAnArgument().getExpr()
    )
  }
  predicate isSource(DataFlow::Node node, FlowState state) {
      (
        isUnsafePointerClosure(state)
        or
        isUnsafePointerFunction(state)
      ) and
      state = node.(DataFlow::ParameterNode).getDeclaringFunction().getUnderlyingCallable()
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    (
      isUnsafePointerClosure(state)
      or
      isUnsafePointerFunction(state)
    )
    and
    (
      node.(DataFlow::InoutReturnNode).getParameter().getDeclaringFunction() = state
      or
      exists(ReturnStmt stmt |
        node.asExpr() = stmt.getResult() and
        stmt.getEnclosingCallable() = state
      )
    )
  }

  predicate isBarrier(DataFlow::Node node) { none() }

  predicate isBarrierIn(DataFlow::Node node) { none() }

  predicate isBarrierOut(DataFlow::Node node) { none() }

  predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) { 
    node2.asExpr().convertsFrom(node1.asExpr())
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    none()
  }

  int fieldFlowBranchLimit() { result = 2 }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    isSink(node, _) and
    c = any(c)
  }
}

module Flow = DataFlow::GlobalWithState<Config>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "This unsafe parameter may escape its invocation"
