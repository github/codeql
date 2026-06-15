/**
 * @name Invalid pointer dereference
 * @description Dereferencing an out-of-bounds pointer is undefined behavior and may lead to security vulnerabilities.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision medium
 * @id cpp/invalid-pointer-deref
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-125
 *       external/cwe/cwe-193
 *       external/cwe/cwe-787
 */

/*
 * High-level description of the query:
 *
 * The goal of this query is to identify issues such as:
 * ```cpp
 * 1. int* base = new int[size];
 * 2. int* end = base + size;
 * 3. for(int* p = base; p <= end; ++p) {
 * 4.   *p = 0; // BUG: Should have been bounded by `p < end`.
 * 5. }
 * ```
 * In order to do this, we split the problem into three subtasks:
 * 1. First, we find flow from `new int[size]` to `base + size`.
 * 2. Then, we find flow from `base + size` to `end` (on line 3).
 * 3. Finally, we use range-analysis to find a write to (or read from) a pointer that may be greater than or equal to `end`.
 *
 * Step 1 is implemented in `AllocationToInvalidPointer.qll`, and step 2 is implemented by
 * `InvalidPointerToDereference.qll`. See those files for the description of these.
 *
 * This file imports both libraries and defines a final dataflow configuration that constructs the full path from
 * the allocation to the dereference of the out-of-bounds pointer. This is done for several reasons:
 * 1. It means the user is able to inspect the entire path from the allocation to the dereference, which can be useful
 *    to understand the problem highlighted.
 * 2. It ensures that the call-contexts line up correctly when we transition from step 1 to step 2. See the
 *    `test_missing_call_context_1` and `test_missing_call_context_2` tests for how this may flag false positives
 *    without this final configuration.
 *
 * The source of the final path is an allocation that is:
 * 1. identified as flowing to an invalid pointer (by `AllocationToInvalidPointer`), and
 * 2. for which the invalid pointer flows to a dereference (as identified by `InvalidPointerToDereference`).
 *
 * The path can be described in 3 "chunks":
 * 1. One path from the allocation to the construction of the invalid pointer
 * 2. Another path from the construction of the invalid pointer to the final pointer that is about to be dereferenced.
 * 3. Finally, a single step from the dataflow node that represents the final pointer to the dereference.
 *
 * Step 1 happens when the flow state is `TInitial`, and step 2 and 3 happen when the flow state is `TPointerArith(pai)`
 * where the pointer-arithmetic instruction `pai` tracks the instruction that generated the out-of-bounds pointer. This
 * instruction is used in the construction of the alert message.
 *
 * The set of pointer-arithmetic instructions that define the `TPointerArith` flow state is restricted to be the pointer-
 * arithmetic instructions that both receive flow from the allocation (as identified by `AllocationToInvalidPointer.qll`),
 * and further flow to a dereference (as identified by `InvalidPointerToDereference.qll`).
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

  int fieldFlowBranchLimit() {
    result =
      allocationToInvalidPointerFieldFlowBranchLimit()
          .maximum(invalidPointerToDereferenceFieldFlowBranchLimit())
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
