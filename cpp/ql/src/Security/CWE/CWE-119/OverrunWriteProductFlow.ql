/**
 * @name Overrunning write
 * @description Exceeding the size of a static array during write or access operations
 *              may result in a buffer overflow.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision medium
 * @id cpp/overrun-write
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */

import cpp
import semmle.code.cpp.ir.dataflow.internal.ProductFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.rangeanalysis.new.RangeAnalysisUtil
import StringSizeFlow::PathGraph1
import codeql.util.Unit

VariableAccess getAVariableAccess(Expr e) { e.getAChild*() = result }

/**
 * Holds if `(n, state)` pair represents the source of flow for the size
 * expression associated with `alloc`.
 */
predicate hasSize(HeuristicAllocationExpr alloc, DataFlow::Node n, int state) {
  exists(VariableAccess va, Expr size, int delta |
    size = alloc.getSizeExpr() and
    // Get the unique variable in a size expression like `x` in `malloc(x + 1)`.
    va = unique( | | getAVariableAccess(size)) and
    // Compute `delta` as the constant difference between `x` and `x + 1`.
    bounded(any(Instruction instr | instr.getUnconvertedResultExpression() = size),
      any(LoadInstruction load | load.getUnconvertedResultExpression() = va), delta) and
    n.asExpr() = va and
    state = delta
  )
}

predicate isSinkPairImpl(
  CallInstruction c, DataFlow::Node bufSink, DataFlow::Node sizeSink, int delta, Expr eBuf
) {
  exists(
    int bufIndex, int sizeIndex, Instruction sizeInstr, Instruction bufInstr, ArrayFunction func
  |
    bufInstr = bufSink.asInstruction() and
    c.getArgument(bufIndex) = bufInstr and
    sizeInstr = sizeSink.asInstruction() and
    c.getStaticCallTarget() = func and
    pragma[only_bind_into](func)
        .hasArrayWithVariableSize(pragma[only_bind_into](bufIndex),
          pragma[only_bind_into](sizeIndex)) and
    bounded(c.getArgument(sizeIndex), sizeInstr, delta) and
    eBuf = bufInstr.getUnconvertedResultExpression()
  )
}

module ValidState {
  /**
   * In the `StringSizeConfig` configuration we use an integer as the flow state for the second
   * projection of the dataflow graph. The integer represents an offset that is added to the
   * size of the allocation. For example, given:
   * ```cpp
   * char* p = new char[size + 1];
   * size += 1;
   * memset(p, 0, size);
   * ```
   * the initial flow state is `1`. This represents the fact that `size + 1` is a valid bound
   * for the size of the allocation pointed to by `p`. After updating the size using `+=`, the
   * flow state changes to `0`, which represents the fact that `size + 0` is a valid bound for
   * the allocation.
   *
   * So we need to compute a set of valid integers that represent the offset applied to the
   * size. We do this in two steps:
   * 1. We first perform the dataflow traversal that the second projection of the product-flow
   * library will perform, and visit all the places where the size argument is modified.
   * 2. Once that dataflow traversal is done, we accumulate the offsets added at each places
   * where the offset is modified (see `validStateImpl`).
   */
  private module ValidStateConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { hasSize(_, source, _) }

    predicate isSink(DataFlow::Node sink) { isSinkPairImpl(_, _, sink, _, _) }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalFlowStep2(node1, node2, _)
    }

    predicate includeHiddenNodes() { any() }
  }

  private import DataFlow::Global<ValidStateConfig>

  private predicate inLoop(PathNode n) { n.getASuccessor+() = n }

  /**
   * Holds if `value` is a possible offset for `n`.
   *
   * To ensure termination, we limit `value` to be in the
   * range `[-2, 2]` if the node is part of a loop. Without
   * this restriction we wouldn't terminate on an example like:
   * ```cpp
   * while(unknown()) { size++; }
   * ```
   */
  private predicate validStateImpl(PathNode n, int value) {
    // If the dataflow node depends recursively on itself we restrict the range.
    (inLoop(n) implies value = [-2 .. 2]) and
    (
      // For the dataflow source we have an allocation such as `malloc(size + k)`,
      // and the value of the flow-state is then `k`.
      hasSize(_, n.getNode(), value)
      or
      // For a dataflow sink any `value` that is strictly smaller than the delta
      // needs to be a valid flow-state. That is, for a snippet like:
      // ```
      // p = b ? new char[size] : new char[size + 1];
      // memset(p, 0, size + 2);
      // ```
      // the valid flow-states at the `memset` must include the set `{0, 1}` since the
      // flow-state at `new char[size]` is `0`, and the flow-state at `new char[size + 1]`
      // is `1`.
      //
      // So we find a valid flow-state at the sink's predecessor, and use the definition
      // of our sink predicate to compute the valid flow-states at the sink.
      exists(int delta, PathNode n0 |
        n0.getASuccessor() = n and
        validStateImpl(n0, value) and
        isSinkPairImpl(_, _, n.getNode(), delta, _) and
        delta > value
      )
      or
      // For a non-source and non-sink node there is two cases to consider.
      // 1. A node where we have to update the flow-state, or
      // 2. A node that doesn't update the flow-state.
      //
      // For case 1, we compute the new flow-state by adding the constant operand of the
      // `AddInstruction` to the flow-state of any predecessor node.
      // For case 2 we simply propagate the valid flow-states from the predecessor node to
      // the next one.
      exists(PathNode n0, DataFlow::Node node0, DataFlow::Node node, int value0 |
        n0.getASuccessor() = n and
        validStateImpl(n0, value0) and
        node = n.getNode() and
        node0 = n0.getNode()
      |
        exists(int delta |
          isAdditionalFlowStep2(node0, node, delta) and
          value0 = value + delta
        )
        or
        not isAdditionalFlowStep2(node0, node, _) and
        value = value0
      )
    )
  }

  predicate validState(DataFlow::Node n, int value) {
    validStateImpl(any(PathNode pn | pn.getNode() = n), value)
  }
}

