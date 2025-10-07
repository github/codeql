/**
 * @name CORS is derived from untrusted input
 * @description CORS header is derived from untrusted input, allowing a remote user to control which origins are trusted.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unvalidated-cors-origin-set
 * @tags security
 *       experimental
 *       external/cwe/cwe-346
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.TaintTracking
import CorsOriginFlow::PathGraph

/**
 *  Holds if `header` sets `Access-Control-Allow-Credentials` to `true`. This ensures fair chances of exploitability.
 */
private predicate setsAllowCredentials(MethodCall header) {
  (
    header.getMethod() instanceof ResponseSetHeaderMethod or
    header.getMethod() instanceof ResponseAddHeaderMethod
  ) and
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() =
    "access-control-allow-credentials" and
  header.getArgument(1).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "true"
}

private class CorsProbableCheckAccess extends MethodCall {
  CorsProbableCheckAccess() {
    this.getMethod().hasName("contains") and
    this.getMethod().getDeclaringType().getASourceSupertype*() instanceof CollectionType
    or
    this.getMethod().hasName("containsKey") and
    this.getMethod().getDeclaringType().getASourceSupertype*() instanceof MapType
    or
    this.getMethod().hasName("equals") and
    this.getQualifier().getType() instanceof TypeString
  }
}

private Expr getAccessControlAllowOriginHeaderName() {
  result.(CompileTimeConstantExpr).getStringValue().toLowerCase() = "access-control-allow-origin"
}

/**
 * A taint-tracking configuration for flow from a source node to CorsProbableCheckAccess methods.
 */
module CorsSourceReachesCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { CorsOriginFlow::flow(source, _) }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CorsProbableCheckAccess check).getAnArgument()
  }
}

/**
 * Taint-tracking flow from a source node to CorsProbableCheckAccess methods.
 */
module CorsSourceReachesCheckFlow = TaintTracking::Global<CorsSourceReachesCheckConfig>;

private module CorsOriginConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall corsHeader, MethodCall allowCredentialsHeader |
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

private module CorsOriginFlow = TaintTracking::Global<CorsOriginConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, CorsOriginFlow::PathNode source, CorsOriginFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  CorsOriginFlow::flowPath(source, sink) and
  not CorsSourceReachesCheckFlow::flow(sourceNode, _) and
  sinkNode = sink.getNode() and
  message1 = "CORS header is being set using user controlled value $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
