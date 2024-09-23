/**
 * Provides Powershell-specific definitions for use in the taint tracking library.
 */

private import powershell
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module PowershellTaintTracking implements InputSig<Location, PowershellDataFlow> {
  import TaintTrackingPrivate
}
