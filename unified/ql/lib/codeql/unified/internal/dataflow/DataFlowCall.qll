private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private newtype TDataFlowCall =
  TExplicitCall(CallExpr call) {
    not isInBindingContext(call, _) // ignore constructor patterns
  } or
  TSummaryCall(SummarizedCallable callable, SummaryNode callee) {
    FlowSummaryOutput::summaryCallbackRange(callable, callee)
  }

/**
 * A call site, covering explicit calls such as `foo(1,2)`, as well as implicit
 * calls and calls derived from library models.
 *
 * Currently only explicit calls are implemented.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets the `CallExpr` wrapped by this dataflow call, if any. */
  CallExpr asExplicitCall() { this = TExplicitCall(result) }

  /** Holds if this is a synthesized call to `callee` in `callable`. */
  predicate isSummaryCall(SummarizedCallable callable, SummaryNode callee) {
    this = TSummaryCall(callable, callee)
  }

  /** Gets a textual representation of this call. */
  string toString() {
    result = this.asExplicitCall().toString()
    or
    exists(SummarizedCallable callable, SummaryNode callee |
      this.isSummaryCall(callable, callee) and
      result = "[summary] call to " + callee.toString() + " in " + callable.toString()
    )
  }

  /** Gets the location of this call, if any. */
  Location getLocation() {
    result = this.asExplicitCall().getLocation()
    or
    this.isSummaryCall(_, _) and result instanceof EmptyLocation
  }

  /** Gets the callable containing this call. */
  DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.asExplicitCall().getEnclosingCallable()
    or
    this.isSummaryCall(result.asSummarizedCallable(), _)
  }
}

DataFlowCall getDataFlowCall(CallExpr call) { result.asExplicitCall() = call }
