/**
 * Provides Swift-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module SwiftTaintTracking implements TaintTrackingParameter<SwiftDataFlow> {
  import TaintTrackingPrivate
  import TaintTrackingPublic
}
