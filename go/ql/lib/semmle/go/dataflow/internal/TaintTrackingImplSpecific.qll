/**
 * Provides Go-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module GoTaintTracking implements TaintTrackingParameter<GoDataFlow> {
  import TaintTrackingUtil
}
