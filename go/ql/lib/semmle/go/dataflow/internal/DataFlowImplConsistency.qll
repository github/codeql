/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import go
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency
private import semmle.go.dataflow.internal.DataFlowNodes

private module Input implements InputSig<Location, GoDataFlow> { }

module Consistency = MakeConsistency<Location, GoDataFlow, GoTaintTracking, Input>;
