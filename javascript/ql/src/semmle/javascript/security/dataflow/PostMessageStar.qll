/**
 * Provides a taint tracking configuration for reasoning about cross-window communication
 * with unrestricted origin.
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
   * A flow label representing an object with at least one tainted property.
   */
  private class PartiallyTaintedObject extends DataFlow::FlowLabel {
    PartiallyTaintedObject() { this = "partially tainted object" }
  }

  /**
   * Gets either a standard flow label or the partial-taint label.
   */
  private DataFlow::FlowLabel anyLabel() {
    result instanceof DataFlow::StandardFlowLabel or result instanceof PartiallyTaintedObject
  }

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

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
      sink instanceof Sink and lbl = anyLabel()
    }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      // writing a tainted value to an object property makes the object partially tainted
      exists(DataFlow::PropWrite write |
        write.getRhs() = src and
        inlbl = anyLabel() and
        trg.(DataFlow::SourceNode).flowsTo(write.getBase()) and
        outlbl instanceof PartiallyTaintedObject
      )
      or
      // `toString` or `JSON.toString` on a partially tainted object gives a tainted value
      exists(DataFlow::InvokeNode toString | toString = trg |
        toString.(DataFlow::MethodCallNode).calls(src, "toString")
        or
        toString = DataFlow::globalVarRef("JSON").getAMemberCall("stringify") and
        src = toString.getArgument(0)
      ) and
      inlbl instanceof PartiallyTaintedObject and
      outlbl = DataFlow::FlowLabel::taint()
      or
      // `valueOf` preserves partial taint
      trg.(DataFlow::MethodCallNode).calls(src, "valueOf") and
      inlbl instanceof PartiallyTaintedObject and
      outlbl = inlbl
    }
  }

  /**
   * A sensitive expression, viewed as a data flow source for cross-window communication
   * with unrestricted origin.
   */
  class SensitiveExprSource extends Source, DataFlow::ValueNode { override SensitiveExpr astNode; }

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
