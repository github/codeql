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
import semmle.code.cpp.ir.dataflow.internal.ProductFlow
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.ir.IR
import codeql.util.Unit

pragma[nomagic]
Instruction getABoundIn(SemBound b, IRFunction func) {
  getSemanticExpr(result) = b.getExpr(0) and
  result.getEnclosingIRFunction() = func
}

/**
 * Holds if `i <= b + delta`.
 */
pragma[inline]
predicate boundedImpl(Instruction i, Instruction b, int delta) {
  exists(SemBound bound, IRFunction func |
    semBounded(getSemanticExpr(i), bound, delta, true, _) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
}

bindingset[i]
pragma[inline_late]
predicate bounded1(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

bindingset[b]
pragma[inline_late]
predicate bounded2(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

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
    bounded1(any(Instruction instr | instr.getUnconvertedResultExpression() = size),
      any(LoadInstruction load | load.getUnconvertedResultExpression() = va), delta) and
    n.asConvertedExpr() = va.getFullyConverted() and
    state = delta
  )
}

/**
 * A module that encapsulates a barrier guard to remove false positives from flow like:
 * ```cpp
 * char *p = new char[size];
 * // ...
 * unsigned n = size;
 * // ...
 * if(n < size) {
 *   use(*p[n]);
 * }
 * ```
 * In this case, the sink pair identified by the product flow library (without any additional barriers)
 * would be `(p, n)` (where `n` is the `n` in `p[n]`), because there exists a pointer-arithmetic
 * instruction `pai` such that:
 * 1. The left-hand of `pai` flows from the allocation, and
 * 2. The right-hand of `pai` is non-strictly upper bounded by `n` (where `n` is the `n` in `p[n]`)
 * but because there's a strict comparison that compares `n` against the size of the allocation this
 * snippet is fine.
 */
module Barrier2 {
  private class FlowState2 = AllocToInvalidPointerConfig::FlowState2;

  private module BarrierConfig2 implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(_, source, _)
    }

    additional predicate isSink(
      DataFlow::Node left, DataFlow::Node right, IRGuardCondition g, FlowState2 state,
      boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison.
      g.comparesLt(left.asOperand(), right.asOperand(), state, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }
  }

  private import DataFlow::Global<BarrierConfig2>

  private FlowState2 getAFlowStateForNode(DataFlow::Node node) {
    exists(DataFlow::Node source |
      flow(source, node) and
      hasSize(_, source, result)
    )
  }

  private predicate operandGuardChecks(
    IRGuardCondition g, Operand left, Operand right, FlowState2 state, boolean edge
  ) {
    exists(DataFlow::Node nLeft, DataFlow::Node nRight, FlowState2 state0 |
      nRight.asOperand() = right and
      nLeft.asOperand() = left and
      BarrierConfig2::isSink(nLeft, nRight, g, state0, edge) and
      state = getAFlowStateForNode(nRight) and
      state0 <= state
    )
  }

  Instruction getABarrierInstruction(FlowState2 state) {
    exists(IRGuardCondition g, ValueNumber value, Operand use, boolean edge |
      use = value.getAUse() and
      operandGuardChecks(pragma[only_bind_into](g), pragma[only_bind_into](use), _,
        pragma[only_bind_into](state), pragma[only_bind_into](edge)) and
      result = value.getAnInstruction() and
      g.controls(result.getBlock(), edge)
    )
  }

  DataFlow::Node getABarrierNode(FlowState2 state) {
    result.asOperand() = getABarrierInstruction(state).getAUse()
  }

  IRBlock getABarrierBlock(FlowState2 state) {
    result.getAnInstruction() = getABarrierInstruction(state)
  }
}

