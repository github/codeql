/**
 * Provides a taint tracking configuration for reasoning about password hashing with insufficient computational effort.
 */

import javascript
private import semmle.javascript.security.SensitiveActions
private import semmle.javascript.frameworks.CryptoLibraries

module InsufficientPasswordHash {
  /**
   * A data flow source for password hashing with insufficient computational effort.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for password hashing with insufficient computational effort.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for password hashing with insufficient computational effort.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint tracking configuration for password hashing with insufficient computational effort.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * password data, to `Sink`s, which is an abstract class representing all
   * the places password data may be hashed with insufficient computational effort. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsufficientPasswordHash" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /**
   * A potential clear-text password, considered as a source for password hashing
   * with insufficient computational effort.
   */
  class CleartextPasswordSource extends Source, DataFlow::ValueNode {
    override SensitiveExpr astNode;

    CleartextPasswordSource() { astNode.getClassification() = SensitiveExpr::password() }

    override string describe() { result = astNode.describe() }
  }

  /**
   * An expression used by a cryptographic algorithm that is not suitable for password hashing.
   */
  class InsufficientPasswordHashAlgorithm extends Sink {
    InsufficientPasswordHashAlgorithm() {
      exists(CryptographicOperation application |
        application.getAlgorithm().isWeak() or
        not application.getAlgorithm() instanceof PasswordHashingAlgorithm
      |
        this.asExpr() = application.getInput()
      )
    }
  }
}
