/**
 * Provides a taint tracking configuration for reasoning about sensitive information in broken or weak cryptographic algorithms.
 */

import javascript
private import semmle.javascript.security.SensitiveActions
private import semmle.javascript.frameworks.CryptoLibraries

module BrokenCryptoAlgorithm {
  /**
   * A data flow source for sensitive information in broken or weak cryptographic algorithms.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for sensitive information in broken or weak cryptographic algorithms.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for sensitive information in broken or weak cryptographic algorithms.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint tracking configuration for sensitive information in broken or weak cryptographic algorithms.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * sensitive data, to `Sink`s, which is an abstract class representing all
   * the places sensitive data may used in broken or weak cryptographic algorithms. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "BrokenCryptoAlgorithm" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /**
   * A sensitive expression, viewed as a data flow source for sensitive information
   * in broken or weak cryptographic algorithms.
   */
  class SensitiveExprSource extends Source, DataFlow::ValueNode {
    override SensitiveExpr astNode;

    override string describe() { result = astNode.describe() }
  }

  /**
   * An expression used by a broken or weak cryptographic algorithm.
   */
  class WeakCryptographicOperationSink extends Sink {
    WeakCryptographicOperationSink() {
      exists(CryptographicOperation application |
        application.getAlgorithm().isWeak() and
        this.asExpr() = application.getInput()
      )
    }
  }
}
