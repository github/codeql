/**
 * Provides a taint tracking configuration for reasoning about cross-window communication
 * with unrestricted origin.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module PostMessageStar {
  /**
   * A data flow source for cross-window communication with unrestricted origin.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cross-window communication with unrestricted origin.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for cross-window communication with unrestricted origin.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint tracking configuration for cross-window communication with unrestricted origin.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * sensitive data, to `Sink`s, which is an abstract class representing all
   * the places sensitive data may be transmitted across window boundaries without restricting
   * the origin.
   *
   * Additional sources or sinks can be added either by extending the relevant class, or by subclassing
   * this configuration itself, and amending the sources and sinks.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "PostMessageStar" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /**
   * A sensitive expression, viewed as a data flow source for cross-window communication
   * with unrestricted origin.
   */
  class SensitiveExprSource extends Source, DataFlow::ValueNode { override SensitiveExpr astNode; }

  /**
   * A variable/property access or function call whose name suggests that it may contain credentials,
   * viewed as a data flow source for cross-window communication with unrestricted origin.
   */
  class CredentialsSource extends Source {
    CredentialsSource() {
      exists(string name |
        name = this.(DataFlow::InvokeNode).getCalleeName() or
        name = this.(DataFlow::PropRead).getPropertyName() or
        name = this.asExpr().(VarUse).getVariable().getName()
      |
        name.regexpMatch(HeuristicNames::suspiciousCredentials()) and
        not name.regexpMatch(HeuristicNames::nonSuspicious())
      )
    }
  }

  /** A call to any function whose name suggests that it encodes or encrypts its arguments. */
  class ProtectSanitizer extends Sanitizer { ProtectSanitizer() { this instanceof ProtectCall } }

  /**
   * An expression sent using `postMessage` without restricting the target window origin.
   */
  class PostMessageStarSink extends Sink {
    PostMessageStarSink() {
      exists(DataFlow::MethodCallNode postMessage |
        postMessage.getMethodName() = "postMessage" and
        postMessage.getArgument(1).mayHaveStringValue("*") and
        this = postMessage.getArgument(0)
      )
    }
  }
}
