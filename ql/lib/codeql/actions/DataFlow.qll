/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlow {
  private import codeql.dataflow.DataFlow
  private import codeql.actions.dataflow.internal.DataFlowImplSpecific
  import DataFlowMake<ActionsDataFlow>
  import codeql.actions.dataflow.internal.DataFlowPublic
}
