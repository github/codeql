/**
 * Provides Swift-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific
private import codeql.swift.elements.Location

module SwiftTaintTracking implements InputSig<Location, SwiftDataFlow> {
  import TaintTrackingPrivate
  import TaintTrackingPublic
}
