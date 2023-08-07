/**
 * Provides C++-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module CppOldTaintTracking implements InputSig<CppOldDataFlow> {
  import TaintTrackingUtil
}
