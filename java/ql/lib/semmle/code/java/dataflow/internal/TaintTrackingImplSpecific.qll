/**
 * Provides Java-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific
private import semmle.code.Location

module JavaTaintTracking implements InputSig<Location, JavaDataFlow> {
  import TaintTrackingUtil
}
