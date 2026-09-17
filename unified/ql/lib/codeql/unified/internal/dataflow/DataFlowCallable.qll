private import unified
private import AllDataFlow

private newtype TDataFlowCallable = TSourceCallable(Callable callable)

/**
 * A callable entity, either an function-like entity in the source code,
 * an entity derived from a library model.
 *
 * Currently only callables in source code are implemented.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the `Callable` wrapped by this dataflow callable, if any. */
  Callable asSourceCallable() { this = TSourceCallable(result) }

  /** Gets a string representation of this call. */
  string toString() { result = this.asSourceCallable().toString() }

  /** Gets the location of this call, if any. */
  Location getLocation() { result = this.asSourceCallable().getLocation() }
}
