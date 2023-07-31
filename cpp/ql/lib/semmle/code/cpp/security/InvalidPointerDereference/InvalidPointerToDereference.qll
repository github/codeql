/**
 * This file provides the second phase of the `cpp/invalid-pointer-deref` query that identifies flow
 * from the out-of-bounds pointer identified by the `AllocationToInvalidPointer.qll` library to
 * a dereference of the out-of-bounds pointer.
 *
 * Consider the following snippet:
 * ```cpp
 * 1. char* base = (char*)malloc(size);
 * 2. char* end = base + size;
 * 3. for(char *p = base; p <= end; p++) {
 * 4.   use(*p); // BUG: Should have been bounded by `p < end`.
 * 5. }
 * ```
 * this file identifies the flow from `base + size` to `end`. We call `base + size` the "dereference source" and `end`
 * the "dereference sink" (even though `end` is not actually dereferenced we will use this term because we will perform
 * dataflow to find a use of a pointer `x` such that `x <= end` which is dereferenced. In the above example, `x` is `p`
 * on line 4).
 *
 * Merely _constructing_ a pointer that's out-of-bounds is fine if the pointer is never dereferenced (in reality, the
 * standard only guarantees that it is safe to move the pointer one element past the last element, but we ignore that
 * here). So this step is about identifying which of the out-of-bounds pointers found by `pointerAddInstructionHasBounds`
 * in `AllocationToInvalidPointer.qll` are actually being dereferenced. We do this using a regular dataflow
 * configuration (see `InvalidPointerToDerefConfig`).
 *
 * The dataflow traversal defines the set of sources as any dataflow node `n` such that there exists a pointer-arithmetic
 * instruction `pai` found by `AllocationToInvalidPointer.qll` and a `n.asInstruction() >= pai + deltaDerefSourceAndPai`.
 * Here, `deltaDerefSourceAndPai` is the constant difference between the source we track for finding a dereference and the
 * pointer-arithmetic instruction.
 *
 * The set of sinks is defined as any dataflow node `n` such that `addr <= n.asInstruction() + deltaDerefSinkAndDerefAddress`
 * for some address operand `addr` and constant difference `deltaDerefSinkAndDerefAddress`. Since an address operand is
 * always consumed by an instruction that performs a dereference this lets us identify a "bad dereference". We call the
 * instruction that consumes the address operand the "operation".
 *
 * For example, consider the flow from `base + size` to `end` above. The sink is `end` on line 3 because
 * `p <= end.asInstruction() + deltaDerefSinkAndDerefAddress`, where `p` is the address operand in `use(*p)` and
 * `deltaDerefSinkAndDerefAddress >= 0`. The load attached to `*p` is the "operation". To ensure that the path makes
 * intuitive sense, we only pick operations that are control-flow reachable from the dereference sink.
 *
 * To compute how many elements the dereference is beyond the end position of the allocation, we sum the two deltas
 * `deltaDerefSourceAndPai` and `deltaDerefSinkAndDerefAddress`. This is done in the `operationIsOffBy` predicate
 * (which is the only predicate exposed by this file).
 *
 * Handling false positives:
 *
 * Consider the following snippet:
 * ```cpp
 * 1. char *p = new char[size];
 * 2. char *end = p + size;
 * 3. if (p < end) {
 * 4.   p += 1;
 * 5. }
 * 6. if (p < end) {
 * 7.   int val = *p; // GOOD
 * 8. }
 * ```
 * this is safe because `p` is guarded to be strictly less than `end` on line 6 before the dereference on line 7. However, if we
 * run the query on the above without further modifications we would see an alert on line 7. This is because range analysis infers
 * that `p <= end` after the increment on line 4, and thus the result of `p += 1` is seen as a valid dereference source. This
 * node then flows to `p` on line 6 (which is a valid dereference sink since it non-strictly upper bounds an address operand), and
 * range analysis then infers that the address operand of `*p` (i.e., `p`) is non-strictly upper bounded by `p`, and thus reports
 * an alert on line 7.
 *
 * In order to handle the above false positive, we define a barrier that identifies guards such as `p < end` that ensures that a value
 * is less than the pointer-arithmetic instruction that computed the invalid pointer. This is done in the `InvalidPointerToDerefBarrier`
 * module. Since the node we are tracking is not necessarily _equal_ to the pointer-arithmetic instruction, but rather satisfies
 * `node.asInstruction() <= pai + deltaDerefSourceAndPai`, we need to account for the delta when checking if a guard is sufficiently
 * strong to infer that a future dereference is safe. To do this, we check that the guard guarantees that a node `n` satisfies
 * `n < node + k` where `node` is a node we know is equal to the value of the dereference source (i.e., it satisfies
 * `node.asInstruction() <= pai + deltaDerefSourceAndPai`) and `k <= deltaDerefSourceAndPai`. Combining this we have
 * `n < node + k <= node + deltaDerefSourceAndPai <= pai + 2*deltaDerefSourceAndPai` (TODO: Oops. This math doesn't quite work out.
 * I think this is because we need to redefine the `BarrierConfig` to start flow at the pointer-arithmetic instruction instead of
 * at the dereference source. When combined with TODO above it's easy to show that this guard ensures that the dereference is safe).
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
      DataFlow::Node left, DataFlow::Node right, IRGuardCondition g, int k, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison.
      g.comparesLt(left.asOperand(), right.asOperand(), k, true, testIsTrue)
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
    exists(DataFlow::Node nLeft, DataFlow::Node nRight, int k |
      nRight.asOperand() = right and
      nLeft.asOperand() = left and
      BarrierConfig::isSink(nLeft, nRight, g, k, edge) and
      state = getInvalidPointerToDerefSourceDelta(nRight) and
      k <= state
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
 * Holds if `allocSource` is dataflow node that represents an allocation that flows to the
 * left-hand side of the pointer-arithmetic `pai`, and `derefSource <= pai + derefSourcePaiDelta`.
 *
 * For example, if `pai` is a pointer-arithmetic operation `p + size` in an expression such
 * as `(p + size) + 1` and `derefSource` is the node representing `(p + size) + 1`. In this
 * case `derefSourcePaiDelta` is 1.
 */
