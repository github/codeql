/**
 * Provides a dataflow tracking configuration for reasoning about
 * clear-text logging of sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

import javascript
import CleartextLoggingCustomizations::CleartextLogging
private import CleartextLoggingCustomizations::CleartextLogging as CleartextLogging

/**
 * A taint tracking configuration for clear-text logging of sensitive information.
 *
 * This configuration identifies flows from `Source`s, which are sources of
 * sensitive data, to `Sink`s, which is an abstract class representing all
 * the places sensitive data may be stored in clear-text. Additional sources or sinks can be
 * added either by extending the relevant class, or by subclassing this configuration itself,
 * and amending the sources and sinks.
 */
module CleartextLoggingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // We rely on heuristic sources, which tends to cause sources to overlap
    isSource(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    CleartextLogging::isAdditionalTaintStep(node1, node2)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // Assume all properties of a logged object are themselves logged.
    contents = DataFlow::ContentSet::anyProperty() and
    isSink(node)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking flow for clear-text logging of sensitive information.
 */
module CleartextLoggingFlow = TaintTracking::Global<CleartextLoggingConfig>;

/**
 * DEPRECATED. Use the `CleartextLoggingFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CleartextLogging" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    source.(Source).getLabel() = lbl
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
    sink.(Sink).getLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Barrier }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    CleartextLogging::isAdditionalTaintStep(src, trg)
  }
}
