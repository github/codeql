/**
 * Provides Ruby-specific definitions for use in the taint tracking library.
 */

private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module RubyTaintTracking implements InputSig<RubyDataFlow> {
  private import TaintTrackingPrivate as Priv
  import Priv

  predicate defaultAdditionalTypedLocalTaintStep = Priv::defaultAdditionalTypedLocalTaintStep/2;

  predicate defaultAdditionalTypedLocalTaintStep = Priv::defaultAdditionalTypedLocalTaintStep/4;
}
