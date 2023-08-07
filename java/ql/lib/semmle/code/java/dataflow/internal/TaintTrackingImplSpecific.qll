/**
 * Provides Java-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module JavaTaintTracking implements InputSig<JavaDataFlow> {
  import TaintTrackingUtil
}
