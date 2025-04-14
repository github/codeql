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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) {
      node instanceof Barrier
      or
      exists(DataFlow::CallNode call | node = call.getResult() |
        call.getTarget() = Builtin::error().getType().getMethod("Error")
        or
        call.getTarget().(Method).hasQualifiedName("fmt", "Stringer", "String")
      )
    }

    predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

    predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
      // A taint propagating data-flow edge through structs: a tainted write taints the entire struct.
      exists(Write write |
        write.writesField(trg.(DataFlow::PostUpdateNode).getPreUpdateNode(), _, src)
      )
      or
      // taint steps that do not include flow through fields. Field reads would produce FPs due to
      // the additional taint step above that taints whole structs from individual field writes.
      TaintTracking::defaultAdditionalTaintStep(src, trg, _) and
      not TaintTracking::fieldReadStep(src, trg) and
      // Also exclude protobuf field fetches, since they amount to single field reads.
      not any(Protobuf::GetMethod gm).taintStep(src, trg)
    }
  }

  /**
   * Tracks data flow for reasoning about clear-text logging of sensitive
   * information, from `Source`s, which are sources of sensitive data, to
   * `Sink`s, which is an abstract class representing all the places sensitive
   * data may be stored in cleartext. Additional sources or sinks can be added
   * by extending the relevant class.
   */
  module Flow = DataFlow::Global<Config>;
}
