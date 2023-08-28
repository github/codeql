/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ip-address-spoofing
 * @tags security
 *       experimental
 *       external/cwe/CWE-321
 */

import javascript
import DataFlow::PathGraph
import DataFlow

class JWTDecodeConfig extends TaintTracking::Configuration {
  JWTDecodeConfig() { this = "JWTConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof StringLiteral }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("jsonwebtoken").getMember(["sign", "verify"]).getParameter(1).asSink()
  }
}

from JWTDecodeConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "this $@. is used as a secret key", source.getNode(),
  "Constant"
