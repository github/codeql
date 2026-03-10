/**
 * Provides classes and predicates for reasoning about cleartext logging
 * of sensitive information vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.security.SensitiveData
private import codeql.rust.Concepts
private import codeql.rust.security.Barriers as Barriers

/**
 * Provides default sources, sinks and barriers for detecting cleartext logging
 * vulnerabilities, as well as extension points for adding your own.
 */
module CleartextLogging {
  /**
   * A data flow source for cleartext logging vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cleartext logging vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "CleartextLogging" }
  }

  /**
   * A barrier for cleartext logging vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * Sensitive data, considered as a flow source.
   */
  private class SensitiveDataAsSource extends Source instanceof SensitiveData { }

  /**
   * A sink for logging from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "log-injection") }
  }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }
}
