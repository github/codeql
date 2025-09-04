/**
 * This file provides the `SizeBarrier` module which provides barriers for
 * both the `cpp/invalid-pointer-deref` query and the `cpp/overrun-write`
 * query.
 */

private import cpp
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
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

/** Provides the input specification of the `SizeBarrier` module. */
signature module SizeBarrierInputSig {
  /** Gets the virtual dispatch branching limit when calculating field flow. */
  int fieldFlowBranchLimit();

  /** Holds if `source` is a relevant data flow source. */
  predicate isSource(DataFlow::Node source);
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
module SizeBarrier<SizeBarrierInputSig Input> {
  private module SizeBarrierConfig implements DataFlow::ConfigSig {
    predicate isSource = Input::isSource/1;

    predicate fieldFlowBranchLimit = Input::fieldFlowBranchLimit/0;

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

  private module SizeBarrierFlow = DataFlow::Global<SizeBarrierConfig>;

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
   * `small <= _ + k` and `small` is the "small side" of a relational comparison that checks
   * whether `small <= size` where `size` is the size of an allocation.
   */
  private Instruction getABarrierInstruction0(int delta, int k) {
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
      result.asInstruction() = getABarrierInstruction0(delta, k) and
      state > k + delta
      // so now we have:
      // result <= "size of allocation" + delta + k
      //        < "size of allocation" + state
    )
  }
}
