/**
 * This file provides the second phase of the `cpp/invalid-pointer-deref` query that identifies flow
 * from the out-of-bounds pointer identified by the `AllocationToInvalidPointer.qll` library to
 * a dereference of the out-of-bounds pointer.
 */

private import cpp
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import AllocationToInvalidPointer as AllocToInvalidPointer
private import RangeAnalysisUtil

private module InvalidPointerToDerefBarrier {
  private module BarrierConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for `InvalidPointerToDerefConfig`.
      invalidPointerToDerefSource(_, _, source, _)
    }

    additional predicate isSink(
      DataFlow::Node left, DataFlow::Node right, IRGuardCondition g, int state, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison.
      g.comparesLt(left.asOperand(), right.asOperand(), state, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }
  }

  private module BarrierFlow = DataFlow::Global<BarrierConfig>;

  private int getInvalidPointerToDerefSourceDelta(DataFlow::Node node) {
    exists(DataFlow::Node source |
      BarrierFlow::flow(source, node) and
      invalidPointerToDerefSource(_, _, source, result)
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
private module InvalidPointerToDerefConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { invalidPointerToDerefSource(_, _, source, _) }

  pragma[inline]
  predicate isSink(DataFlow::Node sink) { isInvalidPointerDerefSink(sink, _, _, _) }

  predicate isBarrier(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi | not phi.isPhiRead()).getAnInput(true)
    or
    node = InvalidPointerToDerefBarrier::getABarrierNode()
  }
}

private import DataFlow::Global<InvalidPointerToDerefConfig>

/**
 * Holds if `source1` is dataflow node that represents an allocation that flows to the
 * left-hand side of the pointer-arithmetic `pai`, and `derefSource` is a dataflow node with
 * a pointer-value that is non-strictly upper bounded by `pai + delta`.
 *
 * For example, if `pai` is a pointer-arithmetic operation `p + size` in an expression such
 * as `(p + size) + 1` and `derefSource` is the node representing `(p + size) + 1`. In this
 * case `delta` is 1.
 */
private predicate invalidPointerToDerefSource(
  DataFlow::Node source1, PointerArithmeticInstruction pai, DataFlow::Node derefSource, int delta
) {
  exists(int delta0 |
    // Note that `delta` is not necessarily equal to `delta0`:
    // `delta0` is the constant offset added to the size of the allocation, and
    // delta is the constant difference between the pointer-arithmetic instruction
    // and the instruction computing the address for which we will search for a dereference.
    AllocToInvalidPointer::pointerAddInstructionHasBounds(source1, pai, _, delta0) and
    bounded2(derefSource.asInstruction(), pai, delta) and
    delta >= 0 and
    // TODO: This condition will go away once #13725 is merged, and then we can make `Barrier2`
    // private to `AllocationToInvalidPointer.qll`.
    not derefSource.getBasicBlock() = AllocToInvalidPointer::Barrier2::getABarrierBlock(delta0)
  )
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConfig` and `i` is a `StoreInstruction` that
 * writes to an address that non-strictly upper-bounds `sink`, or `i` is a `LoadInstruction` that
 * reads from an address that non-strictly upper-bounds `sink`.
 */
pragma[inline]
private predicate isInvalidPointerDerefSink(
  DataFlow::Node sink, Instruction i, string operation, int delta
) {
  exists(AddressOperand addr, Instruction s, IRBlock b |
    s = sink.asInstruction() and
    bounded(addr.getDef(), s, delta) and
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

/**
 * Yields any instruction that is control-flow reachable from `instr`.
 */
bindingset[instr, result]
pragma[inline_late]
private Instruction getASuccessor(Instruction instr) {
  exists(IRBlock b, int instrIndex, int resultIndex |
    b.getInstruction(instrIndex) = instr and
    b.getInstruction(resultIndex) = result
  |
    resultIndex >= instrIndex
  )
  or
  instr.getBlock().getASuccessor+() = result.getBlock()
}

private predicate paiForDereferenceSink(PointerArithmeticInstruction pai, DataFlow::Node derefSink) {
  exists(DataFlow::Node derefSource |
    invalidPointerToDerefSource(_, pai, derefSource, _) and
    flow(derefSource, derefSink)
  )
}

/**
 * Holds if `derefSink` is a dataflow node that represents an out-of-bounds address that is about to
 * be dereferenced by `operation` (which is either a `StoreInstruction` or `LoadInstruction`), and
 * `pai` is the pointer-arithmetic operation that caused the `derefSink` to be out-of-bounds.
 */
private predicate derefSinkToOperation(
  DataFlow::Node derefSink, PointerArithmeticInstruction pai, DataFlow::Node operation,
  string description, int delta
) {
  exists(Instruction i |
    paiForDereferenceSink(pai, pragma[only_bind_into](derefSink)) and
    isInvalidPointerDerefSink(derefSink, i, description, delta) and
    i = getASuccessor(derefSink.asInstruction()) and
    operation.asInstruction() = i
  )
}

/**
 * Holds if `allocation` is the result of an allocation that flows to the left-hand side of `pai`, and where
 * the right-hand side of `pai` is an offset such that the result of `pai` points to an out-of-bounds pointer.
 *
 * Furthermore, `derefSource` is at least as large as `pai` and flows to `derefSink` before being dereferenced
 * by `operation` (which is either a `StoreInstruction` or `LoadInstruction`). The result is that `operation`
 * dereferences a pointer that's "off by `delta`" number of elements.
 */
predicate operationIsOffBy(
  DataFlow::Node allocation, PointerArithmeticInstruction pai, DataFlow::Node derefSource,
  DataFlow::Node derefSink, string description, DataFlow::Node operation, int delta
) {
  exists(int deltaDerefSourceAndPai, int deltaDerefSinkAndDerefAddress |
    invalidPointerToDerefSource(allocation, pai, derefSource, deltaDerefSourceAndPai) and
    flow(derefSource, derefSink) and
    derefSinkToOperation(derefSink, pai, operation, description, deltaDerefSinkAndDerefAddress) and
    delta = deltaDerefSourceAndPai + deltaDerefSinkAndDerefAddress
  )
}
