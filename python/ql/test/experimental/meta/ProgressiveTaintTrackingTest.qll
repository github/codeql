/**
 * Provides classes for testing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * This module intentionally turns off implicit read steps at sinks.
 * This makes it possible to do successive tests of taint propagation,
 * using sinks (such as arguments to `ensure_tainted`) as markers, and get a picture of where taint flows
 * on its way from a source to a sink.
 *
 * To use global (interprocedural) taint tracking, extend the class
 * `TaintTracking::Configuration` as documented on that class. To use local
 * (intraprocedural) taint tracking, call `TaintTracking::localTaint` or
 * `TaintTracking::localTaintStep` with arguments of type `DataFlow::Node`.
 */

private import python

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import semmle.python.dataflow.new.internal.tainttracking1.TaintTrackingParameter::Public
  private import semmle.python.dataflow.new.internal.DataFlowImplSpecific
  private import codeql.dataflow.TaintTracking
  private import semmle.python.Files

  module PythonTaintTracking implements InputSig<Location, PythonDataFlow> {
    private import semmle.python.dataflow.new.internal.TaintTrackingPrivate as TP

    /**
     * Holds if `node` should be a sanitizer in all global taint flow configurations
     * but not in local taint.
     */
    predicate defaultTaintSanitizer(PythonDataFlow::Node node) { TP::defaultTaintSanitizer(node) }

    /**
     * Holds if default `TaintTracking::Configuration`s should allow implicit reads
     * of `c` at sinks and inputs to additional taint steps.
     */
    bindingset[node]
    predicate defaultImplicitTaintRead(PythonDataFlow::Node node, PythonDataFlow::ContentSet c) {
      // Normally, we allow implicit reads of precise content,
      // but for taint tests, we turn this off.
      none()
    }

    predicate defaultAdditionalTaintStep(
      PythonDataFlow::Node nodeFrom, PythonDataFlow::Node nodeTo, string model
    ) {
      TP::defaultAdditionalTaintStep(nodeFrom, nodeTo, model)
    }
  }

  import TaintFlowMake<Location, PythonDataFlow, PythonTaintTracking>
  import semmle.python.dataflow.new.internal.tainttracking1.TaintTrackingImpl
}