import ValidState

/**
 * Holds if `node2` is a dataflow node that represents an addition of two operands `op1`
 * and `op2` such that:
 * 1. `node1` is the dataflow node that represents `op1`, and
 * 2. the value of `op2` can be upper bounded by `delta.`
 */
predicate isAdditionalFlowStep2(DataFlow::Node node1, DataFlow::Node node2, int delta) {
  exists(AddInstruction add, Operand op |
    add.hasOperands(node1.asOperand(), op) and
    semBounded(getSemanticExpr(op.getDef()), any(SemZeroBound zero), delta, true, _) and
    node2.asInstruction() = add
  )
}

module StringSizeConfig implements ProductFlow::StateConfigSig {
  class FlowState1 = Unit;

  class FlowState2 = int;

  predicate isSourcePair(
    DataFlow::Node bufSource, FlowState1 state1, DataFlow::Node sizeSource, FlowState2 state2
  ) {
    // In the case of an allocation like
    // ```cpp
    // malloc(size + 1);
    // ```
    // we use `state2` to remember that there was an offset (in this case an offset of `1`) added
    // to the size of the allocation. This state is then checked in `isSinkPair`.
    exists(state1) and
    hasSize(bufSource.asExpr(), sizeSource, state2) and
    validState(sizeSource, state2)
  }

  predicate isSinkPair(
    DataFlow::Node bufSink, FlowState1 state1, DataFlow::Node sizeSink, FlowState2 state2
  ) {
    exists(state1) and
    validState(sizeSink, state2) and
    exists(int delta |
      isSinkPairImpl(_, bufSink, sizeSink, delta, _) and
      delta > state2
    )
  }

  predicate isBarrierOut2(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi).getAnInput(true)
  }

  predicate isAdditionalFlowStep2(
    DataFlow::Node node1, FlowState2 state1, DataFlow::Node node2, FlowState2 state2
  ) {
    validState(node2, state2) and
    exists(int delta |
      isAdditionalFlowStep2(node1, node2, delta) and
      state1 = state2 + delta
    )
  }
}

module StringSizeFlow = ProductFlow::GlobalWithState<StringSizeConfig>;

/**
 * Gets the maximum number of elements accessed past the buffer `buffer` by the formatting
 * function call `c` when an overflow is detected starting at the `(source1, source2)` pair
 * and ending at the `(sink1, sink2)` pair.
 *
 * Implementation note: Since the number of elements accessed past the buffer is computed
 * using a `FlowState` on the second component of the `DataFlow::PathNode` pair we project
 * the columns down to the underlying `DataFlow::Node` in order to deduplicate the flow
 * state.
 */
int getOverflow(
  DataFlow::Node source1, DataFlow::Node source2, DataFlow::Node sink1, DataFlow::Node sink2,
  CallInstruction c, Expr buffer
) {
  result > 0 and
  exists(
    StringSizeFlow::PathNode1 pathSource1, StringSizeFlow::PathNode2 pathSource2,
    StringSizeFlow::PathNode1 pathSink1, StringSizeFlow::PathNode2 pathSink2
  |
    StringSizeFlow::flowPath(pathSource1, pathSource2, pathSink1, pathSink2) and
    source1 = pathSource1.getNode() and
    source2 = pathSource2.getNode() and
    sink1 = pathSink1.getNode() and
    sink2 = pathSink2.getNode() and
    isSinkPairImpl(c, sink1, sink2, result + pathSink2.getState(), buffer)
  )
}

from
  StringSizeFlow::PathNode1 source1, StringSizeFlow::PathNode2 source2,
  StringSizeFlow::PathNode1 sink1, StringSizeFlow::PathNode2 sink2, int overflow, CallInstruction c,
  Expr buffer, string element
where
  StringSizeFlow::flowPath(source1, source2, sink1, sink2) and
  overflow =
    max(getOverflow(source1.getNode(), source2.getNode(), sink1.getNode(), sink2.getNode(), c,
          buffer)
    ) and
  if overflow = 1 then element = " element." else element = " elements."
select c.getUnconvertedResultExpression(), source1, sink1,
  "This write may overflow $@ by " + overflow + element, buffer, buffer.toString()
