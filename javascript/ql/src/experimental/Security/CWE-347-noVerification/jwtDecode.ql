/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id js/jwt-missing-verification-jwt-decode
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import DataFlow::PathGraph

DataFlow::Node unverifiedDecode() {
  result = API::moduleImport("jwt-decode").getParameter(0).asSink()
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "jsonwebtoken without any signature verification" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = unverifiedDecode() }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"
