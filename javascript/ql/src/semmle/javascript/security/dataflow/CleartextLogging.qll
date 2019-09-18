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
   * A dataflow tracking configuration for clear-text logging of sensitive information.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * sensitive data, to `Sink`s, which is an abstract class representing all
   * the places sensitive data may be stored in clear-text. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "CleartextLogging" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
      StringConcatenation::taintStep(src, trg)
      or
      exists(string name | name = "toString" or name = "valueOf" |
        src.(DataFlow::SourceNode).getAMethodCall(name) = trg
      )
      or
      // A taint propagating data flow edge through objects: a tainted write taints the entire object.
      exists(DataFlow::PropWrite write |
        write.getRhs() = src and
        trg.(DataFlow::SourceNode).flowsTo(write.getBase())
      )
    }
  }
}
