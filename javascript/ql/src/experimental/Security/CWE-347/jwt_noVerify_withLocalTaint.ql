/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ip-address-spoofing
 * @tags security
 *       experimental
 *       external/cwe/cwe-348
 */

import javascript
import API
import DataFlow::PathGraph

class JWTDecodeConfig extends TaintTracking::Configuration {
  JWTDecodeConfig() { this = "JWTConfig" }

  override predicate isSource(DataFlow::Node source) {
    source =
      API::moduleImport("jsonwebtoken")
          .getMember("decode")
          .getParameter(0)
          .asSink()
          .getALocalSource()
    // source = any(VariableAccess v).flow()
    // or
    // source = any(Parameter p).flow()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink()
    // sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
    // sink = any(DataFlow::Node n)
  }

  // override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  //   exists(DataFlow::CallNode n |
  //     n = API::moduleImport("jsonwebtoken").getMember("decode").getACall()
  //   |
  //     nodeFrom = n.getArgument(0) and
  //     nodeTo = n.getArgument(0).getALocalSource()
  //   )
  // }
}

// class JWTVerifyConfig extends DataFlow::Configuration {
//   JWTVerifyConfig() { this = "JWTConfig" }
//   override predicate isSource(DataFlow::Node source) { source = any(DataFlow::Node n) }
//   override predicate isSink(DataFlow::Node sink) {
//     // sink = any(DataFlow::Node n)
//     sink = API::moduleImport("jsonwebtoken").getMember("verify").getACall().getArgument(0)
//   }
// }
from JWTDecodeConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) 
  and
  not DataFlow::localFlowStep*(source.getNode(),
    API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink())
select source.getNode(), source, sink, "this token $@.", sink.getNode(), "file system operation"
