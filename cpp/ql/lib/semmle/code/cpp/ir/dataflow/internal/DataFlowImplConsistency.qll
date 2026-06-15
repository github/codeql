/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import cpp
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, CppDataFlow> {
  predicate argHasPostUpdateExclude(Private::ArgumentNode n) {
    // The rules for whether an IR argument gets a post-update node are too
    // complex to model here.
    any()
  }
}

module Consistency = MakeConsistency<Location, CppDataFlow, CppTaintTracking, Input>;
