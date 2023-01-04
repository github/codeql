private import codeql.ruby.AST
private import DataFlowPrivate
private import TaintTrackingPublic
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.dataflow.SSA

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
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) { none() }

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

  cached
  predicate forceCachingInSameStage() { any() }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // value of `case` expression into variables in patterns
    exists(CfgNodes::ExprNodes::CaseExprCfgNode case, CfgNodes::ExprNodes::InClauseCfgNode clause |
      nodeFrom.asExpr() = case.getValue() and
      clause = case.getBranch(_) and
      nodeTo.(SsaDefinitionExtNode).getDefinitionExt().(Ssa::Definition).getControlFlowNode() =
        variablesInPattern(clause.getPattern())
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
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, false)
    or
    any(FlowSteps::AdditionalTaintStep s).step(nodeFrom, nodeTo)
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
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localTaintStepCached(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    DataFlow::localFlowStep(nodeFrom, nodeTo) or
    defaultAdditionalTaintStep(nodeFrom, nodeTo) or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
  }
}

import Cached
