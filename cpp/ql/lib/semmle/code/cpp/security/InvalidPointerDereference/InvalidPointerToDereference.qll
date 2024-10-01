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
 * instruction `pai` found by `AllocationToInvalidPointer.qll` and a `n.asInstruction() = pai`.
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
 * We use the `deltaDerefSinkAndDerefAddress` to compute how many elements the dereference is beyond the end position of
 * the allocation. This is done in the `operationIsOffBy` predicate (which is the only predicate exposed by this file).
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
 * `n < node + k` where `node` is a node such that `node <= pai`. Thus, we know that any node `m` such that `m <= n + delta` where
 * `delta + k <= 0` will be safe because:
 * ```
 * m <= n + delta
 *   <  node + k + delta
 *   <= pai + k + delta
 *   <= pai
 * ```
 */

private import cpp
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import AllocationToInvalidPointer as AllocToInvalidPointer
private import semmle.code.cpp.rangeanalysis.new.RangeAnalysisUtil

/**
 * Gets the virtual dispatch branching limit when calculating field flow while
 * searching for flow from an out-of-bounds pointer to a dereference of the
 * pointer.
 *
 * This can be overridden to a smaller value to improve performance (a
 * value of 0 disables field flow), or a larger value to get more results.
 */
int invalidPointerToDereferenceFieldFlowBranchLimit() { result = 0 }

private module InvalidPointerToDerefBarrier {
  private module BarrierConfig implements DataFlow::ConfigSig {
    additional predicate isSource(DataFlow::Node source, PointerArithmeticInstruction pai) {
      invalidPointerToDerefSource(_, pai, _) and
      // source <= pai
      bounded2(source.asInstruction(), pai, any(int d | d <= 0))
    }

    predicate isSource(DataFlow::Node source) { isSource(source, _) }

    additional predicate isSink(
      DataFlow::Node small, DataFlow::Node large, IRGuardCondition g, int k, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison.
      g.comparesLt(small.asOperand(), large.asOperand(), k, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }

    int fieldFlowBranchLimit() { result = invalidPointerToDereferenceFieldFlowBranchLimit() }
  }

  private module BarrierFlow = DataFlow::Global<BarrierConfig>;

  /**
   * Holds if `g` ensures that `small < large + k` if `g` evaluates to `edge`.
   *
   * Additionally, it also holds that `large <= pai`. Thus, when `g` evaluates to `edge`
   * it holds that `small < pai + k`.
   */
  private predicate operandGuardChecks(
    PointerArithmeticInstruction pai, IRGuardCondition g, Operand small, int k, boolean edge
  ) {
    exists(DataFlow::Node source, DataFlow::Node nSmall, DataFlow::Node nLarge |
      nSmall.asOperand() = small and
      BarrierConfig::isSource(source, pai) and
      BarrierFlow::flow(source, nLarge) and
      BarrierConfig::isSink(nSmall, nLarge, g, k, edge)
    )
  }

  /**
   * Gets an instruction `instr` such that `instr < pai`.
   */
  Instruction getABarrierInstruction(PointerArithmeticInstruction pai) {
    exists(IRGuardCondition g, ValueNumber value, Operand use, boolean edge, int delta, int k |
      use = value.getAUse() and
      // value < pai + k
      operandGuardChecks(pai, pragma[only_bind_into](g), pragma[only_bind_into](use),
        pragma[only_bind_into](k), pragma[only_bind_into](edge)) and
      // result <= value + delta
      bounded(result, value.getAnInstruction(), delta) and
      g.controls(result.getBlock(), edge) and
      delta + k <= 0
      // combining the above we have: result < pai + k + delta <= pai
    )
  }

  DataFlow::Node getABarrierNode(PointerArithmeticInstruction pai) {
    result.asOperand() = getABarrierInstruction(pai).getAUse()
  }

  /**
   * Gets an address operand whose definition `instr` satisfies `instr < pai`.
   */
  AddressOperand getABarrierAddressOperand(PointerArithmeticInstruction pai) {
    result.getDef() = getABarrierInstruction(pai)
  }
}

/**
 * BEWARE: This configuration uses an unrestricted sink, so accessing its full
 * flow computation or any stages beyond the first 2 will likely diverge.
 * Stage 1 will still be fast and we use it to restrict the subsequent sink
 * computation.
 */
private module InvalidPointerReachesConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { invalidPointerToDerefSource(_, _, source) }

