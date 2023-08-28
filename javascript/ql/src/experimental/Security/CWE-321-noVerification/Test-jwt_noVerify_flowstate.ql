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
import DataFlow::PathGraph
import DataFlow

class OK extends FlowLabel {
  OK() { this = "OK" }
}

class NotOK extends FlowLabel {
  NotOK() { this = "NotOK" }
}

class JWTDecodeConfig extends TaintTracking::Configuration {
  JWTDecodeConfig() { this = "JWTConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel state) {
    source =
      API::moduleImport("jsonwebtoken")
          .getMember("decode")
          .getParameter(0)
          .asSink()
          .getALocalSource() and
    state instanceof OK
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel state) {
    sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink() and
    state instanceof OK 
    or
    sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink() and
    state instanceof NotOK
  }
}

from JWTDecodeConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink, "this token $@.", sink.getNode(), "file system operation"
