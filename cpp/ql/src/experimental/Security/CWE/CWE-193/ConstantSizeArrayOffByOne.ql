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

import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.semantic.SemanticBound
import experimental.semmle.code.cpp.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.DataFlow
import PointerArithmeticToDerefFlow::PathGraph

pragma[nomagic]
Instruction getABoundIn(SemBound b, IRFunction func) {
  result = b.getExpr(0) and
  result.getEnclosingIRFunction() = func
}

/**
 * Holds if `i <= b + delta`.
 */
pragma[nomagic]
predicate bounded(Instruction i, Instruction b, int delta) {
  exists(SemBound bound, IRFunction func |
    semBounded(getSemanticExpr(i), bound, delta, true, _) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
}

module FieldAddressToPointerArithmeticConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isFieldAddressSource(_, source) }

  predicate isSink(DataFlow::Node sink) {
    exists(PointerAddInstruction pai | pai.getLeft() = sink.asInstruction())
  }
}

module FieldAddressToPointerArithmeticFlow = DataFlow::Make<FieldAddressToPointerArithmeticConfig>;

predicate isFieldAddressSource(Field f, DataFlow::Node source) {
  source.asInstruction().(FieldAddressInstruction).getField() = f
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConf` and `i` is a `StoreInstruction` that
 * writes to an address that non-strictly upper-bounds `sink`, or `i` is a `LoadInstruction` that
 * reads from an address that non-strictly upper-bounds `sink`.
 */
predicate isInvalidPointerDerefSink(DataFlow::Node sink, Instruction i, string operation) {
  exists(AddressOperand addr, int delta |
    bounded(addr.getDef(), sink.asInstruction(), delta) and
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

predicate isConstantSizeOverflowSource(Field f, PointerAddInstruction pai, int delta) {
  exists(int size, int bound, DataFlow::Node source, DataFlow::InstructionNode sink |
    FieldAddressToPointerArithmeticFlow::hasFlow(source, sink) and
    isFieldAddressSource(f, source) and
    pai.getLeft() = sink.asInstruction() and
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
    isConstantSizeOverflowSource(_, source.asInstruction(), _)
  }

  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink(sink, _, _) }
}

module PointerArithmeticToDerefFlow = DataFlow::Make<PointerArithmeticToDerefConfig>;

from
  Field f, PointerArithmeticToDerefFlow::PathNode source,
  PointerArithmeticToDerefFlow::PathNode sink, Instruction deref, string operation, int delta
where
  PointerArithmeticToDerefFlow::hasFlowPath(source, sink) and
  isInvalidPointerDerefSink(sink.getNode(), deref, operation) and
  isConstantSizeOverflowSource(f, source.getNode().asInstruction(), delta)
select source, source, sink,
  "This pointer arithmetic may have an off-by-" + (delta + 1) +
    " error allowing it to overrun $@ at this $@.", f, f.getName(), deref, operation
