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
import semmle.code.cpp.controlflow.IRGuards
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

/** Holds if `v` of an array type with size `size` number of elements. */
predicate cand(Variable v, ArrayType arrayType, int bytes) {
  v.getUnspecifiedType() = arrayType and
  exists(int size |
    size = arrayType.getArraySize() and
    size != 0 and
    size != 1
  ) and
  bytes = arrayType.getByteSize()
}

/** Pointer arithmetic to dereference flow. */
module PointerArithmeticToDeref {
  /** Holds if `pai`'s right-hand side can be upper bounded non-strictly by `delta`. */
  private predicate constantUpperBounded0(PointerArithmeticInstruction pai, int delta) {
    semBounded(getSemanticExpr(pai.getRight()), any(SemZeroBound b), delta, true, _)
  }

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources are all the pointer-arithmetic expressions for
      // which we can bound the right-hand side by a constant.
      constantUpperBounded0(source.asInstruction(), _)
    }

    predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

    predicate isSink(DataFlow::Node sink) {
      // The sinks are all the values that non-strictly upper bounds
      // a value that is dereferenced.
      isInvalidPointerDerefSink1(sink, _, _)
    }
  }

  private import DataFlow::Global<Config>

  predicate candidate(PointerArithmeticInstruction pai) { candidateForSink(pai, _) }

  predicate candidateForSink(PointerArithmeticInstruction pai, DataFlow::Node sink) {
    flow(DataFlow::instructionNode(pai), sink)
  }

  predicate constantUpperBounded(PointerArithmeticInstruction pai, int delta) {
    constantUpperBounded0(pai, delta) and
    candidate(pai)
  }
}

/**
 * Holds if `source` is a `FieldAddressInstruction` or `VariableAddressInstruction`
 * that represents `v`, and `v` is of an array-type size `size` number of elements.
 */
predicate isSourceImpl(DataFlow::Node source, Variable v, ArrayType t, int bytes) {
  (
    source.asInstruction().(FieldAddressInstruction).getField() = v
    or
    source.asInstruction().(VariableAddressInstruction).getAstVariable() = v
  ) and
  cand(v, t, bytes)
}

predicate ensuresLt(Operand left, Operand right, int k, IRBlock block) {
  any(IRGuardCondition g).ensuresLt(left, right, k, block, true)
}

/** Variable to pointer arithmetic flow. */
module VariableToPointerArith {
  private import semmle.code.cpp.ir.ValueNumbering

  module Config implements DataFlow::StateConfigSig {
    class FlowState extends ArrayType {
      FlowState() { isSourceImpl(_, _, this, _) }
    }

    predicate isSource(DataFlow::Node source, FlowState state) {
      // The sources are all the instructions that contains a
      // reference to a variable of an array type.
      isSourceImpl(source, _, state, _)
    }

    predicate isBarrierIn(DataFlow::Node node) { isSource(node, _) }

    predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      none()
    }

    pragma[inline]
    predicate isSink(DataFlow::Node sink, FlowState state) {
      exists(PointerArithmeticInstruction pai, int index |
        pai.getLeftOperand() = sink.asOperand() and
        PointerArithmeticToDeref::constantUpperBounded(pai, index) and
        not (index + 1) * pai.getElementSize() <= state.getByteSize() and
        not exists(ConstantInstruction right, int k1, int k2 |
          pai.getElementSize() * (k1 + k2) <= state.getByteSize() and
          right.getValue().toInt() = k1 and
          // `index < k1 + k2 <= array size` so this is safe
          ensuresLt(valueNumber(pai.getRight()).getAUse(), right.getAUse(), k2, sink.getBasicBlock())
        )
      )
    }
  }

  private import DataFlow::GlobalWithState<Config>

  predicate candidateSource(ArrayType array, DataFlow::Node source) {
    flow(source, _) and
    isSourceImpl(source, _, array, _)
  }

  predicate candidatePointerArithmetic(ArrayType array, PointerArithmeticInstruction pai) {
    exists(DataFlow::Node source, DataFlow::Node sink |
      candidateSource(array, source) and
      flow(source, sink) and
      sink.asOperand() = pai.getLeftOperand()
    )
  }
}

/** Variable to dereference flow. */
module ArrayAddressToDerefConfig implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional TArray(ArrayType array) { VariableToPointerArith::candidateSource(array, _) } or
    additional TOverflowArithmetic(ArrayType array, PointerArithmeticInstruction pai) {
      VariableToPointerArith::candidatePointerArithmetic(array, pai)
    }

  predicate isSource(DataFlow::Node source, FlowState state) {
    exists(ArrayType array |
      state = TArray(array) and
      VariableToPointerArith::candidateSource(array, source)
    )
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    exists(PointerArithmeticInstruction pai |
      state = TOverflowArithmetic(_, pai) and
      PointerArithmeticToDeref::candidateForSink(pai, sink)
    )
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node, _) }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node, _) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(PointerArithmeticInstruction pai, ArrayType t |
      state1 = TArray(t) and
      state2 = TOverflowArithmetic(t, pai) and
      pai.getLeftOperand() = node1.asOperand() and
      node2.asInstruction() = pai
    )
  }
}

module ArrayAddressToDerefFlow = DataFlow::GlobalWithState<ArrayAddressToDerefConfig>;

from
  Variable v, ArrayAddressToDerefFlow::PathNode source, PointerArithmeticInstruction pai,
  ArrayAddressToDerefFlow::PathNode sink, Instruction deref, string operation, int delta, int bytes,
  int index, ArrayType arrayType, int end
where
  ArrayAddressToDerefFlow::flowPath(pragma[only_bind_into](source), pragma[only_bind_into](sink)) and
  isInvalidPointerDerefSink2(sink.getNode(), deref, operation) and
  pragma[only_bind_out](sink.getState()) =
    ArrayAddressToDerefConfig::TOverflowArithmetic(arrayType, pai) and
  isSourceImpl(source.getNode(), v, arrayType, bytes) and
  PointerArithmeticToDeref::constantUpperBounded(pai, index) and
  end = (index + 1) * pai.getElementSize() and
  delta = end - bytes and
  delta > 0
select pai, source, sink,
  "This pointer arithmetic may have an off-by-" + ((delta - 1) / pai.getElementSize() + 1) +
    " error allowing it to overrun $@ at this $@.", v, v.getName(), deref, operation
