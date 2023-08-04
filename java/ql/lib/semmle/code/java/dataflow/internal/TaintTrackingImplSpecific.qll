/**
 * Provides Java-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module JavaTaintTracking implements TaintTrackingParameter<JavaDataFlow> {
  import TaintTrackingUtil
}
