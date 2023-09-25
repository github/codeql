/**
 * Provides Ruby-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module RubyTaintTracking implements InputSig<RubyDataFlow> {
  import TaintTrackingPrivate
}
