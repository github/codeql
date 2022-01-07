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
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, false)
  or
  // Although flow through arrays is modelled precisely using stores/reads, we still
  // allow flow out of a _tainted_ array. This is needed in order to support taint-
  // tracking configurations where the source is an array.
  readStep(nodeFrom, any(DataFlow::Content::ArrayElementContent c), nodeTo)
}
