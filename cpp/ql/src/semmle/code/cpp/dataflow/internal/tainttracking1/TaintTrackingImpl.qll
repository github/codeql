/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * We define _taint propagation_ informally to mean that a substantial part of
 * the information from the source is preserved at the sink. For example, taint
 * propagates from `x` to `x + 100`, but it does not propagate from `x` to `x >
 * 100` since we consider a single bit of information to be too little.
 */
import TaintTrackingParameter::Public
private import TaintTrackingParameter::Private

/**
 * A configuration of interprocedural taint tracking analysis. This defines
 * sources, sinks, and any other configurable aspect of the analysis. Each
 * use of the taint tracking library must define its own unique extension of
 * this abstract class.
 *
 * A taint-tracking configuration is a special data flow configuration
 * (`DataFlow::Configuration`) that allows for flow through nodes that do not
 * necessarily preserve values but are still relevant from a taint-tracking
 * perspective. (For example, string concatenation, where one of the operands
 * is tainted.)
 *
 * To create a configuration, extend this class with a subclass whose
 * characteristic predicate is a unique singleton string. For example, write
 *
 * ```
 * class MyAnalysisConfiguration extends TaintTracking::Configuration {
 *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
 *   // Override `isSource` and `isSink`.
 *   // Optionally override `isSanitizer`.
 *   // Optionally override `isSanitizerEdge`.
 *   // Optionally override `isAdditionalTaintStep`.
 * }
 * ```
 *
 * Then, to query whether there is flow between some `source` and `sink`,
 * write
 *
 * ```
 * exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
 * ```
 *
 * Multiple configurations can coexist, but it is unsupported to depend on a
 * `TaintTracking::Configuration` or a `DataFlow::Configuration` in the
 * overridden predicates that define sources, sinks, or additional steps.
 * Instead, the dependency should go to a `TaintTracking2::Configuration` or
 * a `DataFlow{2,3,4}::Configuration`.
 */
abstract class Configuration extends DataFlow::Configuration {
  bindingset[this]
  Configuration() { any() }

  /** Holds if `source` is a taint source. */
  // overridden to provide taint-tracking specific qldoc
  abstract override predicate isSource(DataFlow::Node source);

  /** Holds if `sink` is a taint sink. */
  // overridden to provide taint-tracking specific qldoc
  abstract override predicate isSink(DataFlow::Node sink);

  /**
   * Holds if taint should not flow into `node`.
   */
  predicate isSanitizer(DataFlow::Node node) { none() }

  /** Holds if data flow from `node1` to `node2` is prohibited. */
  predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) {
    none()
  }

  /**
   * Holds if the additional taint propagation step
   * from `source` to `target` must be taken into account in the analysis.
   * This step will only be followed if `target` is not in the `isSanitizer`
   * predicate.
   */
  predicate isAdditionalTaintStep(DataFlow::Node source,
                                  DataFlow::Node target)
  { none() }

  final override
  predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

  /** DEPRECATED: use `isSanitizerEdge` instead. */
  override deprecated
  predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
    this.isSanitizerEdge(node1, node2)
  }

  final override
  predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node target) {
    this.isAdditionalTaintStep(source, target)
    or
    localTaintStep(source, target)
  }
}
