private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions

private newtype TDataFlowCallable =
  TSourceCallable(Callable callable) { not isInTypeContext(callable) } or
  TSummarizedCallable(SummarizedCallable callable)

/**
 * A callable entity: either a function-like entity in source code or
 * an entity derived from a library model.
 *
 * Currently only callables in source code are implemented.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the `Callable` wrapped by this dataflow callable, if any. */
  Callable asSourceCallable() { this = TSourceCallable(result) }

  /** Gets the `SummarizedCallable` wrapped by this dataflow callable, if any. */
  SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Gets a string representation of this call. */
  string toString() {
    result = this.asSourceCallable().toString() or
    result = this.asSummarizedCallable().toString()
  }

  /** Gets the location of this call, if any. */
  Location getLocation() { result = this.asSourceCallable().getLocation() }
}

DataFlowCallable getDataFlowCallable(Callable callable) { result.asSourceCallable() = callable }
