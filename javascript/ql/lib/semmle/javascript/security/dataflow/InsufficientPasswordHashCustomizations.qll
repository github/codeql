/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * password hashing with insufficient computational effort, as well as
 * extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

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
   * A potential clear-text password, considered as a source for password hashing
   * with insufficient computational effort.
   */
  class CleartextPasswordSource extends Source instanceof SensitiveNode {
    CleartextPasswordSource() {
      super.getClassification() = SensitiveDataClassification::password()
    }

    override string describe() { result = SensitiveNode.super.describe() }
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
        this = application.getAnInput()
      )
    }
  }
}
