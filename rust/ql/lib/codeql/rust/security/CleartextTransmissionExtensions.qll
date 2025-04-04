/**
 * Provides classes and predicates for reasoning about cleartext transmission
 * vulnerabilities.
 */

private import codeql.util.Unit
private import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

/**
 * Provides default sources, sinks and barriers for detecting cleartext transmission
 * vulnerabilities, as well as extension points for adding your own.
 */
module CleartextTransmission {
  /**
   * A data flow source for cleartext transmission vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cleartext transmission vulnerabilities. That is,
   * a `DataFlow::Node` of something that is transmitted over a network.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "CleartextTransmission" }
  }

  /**
   * A barrier for cleartext transmission vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A unit class for adding additional flow steps.
   */
  class AdditionalFlowStep extends Unit {
    /**
     * Holds if the step from `node1` to `node2` should be considered a flow
     * step for paths related to cleartext transmission vulnerabilities.
     */
    abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
  }

  /**
   * Sensitive data, considered as a flow source.
   */
  private class SensitiveDataAsSource extends Source instanceof SensitiveData { }

  /**
   * A sink defined through MaD.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "transmission") }
  }
}
