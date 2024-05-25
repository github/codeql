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
import jsonWebToken

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "jsonwebtoken without any signature verification" }

  override predicate isSource(DataFlow::Node source) {
    source =
      API::moduleImport("jsonwebtoken")
          .getMember("decode")
          .getParameter(0)
          .asSink()
          .getALocalSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = unverifiedDecode()
    or
    sink = verifiedDecode()
  }
}

/** Holds if `source` flows to the first parameter of jsonwebtoken.verify */
predicate isSafe(Configuration cfg, DataFlow::Node source) {
  exists(DataFlow::Node sink |
    cfg.hasFlow(source, sink) and
    sink = verifiedDecode()
  )
}

/**
 * Holds if:
 * - `source` does not flow to the first parameter of `jsonwebtoken.verify`, and
 * - `source` flows to the first parameter of `jsonwebtoken.decode`
 */
predicate isVulnerable(Configuration cfg, DataFlow::Node source, DataFlow::Node sink) {
  not isSafe(cfg, source) and // i.e., source does not flow to a verify call
  cfg.hasFlow(source, sink) and // but it does flow to something else
  sink = unverifiedDecode() // and that something else is a call to decode.
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  isVulnerable(cfg, source.getNode(), sink.getNode())
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"
