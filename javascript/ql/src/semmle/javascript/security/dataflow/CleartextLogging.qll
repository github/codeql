/**
 * Provides a dataflow tracking configuration for reasoning about
 * clear-text logging of sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

import javascript

module CleartextLogging {
  import CleartextLoggingCustomizations::CleartextLogging

  /**
   * A taint tracking configuration for clear-text logging of sensitive information.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * sensitive data, to `Sink`s, which is an abstract class representing all
   * the places sensitive data may be stored in clear-text. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CleartextLogging" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
      source.(Source).getLabel() = lbl
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
      sink.(Sink).getLabel() = lbl
    }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Barrier }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      succ.(DataFlow::PropRead).getBase() = pred
    }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
      // A taint propagating data flow edge through objects: a tainted write taints the entire object.
      exists(DataFlow::PropWrite write |
        write.getRhs() = src and
        trg.(DataFlow::SourceNode).flowsTo(write.getBase())
      )
      or
      // Taint through the arguments object.
      exists(DataFlow::CallNode call, Function f |
        src = call.getAnArgument() and
        f = call.getACallee() and
        not call.isImprecise() and
        trg.asExpr() = f.getArgumentsVariable().getAnAccess()
      )
    }
  }
}
