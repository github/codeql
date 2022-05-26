/**
 * Provides a data-flow tracking configuration for reasoning about
 * clear-text logging of sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

import go

/**
 * Provides a data-flow tracking configuration for reasoning about
 * clear-text logging of sensitive information.
 */
module CleartextLogging {
  import CleartextLoggingCustomizations::CleartextLogging

  /**
   * A data-flow tracking configuration for clear-text logging of sensitive information.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * sensitive data, to `Sink`s, which is an abstract class representing all
   * the places sensitive data may be stored in cleartext. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "CleartextLogging" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isBarrier(DataFlow::Node node) {
      node instanceof Barrier
      or
      exists(DataFlow::CallNode call | node = call.getResult() |
        call.getTarget() = Builtin::error().getType().getMethod("Error")
        or
        call.getTarget().(Method).hasQualifiedName("fmt", "Stringer", "String")
      )
    }

    override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
      // A taint propagating data-flow edge through structs: a tainted write taints the entire struct.
      exists(Write write |
        write.writesField(trg.(DataFlow::PostUpdateNode).getPreUpdateNode(), _, src)
      )
      or
      // taint steps that do not include flow through fields
      TaintTracking::localTaintStep(src, trg) and not TaintTracking::fieldReadStep(src, trg)
    }
  }
}
