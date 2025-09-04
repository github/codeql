/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import go
private import DataFlowImplSpecific as Impl
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency
private import semmle.go.dataflow.internal.DataFlowNodes

private module Input implements InputSig<Location, Impl::GoDataFlow> { }

module Consistency = MakeConsistency<Location, Impl::GoDataFlow, GoTaintTracking, Input>;
