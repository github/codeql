/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cross-window communication with unrestricted origin, as well as
 * extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions::HeuristicNames

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
   * DEPRECATED. This query no longer uses flow state.
   *
   * A flow label representing an object with at least one tainted property.
   */
  abstract deprecated class PartiallyTaintedObject extends DataFlow::FlowLabel {
    PartiallyTaintedObject() { this = "partially tainted object" }
  }

  /**
   * DEPRECATED. This query no longer uses flow state.
   *
   * Gets either a standard flow label or the partial-taint label.
   */
  deprecated DataFlow::FlowLabel anyLabel() {
    result.isDataOrTaint() or result instanceof PartiallyTaintedObject
  }

  /**
   * A sensitive expression, viewed as a data flow source for cross-window communication
   * with unrestricted origin.
   */
  class SensitiveExprSource extends Source instanceof SensitiveNode { }

  /** A call to any function whose name suggests that it encodes or encrypts its arguments. */
  class ProtectSanitizer extends Sanitizer instanceof ProtectCall { }

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
