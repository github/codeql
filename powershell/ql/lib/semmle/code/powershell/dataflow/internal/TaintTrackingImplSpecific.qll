/**
 * Provides Powershell-specific definitions for use in the taint tracking library.
 */

private import codeql.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module PowershellTaintTracking implements InputSig<Location, PowershellDataFlow> {
  import TaintTrackingPrivate
}
