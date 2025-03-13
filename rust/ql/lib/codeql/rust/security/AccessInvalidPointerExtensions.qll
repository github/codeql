/**
 * Provides classes and predicates for reasoning about accesses to invalid
 * pointers.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

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
   */
  private class ModelsAsDataSource extends Source {
    ModelsAsDataSource() { sourceNode(this, "pointer-invalidate") }
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
