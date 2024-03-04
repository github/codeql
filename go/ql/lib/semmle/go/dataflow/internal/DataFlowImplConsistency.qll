/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import go
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<GoDataFlow> { }

module Consistency = MakeConsistency<GoDataFlow, GoTaintTracking, Input>;
