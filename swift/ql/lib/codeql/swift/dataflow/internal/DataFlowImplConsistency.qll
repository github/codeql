/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import swift
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, SwiftDataFlow> { }

module Consistency = MakeConsistency<Location, SwiftDataFlow, SwiftTaintTracking, Input>;
