/**
 * Provides a data-flow tracking configuration for reasoning about
 * clear-text logging of sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

import go

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

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
      // A taint propagating data-flow edge through structs: a tainted write taints the entire struct.
      exists(Write write | write.writesField(trg.getASuccessor*(), _, src))
      or
      trg.(DataFlow::BinaryOperationNode).getOperator() = "+" and
      src = trg.(DataFlow::BinaryOperationNode).getAnOperand()
      or
      // Allow flow through functions that are considered for taint flow.
      exists(
        TaintTracking::FunctionModel m, DataFlow::CallNode c, DataFlow::FunctionInput inp,
        DataFlow::FunctionOutput outp
      |
        c = m.getACall() and
        m.hasTaintFlow(inp, outp) and
        src = inp.getNode(c) and
        trg = outp.getNode(c)
      )
    }
  }
}
