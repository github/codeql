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
  import internal.tainttracking1.TaintTrackingImpl
}
