/**
 * @name Cors misconfiguration
 * @description CORS header is delivered by untrusted input, allowing a remote user to control which origins are trusted.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/unvalidated-cors-origin-set
 * @tags security
 *       external/cwe/cwe-346
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.TaintTracking2

/**
 * Provides the name of the `Access-Control-Allow-Origin` header key.
 */
string headerAllowOrigin() { result = "Access-Control-Allow-Origin".toLowerCase() }

/**
 *  Holds if `header` sets `Access-Control-Allow-Credentials` to `true`.
 */
private predicate setsAllowCredentials(HeaderDeclaration header) {
  header.getNameArg().asExpr().(StrConst).getText().toLowerCase() =
    "access-control-allow-credentials" and
  header.getValueArg().asExpr().(StrConst).getText().toLowerCase() = "true"
}

/**
 * This taintflow2 configuration checks if there is a flow from source node towards CorsProbableCheckAccess methods.
 */
class CorsSourceReachesCheckConfig extends TaintTracking2::Configuration {
  CorsSourceReachesCheckConfig() { this = "CorsOriginConfig" }

  override predicate isSource(DataFlow::Node source) { any(CorsOriginConfig c).hasFlow(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Compare cmp, Expr left, Expr right, Cmpop cmpop |
      cmpop.getSymbol() = ["==", "in", "is not", "!="] and
      cmp.compares(left, cmpop, right) and
      sink.asExpr() = [left, right]
    )
  }
}

private class CorsOriginConfig extends TaintTracking::Configuration {
  CorsOriginConfig() { this = "CorsOriginConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(HeaderDeclaration corsHeader, HeaderDeclaration allowCredentialsHeader |
      headerAllowOrigin() = corsHeader.getNameArg().asExpr().(StrConst).getText().toLowerCase() and
      setsAllowCredentials(allowCredentialsHeader) and
      corsHeader.getEnclosingCallable() = allowCredentialsHeader.getEnclosingCallable() and
      sink = corsHeader.getValueArg()
    )
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, CorsOriginConfig conf,
  CorsSourceReachesCheckConfig sanconf
where conf.hasFlowPath(source, sink) and not sanconf.hasFlow(source.getNode(), _)
select sink.getNode(), source, sink, "CORS header is being set using user controlled value $@.",
  source.getNode(), "user-provided value"
