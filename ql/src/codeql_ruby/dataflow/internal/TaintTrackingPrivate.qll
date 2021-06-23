private import ruby
private import TaintTrackingPublic
private import codeql_ruby.CFG
private import codeql_ruby.DataFlow

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

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
  exists(CfgNodes::ExprNodes::StringlikeLiteralCfgNode lit, StringInterpolationComponent sic |
    lit = nodeTo.asExpr() and
    sic = lit.getExpr().getComponent(_) and
    sic.getAStmt() = nodeFrom.asExpr().getExpr()
  )
  or
  // element reference from nodeFrom
  exists(CfgNodes::ExprNodes::ElementReferenceCfgNode ref |
    ref = nodeTo.asExpr() and
    ref.getExpr().getReceiver() = nodeFrom.asExpr().getExpr()
  )
}
