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
   * Holds if the value pointed to by `source` accesses a variable `target` with scope `scope`.
   */
  pragma[nomagic]
  predicate sourceValueScope(Source source, Variable target, BlockExpr scope) {
    valueScope(source.getTarget(), target, scope)
  }

  /**
   * Holds if the pair `(source, sink)` represents a flow from a pointer or reference
   * to a dereference.
   */
  signature predicate dereferenceAfterLifetimeCandSig(DataFlow::Node source, DataFlow::Node sink);

  /** Provides logic for identifying dereferences after lifetime. */
  module DereferenceAfterLifetime<dereferenceAfterLifetimeCandSig/2 dereferenceAfterLifetimeCand> {
    private newtype TTcNode =
      TSource(Source s, Variable target) {
        dereferenceAfterLifetimeCand(s, _) and sourceValueScope(s, target, _)
      } or
      TBlockExpr(BlockExpr be) or
      TSink(Sink s) { dereferenceAfterLifetimeCand(_, s) }

    private class TcNode extends TTcNode {
      Source asSource(Variable target) { this = TSource(result, target) }

      BlockExpr asBlockExpr() { this = TBlockExpr(result) }

      Sink asSink() { this = TSink(result) }

      string toString() {
        result = this.asSource(_).toString()
        or
        result = this.asBlockExpr().toString()
        or
        result = this.asSink().toString()
      }

      Location getLocation() {
        result = this.asSource(_).getLocation()
        or
        result = this.asBlockExpr().getLocation()
        or
        result = this.asSink().getLocation()
      }
    }

    pragma[nomagic]
    private predicate tcStep(TcNode a, TcNode b) {
      // `b` is a child of `a`
      exists(Source source, Variable target, BlockExpr be |
        source = a.asSource(target) and
        be = b.asBlockExpr().getEnclosingBlock*() and
        sourceValueScope(source, target, be) and
        dereferenceAfterLifetimeCand(source, _)
      )
      or
      // propagate through function calls
      exists(Call call |
        a.asBlockExpr() = call.getEnclosingBlock() and
        call.getARuntimeTarget() = b.asBlockExpr().getEnclosingCallable()
      )
      or
      a.asBlockExpr() = b.asSink().asExpr().getEnclosingBlock()
    }

    private predicate isTcSource(TcNode n) { n instanceof TSource }

    private predicate isTcSink(TcNode n) { n instanceof TSink }

    /**
     * Holds if block `a` contains block `b`, in the sense that a stack allocated variable in
     * `a` may still be on the stack during execution of `b`. This is interprocedural,
     * but is an overapproximation that doesn't accurately track call contexts
     * (for example if `f` and `g` both call `b`, then then depending on the
     * caller a variable in `f` or `g` may or may-not be on the stack during `b`).
     */
    private predicate mayEncloseOnStack(TcNode a, TcNode b) =
      doublyBoundedFastTC(tcStep/2, isTcSource/1, isTcSink/1)(a, b)

    /**
     * Holds if the pair `(source, sink)`, that represents a flow from a
     * pointer or reference to a dereference, has its dereference outside the
     * lifetime of the target variable `target`.
     */
    predicate dereferenceAfterLifetime(Source source, Sink sink, Variable target) {
      dereferenceAfterLifetimeCand(source, sink) and
      sourceValueScope(source, target, _) and
      not mayEncloseOnStack(TSource(source, target), TSink(sink))
    }
  }

  /**
   * Holds if `var` has scope `scope`.
   */
  private predicate variableScope(Variable var, BlockExpr scope) {
    // local variable
    scope = var.getEnclosingBlock()
    or
    // parameter
    exists(Callable c |
      var.getParameter().getEnclosingCallable() = c and
      scope.getParentNode() = c
    )
  }

  /**
   * Holds if `value` accesses a variable `target` with scope `scope`.
   */
  private predicate valueScope(Expr value, Variable target, BlockExpr scope) {
    // variable access (to a non-reference)
    target = value.(VariableAccess).getVariable() and
    variableScope(target, scope) and
    not TypeInference::inferType(value) instanceof RefType
    or
    // field access
    valueScope(value.(FieldExpr).getContainer(), target, scope)
  }

  /**
   * A source that is a `RefExpr`.
   */
  private class RefExprSource extends Source {
    Expr targetValue;

    RefExprSource() { this.asExpr().(RefExpr).getExpr() = targetValue }

    override Expr getTarget() { result = targetValue }
  }

  /**
   * A barrier for nodes inside closures, as we don't model lifetimes of
   * variables through closures properly.
   */
  private class ClosureBarrier extends Barrier {
    ClosureBarrier() { this.asExpr().getEnclosingCallable() instanceof ClosureExpr }
  }
}
