private import unified
private import AllDataFlow

private newtype TDataFlowCall = TExplicitCall(CallExpr call)

/**
 * A call site, covering both explicit calls such as `foo(1,2)`, as well an implicit
 * calls and calls derived from library models.
 *
 * Currently only explicit calls are implemented.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets the `CallExpr` wrapped by this dataflow call, if any. */
  CallExpr asExplicitCall() { this = TExplicitCall(result) }

  /** Gets a string representation of this call. */
  string toString() { result = this.asExplicitCall().toString() }

  /** Gets the location of this call, if any. */
  Location getLocation() { result = this.asExplicitCall().getLocation() }

  /** Gets the callable containing this call. */
  DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.asExplicitCall().getEnclosingCallable()
  }
}
