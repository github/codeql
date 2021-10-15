private import ruby
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
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::Content c) { none() }

/**
 * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
 * in all global taint flow configurations.
 */
cached
predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
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
  // element reference from nodeFrom
  nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ElementReferenceCfgNode).getReceiver()
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, false)
}
