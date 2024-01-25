/**
 * Provides Python-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module PythonTaintTracking implements InputSig<PythonDataFlow> {
  import TaintTrackingPrivate
}