  predicate isSink(DataFlow::Node sink) { any() }

  predicate isBarrier(DataFlow::Node node) { InvalidPointerToDerefConfig::isBarrier(node) }

  int fieldFlowBranchLimit() { result = invalidPointerToDereferenceFieldFlowBranchLimit() }
}

private module InvalidPointerReachesFlow = DataFlow::Global<InvalidPointerReachesConfig>;

private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

/**
 * A configuration to track flow from a pointer-arithmetic operation found
 * by `AllocToInvalidPointerConfig` to a dereference of the pointer.
 */
private module InvalidPointerToDerefConfig implements DataFlow::StateConfigSig {
  class FlowState extends PointerArithmeticInstruction {
    FlowState() { invalidPointerToDerefSource(_, this, _) }
  }

  predicate isSource(DataFlow::Node source, FlowState pai) {
    invalidPointerToDerefSource(_, pai, source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlowImplCommon::NodeEx n |
      InvalidPointerReachesFlow::Stages::Stage1::sinkNode(n, _) and
      n.asNode() = sink and
      isInvalidPointerDerefSink(sink, _, _, _, _)
    )
  }

  predicate isSink(DataFlow::Node sink, FlowState pai) { none() }

  predicate isBarrier(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi | not phi.isPhiRead()).getAnInput(true)
  }

  predicate isBarrier(DataFlow::Node node, FlowState pai) {
    // `node = getABarrierNode(pai)` ensures that node < pai, so this node is safe to dereference.
    // Note that this is the only place where the `FlowState` is used in this configuration.
    node = InvalidPointerToDerefBarrier::getABarrierNode(pai)
  }

  int fieldFlowBranchLimit() { result = invalidPointerToDereferenceFieldFlowBranchLimit() }
}

private import DataFlow::GlobalWithState<InvalidPointerToDerefConfig>

/**
 * Holds if `allocSource` is dataflow node that represents an allocation that flows to the
 * left-hand side of the pointer-arithmetic instruction represented by `derefSource`.
 */
private predicate invalidPointerToDerefSource(
  DataFlow::Node allocSource, PointerArithmeticInstruction pai, DataFlow::Node derefSource
) {
  // Note that `deltaDerefSourceAndPai` is not necessarily equal to `rhsSizeDelta`:
  // `rhsSizeDelta` is the constant offset added to the size of the allocation, and
  // `deltaDerefSourceAndPai` is the constant difference between the pointer-arithmetic instruction
  // and the instruction computing the address for which we will search for a dereference.
  AllocToInvalidPointer::pointerAddInstructionHasBounds(allocSource, pai, _, _) and
  derefSource.asInstruction() = pai
}

/**
 * Holds if `sink` is a sink for `InvalidPointerToDerefConfig` and `i` is a `StoreInstruction` that
 * writes to an address `addr` such that `addr <= sink`, or `i` is a `LoadInstruction` that
 * reads from an address `addr` such that `addr <= sink`.
 */
pragma[inline]
private predicate isInvalidPointerDerefSink(
  DataFlow::Node sink, AddressOperand addr, Instruction i, string operation,
  int deltaDerefSinkAndDerefAddress
) {
  exists(Instruction s |
    s = sink.asInstruction() and
    bounded(addr.getDef(), s, deltaDerefSinkAndDerefAddress) and
    deltaDerefSinkAndDerefAddress >= 0 and
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
    invalidPointerToDerefSource(_, pai, derefSource) and
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
  exists(Instruction operationInstr, AddressOperand addr |
    paiForDereferenceSink(pai, pragma[only_bind_into](derefSink)) and
    isInvalidPointerDerefSink(derefSink, addr, operationInstr, description,
      deltaDerefSinkAndDerefAddress) and
    operationInstr = getASuccessor(derefSink.asInstruction()) and
    operation.asInstruction() = operationInstr and
    not addr = InvalidPointerToDerefBarrier::getABarrierAddressOperand(pai)
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
  invalidPointerToDerefSource(allocation, pai, derefSource) and
  flow(derefSource, derefSink) and
  derefSinkToOperation(derefSink, pai, operation, description, delta)
}
