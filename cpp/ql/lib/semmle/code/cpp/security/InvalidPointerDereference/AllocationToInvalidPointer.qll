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
private import semmle.code.cpp.security.ProductFlowUtils.ProductFlowUtils
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import codeql.util.Unit
private import semmle.code.cpp.rangeanalysis.new.RangeAnalysisUtil

/**
 * Gets the virtual dispatch branching limit when calculating field flow while searching
 * for flow from an allocation to the construction of an out-of-bounds pointer.
 *
 * This can be overridden to a smaller value to improve performance (a
 * value of 0 disables field flow), or a larger value to get more results.
 */
int allocationToInvalidPointerFieldFlowBranchLimit() { result = 0 }

private module InterestingPointerAddInstruction {
  private module PointerAddInstructionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // The sources is the same as in the sources for the second
      // projection in the `AllocToInvalidPointerConfig` module.
      hasSize(source.asExpr(), _, _)
    }

    predicate fieldFlowBranchLimit = allocationToInvalidPointerFieldFlowBranchLimit/0;

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

private module SizeBarrierInput implements SizeBarrierInputSig {
  predicate fieldFlowBranchLimit = allocationToInvalidPointerFieldFlowBranchLimit/0;

  predicate isSource(DataFlow::Node source) {
    // The sources is the same as in the sources for the second
    // projection in the `AllocToInvalidPointerConfig` module.
    hasSize(_, source, _) and
    InterestingPointerAddInstruction::isInterestingSize(source)
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
    node = SizeBarrier<SizeBarrierInput>::getABarrierNode(state)
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

  predicate isBarrierOut2(DataFlow::Node node) { DataFlow::flowsToBackEdge(node) }
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
    not right = SizeBarrier<SizeBarrierInput>::getABarrierInstruction(delta) and
    not sizeInstr = SizeBarrier<SizeBarrierInput>::getABarrierInstruction(delta)
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
