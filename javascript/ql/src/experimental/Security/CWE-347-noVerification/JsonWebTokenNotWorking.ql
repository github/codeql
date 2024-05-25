/**
 * @name This query is for seeing if we can have two taint config within on query file
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
import jsonWebToken

class ConfigurationUnverifiedDecode extends TaintTracking::Configuration {
  ConfigurationUnverifiedDecode() { this = "jsonwebtoken without any signature verification" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = unverifiedDecode() }
}

class ConfigurationVerifiedDecode extends TaintTracking::Configuration {
  ConfigurationVerifiedDecode() { this = "jsonwebtoken with signature verification" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = verifiedDecode() }
}

from ConfigurationUnverifiedDecode cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  not exists(ConfigurationVerifiedDecode cfg2 | cfg2.hasFlowPath(source, _))
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"
