/**
 * Provides C#-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module CsharpTaintTracking implements TaintTrackingParameter<CsharpDataFlow> {
  import TaintTrackingPrivate
}
