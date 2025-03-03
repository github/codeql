/**
 * Provides classes and predicates for reasoning about hardcoded cryptographic value
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.security.SensitiveData

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
     * Gets the kind of credential this sink is interpreted as,
     * for example "password", "key", "iv", "salt".
     */
    abstract string getKind();
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
   * A sink for hardcoded cryptographic value from model data.
   */
  private class ModelsAsDataSinks extends Sink {
    string kind;

    ModelsAsDataSinks() {
      kind = ["password", "key", "iv", "salt"] and
      sinkNode(this, "credentials-" + kind)
    }

    override string getKind() { result = kind }
  }
}
