/**
 * Provides classes and predicates for reasoning about disabled certificate
 * check vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

/**
 * Provides default sinks for detecting disabled certificate check
 * vulnerabilities, as well as extension points for adding your own.
 */
module DisabledCertificateCheckExtensions {
  /**
   * A data flow sink for disabled certificate check vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "DisabledCertificateCheck" }
  }

  /**
   * A sink for disabled certificate check vulnerabilities from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "disable-certificate") }
  }
}
