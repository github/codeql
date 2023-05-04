/**
 * @name Constant array overflow
 * @description Dereferencing a pointer that points past a statically-sized array is undefined behavior
 *              and may lead to security vulnerabilities
 * @kind path-problem
 * @problem.severity error
 * @id cpp/constant-array-overflow
 * @tags reliability
 *       security
 *       experimental
 */

import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.DataFlow
import StitchedPathGraph

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
    pragma[only_bind_out](i.getEnclosingIRFunction()) = func
  )
}

bindingset[i]
pragma[inline_late]
predicate bounded1(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

bindingset[b]
pragma[inline_late]
predicate bounded2(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

module FieldAddressToPointerArithmeticConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isFieldAddressSource(_, source) }

  predicate isSink(DataFlow::Node sink) {
    exists(PointerAddInstruction pai | pai.getLeft() = sink.asInstruction())
  }
}

module FieldAddressToPointerArithmeticFlow =
  DataFlow::Global<FieldAddressToPointerArithmeticConfig>;

predicate isFieldAddressSource(Field f, DataFlow::Node source) {
  source.asInstruction().(FieldAddressInstruction).getField() = f
}

bindingset[delta]
predicate isInvalidPointerDerefSinkImpl(
  int delta, Instruction i, AddressOperand addr, string operation
) {
  delta >= 0 and
  i.getAnOperand() = addr and
  (
    i instanceof StoreInstruction and
    operation = "write"
    or
    i instanceof LoadInstruction and
    operation = "read"
  )
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConf` and `i` is a `StoreInstruction` that
 * writes to an address that non-strictly upper-bounds `sink`, or `i` is a `LoadInstruction` that
 * reads from an address that non-strictly upper-bounds `sink`.
 */
pragma[inline]
predicate isInvalidPointerDerefSink1(DataFlow::Node sink, Instruction i, string operation) {
  exists(AddressOperand addr, int delta |
    bounded1(addr.getDef(), sink.asInstruction(), delta) and
    isInvalidPointerDerefSinkImpl(delta, i, addr, operation)
  )
}

pragma[inline]
predicate isInvalidPointerDerefSink2(DataFlow::Node sink, Instruction i, string operation) {
  exists(AddressOperand addr, int delta |
    bounded2(addr.getDef(), sink.asInstruction(), delta) and
    isInvalidPointerDerefSinkImpl(delta, i, addr, operation)
  )
}

predicate isConstantSizeOverflowSource(Field f, FieldAddressToPointerArithmeticFlow::PathNode fieldSource, PointerAddInstruction pai, int delta) {
  exists(int size, int bound, FieldAddressToPointerArithmeticFlow::PathNode sink |
    FieldAddressToPointerArithmeticFlow::flowPath(fieldSource, sink) and
    isFieldAddressSource(f, fieldSource.getNode()) and
    pai.getLeft() = sink.getNode().(DataFlow::InstructionNode).asInstruction() and
    pai.getElementSize() = f.getUnspecifiedType().(ArrayType).getBaseType().getSize() and
    f.getUnspecifiedType().(ArrayType).getArraySize() = size and
    semBounded(getSemanticExpr(pai.getRight()), any(SemZeroBound b), bound, true, _) and
    delta = bound - size and
    delta >= 0 and
    size != 0 and
    size != 1
  )
}

module PointerArithmeticToDerefConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    isConstantSizeOverflowSource(_, _, source.asInstruction(), _)
  }

  pragma[inline]
  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink1(sink, _, _) }
}

module MergedPathGraph = DataFlow::MergePathGraph<PointerArithmeticToDerefFlow::PathNode, FieldAddressToPointerArithmeticFlow::PathNode, PointerArithmeticToDerefFlow::PathGraph, FieldAddressToPointerArithmeticFlow::PathGraph>;
class PathNode = MergedPathGraph::PathNode;
module StitchedPathGraph implements DataFlow::PathGraphSig<PathNode>{
  query predicate edges(PathNode a, PathNode b) {
    MergedPathGraph::PathGraph::edges(a, b)
    or
    a.asPathNode2().getNode().(DataFlow::InstructionNode).asInstruction() = b.asPathNode1().getNode().(DataFlow::InstructionNode).asInstruction().(PointerAddInstruction).getLeft()
  }

  query predicate nodes(PathNode n, string key, string val) {
    MergedPathGraph::PathGraph::nodes(n, key, val)
  }

  query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
    MergedPathGraph::PathGraph::subpaths(arg, par, ret, out)
  }
}
module PointerArithmeticToDerefFlow = DataFlow::Global<PointerArithmeticToDerefConfig>;

from
  Field f, PathNode fieldSource, PathNode paiNode,
  PathNode sink, Instruction deref, string operation, int delta
where
  PointerArithmeticToDerefFlow::flowPath(paiNode.asPathNode1(), sink.asPathNode1()) and
  isInvalidPointerDerefSink2(sink.getNode(), deref, operation) and
  isConstantSizeOverflowSource(f, fieldSource.asPathNode2(), paiNode.getNode().asInstruction(), delta)
select paiNode, fieldSource, sink,
  "This pointer arithmetic may have an off-by-" + (delta + 1) +
    " error allowing it to overrun $@ at this $@.", f, f.getName(), deref, operation
