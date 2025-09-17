/**
 * Provides classes and predicates for reasoning about insecure cookie
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.DataFlowImpl as DataflowImpl
private import codeql.rust.dataflow.internal.Node

/**
 * Provides default sources, sinks and barriers for detecting insecure
 * cookie vulnerabilities, as well as extension points for adding your own.
 */
module InsecureCookie {
  /**
   * A data flow source for insecure cookie vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for insecure cookie vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "InsecureCookie" }
  }

  /**
   * A barrier for insecure cookie vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A source for insecure cookie vulnerabilities from model data.
   */
  private class ModelsAsDataSource extends Source {
    ModelsAsDataSource() { sourceNode(this, "cookie-create") }
  }

  /**
   * A sink for insecure cookie vulnerabilities from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "cookie-use") }
  }
}
