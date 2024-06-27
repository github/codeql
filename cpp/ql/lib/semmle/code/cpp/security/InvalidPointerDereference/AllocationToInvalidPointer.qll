/**
 * This file provides the first phase of the `cpp/invalid-pointer-deref` query that identifies flow
 * from an allocation to a pointer-arithmetic instruction that constructs a pointer that is out of bounds.
 *
 * Consider the following snippet:
 * ```cpp
 * 1. char* base = (char*)malloc(size);
 * 2. char* end = base + size;
 * 3. for(int *p = base; p <= end; p++) {
 * 4.   use(*p); // BUG: Should have been bounded by `p < end`.
 * 5. }
 * ```
 * this file identifies the flow from `new int[size]` to `base + size`.
 *
 * This is done using the product-flow library. The configuration tracks flow from the pair
 * `(allocation, size of allocation)` to a pair `(a, b)` where there exists a pointer-arithmetic instruction
 * `pai = a + r` such that `b` is a dataflow node where `b <= r`. Because there will be a dataflow-path from
 * `allocation` to `a` this means that the `pai` will compute a pointer that is some number of elements beyond
 * the end position of the allocation. See `pointerAddInstructionHasBounds` for the implementation of this.
 *
 * In the above example, the pair `(a, b)` is `(base, size)` with `base` and `size` coming from the expression
 * `base + size` on line 2, which is also the pointer-arithmetic instruction. In general, the pair does not necessarily
 * correspond directly to the operands of the pointer-arithmetic instruction.
 * In the following example, the pair is again `(base, size)`, but with `base` coming from line 3 and `size` from line 2,
 * and the pointer-arithmetic instruction being `base + n` on line 3:
 *  ```cpp
 *  1. int* base = new int[size];
 *  2. if(n <= size) {
 *  3.   int* end = base + n;
 *  4.   for(int* p = base; p <= end; ++p) {
 *  5.     *p = 0; // BUG: Should have been bounded by `p < end`.
 *  6.   }
 *  7. }
 *  ```
 *
 * Handling false positives:
 *
 * Consider a snippet such as:
 * ```cpp
 * 1. int* base = new int[size];
 * 2. int n = condition() ? size : 0;
 * 3. if(n >= size) return;
 * 4. int* end = base + n;
 * 5. for(int* p = base; p <= end; ++p) {
 * 6.   *p = 0; // This is fine since `end < base + size`
 * 7. }
 * ```
 * In order to remove this false positive we define a barrier (see `SizeBarrier::SizeBarrierConfig`) that finds the
 * possible guards that compares a value to the size of the allocation. In the above example, this is the `(n >= size)`
 * guard on line 3. `SizeBarrier::getABarrierNode` then defines any node that is guarded by such a guard as a barrier
 * in the dataflow configuration.
 */

private import cpp
private import semmle.code.cpp.ir.dataflow.internal.ProductFlow
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import codeql.util.Unit
private import semmle.code.cpp.rangeanalysis.new.RangeAnalysisUtil

private VariableAccess getAVariableAccess(Expr e) { e.getAChild*() = result }

/**
 * Gets a (sub)expression that may be the result of evaluating `size`.
 *
 * For example, `getASizeCandidate(a ? b : c)` gives `a ? b : c`, `b` and `c`.
 */
bindingset[size]
pragma[inline_late]
private Expr getASizeCandidate(Expr size) {
  result = size
  or
  result = [size.(ConditionalExpr).getThen(), size.(ConditionalExpr).getElse()]
}

/**
 * Holds if the `(n, state)` pair represents the source of flow for the size
 * expression associated with `alloc`.
 */
predicate hasSize(HeuristicAllocationExpr alloc, DataFlow::Node n, int state) {
  exists(VariableAccess va, Expr size, int delta, Expr s |
    size = alloc.getSizeExpr() and
    s = getASizeCandidate(size) and
    // Get the unique variable in a size expression like `x` in `malloc(x + 1)`.
    va = unique( | | getAVariableAccess(s)) and
    // Compute `delta` as the constant difference between `x` and `x + 1`.
    bounded1(any(Instruction instr | instr.getUnconvertedResultExpression() = s),
      any(LoadInstruction load | load.getUnconvertedResultExpression() = va), delta) and
    n.asExpr() = va and
    state = delta
  )
}

/**
 * Gets the virtual dispatch branching limit when calculating field flow while searching
 * for flow from an allocation to the construction of an out-of-bounds pointer.
 *
 * This can be overridden to a smaller value to improve performance (a
 * value of 0 disables field flow), or a larger value to get more results.
 */
