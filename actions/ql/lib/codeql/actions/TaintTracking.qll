/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import codeql.Locations

module TaintTracking {
  private import codeql.actions.dataflow.internal.DataFlowImplSpecific
  private import codeql.actions.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<Location, ActionsDataFlow, ActionsTaintTracking>
}
