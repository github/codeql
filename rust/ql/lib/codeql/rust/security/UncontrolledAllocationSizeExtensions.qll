/**
 * Provides classes and predicates for reasoning about uncontrolled allocation
 * size vulnerabilities.
 */

import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink

/**
 * Provides default sources, sinks and barriers for detecting uncontrolled
 * allocation size vulnerabilities, as well as extension points for adding your own.
 */
module UncontrolledAllocationSize {
  /**
   * A data flow sink for uncontrolled allocation size vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UncontrolledAllocationSize" }
  }

  /**
   * A barrier for uncontrolled allocation size vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   *  sink for uncontrolled allocation size from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, ["alloc-size", "alloc-layout"]) }
  }
}
