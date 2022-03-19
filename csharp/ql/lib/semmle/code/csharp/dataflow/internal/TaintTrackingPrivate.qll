private import csharp
private import TaintTrackingPublic
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.Caching
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.ControlFlowReachability
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.commons.ComparisonTest
private import cil
private import dotnet
// import `TaintedMember` definitions from other files to avoid potential reevaluation
private import semmle.code.csharp.frameworks.JsonNET
private import semmle.code.csharp.frameworks.WCF

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if `guard` should be a sanitizer guard in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizerGuard(DataFlow::BarrierGuard guard) { none() }

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::Content c) { none() }

private CIL::DataFlowNode asCilDataFlowNode(DataFlow::Node node) {
  result = node.asParameter() or
  result = node.asExpr()
}

private predicate localTaintStepCil(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  asCilDataFlowNode(nodeFrom).getALocalFlowSucc(asCilDataFlowNode(nodeTo), any(CIL::Tainted t))
}

private class LocalTaintExprStepConfiguration extends ControlFlowReachabilityConfiguration {
  LocalTaintExprStepConfiguration() { this = "LocalTaintExprStepConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    exactScope = false and
    isSuccessor = true and
    (
      e1 = e2.(ElementAccess).getQualifier() and
      scope = e2
      or
      e1 = e2.(AddExpr).getAnOperand() and
      scope = e2
      or
      // A comparison expression where taint can flow from one of the
      // operands if the other operand is a constant value.
      exists(ComparisonTest ct, Expr other |
        ct.getExpr() = e2 and
        e1 = ct.getAnArgument() and
        other = ct.getAnArgument() and
        other.stripCasts().hasValue() and
        e1 != other and
        scope = e2
      )
      or
      e1 = e2.(UnaryLogicalOperation).getAnOperand() and
      scope = e2
      or
      e1 = e2.(BinaryLogicalOperation).getAnOperand() and
      scope = e2
      or
      e1 = e2.(InterpolatedStringExpr).getAChild() and
      scope = e2
      or
      e2 =
        any(OperatorCall oc |
          oc.getTarget().(ConversionOperator).fromLibrary() and
          e1 = oc.getAnArgument() and
          scope = e2
        )
      or
      e1 = e2.(AwaitExpr).getExpr() and
      scope = e2
    )
  }
}

private predicate localTaintStepCommon(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  hasNodePath(any(LocalTaintExprStepConfiguration x), nodeFrom, nodeTo)
  or
  localTaintStepCil(nodeFrom, nodeTo)
}

cached
private module Cached {
  private import DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localTaintStepImpl(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Ordinary data flow
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    localTaintStepCommon(nodeFrom, nodeTo)
    or
    not LocalFlow::excludeFromExposedRelations(nodeFrom) and
    not LocalFlow::excludeFromExposedRelations(nodeTo) and
    (
      // Simple flow through library code is included in the exposed local
      // step relation, even though flow is technically inter-procedural
      FlowSummaryImpl::Private::Steps::summaryThroughStep(nodeFrom, nodeTo, false)
      or
      // Taint collection by adding a tainted element
      exists(DataFlow::ElementContent c |
        storeStep(nodeFrom, c, nodeTo)
        or
        FlowSummaryImpl::Private::Steps::summarySetterStep(nodeFrom, c, nodeTo)
      )
      or
      exists(DataFlow::Content c |
        readStep(nodeFrom, c, nodeTo)
        or
        FlowSummaryImpl::Private::Steps::summaryGetterStep(nodeFrom, c, nodeTo)
      |
        // Taint members
        c = any(TaintedMember m).(FieldOrProperty).getContent()
        or
        // Read from a tainted collection
        c = TElementContent()
      )
    )
  }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    localTaintStepCommon(nodeFrom, nodeTo)
    or
    // Taint members
    readStep(nodeFrom, any(TaintedMember m).(FieldOrProperty).getContent(), nodeTo)
    or
    // Although flow through collections is modelled precisely using stores/reads, we still
    // allow flow out of a _tainted_ collection. This is needed in order to support taint-
    // tracking configurations where the source is a collection
    readStep(nodeFrom, TElementContent(), nodeTo)
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, false)
    or
    nodeTo = nodeFrom.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
  }
}

import Cached
