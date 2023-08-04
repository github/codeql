/**
 * Provides Ruby-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module RubyTaintTracking implements TaintTrackingParameter<RubyDataFlow> {
  import TaintTrackingPrivate
}
