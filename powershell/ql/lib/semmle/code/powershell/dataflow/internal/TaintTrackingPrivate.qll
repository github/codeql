private import powershell
private import DataFlowPrivate
private import TaintTrackingPublic
private import semmle.code.powershell.Cfg
private import semmle.code.powershell.dataflow.DataFlow
private import FlowSummaryImpl as FlowSummaryImpl
private import PipelineReturns as PipelineReturns

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) {
  node instanceof ArgumentNode and
  c.isAnyPositional()
}

private module ExpandableSubExprInput implements PipelineReturns::InputSig {
  additional predicate isSourceImpl(
    CfgNodes::ExprNodes::ExpandableSubExprCfgNode expandableSubExpr, CfgNodes::AstCfgNode source
  ) {
    source = expandableSubExpr.getSubExpr()
  }

  predicate isSource(CfgNodes::AstCfgNode source) { isSourceImpl(_, source) }
}

/**
 * Holds if `nodeFrom` flows to `nodeTo` via string interpolation.
 */
predicate stringInterpolationTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // flow from $x to "Hello $x"
  exists(CfgNodes::ExprNodes::ExpandableStringExprCfgNode es |
    nodeFrom.asExpr() = es.getAnExpr() and
    nodeTo.asExpr() = es
  )
  or
  // Flow from $x to $($x)
  exists(
    CfgNodes::ExprNodes::ExpandableSubExprCfgNode es,
    CfgNodes::StmtNodes::StmtBlockCfgNode blockStmt
  |
    ExpandableSubExprInput::isSourceImpl(es, blockStmt) and
    nodeFrom.asExpr() = PipelineReturns::Make<ExpandableSubExprInput>::getAReturn(blockStmt) and
    nodeTo.asExpr() = es
  )
}

predicate operationTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(CfgNodes::ExprNodes::OperationCfgNode op |
    op = nodeTo.asExpr() and
    op.getAnOperand() = nodeFrom.asExpr()
  )
}

cached
private module Cached {
  private import semmle.code.powershell.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    (
      // Flow from an operand to an operation
      operationTaintStep(nodeFrom, nodeTo)
      or
      // Flow through string interpolation
      stringInterpolationTaintStep(nodeFrom, nodeTo)
      or
      // Although flow through collections is modeled precisely using stores/reads, we still
      // allow flow out of a _tainted_ collection. This is needed in order to support taint-
      // tracking configurations where the source is a collection.
      exists(DataFlow::ContentSet c | readStep(nodeFrom, c, nodeTo) |
        c.isSingleton(any(DataFlow::Content::ElementContent ec))
        or
        c.isKnownOrUnknownElement(_)
        or
        c.isAnyElement()
      )
      or
      nodeTo.(DataFlow::ToStringCallNode).getQualifier() = nodeFrom
    ) and
    model = ""
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), false, model)
  }

  cached
  predicate summaryThroughStepTaint(
    DataFlow::Node arg, DataFlow::Node out, FlowSummaryImpl::Public::SummarizedCallable sc
  ) {
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(arg, out, sc)
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localTaintStepCached(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    DataFlow::localFlowStep(nodeFrom, nodeTo) or
    defaultAdditionalTaintStep(nodeFrom, nodeTo, _) or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    summaryThroughStepTaint(nodeFrom, nodeTo, _)
  }
}

import Cached
import SpeculativeTaintFlow

private module SpeculativeTaintFlow {
  private import semmle.code.powershell.dataflow.internal.DataFlowDispatch as DataFlowDispatch
  private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlowPublic

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) { none() }
}
