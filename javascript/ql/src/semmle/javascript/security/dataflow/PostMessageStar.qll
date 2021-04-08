/**
 * Provides a taint tracking configuration for reasoning about
 * cross-window communication with unrestricted origin.
 *
 * Note, for performance reasons: only import this file if
 * `PostMessageStar::Configuration` is needed, otherwise
 * `PostMessageStarCustomizations` should be imported instead.
 */

import javascript

module PostMessageStar {
  import PostMessageStarCustomizations::PostMessageStar

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
        src = toString.(JsonStringifyCall).getInput()
      ) and
      inlbl instanceof PartiallyTaintedObject and
      outlbl.isTaint()
      or
      // `valueOf` preserves partial taint
      trg.(DataFlow::MethodCallNode).calls(src, "valueOf") and
      inlbl instanceof PartiallyTaintedObject and
      outlbl = inlbl
    }
  }
}
