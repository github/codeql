/**
 * Provides C++-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module CppTaintTracking implements InputSig<CppDataFlow> {
  import TaintTrackingUtil
}
