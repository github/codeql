/** Provides classes and predicates to reason about path injection vulnerabilities. */

import rust
private import codeql.rust.controlflow.BasicBlocks
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.DataFlowImpl

/**
 * Provides default sources, sinks and barriers for detecting path injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module TaintedPath {
  /**
   * A data flow source for path injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for path injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A barrier for path injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /** A sink for path-injection from model data. */
  private class ModelsAsDataSinks extends Sink {
    ModelsAsDataSinks() { sinkNode(this, "path-injection") }
  }
}
