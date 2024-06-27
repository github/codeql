/**
 * Provides default sources, sinks, and sanitizers for reasoning about random values that
 * are not cryptographically secure, as well as extension points for adding your own.
 */

private import codeql.ruby.CFG
private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.security.SensitiveActions
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
import codeql.ruby.frameworks.core.Kernel

/**
 * Provides default sources, sinks, and sanitizers for reasoning about random values that
 * are not cryptographically secure, as well as extension points for adding your own.
 */
module InsecureRandomness {
  /**
   * A data flow source for random values that are not cryptographically secure.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for random values that are not cryptographically secure.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for random values that are not cryptographically secure.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A simple random number generator that is not cryptographically secure.
   */
  class DefaultSource extends Source, DataFlow::CallNode {
    DefaultSource() {
      this.asExpr().getExpr() instanceof UnknownMethodCall and
      (
        this.getReceiver().asExpr().getExpr() instanceof SelfVariableAccess and
        super.getMethodName() = "rand"
      )
      or
      this.(Kernel::KernelMethodCall).getMethodName() = "rand"
    }
  }

  /**
   * A sensitive write, considered as a sink for random values that are not cryptographically
   * secure.
   */
  class SensitiveWriteSink extends Sink instanceof SensitiveWrite { }

  /**
   * A cryptographic key, considered as a sink for random values that are not cryptographically
   * secure.
   */
  class CryptoKeySink extends Sink {
    CryptoKeySink() {
      exists(Cryptography::CryptographicOperation operation | this = operation.getAnInput())
    }
  }

  /**
   * A index call, considered as a sink for random values that are not cryptographiocally
   * secure
   */
  class CharacterIndexing extends Sink {
    CharacterIndexing() {
      exists(DataFlow::CallNode c | this = c.getAMethodCall("[]").getArgument(0))
    }
  }
}
