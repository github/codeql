/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id js/decode-jwt-without-verification
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import JWT

module UnverifiedDecodeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink = unverifiedDecode() }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module UnverifiedDecodeFlow = TaintTracking::Global<UnverifiedDecodeConfig>;

module VerifiedDecodeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink = verifiedDecode() }
}

module VerifiedDecodeFlow = TaintTracking::Global<VerifiedDecodeConfig>;

import UnverifiedDecodeFlow::PathGraph

from UnverifiedDecodeFlow::PathNode source, UnverifiedDecodeFlow::PathNode sink
where
  UnverifiedDecodeFlow::flowPath(source, sink) and
  not VerifiedDecodeFlow::flow(source.getNode(), _)
select source.getNode(), source, sink, "Decoding JWT $@.", sink.getNode(),
  "without signature verification"
