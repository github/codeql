/**
 * @name Cors header being set from remote source
 * @description Cors header is being set from remote source, allowing to control the origin.
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
import DataFlow::PathGraph

// Check for Access-Control-Allow-Credentials as well, this ensures fair chances of exploitability.
predicate satisfyAllowCredentials(MethodAccess header, MethodAccess check) {
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() =
    "access-control-allow-credentials" and
  header.getArgument(1).(CompileTimeConstantExpr).getStringValue() = "true" and
  header.getEnclosingCallable() = check.getEnclosingCallable()
}

predicate checkAccessControlAllowOriginHeader(Expr expr) {
  expr.(CompileTimeConstantExpr).getStringValue().toLowerCase() = "access-control-allow-origin"
}

class CorsOriginConfig extends TaintTracking::Configuration {
  CorsOriginConfig() { this = "CORSOriginConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(ResponseSetHeaderMethod h, MethodAccess m |
      m = h.getAReference() and
      checkAccessControlAllowOriginHeader(m.getArgument(0)) and
      satisfyAllowCredentials(h.getAReference(), m) and
      sink.asExpr() = m.getArgument(1)
    )
    or
    exists(ResponseAddHeaderMethod a, MethodAccess m |
      m = a.getAReference() and
      checkAccessControlAllowOriginHeader(m.getArgument(0)) and
      satisfyAllowCredentials(a.getAReference(), m) and
      sink.asExpr() = m.getArgument(1)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, CorsOriginConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cors header is being set using user controlled value $@.",
  source.getNode(), "user-provided value"
