/**
 * @name Overrunning write
 * @description Exceeding the size of a static array during write or access operations
 *              may result in a buffer overflow.
 * @kind path-problem
 * @problem.severity error
 * @id cpp/overrun-write
 * @tags reliability
 *       security
 *       experimental
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */

import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import StringSizeFlow::PathGraph1
import codeql.util.Unit

pragma[nomagic]
Instruction getABoundIn(SemBound b, IRFunction func) {
  getSemanticExpr(result) = b.getExpr(0) and
  result.getEnclosingIRFunction() = func
}

/**
 * Holds if `i <= b + delta`.
 */
bindingset[i]
pragma[inline_late]
predicate bounded(Instruction i, Instruction b, int delta) {
  exists(SemBound bound, IRFunction func |
    semBounded(getSemanticExpr(i), bound, delta, true, _) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
}

VariableAccess getAVariableAccess(Expr e) { e.getAChild*() = result }

/**
 * Holds if `(n, state)` pair represents the source of flow for the size
 * expression associated with `alloc`.
 */
predicate hasSize(AllocationExpr alloc, DataFlow::Node n, int state) {
  exists(VariableAccess va, Expr size, int delta |
    size = alloc.getSizeExpr() and
    // Get the unique variable in a size expression like `x` in `malloc(x + 1)`.
    va = unique( | | getAVariableAccess(size)) and
    // Compute `delta` as the constant difference between `x` and `x + 1`.
    bounded(any(Instruction instr | instr.getUnconvertedResultExpression() = size),
      any(LoadInstruction load | load.getUnconvertedResultExpression() = va), delta) and
    n.asConvertedExpr() = va.getFullyConverted() and
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
    hasSize(bufSource.asConvertedExpr(), sizeSource, state2)
  }

  predicate isSinkPair(
    DataFlow::Node bufSink, FlowState1 state1, DataFlow::Node sizeSink, FlowState2 state2
  ) {
    exists(state1) and
    state2 = [-32 .. 32] and // An arbitrary bound because we need to bound `state2`
    exists(int delta |
      isSinkPairImpl(_, bufSink, sizeSink, delta, _) and
      delta > state2
    )
  }

  predicate isBarrier1(DataFlow::Node node, FlowState1 state) { none() }

  predicate isBarrier2(DataFlow::Node node, FlowState2 state) { none() }

  predicate isAdditionalFlowStep1(
    DataFlow::Node node1, FlowState1 state1, DataFlow::Node node2, FlowState1 state2
  ) {
    none()
  }

  predicate isAdditionalFlowStep2(
    DataFlow::Node node1, FlowState2 state1, DataFlow::Node node2, FlowState2 state2
  ) {
    exists(AddInstruction add, Operand op, int delta, int s1, int s2 |
      s1 = [-32 .. 32] and // An arbitrary bound because we need to bound `state`
      state1 = s1 and
      state2 = s2 and
      add.hasOperands(node1.asOperand(), op) and
      semBounded(getSemanticExpr(op.getDef()), any(SemZeroBound zero), delta, true, _) and
      node2.asInstruction() = add and
      s1 = s2 + delta
    )
  }
}

module StringSizeFlow = ProductFlow::GlobalWithState<StringSizeConfig>;

from
  StringSizeFlow::PathNode1 source1, StringSizeFlow::PathNode2 source2,
  StringSizeFlow::PathNode1 sink1, StringSizeFlow::PathNode2 sink2, int overflow, int sinkState,
  CallInstruction c, DataFlow::Node sourceNode, Expr buffer, string element
where
  StringSizeFlow::flowPath(source1, source2, sink1, sink2) and
  sinkState = sink2.getState() and
  isSinkPairImpl(c, sink1.getNode(), sink2.getNode(), overflow + sinkState, buffer) and
  overflow > 0 and
  sourceNode = source1.getNode() and
  if overflow = 1 then element = " element." else element = " elements."
select c.getUnconvertedResultExpression(), source1, sink1,
  "This write may overflow $@ by " + overflow + element, buffer, buffer.toString()
