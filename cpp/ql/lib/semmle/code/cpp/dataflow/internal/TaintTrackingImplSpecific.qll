/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 *
 * Provides C++-specific definitions for use in the taint tracking library.
 */

private import semmle.code.cpp.Location
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module CppOldTaintTracking implements InputSig<Location, CppOldDataFlow> {
  import TaintTrackingUtil
}
