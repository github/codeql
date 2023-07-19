/**
 * @name Invalid pointer dereference
 * @description Dereferencing a pointer that points past it allocation is undefined behavior
 *              and may lead to security vulnerabilities.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/invalid-pointer-deref
 * @tags reliability
 *       security
 *       experimental
 *       external/cwe/cwe-119
 *       external/cwe/cwe-125
 *       external/cwe/cwe-193
 *       external/cwe/cwe-787
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import FinalFlow::PathGraph
import semmle.code.cpp.security.InvalidPointerDereference.AllocationToInvalidPointer
import semmle.code.cpp.security.InvalidPointerDereference.InvalidPointerToDereference

/**
 * A configuration that represents the full dataflow path all the way from
 * the allocation to the dereference. We need this final dataflow traversal
 * to ensure that the transition from the sink in `AllocToInvalidPointerConfig`
 * to the source in `InvalidPointerToDerefFlow` did not make us construct an
 * infeasible path (which can happen since the transition from one configuration
 * to the next does not preserve information about call contexts).
 */
module FinalConfig implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional TInitial() or
    additional TPointerArith(PointerArithmeticInstruction pai) {
      operationIsOffBy(_, pai, _, _, _, _, _)
    }

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = TInitial() and
    operationIsOffBy(source, _, _, _, _, _, _)
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    exists(PointerArithmeticInstruction pai |
      operationIsOffBy(_, pai, _, _, _, sink, _) and
      state = TPointerArith(pai)
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // A step from the left-hand side of a pointer-arithmetic operation that has been
    // identified as creating an out-of-bounds pointer to the result of the pointer-arithmetic
    // operation.
    exists(PointerArithmeticInstruction pai |
      pointerAddInstructionHasBounds(_, pai, node1, _) and
      operationIsOffBy(_, pai, node2, _, _, _, _) and
      state1 = TInitial() and
      state2 = TPointerArith(pai)
    )
    or
    // A step from an out-of-bounds address to the operation (which is either a `StoreInstruction`
    // or a `LoadInstruction`) that dereferences the address.
    // This step exists purely for aesthetic reasons: we want the alert to be placed at the operation
    // that causes the dereference, and not at the address that flows into the operation.
    state1 = state2 and
    exists(PointerArithmeticInstruction pai |
      state1 = TPointerArith(pai) and
      operationIsOffBy(_, pai, _, node1, _, node2, _)
    )
  }
}

module FinalFlow = DataFlow::GlobalWithState<FinalConfig>;

/**
 * Holds if `source` is an allocation that flows into the left-hand side of `pai`, which produces an out-of-bounds
 * pointer that flows into an address that is dereferenced by `sink` (which is either a `LoadInstruction` or a
 * `StoreInstruction`). The end result is that `sink` writes to an address that is off-by-`delta` from the end of
 * the allocation. The string `operation` describes whether the `sink` is a load or a store (which is then used
 * to produce the alert message).
 *
 * Note that multiple `delta`s can exist for a given `(source, pai, sink)` triplet.
 */
predicate hasFlowPath(
  FinalFlow::PathNode source, FinalFlow::PathNode sink, PointerArithmeticInstruction pai,
  string operation, int delta
) {
  FinalFlow::flowPath(source, sink) and
  operationIsOffBy(source.getNode(), pai, _, _, operation, sink.getNode(), delta) and
  sink.getState() = FinalConfig::TPointerArith(pai)
}

from
  FinalFlow::PathNode source, FinalFlow::PathNode sink, int k, string kstr,
  PointerArithmeticInstruction pai, string operation, Expr offset, DataFlow::Node n
where
  k = min(int cand | hasFlowPath(source, sink, pai, operation, cand)) and
  offset = pai.getRight().getUnconvertedResultExpression() and
  n = source.getNode() and
  if k = 0 then kstr = "" else kstr = " + " + k
select sink.getNode(), source, sink,
  "This " + operation + " might be out of bounds, as the pointer might be equal to $@ + $@" + kstr +
    ".", n, n.toString(), offset, offset.toString()
