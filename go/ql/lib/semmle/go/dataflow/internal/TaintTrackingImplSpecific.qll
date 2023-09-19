/**
 * Provides Go-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module GoTaintTracking implements InputSig<GoDataFlow> {
  import TaintTrackingUtil
}
