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
  override predicate isSource(DataFlow::Node source) { none() }

  /**
   * Holds if `source` is a relevant taint source with the given initial
   * `state`.
   *
   * The smaller this predicate is, the faster `hasFlow()` will converge.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) { none() }

  /**
   * Holds if `sink` is a relevant taint sink
   *
   * The smaller this predicate is, the faster `hasFlow()` will converge.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate isSink(DataFlow::Node sink) { none() }

  /**
   * Holds if `sink` is a relevant taint sink accepting `state`.
   *
   * The smaller this predicate is, the faster `hasFlow()` will converge.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) { none() }

  /** Holds if the node `node` is a taint sanitizer. */
  predicate isSanitizer(DataFlow::Node node) { none() }

  final override predicate isBarrier(DataFlow::Node node) {
    this.isSanitizer(node) or
    defaultTaintSanitizer(node)
  }

  /**
   * Holds if the node `node` is a taint sanitizer when the flow state is
   * `state`.
   */
  predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) { none() }

  final override predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) {
    this.isSanitizer(node, state)
  }

  /** Holds if taint propagation into `node` is prohibited. */
  predicate isSanitizerIn(DataFlow::Node node) { none() }

  final override predicate isBarrierIn(DataFlow::Node node) { this.isSanitizerIn(node) }

  /** Holds if taint propagation out of `node` is prohibited. */
  predicate isSanitizerOut(DataFlow::Node node) { none() }

  final override predicate isBarrierOut(DataFlow::Node node) { this.isSanitizerOut(node) }

  /** Holds if taint propagation through nodes guarded by `guard` is prohibited. */
  predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { none() }

  final override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
    this.isSanitizerGuard(guard) or defaultTaintSanitizerGuard(guard)
  }

  /**
   * Holds if taint propagation through nodes guarded by `guard` is prohibited
   * when the flow state is `state`.
   */
  predicate isSanitizerGuard(DataFlow::BarrierGuard guard, DataFlow::FlowState state) { none() }

  final override predicate isBarrierGuard(DataFlow::BarrierGuard guard, DataFlow::FlowState state) {
    this.isSanitizerGuard(guard, state)
  }

  /**
   * Holds if taint may propagate from `node1` to `node2` in addition to the normal data-flow and taint steps.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    this.isAdditionalTaintStep(node1, node2) or
    defaultAdditionalTaintStep(node1, node2)
  }

  /**
   * Holds if taint may propagate from `node1` to `node2` in addition to the normal data-flow and taint steps.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }

  final override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    this.isAdditionalTaintStep(node1, state1, node2, state2)
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    (this.isSink(node) or this.isAdditionalTaintStep(node, _)) and
    defaultImplicitTaintRead(node, c)
  }

  /**
   * Holds if taint may flow from `source` to `sink` for this configuration.
   */
  // overridden to provide taint-tracking specific qldoc
  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    super.hasFlow(source, sink)
  }
}
