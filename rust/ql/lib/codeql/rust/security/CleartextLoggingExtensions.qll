/**
 * Provides classes and predicates for reasoning about cleartext logging
 * of sensitive information vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.security.SensitiveData

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
  abstract class Sink extends DataFlow::Node { }

  /**
   * A barrier for cleartext logging vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * Sensitive data, considered as a flow source.
   */
  private class SensitiveDataAsSource extends Source instanceof SensitiveData { }

  /** A sink for logging from model data. */
  private class ModelsAsDataSinks extends Sink {
    ModelsAsDataSinks() { exists(string s | sinkNode(this, s) and s.matches("log-injection%")) }
  }
}
