/**
 * Provides classes and predicates for reasoning about accesses to a pointer
 * after its lifetime has ended.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.security.AccessInvalidPointerExtensions
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeInference as TypeInference

/**
 * Provides default sources, sinks and barriers for detecting accesses to a
 * pointer after its lifetime has ended, as well as extension points for
 * adding your own. Note that a particular `(source, sink)` pair must be
 * checked with `dereferenceAfterLifetime` to determine if it is a result.
 */
module AccessAfterLifetime {
  /**
   * A data flow source for accesses to a pointer after its lifetime has ended,
   * that is, creation of a pointer or reference.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the value this pointer or reference points to.
     */
    abstract Expr getTarget();
  }

  /**
   * A data flow sink for accesses to a pointer after its lifetime has ended,
   * that is, a dereference. We re-use the same sinks as for the accesses to
   * invalid pointers query.
   */
  class Sink = AccessInvalidPointer::Sink;

  /**
   * A barrier for accesses to a pointer after its lifetime has ended.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * Holds if the pair `(source, sink)`, that represents a flow from a
   * pointer or reference to a dereference, has its dereference outside the
   * lifetime of the target variable `target`.
   */
  bindingset[source, sink]
  predicate dereferenceAfterLifetime(Source source, Sink sink, Variable target) {
    exists(BlockExpr valueScope, BlockExpr accessScope |
      valueScope(source.getTarget(), target, valueScope) and
      accessScope = sink.asExpr().getExpr().getEnclosingBlock() and
      not maybeOnStack(valueScope, accessScope)
    )
  }

  /**
   * Holds if `value` accesses a variable `target` with scope `scope`.
   */
  private predicate valueScope(Expr value, Variable target, BlockExpr scope) {
    // variable access (to a non-reference)
    target = value.(VariableAccess).getVariable() and
    scope = target.getEnclosingBlock() and
    not TypeInference::inferType(value) instanceof RefType
    or
    // field access
    valueScope(value.(FieldExpr).getContainer(), target, scope)
  }

  /**
   * Holds if block `a` contains block `b`, in the sense that a variable in
   * `a` may be on the stack during execution of `b`. This is interprocedural,
   * but is an overapproximation that doesn't accurately track call contexts
   * (for example if `f` and `g` both call `b`, then then depending on the
   * caller a variable in `f` or `g` may or may-not be on the stack during `b`).
   */
  private predicate maybeOnStack(BlockExpr a, BlockExpr b) {
    // `b` is a child of `a`
    a = b.getEnclosingBlock*()
    or
    // propagate through function calls
    exists(CallExprBase ce |
      maybeOnStack(a, ce.getEnclosingBlock()) and
      ce.getStaticTarget() = b.getEnclosingCallable()
    )
  }

  /**
   * A source that is a `RefExpr`.
   */
  private class RefExprSource extends Source {
    Expr targetValue;

    RefExprSource() { this.asExpr().getExpr().(RefExpr).getExpr() = targetValue }

    override Expr getTarget() { result = targetValue }
  }

  /**
   * A barrier for nodes inside closures, as we don't model lifetimes of
   * variables through closures properly.
   */
  private class ClosureBarrier extends Barrier {
    ClosureBarrier() { this.asExpr().getExpr().getEnclosingCallable() instanceof ClosureExpr }
  }
}
