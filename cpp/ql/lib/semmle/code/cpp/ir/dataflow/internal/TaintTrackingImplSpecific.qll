/**
 * Provides C++-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific
private import semmle.code.cpp.Location

module CppTaintTracking implements InputSig<Location, CppDataFlow> {
  import TaintTrackingUtil
}
