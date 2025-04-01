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
 * A data flow sink for cleartext transmission vulnerabilities. That is,
 * a `DataFlow::Node` of something that is transmitted over a network.
 */
abstract class CleartextTransmissionSink extends QuerySink::Range {
  override string getSinkType() { result = "CleartextTransmission" }
}

/**
 * A barrier for cleartext transmission vulnerabilities.
 */
abstract class CleartextTransmissionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CleartextTransmissionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to cleartext transmission vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink defined through MaD.
 */
private class MadCleartextTransmissionSink extends CleartextTransmissionSink {
  MadCleartextTransmissionSink() { sinkNode(this, "transmission") }
}
