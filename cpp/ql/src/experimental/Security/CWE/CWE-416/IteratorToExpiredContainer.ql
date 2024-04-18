/**
 * @name Iterator to expired container
 * @description Using an iterator owned by a container whose lifetime has expired may lead to unexpected behavior.
 * @kind problem
 * @precision high
 * @id cpp/iterator-to-expired-container
 * @problem.severity warning
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

/**
 * A configuration to track flow from a temporary variable to the qualifier of
 * a destructor call
 */
module TempToDestructorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asInstruction().(VariableAddressInstruction).getIRVariable() instanceof IRTempVariable
  }

  predicate isSink(DataFlow::Node sink) { tempToDestructorSink(sink, _) }
}

module TempToDestructorFlow = DataFlow::Global<TempToDestructorConfig>;

/** Holds if `pun` is the post-update node of the qualifier of `Call`. */
private predicate isPostUpdateOfQualifier(CallInstruction call, DataFlow::PostUpdateNode pun) {
  call.getThisArgumentOperand() = pun.getPreUpdateNode().asOperand()
}

/**
 * Gets a `DataFlow::Node` that represents a temporary that will be destroyed
 * by a call to a destructor, or a `DataFlow::Node` that will transitively be
 * destroyed by a call to a destructor.
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
DataFlow::Node getADestroyedNode() {
  exists(DataFlow::Node n | TempToDestructorFlow::flowTo(n) |
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
  )
}

predicate destroyedToBeginSink(DataFlow::Node sink, FunctionCall fc) {
  exists(CallInstruction call |
    call = sink.asOperand().(ThisArgumentOperand).getCall() and
    fc = call.getUnconvertedResultExpression() and
    call.getStaticCallTarget() instanceof BeginOrEndFunction
  )
}

/**
 * Flow from any destroyed object to the qualifier of a `begin` or `end` call
 */
module DestroyedToBeginConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = getADestroyedNode() }

  predicate isSink(DataFlow::Node sink) { destroyedToBeginSink(sink, _) }

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

module DestroyedToBeginFlow = DataFlow::Global<DestroyedToBeginConfig>;

from DataFlow::Node source, DataFlow::Node sink, FunctionCall beginOrEnd
where DestroyedToBeginFlow::flow(source, sink) and destroyedToBeginSink(sink, beginOrEnd)
select source, "This object is destroyed before $@ is called.", beginOrEnd, beginOrEnd.toString()
