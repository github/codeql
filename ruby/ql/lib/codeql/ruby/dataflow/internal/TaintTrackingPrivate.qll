private import codeql.ruby.AST
private import DataFlowPrivate
private import TaintTrackingPublic
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.dataflow.SSA
private import SsaImpl as SsaImpl

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
  exists(node) and
  c.isElementOfTypeOrUnknown("int")
}

private CfgNodes::ExprNodes::VariableWriteAccessCfgNode variablesInPattern(
  CfgNodes::ExprNodes::CasePatternCfgNode p
) {
  result = p
  or
  p =
    any(CfgNodes::ExprNodes::AsPatternCfgNode ap |
      result = variablesInPattern(ap.getPattern()) or
      result = ap.getVariableAccess()
    )
  or
  p =
    any(CfgNodes::ExprNodes::ParenthesizedPatternCfgNode pp |
      result = variablesInPattern(pp.getPattern())
    )
  or
  p =
    any(CfgNodes::ExprNodes::AlternativePatternCfgNode ap |
      result = variablesInPattern(ap.getAlternative(_))
    )
  or
  p =
    any(CfgNodes::ExprNodes::ArrayPatternCfgNode ap |
      result = variablesInPattern(ap.getPrefixElement(_)) or
      result = variablesInPattern(ap.getSuffixElement(_)) or
      result = ap.getRestVariableAccess()
    )
  or
  p =
    any(CfgNodes::ExprNodes::FindPatternCfgNode fp |
      result = variablesInPattern(fp.getElement(_)) or
      result = fp.getPrefixVariableAccess() or
      result = fp.getSuffixVariableAccess()
    )
  or
  p =
    any(CfgNodes::ExprNodes::HashPatternCfgNode hp |
      result = variablesInPattern(hp.getValue(_)) or
      result = hp.getRestVariableAccess()
    )
}

cached
private module Cached {
  private import codeql.ruby.dataflow.FlowSteps as FlowSteps
  private import codeql.ruby.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    (
      // value of `case` expression into variables in patterns
      exists(
        CfgNodes::ExprNodes::CaseExprCfgNode case, CfgNodes::ExprCfgNode value,
        CfgNodes::ExprNodes::InClauseCfgNode clause, Ssa::Definition def
      |
        nodeFrom.asExpr() = value and
        value = case.getValue() and
        clause = case.getBranch(_) and
        def = nodeTo.(SsaDefinitionExtNode).getDefinitionExt() and
        def.getControlFlowNode() = variablesInPattern(clause.getPattern()) and
        not def.(Ssa::WriteDefinition).assigns(value)
      )
      or
      // operation involving `nodeFrom`
      exists(CfgNodes::ExprNodes::OperationCfgNode op |
        op = nodeTo.asExpr() and
        op.getAnOperand() = nodeFrom.asExpr() and
        not op.getExpr() =
          any(Expr e |
            // included in normal data-flow
            e instanceof AssignExpr or
            e instanceof BinaryLogicalOperation or
            // has flow summary
            e instanceof SplatExpr
          )
      )
    ) and
    model = ""
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), false, model)
    or
    any(FlowSteps::AdditionalTaintStep s).step(nodeFrom, nodeTo) and model = "AdditionalTaintStep"
    or
    // Although flow through collections is modeled precisely using stores/reads, we still
    // allow flow out of a _tainted_ collection. This is needed in order to support taint-
    // tracking configurations where the source is a collection.
    exists(DataFlow::ContentSet c |
      readStep(nodeFrom, c, nodeTo) and
      c.isElement() and
      model = ""
    )
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
  private import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch
  private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlowPublic

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    exists(
      DataFlowDispatch::DataFlowCall call, MethodCall srcCall,
      DataFlowDispatch::ArgumentPosition argpos, MethodCall mc
    |
      // TODO: exclude neutrals and anything that has QL modeling.
      not exists(DataFlowDispatch::viableCallable(call)) and
      call.asCall().getExpr() = srcCall and
      src.(ArgumentNode).argumentOf(call, argpos) and
      call.asCall().getExpr() = mc and
      not mc instanceof Operation and
      not mc instanceof SetterMethodCall and
      not mc instanceof ElementReference
    |
      not argpos.isSelf() and
      sink.(DataFlowPublic::PostUpdateNode)
          .getPreUpdateNode()
          .(ArgumentNode)
          .argumentOf(call, any(DataFlowDispatch::ArgumentPosition qualpos | qualpos.isSelf()))
      or
      sink.(OutNode).getCall(_) = call
    )
  }
}
