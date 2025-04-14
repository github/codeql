/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id js/decode-jwt-without-verification-local-source
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import JWT

module DecodeWithoutVerificationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = [unverifiedDecode(), verifiedDecode()].getALocalSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = unverifiedDecode()
    or
    sink = verifiedDecode()
  }

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/experimental/Security/CWE-347/decodeJwtWithoutVerificationLocalSource.ql:32: Flow call outside 'select' clause
    // ql/src/experimental/Security/CWE-347/decodeJwtWithoutVerificationLocalSource.ql:42: Flow call outside 'select' clause
    none()
  }
}

module DecodeWithoutVerificationFlow = TaintTracking::Global<DecodeWithoutVerificationConfig>;

/** Holds if `source` flows to the first parameter of jsonwebtoken.verify */
predicate isSafe(DataFlow::Node source) {
  DecodeWithoutVerificationFlow::flow(source, verifiedDecode())
}

/**
 * Holds if:
 * - `source` does not flow to the first parameter of `jsonwebtoken.verify`, and
 * - `source` flows to the first parameter of `jsonwebtoken.decode`
 */
predicate isVulnerable(DataFlow::Node source, DataFlow::Node sink) {
  not isSafe(source) and // i.e., source does not flow to a verify call
  DecodeWithoutVerificationFlow::flow(source, sink) and // but it does flow to something else
  sink = unverifiedDecode() // and that something else is a call to decode.
}

import DecodeWithoutVerificationFlow::PathGraph

from DecodeWithoutVerificationFlow::PathNode source, DecodeWithoutVerificationFlow::PathNode sink
where
  DecodeWithoutVerificationFlow::flowPath(source, sink) and
  isVulnerable(source.getNode(), sink.getNode())
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"
