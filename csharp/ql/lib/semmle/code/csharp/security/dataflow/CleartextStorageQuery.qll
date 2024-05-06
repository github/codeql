/**
 * Provides a taint-tracking configuration for reasoning about cleartext storage
 * of sensitive or private information.
 */

import csharp
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
private import semmle.code.csharp.security.PrivateData
private import semmle.code.csharp.security.SensitiveActions

/**
 * A data flow source for cleartext storage of sensitive or private information.
 */
abstract class Source extends DataFlow::ExprNode { }

/**
 * A data flow sink for cleartext storage of sensitive or private information.
 */
abstract class Sink extends DataFlow::ExprNode { }

/**
 * A sanitizer for cleartext storage of sensitive or private information.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * DEPRECATED: Use `ClearTextStorage` instead.
 *
 * A taint-tracking configuration for cleartext storage of sensitive or private information.
 */
deprecated class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "ClearTextStorage" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking configuration for cleartext storage of sensitive or private information.
 */
private module ClearTextStorageConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for cleartext storage of sensitive or private information.
 */
module ClearTextStorage = TaintTracking::Global<ClearTextStorageConfig>;

/** A source of sensitive data. */
class SensitiveExprSource extends Source {
  SensitiveExprSource() { this.getExpr() instanceof SensitiveExpr }
}

/** A source of private data. */
private class PrivateDataExprSource extends Source {
  PrivateDataExprSource() { this.getExpr() instanceof PrivateDataExpr }
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
class ExternalSink extends Sink instanceof ExternalLocationSink { }
