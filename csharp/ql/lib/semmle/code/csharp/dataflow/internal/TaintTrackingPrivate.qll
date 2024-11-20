private import csharp
private import TaintTrackingPublic
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.Caching
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.ControlFlowReachability
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.commons.ComparisonTest
// import `TaintedMember` definitions from other files to avoid potential reevaluation
private import semmle.code.csharp.frameworks.JsonNET
private import semmle.code.csharp.frameworks.WCF
private import semmle.code.csharp.security.dataflow.flowsources.Remote

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) {
  exists(MethodCall mc |
    mc.getTarget().hasFullyQualifiedName("System.Text.StringBuilder", "Clear")
  |
    node.asExpr() = mc.getQualifier()
  )
}

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) { none() }

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
      or
      // Taint flows from the operand of a cast to the cast expression if the cast is to an interpolated string handler.
      e2 =
        any(CastExpr ce |
          e1 = ce.getExpr() and
          scope = ce and
          ce.getTargetType()
              .(Attributable)
              .getAnAttribute()
              .getType()
              .hasFullyQualifiedName("System.Runtime.CompilerServices",
                "InterpolatedStringHandlerAttribute")
        )
    )
  }
}

private predicate localTaintStepCommon(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  hasNodePath(any(LocalTaintExprStepConfiguration x), nodeFrom, nodeTo)
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
      FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
      or
      // Taint collection by adding a tainted element
      exists(DataFlow::ContentSet c | c.isElement() |
        storeStep(nodeFrom, c, nodeTo)
        or
        FlowSummaryImpl::Private::Steps::summarySetterStep(nodeFrom, c, nodeTo, _)
      )
      or
      exists(DataFlow::ContentSet c |
        readStep(nodeFrom, c, nodeTo)
        or
        FlowSummaryImpl::Private::Steps::summaryGetterStep(nodeFrom, c, nodeTo, _)
      |
        // Taint members
        c = any(TaintedMember m).(FieldOrProperty).getContentSet()
        or
        // Read from a tainted collection
        c.isElement()
      )
    )
  }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    (
      localTaintStepCommon(nodeFrom, nodeTo)
      or
      // Taint members
      readStep(nodeFrom, any(TaintedMember m).(FieldOrProperty).getContentSet(), nodeTo)
      or
      // Although flow through collections is modeled precisely using stores/reads, we still
      // allow flow out of a _tainted_ collection. This is needed in order to support taint-
      // tracking configurations where the source is a collection
      readStep(nodeFrom, any(DataFlow::ContentSet c | c.isElement()), nodeTo)
      or
      nodeTo = nodeFrom.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
    ) and
    model = ""
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), false, model)
  }
}

import Cached
import SpeculativeTaintFlow

private module SpeculativeTaintFlow {
  private import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
  private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as Impl

  private predicate hasTarget(Call call) {
    exists(Impl::Public::SummarizedCallable sc | sc.getACall() = call)
    or
    exists(Impl::Public::NeutralSummaryCallable nc | nc.getACall() = call)
    or
    call.getTarget().getUnboundDeclaration() instanceof ExternalFlow::SinkCallable
    or
    exists(FlowSummaryImpl::Public::NeutralSinkCallable sc | sc.getACall() = call)
  }

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    exists(DataFlowCall call, Call srcCall, ArgumentPosition argpos |
      not exists(viableCallable(call)) and
      not hasTarget(srcCall) and
      call.(NonDelegateDataFlowCall).getDispatchCall().getCall() = srcCall and
      (srcCall instanceof ConstructorInitializer or srcCall instanceof MethodCall) and
      src.(ArgumentNode).argumentOf(call, argpos) and
      not src instanceof PostUpdateNodes::ObjectInitializerNode and
      not src instanceof MallocNode
    |
      not argpos.isQualifier() and
      sink.(PostUpdateNode)
          .getPreUpdateNode()
          .(ArgumentNode)
          .argumentOf(call, any(ArgumentPosition qualpos | qualpos.isQualifier()))
      or
      sink.(OutNode).getCall(_) = call
    )
  }
}
