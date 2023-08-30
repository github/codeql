/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import semmle.go.dataflow.DataFlow

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import semmle.go.dataflow.internal.tainttracking1.TaintTrackingParameter::Public
  private import semmle.go.dataflow.internal.DataFlowImplSpecific
  private import semmle.go.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<GoDataFlow, GoTaintTracking>
  import semmle.go.dataflow.internal.tainttracking1.TaintTrackingImpl
}
