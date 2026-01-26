/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import go
private import DataFlowImplSpecific as Impl
private import DataFlowUtil
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency
private import semmle.go.dataflow.internal.DataFlowNodes

private module Input implements InputSig<Location, Impl::GoDataFlow> {
  predicate missingLocationExclude(DataFlow::Node n) {
    n instanceof DataFlow::GlobalFunctionNode or n instanceof Private::FlowSummaryNode
  }

  predicate uniqueNodeLocationExclude(DataFlow::Node n) { missingLocationExclude(n) }

  predicate localFlowIsLocalExclude(DataFlow::Node n1, DataFlow::Node n2) {
    n1 instanceof DataFlow::FunctionNode and simpleLocalFlowStep(n1, n2, _)
  }

  predicate argHasPostUpdateExclude(DataFlow::ArgumentNode n) {
    not DataFlow::insnHasPostUpdateNode(n.asInstruction())
  }
}

module Consistency = MakeConsistency<Location, Impl::GoDataFlow, GoTaintTracking, Input>;
