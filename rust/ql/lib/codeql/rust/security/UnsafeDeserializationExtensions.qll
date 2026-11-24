/**
 * Provides classes and predicates for reasoning about unsafe deserialization
 * vulnerabilities (CWE-502).
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.dataflow.FlowBarrier
private import codeql.rust.Concepts
private import codeql.rust.security.Barriers as Barriers

/**
 * Provides default sources, sinks and barriers for detecting unsafe deserialization
 * vulnerabilities, as well as extension points for adding your own.
 */
module UnsafeDeserialization {
  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UnsafeDeserialization" }
  }

  /**
   * A barrier for unsafe deserialization vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for unsafe deserialization from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "unsafe-deserialization") }
  }

  /**
   * A barrier for unsafe deserialization from model data.
   */
  private class ModelsAsDataBarrier extends Barrier {
    ModelsAsDataBarrier() { barrierNode(this, "unsafe-deserialization") }
  }

  /**
   * A barrier for unsafe deserialization for nodes whose type is a numeric
   * type, which is unlikely to expose any vulnerability.
   */
  private class NumericTypeBarrier extends Barrier instanceof Barriers::NumericTypeBarrier { }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }
}
