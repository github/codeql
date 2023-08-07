/**
 * Provides C#-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module CsharpTaintTracking implements InputSig<CsharpDataFlow> {
  import TaintTrackingPrivate
}
