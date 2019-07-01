/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * We define _taint propagation_ informally to mean that a substantial part of
 * the information from the source is preserved at the sink. For example, taint
 * propagates from `x` to `x + 100`, but it does not propagate from `x` to `x >
 * 100` since we consider a single bit of information to be too little.
 */

import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.dataflow.DataFlow2
private import semmle.code.cpp.ir.IR

module TaintTracking {
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
   * Instead, the dependency should go to a `TaintTracking::Configuration2` or
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

    /**
     * Holds if the additional taint propagation step
     * from `source` to `target` must be taken into account in the analysis.
     * This step will only be followed if `target` is not in the `isSanitizer`
     * predicate.
     */
    predicate isAdditionalTaintStep(DataFlow::Node source, DataFlow::Node target) { none() }

    final override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    final override predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node target) {
      this.isAdditionalTaintStep(source, target)
      or
      localTaintStep(source, target)
    }
  }

  /**
   * A taint-tracking configuration that is backed by the `DataFlow2` library
   * instead of `DataFlow`. Use this class when taint-tracking configurations
   * or data-flow configurations must depend on each other.
   *
   * See `TaintTracking::Configuration` for the full documentation.
   */
  abstract class Configuration2 extends DataFlow2::Configuration {
    bindingset[this]
    Configuration2() { any() }

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

    /**
     * Holds if the additional taint propagation step
     * from `source` to `target` must be taken into account in the analysis.
     * This step will only be followed if `target` is not in the `isSanitizer`
     * predicate.
     */
    predicate isAdditionalTaintStep(DataFlow::Node source, DataFlow::Node target) { none() }

    final override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    final override predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node target) {
      this.isAdditionalTaintStep(source, target)
      or
      localTaintStep(source, target)
    }
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Taint can flow into using ordinary data flow.
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    // Taint can flow through expressions that alter the value but preserve
    // more than one bit of it _or_ expressions that follow data through
    // pointer indirections.
    nodeTo.getAnOperand().getAnyDef() = nodeFrom and
    (
      nodeTo instanceof ArithmeticInstruction
      or
      nodeTo instanceof BitwiseInstruction
      or
      nodeTo instanceof PointerArithmeticInstruction
      or
      nodeTo instanceof FieldAddressInstruction
      or
      // The `CopyInstruction` case is also present in non-taint data flow, but
      // that uses `getDef` rather than `getAnyDef`. For taint, we want flow
      // from a definition of `myStruct` to a `myStruct.myField` expression.
      nodeTo instanceof CopyInstruction
    )
    or
    nodeTo.(LoadInstruction).getSourceAddress() = nodeFrom
  }

  /**
   * Holds if taint may propagate from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }
}
