/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
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
  private import semmle.python.dataflow.new.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<PythonDataFlow, PythonTaintTracking>
  import internal.tainttracking1.TaintTrackingImpl
}
