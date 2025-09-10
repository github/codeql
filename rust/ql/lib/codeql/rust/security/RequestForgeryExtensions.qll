/**
 * Provides classes and predicates for reasoning about request forgery
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.Concepts

/**
 * Provides default sources, sinks and barriers for detecting request forgery
 * vulnerabilities, as well as extension points for adding your own.
 */
module RequestForgery {
  /**
   * A data flow source for request forgery vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for request forgery vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    /**
     * Gets the name of a part of the request that may be tainted by this sink,
     * such as the URL or the host.
     */
    override string getSinkType() { result = "RequestForgery" }
  }

  /**
   * A barrier for request forgery vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for request forgery from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "request-url") }
  }
}
