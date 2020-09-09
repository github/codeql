/**
 * Provides an implementation of global (interprocedural) taint tracking.
 * This file re-exports the local (intraprocedural) taint-tracking analysis
 * from `TaintTrackingParameter::Public` and adds a global analysis, mainly
 * exposed through the `Configuration` class. For some languages, this file
 * exists in several identical copies, allowing queries to use multiple
 * `Configuration` classes that depend on each other without introducing
 * mutual recursion among those configurations.
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
 * necessarily preserve values but are still relevant from a taint tracking
 * perspective. (For example, string concatenation, where one of the operands
 * is tainted.)
 *
 * To create a configuration, extend this class with a subclass whose
 * characteristic predicate is a unique singleton string. For example, write
 *
 * ```ql
 * class MyAnalysisConfiguration extends TaintTracking::Configuration {
 *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
 *   // Override `isSource` and `isSink`.
 *   // Optionally override `isSanitizer`.
 *   // Optionally override `isSanitizerIn`.
 *   // Optionally override `isSanitizerOut`.
 *   // Optionally override `isSanitizerGuard`.
 *   // Optionally override `isAdditionalTaintStep`.
 * }
 * ```
 *
 * Then, to query whether there is flow between some `source` and `sink`,
 * write
 *
 * ```ql
 * exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
 * ```
 *
 * Multiple configurations can coexist, but it is unsupported to depend on
 * another `TaintTracking::Configuration` or a `DataFlow::Configuration` in the
 * overridden predicates that define sources, sinks, or additional steps.
 * Instead, the dependency should go to a `TaintTracking2::Configuration` or a
 * `DataFlow2::Configuration`, `DataFlow3::Configuration`, etc.
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
    defaultTaintSanitizer(node)
  }

  /** Holds if taint propagation into `node` is prohibited. */
  predicate isSanitizerIn(DataFlow::Node node) { none() }

  final override predicate isBarrierIn(DataFlow::Node node) { isSanitizerIn(node) }

  /** Holds if taint propagation out of `node` is prohibited. */
  predicate isSanitizerOut(DataFlow::Node node) { none() }

  final override predicate isBarrierOut(DataFlow::Node node) { isSanitizerOut(node) }

  /** Holds if taint propagation through nodes guarded by `guard` is prohibited. */
  predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { none() }

  final override predicate isBarrierGuard(DataFlow::BarrierGuard guard) { isSanitizerGuard(guard) }

  /**
   * Holds if the additional taint propagation step from `node1` to `node2`
   * must be taken into account in the analysis.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalTaintStep(node1, node2) or
    defaultAdditionalTaintStep(node1, node2)
  }

  /**
   * Holds if taint may flow from `source` to `sink` for this configuration.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    super.hasFlow(source, sink)
  }
}
