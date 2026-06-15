/**
 * Provides Go-specific definitions for use in the taint tracking library.
 */
overlay[local?]
module;

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific
private import semmle.go.Locations

module GoTaintTracking implements InputSig<Location, GoDataFlow> {
  import TaintTrackingUtil
}
