/**
 * Provides a taint-tracking configuration for reasoning about cleartext storage of sensitive information.
 */

import csharp

module CleartextStorage {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.system.Web
  import semmle.code.csharp.security.SensitiveActions
  import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink

  /**
   * A data flow source for cleartext storage of sensitive information.
   */
  abstract class Source extends DataFlow::ExprNode { }

  /**
   * A data flow sink for cleartext storage of sensitive information.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for cleartext storage of sensitive information.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for cleartext storage of sensitive information.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "ClearTextStorage" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of sensitive data. */
  class SensitiveExprSource extends Source {
    SensitiveExprSource() { this.getExpr() instanceof SensitiveExpr }
  }

  /** A call to any method whose name suggests that it encodes or encrypts the parameter. */
  class ProtectSanitizer extends Sanitizer {
    ProtectSanitizer() {
      exists(Method m, string s |
        this.getExpr().(MethodCall).getTarget() = m and
        m.getName().regexpMatch("(?i).*" + s + ".*")
      |
        s = "protect" or s = "encode" or s = "encrypt"
      )
    }
  }

  /**
   * An external location sink.
   */
  class ExternalSink extends Sink {
    ExternalSink() { this instanceof ExternalLocationSink }
  }
}
