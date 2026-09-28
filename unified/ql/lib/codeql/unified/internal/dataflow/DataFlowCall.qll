private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private newtype TDataFlowCall =
  TExplicitCall(CallExpr call) {
    not isInBindingContext(call, _) // ignore constructor patterns
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

  /** Gets a textual representation of this call. */
  string toString() { result = this.asExplicitCall().toString() }

  /** Gets the location of this call, if any. */
  Location getLocation() { result = this.asExplicitCall().getLocation() }

  /** Gets the callable containing this call. */
  DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.asExplicitCall().getEnclosingCallable()
  }
}
