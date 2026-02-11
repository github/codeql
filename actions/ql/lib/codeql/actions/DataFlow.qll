/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import codeql.Locations

module DataFlow {
  private import codeql.dataflow.DataFlow
  private import codeql.actions.dataflow.internal.DataFlowImplSpecific
  import DataFlowMake<Location, ActionsDataFlow>
  import codeql.actions.dataflow.internal.DataFlowPublic
  // debug
  private import codeql.actions.dataflow.internal.TaintTrackingImplSpecific
  import codeql.dataflow.internal.DataFlowImplConsistency as DFIC

  module ActionsConsistency implements DFIC::InputSig<Location, ActionsDataFlow> { }

  module Consistency {
    import DFIC::MakeConsistency<Location, ActionsDataFlow, ActionsTaintTracking, ActionsConsistency>
  }
}
