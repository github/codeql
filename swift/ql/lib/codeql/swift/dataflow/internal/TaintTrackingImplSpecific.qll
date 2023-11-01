/**
 * Provides Swift-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module SwiftTaintTracking implements InputSig<SwiftDataFlow> {
  import TaintTrackingPrivate
  import TaintTrackingPublic
}
