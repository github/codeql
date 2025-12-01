/**
 * Provides classes and predicates for reasoning about accesses to invalid
 * pointers.
 */

import rust
private import codeql.rust.elements.Call
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.Node
private import codeql.rust.security.Barriers as Barriers
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.internal.Type

/**
 * Provides default sources, sinks and barriers for detecting accesses to
 * invalid pointers, as well as extension points for adding your own.
 */
module AccessInvalidPointer {
  /**
   * A data flow source for invalid pointer accesses, that is, an operation
   * where a pointer becomes invalid.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for invalid pointer accesses, that is, a pointer
   * dereference.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "AccessInvalidPointer" }
  }

  /**
   * A barrier for invalid pointer accesses.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A pointer invalidation from model data.
   *
   * Note: we don't currently support invalidation via the object itself rather than via a pointer, such as:
   * ```
   * drop(obj)
   * ```
   */
  private class ModelsAsDataSource extends Source {
    ModelsAsDataSource() { sourceNode(this, "pointer-invalidate") }
  }

  /** A raw pointer access using the unary `*` operator. */
  private class DereferenceSink extends Sink {
    DereferenceSink() {
      exists(Expr p, DerefExpr d | p = d.getExpr() and p = this.asExpr() |
        // Dereferencing a raw pointer is an unsafe operation. Hence relevant
        // dereferences must occur inside code marked as unsafe.
        // See: https://doc.rust-lang.org/reference/types/pointer.html#r-type.pointer.raw.safety
        (p.getEnclosingBlock*().isUnsafe() or p.getEnclosingCallable().(Function).isUnsafe()) and
        (not exists(TypeInference::inferType(p)) or TypeInference::inferType(p) instanceof PtrType)
      )
    }
  }

  /** A pointer access from model data. */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "pointer-access") }
  }

  private class BarrierCall extends Barrier {
    BarrierCall() {
      exists(Call call, ArgumentPosition pos, string canonicalName |
        call.getStaticTarget().getCanonicalPath() = canonicalName and
        this.asExpr() = call.getArgument(pos)
      |
        canonicalName = "<core::ptr::non_null::NonNull>::new" and pos.asPosition() = 0
      )
    }
  }

  private class NumericTypeBarrier extends Barrier instanceof Barriers::NumericTypeBarrier { }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }

  private class DefaultBarrier extends Barrier {
    DefaultBarrier() {
      // A barrier for calls that statically resolve to the `Default::default`
      // trait function. Such calls are imprecise, and can always resolve to the
      // implementations for raw pointers that return a null pointer. This
      // creates many false positives in combination with other inaccuracies
      // (too many `pointer-access` sinks created by the model generator).
      //
      // We could try removing this barrier in the future when either 1/ the
      // model generator creates fewer spurious sinks or 2/ data flow for calls
      // to trait functions is more precise.
      this.asExpr().(Call).getStaticTarget().getCanonicalPath() =
        "<_ as core::default::Default>::default"
    }
  }

  /**
   * A barrier for invalid pointer access vulnerabilities for values checked to
   * be non-`null`.
   */
  private class NotNullCheckBarrier extends Barrier instanceof Barriers::NotNullCheckBarrier { }
}
