/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * sensitive information in weak cryptographic algorithms,
 * as well as extension points for adding your own.
 */

import go
private import semmle.go.security.SensitiveActions
private import CryptoLibraries

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * sensitive information in weak cryptographic algorithms,
 * as well as extension points for adding your own.
 */
module WeakCryptoAlgorithm {
  /**
   * A data flow source for sensitive information in weak cryptographic algorithms.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for sensitive information in weak cryptographic algorithms.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for sensitive information in weak cryptographic algorithms.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sensitive source.
   */
  class SensitiveSource extends Source {
    SensitiveSource() { this.asExpr() instanceof SensitiveExpr }
  }

  /**
   * An expression used by a weak cryptographic algorithm.
   */
  class WeakCryptographicOperationSink extends Sink {
    WeakCryptographicOperationSink() {
      exists(CryptographicOperation application |
        application.getAlgorithm().isWeak() and
        this.asExpr() = application.getInput()
      )
    }
  }

  /**
   * A configuration depicting taint flow from sensitive information to weak cryptographic algorithms.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "WeakCryptoAlgorithm" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
