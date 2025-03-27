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

  /**
   * A pointer invalidation from an argument of a modeled call (this is a workaround).
   */
  private class ModelsAsDataArgumentSource extends Source {
    ModelsAsDataArgumentSource() {
      exists(DataFlow::Node n, CallExpr ce, Expr arg |
        sourceNode(n, "pointer-invalidate") and
        n.(FlowSummaryNode).getSourceElement() = ce.getFunction() and
        arg = ce.getArgList().getAnArg() and
        this.asExpr().getExpr().getParentNode+() = arg
      )
    }
  }

  /**
   * A pointer access using the unary `*` operator.
   */
  private class DereferenceSink extends Sink {
    DereferenceSink() {
      exists(PrefixExpr p | p.getOperatorName() = "*" and p.getExpr() = this.asExpr().getExpr())
    }
  }

  /**
   * A pointer access from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "pointer-access") }
  }
}