int allocationToInvalidPointerFieldFlowBranchLimit() { result = 0 }

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
private module SizeBarrier {
  private module SizeBarrierConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(_, source, _) and
      InterestingPointerAddInstruction::isInterestingSize(source)
    }

    int fieldFlowBranchLimit() { result = allocationToInvalidPointerFieldFlowBranchLimit() }

    /**
     * Holds if `small <= large + k` holds if `g` evaluates to `testIsTrue`.
     */
    additional predicate isSink(
      DataFlow::Node small, DataFlow::Node large, IRGuardCondition g, int k, boolean testIsTrue
    ) {
      // The sink is any "large" side of a relational comparison. i.e., the `large` expression
      // in a guard such as `small <= large + k`.
      g.comparesLt(small.asOperand(), large.asOperand(), k + 1, true, testIsTrue)
    }

    predicate isSink(DataFlow::Node sink) { isSink(_, sink, _, _, _) }
  }

  module SizeBarrierFlow = DataFlow::Global<SizeBarrierConfig>;

  private int getASizeAddend(DataFlow::Node node) {
    exists(DataFlow::Node source |
      SizeBarrierFlow::flow(source, node) and
      hasSize(_, source, result)
    )
  }

  /**
   * Holds if `small <= large + k` holds if `g` evaluates to `edge`.
   */
  private predicate operandGuardChecks(
    IRGuardCondition g, Operand small, DataFlow::Node large, int k, boolean edge
  ) {
    SizeBarrierFlow::flowTo(large) and
    SizeBarrierConfig::isSink(DataFlow::operandNode(small), large, g, k, edge)
  }

  /**
   * Gets an instruction `instr` that is guarded by a check such as `instr <= small + delta` where
   * `small <= _ + k` and `small` is the "small side" of of a relational comparison that checks
   * whether `small <= size` where `size` is the size of an allocation.
   */
  Instruction getABarrierInstruction0(int delta, int k) {
    exists(
      IRGuardCondition g, ValueNumber value, Operand small, boolean edge, DataFlow::Node large
    |
      // We know:
      // 1. result <= value + delta (by `bounded`)
      // 2. value <= large + k (by `operandGuardChecks`).
      // So:
      // result <= value + delta (by 1.)
      //        <= large + k + delta (by 2.)
      small = value.getAUse() and
      operandGuardChecks(pragma[only_bind_into](g), pragma[only_bind_into](small), large,
        pragma[only_bind_into](k), pragma[only_bind_into](edge)) and
      bounded(result, value.getAnInstruction(), delta) and
      g.controls(result.getBlock(), edge) and
      k < getASizeAddend(large)
    )
  }

  /**
   * Gets an instruction that is guarded by a guard condition which ensures that
   * the value of the instruction is upper-bounded by size of some allocation.
   */
  bindingset[state]
  pragma[inline_late]
  Instruction getABarrierInstruction(int state) {
    exists(int delta, int k |
      state > k + delta and
      // result <= "size of allocation" + delta + k
      //        < "size of allocation" + state
      result = getABarrierInstruction0(delta, k)
    )
  }

  /**
   * Gets a `DataFlow::Node` that is guarded by a guard condition which ensures that
   * the value of the node is upper-bounded by size of some allocation.
   */
  DataFlow::Node getABarrierNode(int state) {
    exists(DataFlow::Node source, int delta, int k |
      SizeBarrierFlow::flow(source, result) and
      hasSize(_, source, state) and
      result.asInstruction() = SizeBarrier::getABarrierInstruction0(delta, k) and
      state > k + delta
      // so now we have:
      // result <= "size of allocation" + delta + k
      //        < "size of allocation" + state
    )
  }
}

private module InterestingPointerAddInstruction {
  private module PointerAddInstructionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(source.asExpr(), _, _)
    }

    int fieldFlowBranchLimit() { result = allocationToInvalidPointerFieldFlowBranchLimit() }

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

  /**
   * Holds if `n` is a size of an allocation whose result flows to the left operand
   * of a pointer-arithmetic instruction.
   *
   * This predicate is used to reduce the set of tuples in `SizeBarrierConfig::isSource`.
   */
  predicate isInterestingSize(DataFlow::Node n) {
    exists(DataFlow::Node alloc |
      hasSize(alloc.asExpr(), n, _) and
      flow(alloc, _)
    )
  }
}

/**
 * A product-flow configuration for flow from an `(allocation, size)` pair to a
 * pointer-arithmetic operation `pai` such that `pai <= allocation + size`.
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
    hasSize(allocSource.asExpr(), sizeSource, sizeAddend)
  }

  int fieldFlowBranchLimit1() { result = allocationToInvalidPointerFieldFlowBranchLimit() }

  int fieldFlowBranchLimit2() { result = allocationToInvalidPointerFieldFlowBranchLimit() }

  predicate isSinkPair(
    DataFlow::Node allocSink, FlowState1 unit, DataFlow::Node sizeSink, FlowState2 sizeAddend
  ) {
    exists(unit) and
    // We check that the delta computed by the range analysis matches the
    // state value that we set in `isSourcePair`.
    pointerAddInstructionHasBounds0(_, allocSink, sizeSink, sizeAddend)
  }

  private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

  predicate isBarrier2(DataFlow::Node node, FlowState2 state) {
    node = SizeBarrier::getABarrierNode(state)
  }

  predicate isBarrier2(DataFlow::Node node) {
    // Block flow from `*p` to `*(p + n)` when `n` is not `0`. This removes
    // false positives
    // when tracking the size of the allocation as an element of an array such
    // as:
    // ```
    // size_t* p = new size_t[n];
    // ...
    // p[0] = n;
    // int i = p[1];
    // p[i] = ...
    // ```
    // In the above case, this barrier blocks flow from the indirect node
    // for `p` to `p[1]`.
    exists(Operand operand, PointerAddInstruction add |
      node.(IndirectOperand).hasOperandAndIndirectionIndex(operand, _) and
      add.getLeftOperand() = operand and
      add.getRight().(ConstantInstruction).getValue() != "0"
    )
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
