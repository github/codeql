/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import powershell

module DataFlow {
  private import internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, PowershellDataFlow>
  import internal.DataFlowImpl
}