private predicate invalidPointerToDerefSource(
  DataFlow::Node allocSource, PointerArithmeticInstruction pai, DataFlow::Node derefSource,
  int deltaDerefSourceAndPai
) {
  exists(int rhsSizeDelta |
    // Note that `deltaDerefSourceAndPai` is not necessarily equal to `rhsSizeDelta`:
    // `rhsSizeDelta` is the constant offset added to the size of the allocation, and
    // `deltaDerefSourceAndPai` is the constant difference between the pointer-arithmetic instruction
    // and the instruction computing the address for which we will search for a dereference.
    AllocToInvalidPointer::pointerAddInstructionHasBounds(allocSource, pai, _, rhsSizeDelta) and
    bounded2(derefSource.asInstruction(), pai, deltaDerefSourceAndPai) and
    deltaDerefSourceAndPai >= 0 and
    // TODO: This condition will go away once #13725 is merged, and then we can make `SizeBarrier`
    // private to `AllocationToInvalidPointer.qll`.
    not derefSource.getBasicBlock() =
      AllocToInvalidPointer::SizeBarrier::getABarrierBlock(rhsSizeDelta)
  )
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConfig` and `i` is a `StoreInstruction` that
 * writes to an address `addr` such that `addr <= sink`, or `i` is a `LoadInstruction` that
 * reads from an address `addr` such that `addr <= sink`.
 */
pragma[inline]
private predicate isInvalidPointerDerefSink(
  DataFlow::Node sink, Instruction i, string operation, int deltaDerefSinkAndDerefAddress
) {
  exists(AddressOperand addr, Instruction s, IRBlock b |
    s = sink.asInstruction() and
    bounded(addr.getDef(), s, deltaDerefSinkAndDerefAddress) and
    deltaDerefSinkAndDerefAddress >= 0 and
    i.getAnOperand() = addr and
    b = i.getBlock() and
    not b = InvalidPointerToDerefBarrier::getABarrierBlock(deltaDerefSinkAndDerefAddress)
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
  string description, int deltaDerefSinkAndDerefAddress
) {
  exists(Instruction operationInstr |
    paiForDereferenceSink(pai, pragma[only_bind_into](derefSink)) and
    isInvalidPointerDerefSink(derefSink, operationInstr, description, deltaDerefSinkAndDerefAddress) and
    operationInstr = getASuccessor(derefSink.asInstruction()) and
    operation.asInstruction() = operationInstr
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
