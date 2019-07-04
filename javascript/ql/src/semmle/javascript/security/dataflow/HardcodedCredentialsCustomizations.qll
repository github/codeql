/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * hardcoded credentials, as well as extension points for adding your
 * own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module HardcodedCredentials {
  /**
   * A data flow source for hardcoded credentials.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for hardcoded credentials.
   */
  abstract class Sink extends DataFlow::Node {
    abstract string getKind();
  }

  /**
   * A sanitizer for hardcoded credentials.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A constant string, considered as a source of hardcoded credentials. */
  class ConstantStringSource extends Source, DataFlow::ValueNode {
    override ConstantString astNode;
  }

  /**
   * A subclass of `Sink` that includes every `CredentialsExpr`
   * as a credentials sink.
   */
  class DefaultCredentialsSink extends Sink, DataFlow::ValueNode {
    override CredentialsExpr astNode;

    DefaultCredentialsSink() {
      // Don't flag an empty user name
      not (astNode.getCredentialsKind() = "user name" and astNode.getStringValue() = "")
    }

    override string getKind() { result = astNode.getCredentialsKind() }
  }
}
