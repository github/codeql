/**
 * Provides Python-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTrackingParameter
private import DataFlowImplSpecific

module PythonTaintTracking implements TaintTrackingParameter<PythonDataFlow> {
  import TaintTrackingPrivate
}
