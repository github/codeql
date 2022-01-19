private import ruby
private import DataFlowPrivate
private import TaintTrackingPublic
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import FlowSummaryImpl as FlowSummaryImpl

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

private CfgNodes::ExprNodes::VariableWriteAccessCfgNode variablesInPattern(
  CfgNodes::ExprNodes::CasePatternCfgNode p
) {
  result = p
  or
  exists(CfgNodes::ExprNodes::AsPatternCfgNode ap | p = ap |
    result = variablesInPattern(ap.getPattern()) or
    result = ap.getVariableAccess()
  )
  or
  exists(CfgNodes::ExprNodes::ParenthesizedPatternCfgNode pp | p = pp |
    result = variablesInPattern(pp.getPattern())
  )
  or
  exists(CfgNodes::ExprNodes::AlternativePatternCfgNode ap | p = ap |
    result = variablesInPattern(ap.getAlternative(_))
  )
  or
  exists(CfgNodes::ExprNodes::ArrayPatternCfgNode ap | p = ap |
    result = variablesInPattern(ap.getPrefixElement(_)) or
    result = variablesInPattern(ap.getSuffixElement(_)) or
    result = ap.getRestVariableAccess()
  )
  or
  exists(CfgNodes::ExprNodes::FindPatternCfgNode fp | p = fp |
    result = variablesInPattern(fp.getElement(_)) or
    result = fp.getPrefixVariableAccess() or
    result = fp.getSuffixVariableAccess()
  )
  or
  exists(CfgNodes::ExprNodes::HashPatternCfgNode hp | p = hp |
    result = variablesInPattern(hp.getValue(_)) or
    result = hp.getRestVariableAccess()
  )
}

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
    nodeTo.(SsaDefinitionNode).getDefinition().getControlFlowNode() =
      variablesInPattern(clause.getPattern())
  )
  or
  // operation involving `nodeFrom`
  exists(CfgNodes::ExprNodes::OperationCfgNode op |
    op = nodeTo.asExpr() and
    op.getAnOperand() = nodeFrom.asExpr() and
    not op.getExpr() instanceof AssignExpr
  )
  or
  // string interpolation of `nodeFrom` into `nodeTo`
  nodeFrom.asExpr() =
    nodeTo.asExpr().(CfgNodes::ExprNodes::StringlikeLiteralCfgNode).getAComponent()
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, false)
  or
  // Although flow through arrays is modelled precisely using stores/reads, we still
  // allow flow out of a _tainted_ array. This is needed in order to support taint-
  // tracking configurations where the source is an array.
  readStep(nodeFrom, any(DataFlow::Content::ArrayElementContent c), nodeTo)
}
