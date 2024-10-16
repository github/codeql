/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import semmle.code.powershell.dataflow.internal.TaintTrackingImpl::Public
  private import semmle.code.powershell.dataflow.internal.DataFlowImplSpecific
  private import semmle.code.powershell.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import powershell
  import TaintFlowMake<Location, PowershellDataFlow, PowershellTaintTracking>
}
