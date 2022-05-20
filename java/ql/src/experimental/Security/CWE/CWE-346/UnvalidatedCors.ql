/**
 * @name CORS is derived from untrusted input
 * @description CORS header is derived from untrusted input, allowing a remote user to control which origins are trusted.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unvalidated-cors-origin-set
 * @tags security
 *       external/cwe/cwe-346
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import DataFlow::PathGraph

/**
 *  Holds if `header` sets `Access-Control-Allow-Credentials` to `true`. This ensures fair chances of exploitability.
 */
private predicate setsAllowCredentials(MethodAccess header) {
  (
    header.getMethod() instanceof ResponseSetHeaderMethod or
    header.getMethod() instanceof ResponseAddHeaderMethod
  ) and
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() =
    "access-control-allow-credentials" and
  header.getArgument(1).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "true"
}

private class CorsProbableCheckAccess extends MethodAccess {
  CorsProbableCheckAccess() {
    getMethod().hasName("contains") and
    getMethod().getDeclaringType().getASourceSupertype*() instanceof CollectionType
    or
    getMethod().hasName("containsKey") and
    getMethod().getDeclaringType().getASourceSupertype*() instanceof MapType
    or
    getMethod().hasName("equals") and
    getQualifier().getType() instanceof TypeString
  }
}

private Expr getAccessControlAllowOriginHeaderName() {
  result.(CompileTimeConstantExpr).getStringValue().toLowerCase() = "access-control-allow-origin"
}

/**
 * This taintflow2 configuration checks if there is a flow from source node towards CorsProbableCheckAccess methods.
 */
class CorsSourceReachesCheckConfig extends TaintTracking2::Configuration {
  CorsSourceReachesCheckConfig() { this = "CorsOriginConfig" }

  override predicate isSource(DataFlow::Node source) { any(CorsOriginConfig c).hasFlow(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CorsProbableCheckAccess check).getAnArgument()
  }
}

private class CorsOriginConfig extends TaintTracking::Configuration {
  CorsOriginConfig() { this = "CorsOriginConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess corsHeader, MethodAccess allowCredentialsHeader |
      (
        corsHeader.getMethod() instanceof ResponseSetHeaderMethod or
        corsHeader.getMethod() instanceof ResponseAddHeaderMethod
      ) and
      getAccessControlAllowOriginHeaderName() = corsHeader.getArgument(0) and
      setsAllowCredentials(allowCredentialsHeader) and
      corsHeader.getEnclosingCallable() = allowCredentialsHeader.getEnclosingCallable() and
      sink.asExpr() = corsHeader.getArgument(1)
    )
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, CorsOriginConfig conf,
  CorsSourceReachesCheckConfig sanconf
where conf.hasFlowPath(source, sink) and not sanconf.hasFlow(source.getNode(), _)
select sink.getNode(), source, sink, "CORS header is being set using user controlled value $@.",
  source.getNode(), "user-provided value"
