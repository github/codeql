/**
 * Provides C#-specific definitions for use in the taint tracking library.
 */

private import semmle.code.csharp.Location
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module CsharpTaintTracking implements InputSig<Location, CsharpDataFlow> {
  import TaintTrackingPrivate
}
