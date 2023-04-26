import cpp
import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.ir.IR

/**
 * Signature for a predicate that holds if `n.asExpr() = e` and `n` is a sink in
 * the `FlowFromFreeConfig` module.
 */
private signature predicate isSinkSig(DataFlow::Node n, Expr e);

/**
 * Holds if `dealloc` is a deallocation expression and `e` is an expression such
 * that `isFree(_, e)` holds for some `isFree` predicate satisfying `isSinkSig`,
 * and this source-sink pair should be excluded from the analysis.
 */
bindingset[dealloc, e]
private signature predicate isExcludedSig(DeallocationExpr dealloc, Expr e);

/**
 * Holds if `(b1, i1)` strictly post-dominates `(b2, i2)`
 */
bindingset[i1, i2]
predicate strictlyPostDominates(IRBlock b1, int i1, IRBlock b2, int i2) {
  b1 = b2 and
  i1 > i2
  or
  b1.strictlyPostDominates(b2)
}

/**
 * Holds if `(b1, i1)` strictly dominates `(b2, i2)`
 */
bindingset[i1, i2]
predicate strictlyDominates(IRBlock b1, int i1, IRBlock b2, int i2) {
  b1 = b2 and
  i1 < i2
  or
  b1.strictlyDominates(b2)
}

/**
 * Constructs a `FlowFromFreeConfig` module that can be used to find flow between
 * a pointer being freed by some deallocation function, and a user-specified sink.
 *
 * In order to reduce false positives, the set of sinks is restricted to only those
 * that satisfy at least one of the following two criteria:
 * 1. The source dominates the sink, or
 * 2. The sink post-dominates the source.
 */
module FlowFromFree<isSinkSig/2 isASink, isExcludedSig/2 isExcluded> {
  module FlowFromFreeConfig implements DataFlow::StateConfigSig {
    class FlowState instanceof Expr {
      FlowState() { isFree(_, this, _) }

      string toString() { result = super.toString() }
    }

    predicate isSource(DataFlow::Node node, FlowState state) { isFree(node, state, _) }

    pragma[inline]
    predicate isSink(DataFlow::Node sink, FlowState state) {
      exists(
        Expr e, DataFlow::Node source, IRBlock b1, int i1, IRBlock b2, int i2,
        DeallocationExpr dealloc
      |
        isASink(sink, e) and
        isFree(source, state, dealloc) and
        e != state and
        source.hasIndexInBlock(b1, i1) and
        sink.hasIndexInBlock(b2, i2) and
        not isExcluded(dealloc, e)
      |
        strictlyDominates(b1, i1, b2, i2)
        or
        strictlyPostDominates(b2, i2, b1, i1)
      )
    }

    predicate isBarrierIn(DataFlow::Node n) {
      n.asIndirectExpr() = any(AddressOfExpr aoe)
      or
      n.asIndirectExpr() = any(Call call).getAnArgument()
      or
      exists(Expr e |
        n.asIndirectExpr() = e.(PointerDereferenceExpr).getOperand() or
        n.asIndirectExpr() = e.(ArrayExpr).getArrayBase()
      |
        e = any(StoreInstruction store).getDestinationAddress().getUnconvertedResultExpression()
      )
    }

    predicate isBarrier(DataFlow::Node n, FlowState state) { none() }

    predicate isAdditionalFlowStep(
      DataFlow::Node n1, FlowState state1, DataFlow::Node n2, FlowState state2
    ) {
      none()
    }
  }

  import DataFlow::GlobalWithState<FlowFromFreeConfig>
}

/**
 * Holds if `n` is a dataflow node such that `n.asExpr() = e` and `e`
 * is being freed by a deallocation expression `dealloc`.
 */
predicate isFree(DataFlow::Node n, Expr e, DeallocationExpr dealloc) {
  e = dealloc.getFreedExpr() and
  e = n.asExpr() and
  // Ignore realloc functions
  not exists(dealloc.(FunctionCall).getTarget().(AllocationFunction).getReallocPtrArg())
}

/**
 * Holds if `fc` is a function call that is the result of expanding
 * the `ExFreePool` macro.
 */
predicate isExFreePoolCall(FunctionCall fc, Expr e) {
  e = fc.getArgument(0) and
  (
    exists(MacroInvocation mi |
      mi.getMacroName() = "ExFreePool" and
      mi.getExpr() = fc
    )
    or
    fc.getTarget().hasGlobalName("ExFreePool")
  )
}
