/**
 * Provides PHP-specific definitions for use in the taint tracking library.
 */

private import codeql.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module PhpTaintTracking implements InputSig<Location, PhpDataFlow> {
  import TaintTrackingPrivate
}
