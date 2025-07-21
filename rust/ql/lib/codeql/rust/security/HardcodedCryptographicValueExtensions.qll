/**
 * Provides classes and predicates for reasoning about hard-coded cryptographic value
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
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
 * Provides default sources, sinks and barriers for detecting hard-coded cryptographic
 * value vulnerabilities, as well as extension points for adding your own.
 */
module HardcodedCryptographicValue {
  /**
   * A data flow source for hard-coded cryptographic value vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for hard-coded cryptographic value vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "HardcodedCryptographicValue" }

    /**
     * Gets the kind of credential this sink is interpreted as.
     */
    abstract CryptographicValueKind getKind();
  }

  /**
   * A barrier for hard-coded cryptographic value vulnerabilities.
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
   * An externally modeled sink for hard-coded cryptographic value vulnerabilities.
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
      exists(CallExprBase ce |
        ce.getStaticTarget().(Addressable).getCanonicalPath() =
          ["getrandom::fill", "getrandom::getrandom"] and
        this.asExpr().getExpr().getParentNode*() = ce.getArgList().getArg(0)
      )
    }
  }
}
