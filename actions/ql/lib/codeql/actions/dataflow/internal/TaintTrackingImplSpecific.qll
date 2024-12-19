/**
 * Provides Actions-specific definitions for use in the taint tracking library.
 * Implementation of https://github.com/github/codeql/blob/main/shared/dataflow/codeql/dataflow/TaintTracking.qll
 */

private import codeql.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module ActionsTaintTracking implements InputSig<Location, ActionsDataFlow> {
  import TaintTrackingPrivate
}