/**
 * A product-flow configuration for flow from an (allocation, size) pair to a
 * pointer-arithmetic operation that is non-strictly upper-bounded by `allocation + size`.
 *
 * The goal of this query is to find patterns such as:
 * ```cpp
 * 1. char* begin = (char*)malloc(size);
 * 2. char* end = begin + size;
 * 3. for(int *p = begin; p <= end; p++) {
 * 4.   use(*p);
 * 5. }
 * ```
 *
 * We do this by splitting the task up into two configurations:
 * 1. `AllocToInvalidPointerConfig` find flow from `malloc(size)` to `begin + size`, and
 * 2. `InvalidPointerToDerefConfig` finds flow from `begin + size` to an `end` (on line 3).
 *
 * Finally, the range-analysis library will find a load from (or store to) an address that
 * is non-strictly upper-bounded by `end` (which in this case is `*p`).
 */
module AllocToInvalidPointerConfig implements ProductFlow::StateConfigSig {
  class FlowState1 = Unit;

  class FlowState2 = int;

  predicate isSourcePair(
    DataFlow::Node source1, FlowState1 state1, DataFlow::Node source2, FlowState2 state2
  ) {
    // In the case of an allocation like
    // ```cpp
    // malloc(size + 1);
    // ```
    // we use `state2` to remember that there was an offset (in this case an offset of `1`) added
    // to the size of the allocation. This state is then checked in `isSinkPair`.
    exists(state1) and
    hasSize(source1.asConvertedExpr(), source2, state2)
  }

  predicate isSinkPair(
    DataFlow::Node sink1, FlowState1 state1, DataFlow::Node sink2, FlowState2 state2
  ) {
    exists(state1) and
    // We check that the delta computed by the range analysis matches the
    // state value that we set in `isSourcePair`.
    isSinkImpl(_, sink1, sink2, state2)
  }

  predicate isBarrier1(DataFlow::Node node, FlowState1 state) { none() }

  predicate isBarrier2(DataFlow::Node node, FlowState2 state) {
    node = Barrier2::getABarrierNode(state)
  }

  predicate isBarrierIn1(DataFlow::Node node) { isSourcePair(node, _, _, _) }

  predicate isBarrierOut2(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi).getAnInput(true)
  }

  predicate isAdditionalFlowStep1(
    DataFlow::Node node1, FlowState1 state1, DataFlow::Node node2, FlowState1 state2
  ) {
    none()
  }

  predicate isAdditionalFlowStep2(
    DataFlow::Node node1, FlowState2 state1, DataFlow::Node node2, FlowState2 state2
  ) {
    none()
  }
}

module AllocToInvalidPointerFlow = ProductFlow::GlobalWithState<AllocToInvalidPointerConfig>;

/**
 * Holds if `pai` is non-strictly upper bounded by `sink2 + delta` and `sink1` is the
 * left operand of the pointer-arithmetic operation.
 *
 * For example in,
 * ```cpp
 * char* end = p + (size + 1);
 * ```
 * We will have:
 * - `pai` is `p + (size + 1)`,
 * - `sink1` is `p`
 * - `sink2` is `size`
 * - `delta` is `1`.
 */
pragma[nomagic]
predicate pointerAddInstructionHasBounds(
  PointerAddInstruction pai, DataFlow::Node sink1, DataFlow::Node sink2, int delta
) {
  InterestingPointerAddInstruction::isInteresting(pragma[only_bind_into](pai)) and
  exists(Instruction right, Instruction instr2 |
    pai.getRight() = right and
    pai.getLeft() = sink1.asInstruction() and
    instr2 = sink2.asInstruction() and
    bounded1(right, instr2, delta) and
    not right = Barrier2::getABarrierInstruction(delta) and
    not instr2 = Barrier2::getABarrierInstruction(delta)
  )
}

module InterestingPointerAddInstruction {
  private module PointerAddInstructionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(source.asConvertedExpr(), _, _)
    }

    predicate isSink(DataFlow::Node sink) {
      sink.asInstruction() = any(PointerAddInstruction pai).getLeft()
    }
  }

  private import DataFlow::Global<PointerAddInstructionConfig>

  predicate isInteresting(PointerAddInstruction pai) {
    exists(DataFlow::Node n |
      n.asInstruction() = pai.getLeft() and
      flowTo(n)
    )
  }
}

