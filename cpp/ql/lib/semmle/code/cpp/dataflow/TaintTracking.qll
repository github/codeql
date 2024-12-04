/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * We define _taint propagation_ informally to mean that a substantial part of
 * the information from the source is preserved at the sink. For example, taint
 * propagates from `x` to `x + 100`, but it does not propagate from `x` to `x >
 * 100` since we consider a single bit of information to be too little.
 *
 * To use global (interprocedural) taint tracking, extend the class
 * `TaintTracking::Configuration` as documented on that class. To use local
 * (intraprocedural) taint tracking between expressions, call
 * `TaintTracking::localExprTaint`. For more general cases of local taint
 * tracking, call `TaintTracking::localTaint` or
 * `TaintTracking::localTaintStep` with arguments of type `DataFlow::Node`.
 */

import semmle.code.cpp.dataflow.DataFlow

/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.TaintTracking` instead.
 *
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
deprecated module TaintTracking {
  import semmle.code.cpp.dataflow.internal.TaintTrackingUtil
  private import semmle.code.cpp.dataflow.internal.DataFlowImplSpecific
  private import semmle.code.cpp.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<Location, CppOldDataFlow, CppOldTaintTracking>
}
