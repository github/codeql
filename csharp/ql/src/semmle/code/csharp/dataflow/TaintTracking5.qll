/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import csharp

module TaintTracking5 {
  private import semmle.code.csharp.dataflow.DataFlow5
  private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
  import semmle.code.csharp.dataflow.internal.TaintTrackingPublic

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
  abstract class Configuration extends DataFlow5::Configuration {
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

    /** Holds if the intermediate node `node` is a taint sanitizer. */
    predicate isSanitizer(DataFlow::Node node) { none() }

    final override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /**
     * Holds if the additional taint propagation step from `pred` to `succ`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      isAdditionalTaintStep(pred, succ)
      or
      localAdditionalTaintStep(pred, succ)
      or
      succ = pred.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }
}
