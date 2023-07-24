/**
 * This file provides the first phase of the `cpp/invalid-pointer-deref` query that identifies flow
 * from an allocation to a pointer-arithmetic instruction that constructs a pointer that is out of bounds.
 */

private import cpp
private import semmle.code.cpp.ir.dataflow.internal.ProductFlow
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import codeql.util.Unit
private import RangeAnalysisUtil

private VariableAccess getAVariableAccess(Expr e) { e.getAChild*() = result }

/**
 * Holds if the `(n, state)` pair represents the source of flow for the size
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
 * instruction `pai = a + b` such that:
 * 1. the allocation flows to `a`, and
 * 2. `b <= n` where `n` is the `n` in `p[n]`
 * but because there's a strict comparison that compares `n` against the size of the allocation this
 * snippet is fine.
 */
module SizeBarrier {
  private module SizeBarrierConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(_, source, _)
    }

    additional predicate isSink(
      DataFlow::Node left, DataFlow::Node right, IRGuardCondition g, int k, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison. i.e., the `right` expression
      // in a guard such as `left < right + k`.
      g.comparesLt(left.asOperand(), right.asOperand(), k, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }
  }

  private import DataFlow::Global<SizeBarrierConfig>

  private int getAFlowStateForNode(DataFlow::Node node) {
    exists(DataFlow::Node source |
      flow(source, node) and
      hasSize(_, source, result)
    )
  }

  private predicate operandGuardChecks(
    IRGuardCondition g, Operand left, Operand right, int state, boolean edge
  ) {
    exists(DataFlow::Node nLeft, DataFlow::Node nRight, int k |
      nRight.asOperand() = right and
      nLeft.asOperand() = left and
      SizeBarrierConfig::isSink(nLeft, nRight, g, k, edge) and
      state = getAFlowStateForNode(nRight) and
      k <= state
    )
  }

  /**
   * Gets an instruction that is guarded by a guard condition which ensures that
   * the value of the instruction is upper-bounded by size of some allocation.
   */
  Instruction getABarrierInstruction(int state) {
    exists(IRGuardCondition g, ValueNumber value, Operand use, boolean edge |
      use = value.getAUse() and
      operandGuardChecks(pragma[only_bind_into](g), pragma[only_bind_into](use), _,
        pragma[only_bind_into](state), pragma[only_bind_into](edge)) and
      result = value.getAnInstruction() and
      g.controls(result.getBlock(), edge)
    )
  }

  /**
   * Gets a `DataFlow::Node` that is guarded by a guard condition which ensures that
   * the value of the node is upper-bounded by size of some allocation.
   */
  DataFlow::Node getABarrierNode(int state) {
    result.asOperand() = getABarrierInstruction(state).getAUse()
  }

  /**
   * Gets the block of a node that is guarded (see `getABarrierInstruction` or
   * `getABarrierNode` for the definition of what it means to be guarded).
   */
  IRBlock getABarrierBlock(int state) { result.getAnInstruction() = getABarrierInstruction(state) }
}

private module InterestingPointerAddInstruction {
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

  /**
   * Holds if `pai` is a pointer-arithmetic instruction such that the
   * result of an allocation flows to the left-hand side of `pai`.
   *
   * This predicate is used to reduce the set of tuples in `isSinkPair`.
   */
  predicate isInteresting(PointerAddInstruction pai) {
    exists(DataFlow::Node n |
      n.asInstruction() = pai.getLeft() and
      flowTo(n)
    )
  }
}

/**
 * A product-flow configuration for flow from an `(allocation, size)` pair to a
 * pointer-arithmetic operation `pai` such that `pai <= allocation + size`.
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
private module Config implements ProductFlow::StateConfigSig {
  class FlowState1 = Unit;

  class FlowState2 = int;

  predicate isSourcePair(
    DataFlow::Node allocSource, FlowState1 unit, DataFlow::Node sizeSource, FlowState2 sizeAddend
  ) {
    // In the case of an allocation like
    // ```cpp
    // malloc(size + 1);
    // ```
    // we use `state2` to remember that there was an offset (in this case an offset of `1`) added
    // to the size of the allocation. This state is then checked in `isSinkPair`.
    exists(unit) and
    hasSize(allocSource.asConvertedExpr(), sizeSource, sizeAddend)
  }

  predicate isSinkPair(
    DataFlow::Node allocSink, FlowState1 unit, DataFlow::Node sizeSink, FlowState2 sizeAddend
  ) {
    exists(unit) and
    // We check that the delta computed by the range analysis matches the
    // state value that we set in `isSourcePair`.
    pointerAddInstructionHasBounds0(_, allocSink, sizeSink, sizeAddend)
  }

  predicate isBarrier2(DataFlow::Node node, FlowState2 state) {
    node = SizeBarrier::getABarrierNode(state)
  }

  predicate isBarrierIn1(DataFlow::Node node) { isSourcePair(node, _, _, _) }

  predicate isBarrierOut2(DataFlow::Node node) {
    node = any(DataFlow::SsaPhiNode phi).getAnInput(true)
  }
}

private module AllocToInvalidPointerFlow = ProductFlow::GlobalWithState<Config>;

/**
 * Holds if `pai` is non-strictly upper bounded by `sizeSink + delta` and `allocSink` is the
 * left operand of the pointer-arithmetic operation.
 *
 * For example in,
 * ```cpp
 * char* end = p + (size + 1);
 * ```
 * We will have:
 * - `pai` is `p + (size + 1)`,
 * - `allocSink` is `p`
 * - `sizeSink` is `size`
 * - `delta` is `1`.
 */
pragma[nomagic]
private predicate pointerAddInstructionHasBounds0(
  PointerAddInstruction pai, DataFlow::Node allocSink, DataFlow::Node sizeSink, int delta
) {
  InterestingPointerAddInstruction::isInteresting(pragma[only_bind_into](pai)) and
  exists(Instruction right, Instruction sizeInstr |
    pai.getRight() = right and
    pai.getLeft() = allocSink.asInstruction() and
    sizeInstr = sizeSink.asInstruction() and
    // pai.getRight() <= sizeSink + delta
    bounded1(right, sizeInstr, delta) and
    not right = SizeBarrier::getABarrierInstruction(delta) and
    not sizeInstr = SizeBarrier::getABarrierInstruction(delta)
  )
}

/**
 * Holds if `allocation` flows to `allocSink` and `allocSink` represents the left operand
 * of the pointer-arithmetic instruction `pai = a + b` (i.e., `allocSink = a`), and
 * `b <= allocation + delta`.
 */
pragma[nomagic]
predicate pointerAddInstructionHasBounds(
  DataFlow::Node allocation, PointerAddInstruction pai, DataFlow::Node allocSink, int delta
) {
  exists(DataFlow::Node sizeSink |
    AllocToInvalidPointerFlow::flow(allocation, _, allocSink, sizeSink) and
    pointerAddInstructionHasBounds0(pai, allocSink, sizeSink, delta)
  )
}
