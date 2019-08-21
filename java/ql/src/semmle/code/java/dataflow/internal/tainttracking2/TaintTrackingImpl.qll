import TaintTrackingParameter::Public
private import TaintTrackingParameter::Private

/**
 * A taint tracking configuration.
 *
 * A taint tracking configuration is a special dataflow configuration
 * (`DataFlow::Configuration`) that allows for flow through nodes that do not
 * necessarily preserve values, but are still relevant from a taint tracking
 * perspective. (For example, string concatenation, where one of the operands
 * is tainted.)
 *
 * Each use of the taint tracking library must define its own unique extension
 * of this abstract class. A configuration defines a set of relevant sources
 * (`isSource`) and sinks (`isSink`), and may additionally treat intermediate
 * nodes as "sanitizers" (`isSanitizer`) as well as add custom taint flow steps
 * (`isAdditionalTaintStep()`).
 */
abstract class Configuration extends DataFlow::Configuration {
  bindingset[this]
  Configuration() { any() }

  /**
   * Holds if `source` is a relevant taint source.
   *
   * The smaller this predicate is, the faster `hasFlow()` will converge.
   */
  // overridden to provide taint-tracking specific qldoc
  abstract override predicate isSource(DataFlow::Node source);

  /**
   * Holds if `sink` is a relevant taint sink.
   *
   * The smaller this predicate is, the faster `hasFlow()` will converge.
   */
  // overridden to provide taint-tracking specific qldoc
  abstract override predicate isSink(DataFlow::Node sink);

  /** Holds if the node `node` is a taint sanitizer. */
  predicate isSanitizer(DataFlow::Node node) { none() }

  final override predicate isBarrier(DataFlow::Node node) {
    isSanitizer(node) or
    defaultTaintBarrier(node)
  }

  /** DEPRECATED: override `isSanitizerIn` and `isSanitizerOut` instead. */
  deprecated predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) { none() }

  deprecated final override predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
    isSanitizerEdge(node1, node2)
  }

  /** Holds if data flow into `node` is prohibited. */
  predicate isSanitizerIn(DataFlow::Node node) { none() }

  final override predicate isBarrierIn(DataFlow::Node node) { isSanitizerIn(node) }

  /** Holds if data flow out of `node` is prohibited. */
  predicate isSanitizerOut(DataFlow::Node node) { none() }

  final override predicate isBarrierOut(DataFlow::Node node) { isSanitizerOut(node) }

  /** Holds if data flow through nodes guarded by `guard` is prohibited. */
  predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { none() }

  final override predicate isBarrierGuard(DataFlow::BarrierGuard guard) { isSanitizerGuard(guard) }

  /**
   * Holds if the additional taint propagation step from `node1` to `node2`
   * must be taken into account in the analysis.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalTaintStep(node1, node2) or
    localAdditionalTaintStep(node1, node2)
  }

  /**
   * Holds if taint may flow from `source` to `sink` for this configuration.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    super.hasFlow(source, sink)
  }
}
