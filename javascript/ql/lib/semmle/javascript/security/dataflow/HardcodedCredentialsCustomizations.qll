/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * hardcoded credentials, as well as extension points for adding your
 * own.
 */

import semmle.javascript.filters.ClassifyFiles
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

    ConstantStringSource() { not astNode.getStringValue() = "" }
  }

  /**
   * A subclass of `Sink` that includes every `CredentialsNode`
   * as a credentials sink.
   */
  class DefaultCredentialsSink extends Sink instanceof CredentialsNode {
    override string getKind() { result = super.getCredentialsKind() }

    DefaultCredentialsSink() {
      not (super.getCredentialsKind() = "jwt key" and isTestFile(this.getFile()))
    }
  }
}
