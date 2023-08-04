/**
 * Provides C++-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module CppOldTaintTracking implements TaintTrackingParameter<CppOldDataFlow> {
  import TaintTrackingUtil
}
