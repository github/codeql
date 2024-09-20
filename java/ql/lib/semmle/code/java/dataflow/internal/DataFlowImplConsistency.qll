/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import java
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, JavaDataFlow> {
  predicate argHasPostUpdateExclude(JavaDataFlow::ArgumentNode n) {
    n.getType() instanceof ImmutableType or n instanceof Public::ImplicitVarargsArray
  }
}

module Consistency = MakeConsistency<Location, JavaDataFlow, JavaTaintTracking, Input>;
