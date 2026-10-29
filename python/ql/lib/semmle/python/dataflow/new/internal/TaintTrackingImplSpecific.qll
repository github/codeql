/**
 * Provides Python-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific
private import semmle.python.Files

module PythonTaintTracking implements InputSig<Location, PythonDataFlow> {
  import TaintTrackingPrivate
}
