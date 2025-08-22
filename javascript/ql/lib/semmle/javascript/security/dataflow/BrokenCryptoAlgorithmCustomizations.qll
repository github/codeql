/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * sensitive information in broken or weak cryptographic algorithms,
 * as well as extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

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
  abstract class Sink extends DataFlow::Node {
    /** Gets the data-flow node where the cryptographic algorithm used in this operation is configured. */
    abstract DataFlow::Node getInitialization();
  }

  /**
   * A sanitizer for sensitive information in broken or weak cryptographic algorithms.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sensitive expression, viewed as a data flow source for sensitive information
   * in broken or weak cryptographic algorithms.
   */
  class SensitiveExprSource extends Source instanceof SensitiveNode {
    override string describe() { result = SensitiveNode.super.describe() }
  }

  /**
   * An expression used by a broken or weak cryptographic algorithm.
   */
  class WeakCryptographicOperationSink extends Sink {
    CryptographicOperation application;

    WeakCryptographicOperationSink() {
      (
        application.getAlgorithm().isWeak()
        or
        application.getBlockMode().isWeak()
      ) and
      this = application.getAnInput()
    }

    override DataFlow::Node getInitialization() { result = application.getInitialization() }
  }
}
