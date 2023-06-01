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
import ArrayAddressToDerefFlow::PathGraph

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

predicate pointerArithOverflow0(
  PointerArithmeticInstruction pai, Variable v, int size, int bound, int delta
) {
  pai.getElementSize() = v.getUnspecifiedType().(ArrayType).getBaseType().getSize() and
  v.getUnspecifiedType().(ArrayType).getArraySize() = size and
  semBounded(getSemanticExpr(pai.getRight()), any(SemZeroBound b), bound, true, _) and
  delta = bound - size and
  delta >= 0 and
  size != 0 and
  size != 1
}

module PointerArithmeticToDerefConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    pointerArithOverflow0(source.asInstruction(), _, _, _, _)
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink1(sink, _, _) }
}

module PointerArithmeticToDerefFlow = DataFlow::Global<PointerArithmeticToDerefConfig>;

predicate pointerArithOverflow(
  PointerArithmeticInstruction pai, Variable v, int size, int bound, int delta
) {
  pointerArithOverflow0(pai, v, size, bound, delta) and
  PointerArithmeticToDerefFlow::flow(DataFlow::instructionNode(pai), _)
}

module ArrayAddressToDerefConfig implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional TArray(Variable v) { pointerArithOverflow(_, v, _, _, _) } or
    additional TOverflowArithmetic(PointerArithmeticInstruction pai) {
      pointerArithOverflow(pai, _, _, _, _)
    }

  predicate isSource(DataFlow::Node source, FlowState state) {
    exists(Variable v |
      (
        source.asInstruction().(FieldAddressInstruction).getField() = v
        or
        source.asInstruction().(VariableAddressInstruction).getAstVariable() = v
      ) and
      exists(v.getUnspecifiedType().(ArrayType).getArraySize()) and
      state = TArray(v)
    )
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    exists(DataFlow::Node pai |
      state = TOverflowArithmetic(pai.asInstruction()) and
      PointerArithmeticToDerefFlow::flow(pai, sink)
    )
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node, _) }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node, _) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(PointerArithmeticInstruction pai, Variable v |
      state1 = TArray(v) and
      state2 = TOverflowArithmetic(pai) and
      pai.getLeft() = node1.asInstruction() and
      node2.asInstruction() = pai and
      pointerArithOverflow(pai, v, _, _, _)
    )
  }
}

module ArrayAddressToDerefFlow = DataFlow::GlobalWithState<ArrayAddressToDerefConfig>;

from
  Variable v, ArrayAddressToDerefFlow::PathNode source, PointerArithmeticInstruction pai,
  ArrayAddressToDerefFlow::PathNode sink, Instruction deref, string operation, int delta
where
ArrayAddressToDerefFlow::flowPath(source, sink) and
  isInvalidPointerDerefSink2(sink.getNode(), deref, operation) and
  source.getState() = ArrayAddressToDerefConfig::TArray(v) and
  sink.getState() = ArrayAddressToDerefConfig::TOverflowArithmetic(pai) and
  pointerArithOverflow(pai, v, _, _, delta)
select pai, source, sink,
  "This pointer arithmetic may have an off-by-" + (delta + 1) +
    " error allowing it to overrun $@ at this $@.", v, v.getName(), deref, operation
