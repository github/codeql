/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id js/jwt-missing-verification-jsonwebtoken
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import DataFlow::PathGraph

DataFlow::Node unverifiedDecode() {
  result = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink()
}

DataFlow::Node verifiedDecode() {
  result = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "jsonwebtoken constant secret key" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = unverifiedDecode()
    or
    sink = verifiedDecode()
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  sink.getNode() = unverifiedDecode() and
  not isSafe(source.getNode())
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"

// Holds if the source has a flow to a JWT decoding function with signature verification
predicate isSafe(DataFlow::Node source) {
  exists(Configuration cfg | cfg.hasFlow(source, verifiedDecode()))
}