/**
 * Holds if `pai` is non-strictly upper bounded by `sink2 + delta` and `sink1` is the
 * left operand of the pointer-arithmetic operation.
 *
 * See `pointerAddInstructionHasBounds` for an example.
 */
predicate isSinkImpl(
  PointerAddInstruction pai, DataFlow::Node sink1, DataFlow::Node sink2, int delta
) {
  pointerAddInstructionHasBounds(pai, sink1, sink2, delta)
}

/**
 * Yields any instruction that is control-flow reachable from `instr`.
 */
bindingset[instr, result]
pragma[inline_late]
Instruction getASuccessor(Instruction instr) {
  exists(IRBlock b, int instrIndex, int resultIndex |
    result.getBlock() = b and
    instr.getBlock() = b and
    b.getInstruction(instrIndex) = instr and
    b.getInstruction(resultIndex) = result
  |
    resultIndex >= instrIndex
  )
  or
  instr.getBlock().getASuccessor+() = result.getBlock()
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConfig` and `i` is a `StoreInstruction` that
 * writes to an address that non-strictly upper-bounds `sink`, or `i` is a `LoadInstruction` that
 * reads from an address that non-strictly upper-bounds `sink`.
 */
pragma[inline]
predicate isInvalidPointerDerefSink(DataFlow::Node sink, Instruction i, string operation, int delta) {
  exists(AddressOperand addr, Instruction s, IRBlock b |
    s = sink.asInstruction() and
    boundedImpl(addr.getDef(), s, delta) and
    delta >= 0 and
    i.getAnOperand() = addr and
    b = i.getBlock() and
    not b = InvalidPointerToDerefBarrier::getABarrierBlock(delta)
  |
    i instanceof StoreInstruction and
    operation = "write"
    or
    i instanceof LoadInstruction and
    operation = "read"
  )
}

module InvalidPointerToDerefBarrier {
  private module BarrierConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for `InvalidPointerToDerefConfig`.
      invalidPointerToDerefSource(_, source, _)
    }

    additional predicate isSink(
      DataFlow::Node left, DataFlow::Node right, IRGuardCondition g, int state, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison.
      g.comparesLt(left.asOperand(), right.asOperand(), state, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }
  }

  private import DataFlow::Global<BarrierConfig>

  private int getInvalidPointerToDerefSourceDelta(DataFlow::Node node) {
    exists(DataFlow::Node source |
      flow(source, node) and
      invalidPointerToDerefSource(_, source, result)
    )
  }

  private predicate operandGuardChecks(
    IRGuardCondition g, Operand left, Operand right, int state, boolean edge
  ) {
    exists(DataFlow::Node nLeft, DataFlow::Node nRight, int state0 |
      nRight.asOperand() = right and
      nLeft.asOperand() = left and
      BarrierConfig::isSink(nLeft, nRight, g, state0, edge) and
      state = getInvalidPointerToDerefSourceDelta(nRight) and
      state0 <= state
    )
  }

  Instruction getABarrierInstruction(int state) {
    exists(IRGuardCondition g, ValueNumber value, Operand use, boolean edge |
      use = value.getAUse() and
      operandGuardChecks(pragma[only_bind_into](g), pragma[only_bind_into](use), _, state,
        pragma[only_bind_into](edge)) and
      result = value.getAnInstruction() and
      g.controls(result.getBlock(), edge)
    )
  }

  DataFlow::Node getABarrierNode() { result.asOperand() = getABarrierInstruction(_).getAUse() }

  pragma[nomagic]
  IRBlock getABarrierBlock(int state) { result.getAnInstruction() = getABarrierInstruction(state) }
}

/**
 * A configuration to track flow from a pointer-arithmetic operation found
 * by `AllocToInvalidPointerConfig` to a dereference of the pointer.
 */
module InvalidPointerToDerefConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { invalidPointerToDerefSource(_, source, _) }

  pragma[inline]
  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink(sink, _, _, _) }

  predicate isBarrier(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi | not phi.isPhiRead()).getAnInput(true)
    or
    node = InvalidPointerToDerefBarrier::getABarrierNode()
  }
}

module InvalidPointerToDerefFlow = DataFlow::Global<InvalidPointerToDerefConfig>;

/**
 * Holds if `pai` is a pointer-arithmetic operation and `source` is a dataflow node with a
 * pointer-value that is non-strictly upper bounded by `pai + delta`.
 *
 * For example, if `pai` is a pointer-arithmetic operation `p + size` in an expression such
 * as `(p + size) + 1` and `source` is the node representing `(p + size) + 1`. In this
 * case `delta` is 1.
 */
predicate invalidPointerToDerefSource(
  PointerArithmeticInstruction pai, DataFlow::Node source, int delta
) {
  exists(
    AllocToInvalidPointerFlow::PathNode1 p1, AllocToInvalidPointerFlow::PathNode2 p2,
    DataFlow::Node sink1, DataFlow::Node sink2, int delta0
  |
    pragma[only_bind_out](p1.getNode()) = sink1 and
    pragma[only_bind_out](p2.getNode()) = sink2 and
    AllocToInvalidPointerFlow::flowPath(_, _, pragma[only_bind_into](p1), pragma[only_bind_into](p2)) and
    // Note that `delta` is not necessarily equal to `delta0`:
    // `delta0` is the constant offset added to the size of the allocation, and
    // delta is the constant difference between the pointer-arithmetic instruction
    // and the instruction computing the address for which we will search for a dereference.
    isSinkImpl(pai, sink1, sink2, delta0) and
    bounded2(source.asInstruction(), pai, delta) and
    delta >= 0 and
    not source.getBasicBlock() = Barrier2::getABarrierBlock(delta0)
  )
}

newtype TMergedPathNode =
  // The path nodes computed by the first projection of `AllocToInvalidPointerConfig`
  TPathNode1(AllocToInvalidPointerFlow::PathNode1 p) or
  // The path nodes computed by `InvalidPointerToDerefConfig`
  TPathNode3(InvalidPointerToDerefFlow::PathNode p) or
  // The read/write that uses the invalid pointer identified by `InvalidPointerToDerefConfig`.
  // This one is needed because the sink identified by `InvalidPointerToDerefConfig` is the
  // pointer, but we want to raise an alert at the dereference.
  TPathNodeSink(Instruction i) {
    exists(DataFlow::Node n |
      InvalidPointerToDerefFlow::flowTo(pragma[only_bind_into](n)) and
      isInvalidPointerDerefSink(n, i, _, _) and
      i = getASuccessor(n.asInstruction())
    )
  }

class MergedPathNode extends TMergedPathNode {
  string toString() { none() }

  final AllocToInvalidPointerFlow::PathNode1 asPathNode1() { this = TPathNode1(result) }

  final InvalidPointerToDerefFlow::PathNode asPathNode3() { this = TPathNode3(result) }

  final Instruction asSinkNode() { this = TPathNodeSink(result) }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }
}

class PathNode1 extends MergedPathNode, TPathNode1 {
  override string toString() {
    exists(AllocToInvalidPointerFlow::PathNode1 p |
      this = TPathNode1(p) and
      result = p.toString()
    )
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asPathNode1().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class PathNode3 extends MergedPathNode, TPathNode3 {
  override string toString() {
    exists(InvalidPointerToDerefFlow::PathNode p |
      this = TPathNode3(p) and
      result = p.toString()
    )
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asPathNode3().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class PathSinkNode extends MergedPathNode, TPathNodeSink {
  override string toString() {
    exists(Instruction i |
      this = TPathNodeSink(i) and
      result = i.toString()
    )
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asSinkNode()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

query predicate edges(MergedPathNode node1, MergedPathNode node2) {
  node1.asPathNode1().getASuccessor() = node2.asPathNode1()
  or
  joinOn1(_, node1.asPathNode1(), node2.asPathNode3())
  or
  node1.asPathNode3().getASuccessor() = node2.asPathNode3()
  or
  joinOn2(node1.asPathNode3(), node2.asSinkNode(), _, _)
}

query predicate nodes(MergedPathNode n, string key, string val) {
  AllocToInvalidPointerFlow::PathGraph1::nodes(n.asPathNode1(), key, val)
  or
  InvalidPointerToDerefFlow::PathGraph::nodes(n.asPathNode3(), key, val)
  or
  key = "semmle.label" and val = n.asSinkNode().toString()
}

query predicate subpaths(
  MergedPathNode arg, MergedPathNode par, MergedPathNode ret, MergedPathNode out
) {
  AllocToInvalidPointerFlow::PathGraph1::subpaths(arg.asPathNode1(), par.asPathNode1(),
    ret.asPathNode1(), out.asPathNode1())
  or
  InvalidPointerToDerefFlow::PathGraph::subpaths(arg.asPathNode3(), par.asPathNode3(),
    ret.asPathNode3(), out.asPathNode3())
}

/**
 * Holds if `p1` is a sink of `AllocToInvalidPointerConfig` and `p2` is a source
 * of `InvalidPointerToDerefConfig`, and they are connected through `pai`.
 */
predicate joinOn1(
  PointerArithmeticInstruction pai, AllocToInvalidPointerFlow::PathNode1 p1,
  InvalidPointerToDerefFlow::PathNode p2
) {
  isSinkImpl(pai, p1.getNode(), _, _) and
  invalidPointerToDerefSource(pai, p2.getNode(), _)
}

/**
 * Holds if `p1` is a sink of `InvalidPointerToDerefConfig` and `i` is the instruction
 * that dereferences `p1`. The string `operation` describes whether the `i` is
 * a `StoreInstruction` or `LoadInstruction`.
 */
pragma[inline]
predicate joinOn2(InvalidPointerToDerefFlow::PathNode p1, Instruction i, string operation, int delta) {
  isInvalidPointerDerefSink(p1.getNode(), i, operation, delta)
}

predicate hasFlowPath(
  MergedPathNode source1, MergedPathNode sink, InvalidPointerToDerefFlow::PathNode source3,
  PointerArithmeticInstruction pai, string operation, int delta
) {
  exists(InvalidPointerToDerefFlow::PathNode sink3, AllocToInvalidPointerFlow::PathNode1 sink1 |
    AllocToInvalidPointerFlow::flowPath(source1.asPathNode1(), _, sink1, _) and
    joinOn1(pai, sink1, source3) and
    InvalidPointerToDerefFlow::flowPath(source3, sink3) and
    joinOn2(sink3, sink.asSinkNode(), operation, delta)
  )
}

from
  MergedPathNode source, MergedPathNode sink, int k, string kstr, PointerArithmeticInstruction pai,
  string operation, Expr offset, DataFlow::Node n
where
  k =
    min(int k2, int k3, InvalidPointerToDerefFlow::PathNode source3 |
      hasFlowPath(source, sink, source3, pai, operation, k3) and
      invalidPointerToDerefSource(pai, source3.getNode(), k2)
    |
      k2 + k3
    ) and
  offset = pai.getRight().getUnconvertedResultExpression() and
  n = source.asPathNode1().getNode() and
  if k = 0 then kstr = "" else kstr = " + " + k
select sink, source, sink,
  "This " + operation + " might be out of bounds, as the pointer might be equal to $@ + $@" + kstr +
    ".", n, n.toString(), offset, offset.toString()
