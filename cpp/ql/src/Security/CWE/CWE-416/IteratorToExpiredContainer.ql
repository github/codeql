/**
 * @name Iterator to expired container
 * @description Using an iterator owned by a container whose lifetime has expired may lead to unexpected behavior.
 * @kind problem
 * @precision high
 * @id cpp/iterator-to-expired-container
 * @problem.severity warning
 * @security-severity 8.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 *       external/cwe/cwe-664
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.models.implementations.StdContainer
import semmle.code.cpp.models.implementations.StdMap
import semmle.code.cpp.models.implementations.Iterator

private predicate tempToDestructorSink(DataFlow::Node sink, CallInstruction call) {
  call = sink.asOperand().(ThisArgumentOperand).getCall() and
  call.getStaticCallTarget() instanceof Destructor
}

/** Holds if `pun` is the post-update node of the qualifier of `Call`. */
private predicate isPostUpdateOfQualifier(CallInstruction call, DataFlow::PostUpdateNode pun) {
  call.getThisArgumentOperand() = pun.getPreUpdateNode().asOperand()
}

/**
 * Gets a `DataFlow::Node` that represents a temporary that will be destroyed
 * by a call to a destructor when `n` is destroyed, or a `DataFlow::Node` that
 * will transitively be destroyed by a call to a destructor.
 *
 * For the latter case, consider something like:
 * ```
 * std::vector<std::vector<int>> get_2d_vector();
 * auto& v = get_2d_vector()[0];
 * ```
 * Given the above, this predicate returns the node corresponding
 * to `get_2d_vector()[0]` since the temporary `get_2d_vector()` gets
 * destroyed by a call to `std::vector<std::vector<int>>::~vector`,
 * and thus the result of `get_2d_vector()[0]` is also an invalid reference.
 */
DataFlow::Node getADestroyedNode(DataFlow::Node n) {
  // Case 1: The pointer that goes into the destructor call is destroyed
  exists(CallInstruction destructorCall |
    tempToDestructorSink(n, destructorCall) and
    isPostUpdateOfQualifier(destructorCall, result)
  )
  or
  // Case 2: Anything that was derived from the temporary that is now destroyed
  // is also destroyed.
  exists(CallInstruction call |
    result.asInstruction() = call and
    DataFlow::localFlow(DataFlow::operandNode(call.getThisArgumentOperand()), n)
  |
    call.getStaticCallTarget() instanceof StdSequenceContainerAt or
    call.getStaticCallTarget() instanceof StdMapAt
  )
}

predicate destroyedToBeginSink(DataFlow::Node sink) {
  exists(CallInstruction call |
    call = sink.asOperand().(ThisArgumentOperand).getCall() and
    call.getStaticCallTarget() instanceof BeginOrEndFunction
  )
}

/**
 * Holds if `node1` is the node corresponding to a qualifier of a destructor
 * call and `node2` is a node that is destroyed as a result of `node1` being
 * destroyed.
 */
private predicate qualifierToDestroyed(DataFlow::Node node1, DataFlow::Node node2) {
  tempToDestructorSink(node1, _) and
  node2 = getADestroyedNode(node1)
}

/**
 * A configuration to track flow from a destroyed node to a qualifier of
 * a `begin` or `end` function call.
 *
 * This configuration exists to prevent a cartesian product between all sinks and
 * all states in `Config::isSink`.
 */
module Config0 implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { qualifierToDestroyed(_, source) }

  predicate isSink(DataFlow::Node sink) { destroyedToBeginSink(sink) }
}

module Flow0 = DataFlow::Global<Config0>;

/**
 * A configuration to track flow from a temporary variable to the qualifier of
 * a destructor call, and subsequently to a qualifier of a call to `begin` or
 * `end`.
 */
module Config implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional TempToDestructor() or
    additional DestroyedToBegin(DataFlow::Node n) {
      any(Flow0::PathNode pn | pn.isSource()).getNode() = n
    }

  /**
   * Holds if `sink` is a qualifier to a call to `begin`, and `mid` is an
   * object that is destroyed.
   */
  private predicate relevant(DataFlow::Node mid, DataFlow::Node sink) { Flow0::flow(mid, sink) }

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.asInstruction().(VariableAddressInstruction).getIRVariable() instanceof IRTempVariable and
    state = TempToDestructor()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 = TempToDestructor() and
    state2 = DestroyedToBegin(node2) and
    qualifierToDestroyed(node1, node2)
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    exists(DataFlow::Node mid |
      relevant(mid, sink) and
      state = DestroyedToBegin(mid)
    )
  }

  DataFlow::FlowFeature getAFeature() {
    // By blocking argument-to-parameter flow we ensure that we don't enter a
    // function body where the temporary outlives anything inside the function.
    // This prevents false positives in cases like:
    // ```cpp
    // void foo(const std::vector<int>& v) {
    //   for(auto x : v) { ... } // this is fine since v outlives the loop
    // }
    // ...
    // foo(create_temporary())
    // ```
    result instanceof DataFlow::FeatureHasSinkCallContext
  }
}

module Flow = DataFlow::GlobalWithState<Config>;

from Flow::PathNode source, Flow::PathNode sink, DataFlow::Node mid
where
  Flow::flowPath(source, sink) and
  destroyedToBeginSink(sink.getNode()) and
  sink.getState() = Config::DestroyedToBegin(mid)
select mid, "This object is destroyed at the end of the full-expression."
