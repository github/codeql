/**
 * Provides classes and predicates for reasoning about hardcoded cryptographic value
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.security.SensitiveData

/**
 * A kind of cryptographic value.
 */
class CryptographicValueKind extends string {
  CryptographicValueKind() { this = ["password", "key", "iv", "nonce", "salt"] }

  /**
   * Gets a description of this value kind for user-facing messages.
   */
  string getDescription() {
    this = "password" and result = "a password"
    or
    this = "key" and result = "a key"
    or
    this = "iv" and result = "an initialization vector"
    or
    this = "nonce" and result = "a nonce"
    or
    this = "salt" and result = "a salt"
  }
}

/**
 * Provides default sources, sinks and barriers for detecting hardcoded cryptographic
 * value vulnerabilities, as well as extension points for adding your own.
 */
module HardcodedCryptographicValue {
  /**
   * A data flow source for hardcoded cryptographic value vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for hardcoded cryptographic value vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of credential this sink is interpreted as.
     */
    abstract CryptographicValueKind getKind();
  }

  /**
   * A barrier for hardcoded cryptographic value vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A literal, considered as a flow source.
   */
  private class LiteralSource extends Source {
    LiteralSource() { this.asExpr().getExpr() instanceof LiteralExpr }
  }

  /**
   * An array initialized from a list of literals, considered as a single flow source. For example:
   * ```
   * `[0, 0, 0, 0]`
   * ```
   */
  private class ArrayListSource extends Source {
    ArrayListSource() { this.asExpr().getExpr().(ArrayListExpr).getExpr(_) instanceof LiteralExpr }
  }

  /**
   * An externally modeled source for constant values.
   */
  private class ModeledSource extends Source {
    ModeledSource() { sourceNode(this, "constant-source") }
  }

  /**
   * An externally modeled sink for hardcoded cryptographic value vulnerabilities.
   */
  private class ModelsAsDataSinks extends Sink {
    CryptographicValueKind kind;

    ModelsAsDataSinks() { sinkNode(this, "credentials-" + kind) }

    override CryptographicValueKind getKind() { result = kind }
  }

  /**
   * A call to `getrandom` that is a barrier.
   */
  private class GetRandomBarrier extends Barrier {
    GetRandomBarrier() {
      exists(CallExpr ce |
        ce.getFunction().(PathExpr).getResolvedCrateOrigin() =
          "repo:https://github.com/rust-random/getrandom:getrandom" and
        ce.getFunction().(PathExpr).getResolvedPath() = ["crate::fill", "crate::getrandom"] and
        this.asExpr().getExpr().getParentNode*() = ce.getArgList().getArg(0)
      )
    }
  }
}
