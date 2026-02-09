/**
 * Provides classes and predicates for reasoning about accesses to invalid
 * pointers.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.Node
private import codeql.rust.security.Barriers as Barriers
private import codeql.rust.internal.typeinference.TypeInference as TypeInference
private import codeql.rust.internal.typeinference.Type

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
        // We are only interested in dereferences of raw pointers, as other uses
        // of `*` are safe.
        (not exists(TypeInference::inferType(p)) or TypeInference::inferType(p) instanceof PtrType)
      )
    }
  }

  /** A pointer access from model data. */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "pointer-access") }
  }

  /**
   * A barrier for invalid pointer access vulnerabilities for values checked to
   * be non-`null`.
   */
  private class NotNullCheckBarrier extends Barrier instanceof Barriers::NotNullCheckBarrier { }
}
