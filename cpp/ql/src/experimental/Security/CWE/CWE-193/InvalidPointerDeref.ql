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
import experimental.semmle.code.cpp.dataflow.ProductFlow
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
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

/**
 * Holds if the combination of `n` and `state` represents an appropriate
 * source for the expression `e` suitable for use-use flow.
 */
private predicate hasSizeImpl(Expr e, DataFlow::Node n, int state) {
  // The simple case: If the size is a variable access with no qualifier we can just use the
  // dataflow node for that expression and no state.
  exists(VariableAccess va |
    va = e and
    not va instanceof FieldAccess and
    n.asConvertedExpr() = va.getFullyConverted() and
    state = 0
  )
  or
  // If the size is a choice between two expressions we allow both to be nodes representing the size.
  exists(ConditionalExpr cond | cond = e | hasSizeImpl([cond.getThen(), cond.getElse()], n, state))
  or
  // If the size is an expression plus a constant, we pick the dataflow node of the expression and
  // remember the constant in the state.
  exists(Expr const, Expr nonconst |
    e.(AddExpr).hasOperands(const, nonconst) and
    state = const.getValue().toInt() and
    hasSizeImpl(nonconst, n, _)
  )
  or
  exists(Expr const, Expr nonconst |
    e.(SubExpr).hasOperands(const, nonconst) and
    state = -const.getValue().toInt() and
    hasSizeImpl(nonconst, n, _)
  )
}

/**
 * Holds if `(n, state)` pair represents the source of flow for the size
 * expression associated with `alloc`.
 */
predicate hasSize(HeuristicAllocationExpr alloc, DataFlow::Node n, int state) {
  hasSizeImpl(alloc.getSizeExpr(), n, state)
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
 * 1. `AllocToInvalidPointerConf` find flow from `malloc(size)` to `begin + size`, and
 * 2. `InvalidPointerToDerefConf` finds flow from `begin + size` to an `end` (on line 3).
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
    exists(int delta |
      isSinkImpl(_, sink1, sink2, delta) and
      state2 = delta
    )
  }

  predicate isBarrier1(DataFlow::Node node, FlowState1 state) { none() }

  predicate isBarrier2(DataFlow::Node node, FlowState2 state) { none() }

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
  exists(Instruction right |
    pai.getRight() = right and
    pai.getLeft() = sink1.asInstruction() and
    bounded1(right, sink2.asInstruction(), delta)
  )
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
 * Holds if `sink` is a sink for `InvalidPointerToDerefConf` and `i` is a `StoreInstruction` that
 * writes to an address that non-strictly upper-bounds `sink`, or `i` is a `LoadInstruction` that
 * reads from an address that non-strictly upper-bounds `sink`.
 */
pragma[inline]
predicate isInvalidPointerDerefSink(DataFlow::Node sink, Instruction i, string operation) {
  exists(AddressOperand addr, int delta |
    bounded1(addr.getDef(), sink.asInstruction(), delta) and
    delta >= 0 and
    i.getAnOperand() = addr
  |
    i instanceof StoreInstruction and
    operation = "write"
    or
    i instanceof LoadInstruction and
    operation = "read"
  )
}

/**
 * A configuration to track flow from a pointer-arithmetic operation found
 * by `AllocToInvalidPointerConf` to a dereference of the pointer.
 */
module InvalidPointerToDerefConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { invalidPointerToDerefSource(_, source, _) }

  pragma[inline]
  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink(sink, _, _) }
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
  exists(AllocToInvalidPointerFlow::PathNode1 p, DataFlow::Node sink1 |
    pragma[only_bind_out](p.getNode()) = sink1 and
    AllocToInvalidPointerFlow::flowPath(_, _, pragma[only_bind_into](p), _) and
    isSinkImpl(pai, sink1, _, _) and
    bounded2(source.asInstruction(), pai, delta) and
    delta >= 0
  )
}

newtype TMergedPathNode =
  // The path nodes computed by the first projection of `AllocToInvalidPointerConf`
  TPathNode1(AllocToInvalidPointerFlow::PathNode1 p) or
  // The path nodes computed by `InvalidPointerToDerefConf`
  TPathNode3(InvalidPointerToDerefFlow::PathNode p) or
  // The read/write that uses the invalid pointer identified by `InvalidPointerToDerefConf`.
  // This one is needed because the sink identified by `InvalidPointerToDerefConf` is the
  // pointer, but we want to raise an alert at the dereference.
  TPathNodeSink(Instruction i) {
    exists(DataFlow::Node n |
      InvalidPointerToDerefFlow::flowTo(n) and
      isInvalidPointerDerefSink(n, i, _)
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
  joinOn2(node1.asPathNode3(), node2.asSinkNode(), _)
}

/**
 * Holds if `p1` is a sink of `AllocToInvalidPointerConf` and `p2` is a source
 * of `InvalidPointerToDerefConf`, and they are connected through `pai`.
 */
predicate joinOn1(
  PointerArithmeticInstruction pai, AllocToInvalidPointerFlow::PathNode1 p1,
  InvalidPointerToDerefFlow::PathNode p2
) {
  isSinkImpl(pai, p1.getNode(), _, _) and
  invalidPointerToDerefSource(pai, p2.getNode(), _)
}

/**
 * Holds if `p1` is a sink of `InvalidPointerToDerefConf` and `i` is the instruction
 * that dereferences `p1`. The string `operation` describes whether the `i` is
 * a `StoreInstruction` or `LoadInstruction`.
 */
pragma[inline]
predicate joinOn2(InvalidPointerToDerefFlow::PathNode p1, Instruction i, string operation) {
  isInvalidPointerDerefSink(p1.getNode(), i, operation)
}

predicate hasFlowPath(
  MergedPathNode source1, MergedPathNode sink, InvalidPointerToDerefFlow::PathNode source3,
  PointerArithmeticInstruction pai, string operation
) {
  exists(InvalidPointerToDerefFlow::PathNode sink3, AllocToInvalidPointerFlow::PathNode1 sink1 |
    AllocToInvalidPointerFlow::flowPath(source1.asPathNode1(), _, sink1, _) and
    joinOn1(pai, sink1, source3) and
    InvalidPointerToDerefFlow::flowPath(source3, sink3) and
    joinOn2(sink3, sink.asSinkNode(), operation)
  )
}

from
  MergedPathNode source, MergedPathNode sink, int k, string kstr,
  InvalidPointerToDerefFlow::PathNode source3, PointerArithmeticInstruction pai, string operation,
  Expr offset, DataFlow::Node n
where
  hasFlowPath(source, sink, source3, pai, operation) and
  invalidPointerToDerefSource(pai, source3.getNode(), k) and
  offset = pai.getRight().getUnconvertedResultExpression() and
  n = source.asPathNode1().getNode() and
  if k = 0 then kstr = "" else kstr = " + " + k
select sink, source, sink,
  "This " + operation + " might be out of bounds, as the pointer might be equal to $@ + $@" + kstr +
    ".", n, n.toString(), offset, offset.toString()
